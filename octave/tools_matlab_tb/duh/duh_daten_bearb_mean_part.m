function  s_duh = duh_daten_bearb_mean_part(data_selection,s_duh)
n_data_set = length(data_selection);


s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (0      ,'x_vec_flag'       ,0       ,'x-Vektor auswählen, ansonsten 1. Kanal' ...
             ,0      ,'x_vec'            ,0       ,'x-Vektor' ...
             ,1      ,'y_vec'            ,1       ,'y-vektor' ...
             ,1      ,'band_y'          ,1       ,'prozentuales Band in dem die y-Werte liegen sollen' ...
             ,1      ,'delta_x'          ,1       ,'delta_x über das für die Ableitung gemittelt' ...
             ,0      ,'data_cor_flag'    ,0       ,'Datensatz darauf beschneiden' ...
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

            case 1 % x_vec_flag
                if( s_liste(option).c_value{1} )
                    s_liste(option).c_value{1} = 0;
                    s_liste(option).tbd        = 0;
                    s_liste(option+1).tbd      = 0;
                else
                    s_liste(option).c_value{1} = 1;
                    s_liste(option).tbd        = 0;
                    s_liste(option+1).tbd      = 1;
                end
            case 2  % x_vec              
                c_arr  = fieldnames(s_duh.s_data(data_selection(1)).d);
                for i= 1:length(c_arr)
                    s_frage.c_liste{i} = c_arr{i};
                    s_frage.c_name{i}  = c_arr{i};
                end

                s_frage.frage  = sprintf('x-Vektor auswählen ?');
                s_frage.command        = 'x_vec';
                s_frage.single         = 1;
                s_frage.prot_name      = 1;
								s_frage.sort_list      = 1;
								
                [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

                if( okay )
                    s_liste(option).c_value{1} = c_arr{selection(1)};
                    s_liste(option).tbd        = 0;
                end

            case 3 % y_vec
                c_arr  = fieldnames(s_duh.s_data(data_selection(1)).d);
                for i= 1:length(c_arr)
                    s_frage.c_liste{i} = c_arr{i};
                    s_frage.c_name{i}  = c_arr{i};
                end

                s_frage.frage  = sprintf('y-Vektor auswählen ?');
                s_frage.command        = 'y_vec';
                s_frage.single         = 1;
                s_frage.prot_name      = 1;
								s_frage.sort_list      = 1;
								
                [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

                if( okay )
                    s_liste(option).c_value{1} = c_arr{selection(1)};
                    s_liste(option).tbd        = 0;
                end

            case 4 % band_y    
                
                s_frage.frage     = 'Wie groß soll das Band sein in Prozent bezogen auf den Gesamthub (max-min)';
                s_frage.prot      = 0;
                s_frage.command   = 'band_y';
                s_frage.type      = 'double';
                
                ii = 0;
                for ich = 1:n_data_set
                    ymin = min(s_duh.s_data(data_selection(ich)).d.(s_liste(3).c_value{1}));
                    ymax = max(s_duh.s_data(data_selection(ich)).d.(s_liste(3).c_value{1}));
                    ii = ii+1;
                    s_frage.c_comment{ii} = ['Min: ',num2str(ymin)];
                    ii = ii+1;
                    s_frage.c_comment{ii} = ['Max: ',num2str(ymax)];
                    ii = ii+1;
                    s_frage.c_comment{ii} = ['Delta: ',num2str(ymax-ymin)];
                end

                [okay,value] = o_abfragen_wert_f(s_frage);
                if( okay )
                    s_liste(option).c_value{1} = value;
                    s_liste(option).tbd        = 0;
                end

            case 5 % delta_x

                s_frage.frage     = 'x-Wertebereich mit dem gemittelt und unterabgetastet wird';
                s_frage.prot      = 0;
                s_frage.command   = 'delta_x';
                s_frage.type      = 'double';
                

                [okay,value] = o_abfragen_wert_f(s_frage);
                if( okay )
                    s_liste(option).c_value{1} = value;
                    s_liste(option).tbd        = 0;
                end
            case 6 % delta_cor_flag
                if( s_liste(option).c_value{1} )
                    s_liste(option).c_value{1} = 0;
                    s_liste(option).tbd        = 0;
                else
                    s_liste(option).c_value{1} = 1;
                    s_liste(option).tbd        = 0;
                end

        end
    end
end


x_vec_flag    = s_liste(1).c_value{1};
x_vec_name    = s_liste(2).c_value{1};
y_vec_name    = s_liste(3).c_value{1};
band_y        = s_liste(4).c_value{1};
delta_x       = s_liste(5).c_value{1};
data_cor_flag = s_liste(6).c_value{1};


for ich = 1:n_data_set
    
    if( ~x_vec_flag )        
        c_names    = fieldnames(s_duh.s_data(data_selection(ich)).d);
        x_vec_name = c_names{1};
    end
    
    if(  isfield(s_duh.s_data(data_selection(ich)).d,x_vec_name) ...
      && isfield(s_duh.s_data(data_selection(ich)).d,y_vec_name) ...
      )
  
        x_vec = s_duh.s_data(data_selection(ich)).d.(x_vec_name);
        y_vec = s_duh.s_data(data_selection(ich)).d.(y_vec_name);
        
        delta_y = (max(y_vec)-min(y_vec))*band_y/100;
        
        [i_start,i_end,ymit] = suche_mittelwertstueck(x_vec,y_vec,delta_x,delta_y,1);
        
        if( data_cor_flag )
            
            s_duh.s_data(data_selection(ich)).d = struct_vec_beschneiden(s_duh.s_data(data_selection(ich)).d ...
                                                                                     ,'i_start',i_start ...
                                                                                     ,'i_end',i_end ...
                                                                                     );
        end
    end
end