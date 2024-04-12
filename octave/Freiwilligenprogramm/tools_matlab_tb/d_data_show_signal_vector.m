function d_data_show_signal_vector(d)
%
% d_data_show_signal_vector(d)
%
% Schreibt an Bildschirm, wenn ein cellarray augewählt ist
%


  c_names = fieldnames(d);
  liste = {};
  for i=1:length(c_names)

    if( iscell(d.(c_names{i})) )
      liste = cell_add(liste,c_names{i});
    end
  end
  if( isempty(liste) )
    fprintf('!\n!\n!\n!\n!\n!\n!\n!\n!\nEs sind keine SignalVektor (cellarrays) vorhanden !!!\n')
    return
  end
  if(length(liste) == 1 )
    signame = liste{1};
  else
    s_frage.c_liste  = liste;
    s_frage.frage    = 'Ein SignalVektor auswählen';
    s_frage.single   = 1;

    [okay,selection] = o_abfragen_listboxsort_f(s_frage);
    if( ~okay ), eturn;end
    signame = liste{selection(1)};
  end
  
  sig = d.(signame);
  runflag  = 1;
  index    = 1;
  run_time = d.time(1);
  ttt      = 'Von diesem Zeitpunkt wird der nachste Vektor gesucht';
  while( runflag ) 
     [runflag,index,run_time] = handle_index_demand(runflag,index,run_time,d.time,length(d.time),ttt);
     fprintf('\n');
     if( runflag )
        empty_flag = 1;
        for i=index:length(sig)
    
          if( ~isempty(sig{i}) )
            empty_flag = 0;
            vec = sig{i};
            n = length(vec);
            tt = sprintf('time: %i, index: %i, length: %i\n',d.time(i),i,n);
            fprintf(tt)
            tt = '';
            for j=1:n
              if( j == 1 )
                tt = [tt,'{',num2str(vec(j))];
              else
                tt = [tt,',',num2str(vec(j))];
              end
              if( length(tt) >= 100 )
                fprintf('%s\n',tt);
                tt = '';
              end
            end
            fprintf('%s}\n\n',tt);
            index  = i;
            break;
          end
        end
      if( empty_flag )
        fprintf('-- leer --\n');
        run_flag = 0;
      end
     end
  end
end
    
  



