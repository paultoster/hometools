function  s_duh = duh_daten_bearb_integration(data_selection,s_duh)

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'signal'                  ,''       ,'Mit welchem Signal integrieren' ...
             ,1      ,'time_signal'             ,''        ,'Zeitsignal' ...
             ,0      ,'offset'                  ,0.0        ,'Offset' ...
             ,0      ,'order'                   ,0.0        ,'Order 0:Euler 1:Trapez' ...
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

				for i=1:length(data_selection)
                    c_arr            = fieldnames(s_duh.s_data(data_selection(i)).d);
                    s_set(i).c_names = {c_arr{2:length(c_arr)}};
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
                    
				s_frage.frage          = sprintf('Signalnamen aus %g Datensätze zum Filtern auswählen ?',length(data_selection));
				s_frage.command        = 'signal';
				s_frage.single         = 0;
				s_frage.prot           = 0;
				s_frage.sort_list      = 1;
				
				[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd        = 0;
                    for i=1:length(selection)
                        s_liste(option).c_value{i}    = s_frage.c_name{selection(i)};
                    end
                else
                    return;
                end
                
            case 2
                clear s_frage c_arr s_set s_erg
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
                    
				s_frage.frage          = sprintf('Zeit-Signalnamen aus %g Datensätze auswählen ?',length(data_selection));
				s_frage.command        = 'time_signal';
				s_frage.single         = 1;
				s_frage.prot           = 0;
        s_frage.sort_list      = 1;
        				
				[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd        = 0;
                    for i=1:length(selection)
                        s_liste(option).c_value{i}    = s_frage.c_name{selection(i)};
                    end
                else
                    return;
                end
            
            case 3            
				s_frage.frage     = 'Offset angeben';
				s_frage.prot      = 0;
				s_frage.command   = 'offset';
				s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    s_liste(option).c_value{1} = value;
                    s_liste(option).tbd        = 0;
                else
                    return;
                end
                
            case 4
                s_frage.comment  = 'Order 0:Euler 1:Trapez ?';
                s_frage.default  = 1;
                s_frage.def_value  = ~s_liste(option).c_value{1};

                if( o_abfragen_jn_f(s_frage) )
                    s_liste(option).c_value{1} = 1;
                else
                    s_liste(option).c_value{1} = 0;
                end
                s_liste(option).tbd     = 0;
                

        end
	end
end

% Auswerten
c_names_select = s_liste(1).c_value;
time_name      = s_liste(2).c_value{1};
offset         = s_liste(3).c_value{1};

if( s_liste(4).c_value{1} > 0.5 )
    order = 1;
else
    order = 0;
end

for i=1:length(data_selection)
    
    % data index
    i_data = data_selection(i);
    
    % Namen des Datasets
    c_names = fieldnames(s_duh.s_data(i_data).d);
    
    %

    for j=1:length(c_names)
        
        for k=1:length(c_names_select)
            
            if( strcmp(c_names{j},c_names_select{k}) )
                yint = integriere(s_duh.s_data(i_data).d.(time_name) ...
                                 ,s_duh.s_data(i_data).d.(c_names{j}) ...
                                 ,order,offset);
            

                s_duh.s_data(i_data).d.([c_names{j},'_int']) = yint;
                s_duh.s_data(i_data).u.([c_names{j},'_int']) = [s_duh.s_data(i_data).u.([c_names{j}]) ...
                                                               ,'*' ...
                                                               ,s_duh.s_data(i_data).u.(time_name)];
                                                                       
            end
        end
    end    
end