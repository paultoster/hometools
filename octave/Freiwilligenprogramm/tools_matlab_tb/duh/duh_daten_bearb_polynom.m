function  s_duh = duh_daten_bearb_polynom(data_selection,s_duh)

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'x-signal'         ,''       ,'Welches Signal x-Achse' ...
             ,1      ,'y-signal'         ,''       ,'Welches Signal y-Achse' ...
             ,1      ,'ftyp'             ,1        ,'Funktionstyp' ...
             ,1      ,'g0'               ,1        ,'kleinste Potenz' ...
             ,1      ,'g1'               ,1        ,'grösste Potenz' ...
             ,0      ,'plot_flag'        ,0        ,'Ergebnis plotten' ...
             ,0      ,'data_save'        ,0        ,'Ergebnis speichern' ...
             );
option_flag = 1;
%      xap	zu approximierenden x-Array
%      yap        dazugehörige Werte yap = f(xap)
%      
%      Ftyp	Funktionstyp
%      		= 1	    a(1) + a(2) * x       + ... + a(n) * x^(n-1)
%      		= 2     a(1) + a(2) * x       + ... + a(n) * x^(1/(n-1))
%      		= 3     a(1) + a(2) / x       + ... + a(n) / x^(n-1)
%      		= 4     a(1) + a(2) * exp(x)  + ... + a(n) * exp(x^(n-1)) 
%      		= 5     a(1) + a(2) * exp(-x) + ... + a(n) * exp(-x^(n-1))
%      		= 6     a(1) + a(2) * log(x)  + ... + a(n) * log(x^(n-1))
%      
%      g0         kleinstes Potenz (0,1,2, ...)
%      g1		höchste Potenz  => n
%      
%      PlotFlag   = 0 kein Plot
%                 = 1 Plot mit size(xap)*10 Punkten
%                 = 2 wie 1 ohne marker mit Legende
%      
%      z.B.       a = spolyap(xmess,ymess,1,1,4)
% 
%                 =>  ergibt ein Polnom:
%                     y = a(1) + a(2)*x + a(3)*x^2 + a(4)*x^3 + a(5)*x^4
%                     
%                     wobei a(1) == 0 ist.
% function polynom = poly_approx(xap,yap,Ftyp,g0,g1,PlotFlag)

while( option_flag )
	
	[end_flag,option_flag,option,s_liste,s_duh.s_prot,s_duh.s_remote] = ...
                                      o_abfragen_werte_liste_f(s_liste,s_duh.s_prot,s_duh.s_remote);
	
	if( end_flag )
       return;
	end
	if( option_flag )
        
        if( exist('s_frage') == 1 )
            clear s_frage
        end
        switch option
            
            case 1 % x-Signal

              for i=1:length(data_selection)
                          c_arr            = fieldnames(s_duh.s_data(data_selection(i)).d);
                          s_set(i).c_names = {c_arr{1:length(c_arr)}};
              end
              [s_erg] = str_count_names_f(s_set,1);
              j = 0;
              for i= 1:length(s_erg)
                          if( s_erg(i).n == length(data_selection) )
                              j = j+1;
                              s_frage.c_liste{j} = sprintf('%s',s_erg(i).name);
                              s_frage.c_name{j}  = s_erg(i).name;
                          end
              end

              s_frage.frage          = sprintf('x-Signalnamen aus %g Datensätze auswählen ?',length(data_selection));
              s_frage.command        = 'x-signal';
              s_frage.single         = 1;
              s_frage.prot           = 0;
              s_frage.sort_list      = 1;

              [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

                      if( okay ) % tbd muß zurückgesetzt werden
                          s_liste(option).tbd        = 0;
                          for isec = 1:length(selection)
                              s_liste(option).c_value{isec} = char(s_frage.c_name(selection(isec)));
                          end
      %                else
      %                    return;
                      end

          case 2
              for i=1:length(data_selection)
                          c_arr            = fieldnames(s_duh.s_data(data_selection(i)).d);
                          s_set(i).c_names = {c_arr{1:length(c_arr)}};
              end
              [s_erg] = str_count_names_f(s_set,1);
              j = 0;
              for i= 1:length(s_erg)
                          if( s_erg(i).n == length(data_selection) )
                              j = j+1;
                              s_frage.c_liste{j} = sprintf('%s',s_erg(i).name);
                              s_frage.c_name{j}  = s_erg(i).name;
                          end
              end

              s_frage.frage          = sprintf('y-Signalnamen aus %g Datensätze auswählen ?',length(data_selection));
              s_frage.command        = 'y-signal';
              s_frage.single         = 0;
              s_frage.prot           = 0;
              s_frage.sort_list      = 1;

              [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

                      if( okay ) % tbd muß zurückgesetzt werden
                          s_liste(option).tbd        = 0;
                          for isec = 1:length(selection)
                              s_liste(option).c_value{isec} = char(s_frage.c_name(selection(isec)));
                          end
      %                else
      %                    return;
                      end


            case 3
              
                s_frage.c_comment{1} = 'ftyp = 1:	    a(1) + a(2) * x       + ... + a(n) * x^(n-1)';            
                s_frage.c_comment{2} = 'ftyp = 2:	    a(1) + a(2) * x       + ... + a(n) * x^(1/(n-1))';            
                s_frage.c_comment{3} = 'ftyp = 3:	    a(1) + a(2) / x       + ... + a(n) / x^(n-1)';            
                s_frage.c_comment{4} = 'ftyp = 4:	    a(1) + a(2) * exp(x)  + ... + a(n) * exp(x^(n-1))';            
                s_frage.c_comment{5} = 'ftyp = 5:	    a(1) + a(2) * exp(-x) + ... + a(n) * exp(-x^(n-1))';            
                s_frage.c_comment{6} = 'ftyp = 6:	    a(1) + a(2) * log(x)  + ... + a(n) * log(x^(n-1))';            

                s_frage.frage     = 'Welcher Funktionstyp ftyp ?';
                s_frage.prot      = 0;
                s_frage.command   = 'ftyp';
                s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                  s_liste(option).c_value{1} = value;
                  s_liste(option).tbd        = 0;
                end
            case 4         
              
                s_frage.frage     = 'Welcher kleinstes Potenz g0 (0,1,2, ...) ?';
                s_frage.prot      = 0;
                s_frage.command   = 'g0';
                s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                  s_liste(option).c_value{1} = value;
                  s_liste(option).tbd        = 0;
                end
            case 5         
              
                s_frage.frage     = 'Welcher höchste Potenz g1 => n ?';
                s_frage.prot      = 0;
                s_frage.command   = 'g1';
                s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                  s_liste(option).c_value{1} = value;
                  s_liste(option).tbd        = 0;
                end
            case 6            
              s_frage.frage = 'Sollen geplottet werden?';
              s_frage.prot      = 0;
              s_frage.command   = 'plot_flag';
              s_frage.default   = 1;
              s_frage.def_value = 'n';
		                
              [flag] = o_abfragen_jn_f(s_frage);

              if( okay )
                  if( flag )
                      s_liste(option).c_value{1} = 1;
                  else
                      s_liste(option).c_value{1} = 0;
                  end
                  s_liste(option).tbd        = 0;
              end
            case 7           
              s_frage.frage = 'Sollen Werte als Data-Set gespeichert werden?';
              s_frage.prot      = 0;
              s_frage.command   = 'data_save';
              s_frage.default   = 1;
              s_frage.def_value = 'n';
		                
                [flag] = o_abfragen_jn_f(s_frage);
                
                if( okay )
                    if( flag )
                        s_liste(option).c_value{1} = 1;
                    else
                        s_liste(option).c_value{1} = 0;
                    end
                    s_liste(option).tbd        = 0;
                end
        end
	end
end

% Auswerten

x_sig_name  = s_liste(1).c_value{1};
y_sig_liste = s_liste(2).c_value;
ftyp        = s_liste(3).c_value{1};
g0          = s_liste(4).c_value{1};
g1          = s_liste(5).c_value{1};
plot_flag   = s_liste(5).c_value{1} ~= 0;
data_save   = s_liste(6).c_value{1} ~= 0;


% Polynome bestimmen
for i_data=1:length(data_selection)

  for i=1:length(y_sig_liste)
    
    y_sig_name = y_sig_liste{i};

    [polynom,Res] = poly_approx(s_duh.s_data(i_data).d.(x_sig_name),s_duh.s_data(i_data).d.(y_sig_name),ftyp,g0,g1,plot_flag);
    
    fprintf('===============%s======================\n',y_sig_name);
    if ftyp == 1    
      text1 = 'f(x) = a(1) + a(2) * x       + ... + a(n) * x**(n-1)';
    elseif ftyp == 2 
      text1 = 'f(x) = a(1) + a(2) * x       + ... + a(n) * x**(1/(n-1))';
    elseif ftyp == 3 
      text1 = 'f(x) = a(1) + a(2) / x       + ... + a(n) / x**(n-1)';
    elseif ftyp == 4 
      text1 = 'f(x) = a(1) + a(2) * exp(x)  + ... + a(n) * exp(x**(n-1)) ';
    elseif ftyp == 5 
      text1 = 'f(x) = a(1) + a(2) * exp(-x) + ... + a(n) * exp(-x**(n-1))';
    elseif ftyp == 6 
      text1 = 'f(x) = a(1) + a(2) * log(x)  + ... + a(n) * log(x**(n-1))';
    end

    fprintf('%s\n',text1);
    for j = 1:g1+1
    
      text2 = ['a(',num2str(j),') = ',num2str(polynom(j))];
      fprintf('%s\n',text2);
    end
     text3 = ['Standardabweichung = ',num2str(Res)];
    fprintf('%s\n',text3);
     fprintf('====================================================\n');
  
    
    if( data_save )
      
        y = poly_multiplaction(polynom,s_duh.s_data(i_data).d.(x_sig_name),0);
        
        y_sig_name_poly = [y_sig_name,'_poly'];
        while( isfield(s_duh.s_data(s_duh.n_data).d,y_sig_name_poly) )
          y_sig_name_poly = [y_sig_name_poly,'_poly'];
        end
        s_duh.s_data(s_duh.n_data).d.(y_sig_name_poly)  = y;
        s_duh.s_data(s_duh.n_data).u.(y_sig_name_poly)  = s_duh.s_data(s_duh.n_data).u.(y_sig_name);
    end    
    

  end
end