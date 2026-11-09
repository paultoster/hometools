function  s_duh = duh_daten_bearb_vergleich(data_selection,s_duh)
n_data_set = length(data_selection);

if( n_data_set == 1 )
    warning('Einen Datensatz zum Vergleich ist zu wenig')
    input('<pause>')
elseif( n_data_set > 2 )
    warning('Zuviele Datensätze zum Vergleich max = 2')
    input('<pause>')
else

    s_frage    = 0;
    s_liste = o_abfragen_werte_liste_erstellen_f ...
                 (1      ,'x_vec_basis'      ,1       ,'x-Vektor Datensatz 1 (Basis für Offset-Bestimmung)' ...
                 ,1      ,'y_vec_basis'      ,1       ,'y-vektor Datensatz 1 (Korrelationssignal Basis)' ...
                 ,1      ,'x_vec_corr'       ,1       ,'x-Vektor Datensatz 2 (Korreltaionsvergleich für Offset-Bestimmung)' ...
                 ,1      ,'y_vec_corr'       ,1       ,'y-vektor Datensatz 2 (Korrelationssignal Vergleich)' ...
                 ,1      ,'delta_x_corr'     ,0       ,'Maximale Verschiebung (+/-) des x-Vektors' ...
                 ,0      ,'data_cor_flag'    ,0       ,'Soll x-Vektor Datensatz 2 korrigiert werden' ...
                 );
    option_flag = 1;

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

                case 1            
                    c_arr  = fieldnames(s_duh.s_data(data_selection(1)).d);
                    for i= 1:length(c_arr)
                        s_frage.c_liste{i} = c_arr{i};
                        s_frage.c_name{i}  = c_arr{i};
                    end

                    s_frage.frage  = sprintf('x-Vektor Datensatz 1 (Basis für Offset-Bestimmung) auswählen ?');
                    s_frage.command        = 'x_vec_basis';
                    s_frage.single         = 1;
                    s_frage.prot_name      = 1;
										s_frage.sort_list      = 1;
										
                    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

                    if( okay )
                        s_liste(option).c_value{1} = c_arr{selection(1)};
                        s_liste(option).tbd        = 0;
                    end

                case 2

                    c_arr  = fieldnames(s_duh.s_data(data_selection(1)).d);
                    for i= 1:length(c_arr)
                        s_frage.c_liste{i} = c_arr{i};
                        s_frage.c_name{i}  = c_arr{i};
                    end

                    s_frage.frage  = sprintf('y-vektor Datensatz 1 (Korrelationssignal Basis) auswählen ?');
                    s_frage.command        = 'y_vec_basis';
                    s_frage.single         = 1;
                    s_frage.prot_name      = 1;
										s_frage.sort_list      = 1;
										
                    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

                    if( okay )
                        s_liste(option).c_value{1} = c_arr{selection(1)};
                        s_liste(option).tbd        = 0;
                    end
                case 3            
                    c_arr  = fieldnames(s_duh.s_data(data_selection(2)).d);
                    for i= 1:length(c_arr)
                        s_frage.c_liste{i} = c_arr{i};
                        s_frage.c_name{i}  = c_arr{i};
                    end

                    s_frage.frage  = sprintf('x-Vektor Datensatz 2 (Vergleich für Offset-Bestimmung) auswählen ?');
                    s_frage.command        = 'x_vec_corr';
                    s_frage.single         = 1;
                    s_frage.prot_name      = 1;
										s_frage.sort_list      = 1;
										
                    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

                    if( okay )
                        s_liste(option).c_value{1} = c_arr{selection(1)};
                        s_liste(option).tbd        = 0;
                    end

                case 4

                    c_arr  = fieldnames(s_duh.s_data(data_selection(2)).d);
                    for i= 1:length(c_arr)
                        s_frage.c_liste{i} = c_arr{i};
                        s_frage.c_name{i}  = c_arr{i};
                    end

                    s_frage.frage  = sprintf('y-vektor Datensatz 2 (Korrelationssignal Vergleich) auswählen ?');
                    s_frage.command        = 'y_vec_basis';
                    s_frage.single         = 1;
                    s_frage.prot_name      = 1;
										s_frage.sort_list      = 1;
										
                    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

                    if( okay )
                        s_liste(option).c_value{1} = c_arr{selection(1)};
                        s_liste(option).tbd        = 0;
                    end
                    
                case 5

                    s_frage.frage     = 'Maximale Verschiebung (+/-) des x-Vektors';
                    s_frage.prot      = 0;
                    s_frage.command   = 'delta_x_corr';
                    s_frage.type      = 'double';

                    [okay,value] = o_abfragen_wert_f(s_frage);
                    if( okay )
                        s_liste(option).c_value{1} = value;
                        s_liste(option).tbd        = 0;
                    end
                case 5

                    if( s_liste(option).c_value{1} )
                        s_liste(option).c_value{1} = 0;
                    else
                        s_liste(option).c_value{1} = 1;
                    end  
                    
            end
        end
    end
    
    
		
   x_vec_b      = s_duh.s_data(data_selection(1)).d.(s_liste(1).c_value{1});
   name_x_vec_b = s_liste(1).c_value{1};
   y_vec_b      = s_duh.s_data(data_selection(1)).d.(s_liste(2).c_value{1});
   name_y_vec_b = s_liste(2).c_value{1};
   x_vec_c      = s_duh.s_data(data_selection(2)).d.(s_liste(3).c_value{1});
   name_x_vec_c = s_liste(3).c_value{1};
   y_vec_c      = s_duh.s_data(data_selection(2)).d.(s_liste(4).c_value{1});
   name_y_vec_c = s_liste(4).c_value{1};
   delta_x_max  = s_liste(5).c_value{1};
   write_flag   = s_liste(6).c_value{1};

   plot_flag = 0;
       
    n     = 100;
    delta = delta_x_max/n;

    if( plot_flag )
        figure
    end

    R_max = -10000;
    delta_x_best = 0;
    
    for i=1:2*n+1

        delta_x = -delta_x_max+delta*(i-1);

        xmin = max(min(x_vec_b),min(x_vec_c+delta_x));
        xmax = min(max(x_vec_b),max(x_vec_c+delta_x));

        i1 = suche_index(x_vec_b,xmin);
        i2 = suche_index(x_vec_b,xmax);

        xvec1 = x_vec_b(i1:i2);
        yvec1 = y_vec_b(i1:i2);


        yvec2 = interp1(x_vec_c+delta_x,y_vec_c,xvec1,'linear','extrap');

        R = corrcoef(yvec1,yvec2);
        if( R(2,1) > R_max )
            
            R_max = R(2,1);
            delta_x_best = delta_x;
        end

        if( plot_flag )
            plot(delta_x,R,'r+')
            hold on
        end
    end

    if( plot_flag )
        grid on
    end
    
    figure
    plot(x_vec_b,y_vec_b,'k-','LineWidth',2)
    hold on
    plot(x_vec_c+delta_x_best,y_vec_c,'r-')
    plot(x_vec_c,y_vec_c,'r:')
    legend(sprintf('D1 %s=f(%s)',name_y_vec_b,name_x_vec_b) ...
          ,sprintf('D2 %s=f(%s+%s)',name_y_vec_c,name_x_vec_c,num2str(delta_x_best)) ...
          ,sprintf('D2 %s=f(%s)',name_y_vec_c,name_x_vec_c) ...
          )
    hold off
    grid on
    
    s_duh.s_output=duh_output(s_duh.s_output,1,sprintf('Offset für Datensatz 2 Varibale %s  = %g\n',name_x_vec_c,delta_x_best));
    
    if( write_flag )        
        s_duh.s_data(data_selection(2)).d.(name_x_vec_c) = s_duh.s_data(data_selection(2)).d.(name_x_vec_c)+delta_x_best;
    end        
end
