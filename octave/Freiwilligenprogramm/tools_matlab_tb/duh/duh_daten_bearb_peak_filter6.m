function s_duh = duh_daten_bearb_peak_filter6(data_selection,s_duh)

  index_liste = [];

  %
  % Signal um Ausschnitte fetszulegen
  %
  for i=1:length(data_selection)
      c_arr            = fieldnames(s_duh.s_data(data_selection(i)).d);
      s_set(i).c_names = {c_arr{1:length(c_arr)}};
  end
  [s_erg] = str_count_names_f(s_set,1);
  for i= 1:length(s_erg)
      s_frage.c_liste{i} = sprintf('%s (%g x)',s_erg(i).name,s_erg(i).n);
      s_frage.c_name{i}  = s_erg(i).name;
  end

  s_frage.frage          = sprintf('Signal zum ausfiltern aus %g Datensätze auswählen (n mal vorhanden) ?',length(data_selection));
  s_frage.command        = 'signal';
  s_frage.single         = 1;
  s_frage.prot_name      = 1;
  [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listboxsort_f(s_frage,s_duh.s_prot,s_duh.s_remote);

  if( okay )
    %
    % Ausschnitte fetszulegen [i01,i11,i02,i12, ...]
    %
    [s_duh,index_liste] = duh_daten_bearb_peak_filter6_set_index_liste(data_selection,s_duh,s_erg(selection(1)).name,s_set);

    for i=1:length(data_selection)
        c_arr            = fieldnames(s_duh.s_data(data_selection(i)).d);
        s_set(i).c_names = {c_arr{1:length(c_arr)}};
    end
    [s_erg] = str_count_names_f(s_set,1);
    for i= 1:length(s_erg)
        s_frage.c_liste{i} = sprintf('%s (%g x)',s_erg(i).name,s_erg(i).n);
        s_frage.c_name{i}  = s_erg(i).name;
    end

    s_frage.frage          = sprintf('Welche Signale sollen mit Indexliste ausgefilterd werden, aus %g Datensätze auswählen (n mal vorhanden) ?',length(data_selection));
    s_frage.command        = 'signal_filt';
    s_frage.single         = 0;
    s_frage.prot_name      = 1;

    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listboxsort_f(s_frage,s_duh.s_prot,s_duh.s_remote);

    if( okay )
      %
      % Ausfiltern
      %
      type = 1;
      for i=1:length(data_selection)
        for j=1:length(selection)
          sig_name = s_frage.c_name{selection(j)};
          ifound = cell_find_f(s_set(i).c_names,sig_name);
          if( ~isempty(ifound) )
            s_duh.s_data(data_selection(i)).d.(sig_name) = duh_daten_bearb_peak_filter6_filter(s_duh.s_data(data_selection(i)).d.(sig_name),index_liste,type);
          end
        end
      end
    end
  end
end
    
function [s_duh,index_liste] = duh_daten_bearb_peak_filter6_set_index_liste(data_selection,s_duh,sig_name,s_set)

  command     = 'index_liste';
  index_liste = [];

  if( s_duh.s_remote.run_flag ) % remote abfragen

      command_found = 0;
      icount        = 0;
      [ok_flag,s_duh.s_remote,line,remote_command,c_value,c_type] = o_remote_f(s_duh.s_remote);
      if( ok_flag == 0 || ok_flag == 2  )
          s_duh.s_remote.run_flag = 0;
      else
          if( strcmp(remote_command,command)  )
              command_found = 1;
              for i=1:length(c_value)
                  if( strcmp(c_type{i},'double') )
                      icount = icount+1;
                      index_liste(icount) = c_value{i};
                  end
              end
          end
      end

      if( icount == 0 )
          s_duh.s_remote.run_flag = 0;
          okay                    = 1;
          if( ~command_found )
              a=sprintf('\nduh_daten_bearb_peak_filter6_set_index_liste: Der remote_command <%s> aus Zeile %i in Datei <%s> \n',remote_command,line,s_duh.s_remote.file);
              o_ausgabe_f(a,s_duh.s_prot.debug_fid);
              a=sprintf('entspricht nicht dem gesuchten command <%s>:\n',command);
              o_ausgabe_f(a,s_duh.s_prot.debug_fid);
          else
              for i=1:length(c_value)
                  a=sprintf('\nduh_daten_bearb_peak_filter6_set_index_liste: Der value <%s> aus Zeile %i in Datei <%s> entspricht nicht der index-Liste \n', ...
                            c_value{i},line,s_duh.s_remote.file);
                  o_ausgabe_f(a,s_duh.s_prot.debug_fid);
              end
          end
      end

  end
  if( ~s_duh.s_remote.run_flag ) % remote abfragen

    hfig     = 0;
    for i=1:length(data_selection)
      ifound = cell_find_f(s_set(i).c_names,sig_name);
      if( ~isempty(ifound) )

        if( ~hfig )
          hfig=figure;
        end

        vec  = s_duh.s_data(data_selection(i)).d.(sig_name);
        plot(vec)
        hold on
        grid on
      end
    end

    if( hfig )
      hold off
      but = 1;
      while(but == 1)

        fprintf('Diagramm ausrichten, Ausschnitt vergrößern')
        a=input('<<weiter:Return,e:Ende>>\n','s');

        if( strcmp(a,'e') )
          but = 0;
        else
          fprintf('Startindex zum Ausfiltern aus Grafik auswählen (linke Maustaste,Ende: rechte Maustaste)\n')
          [x0,y0,but] = ginput(1);
          if( but == 1 )
            ix0 = round(x0);
            hold on
            plot(ix0,vec(ix0),'ro')
            hold off
            fprintf('Endindex zum Ausfiltern aus Grafik auswählen (linke Maustaste,Ende: rechte Maustaste)\n')
            [x1,y1,but] = ginput(1);

            if(  but == 1 && x1 > x0 )
              ix1 = round(x1);
              hold on
              plot(ix1,vec(ix1),'r+')
              hold off
              index_liste = [index_liste,ix0,ix1];
            end
          end
        end
      end
      close(hfig) 

      if( ~isempty(index_liste) )

          s_duh.s_prot.command = 'index_liste';
          s_duh.s_prot.val = index_liste;
         s_duh.s_prot = o_protokoll_f(3,s_duh.s_prot);
      end
    end
  
  end
end
function vec = duh_daten_bearb_peak_filter6_filter(vec,index_liste,type)
  
  nind = floor(length(index_liste)/2);
  n    = length(vec);
  test = 0;
  
  
  if( test )
    figure
    plot(vec,'g-','LineWidth',3)
  end
  
  for i=1:nind
    
    i0 = max(1,min(n,index_liste(2*i-1)));
    i1 = max(1,min(n,index_liste(2*i)));
    
    if( (i1 > i0) || ( (i0 <= 1) && (i1 >= n) ) )
      
      j0 = max(1,i0-(i1-i0)*2);
      j1 = min(n,i1+(i1-i0)*2);
      
      if( i0 == 1 )
        vec_x = [j1:1:i1]';
        xin = [1:1:max(vec_x)]';
      elseif( i1 == n )
        vec_x = [j0:1:i0]';
        xin = [min(vec_x):1:n]';
      else
        vec_x = [[j0:1:i0]';[i1:1:j1]'];
        xin = [min(vec_x):1:max(vec_x)]';
      end
      vec_y = vec_x*0;
      for j=1:length(vec_x)
        vec_y(j) = vec(vec_x(j));
      end
      if( test )
        hold on
        plot(vec_x,vec_y,'b+','LineWidth',2)
        hold off
      end
      if( type < 1.5 )
        yout = interp1(vec_x,vec_y,xin,'linear','extrap');
      elseif( type < 2.5 )
        yout = interp1(vec_x,vec_y,xin,'spline','extrap');
      else
        yout = interp1(vec_x,vec_y,xin,'cubic','extrap');
      end
      for j=1:length(xin)
        vec(xin(j)) = yout(j);
      end
    end
  end
  if( test )
    hold on
    plot(vec,'r-','LineWidth',1)
    hold off
    grid on
  end
end
