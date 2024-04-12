function  s_duh = duh_daten_bearb_two_channels(data_selection,s_duh)

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'signal1'          ,''       ,'Welches 1. Signal' ...
             ,1      ,'signal2'          ,''       ,'Welches 2. Signal' ...
             ,1      ,'calc'             ,''       ,'rechenvorschrift' ...
             ,1      ,'new_name'         ,''       ,'Neuer Name' ...
             );
option_flag = 1;

while( option_flag )
	
	[end_flag,option_flag,option,s_liste,s_duh.s_prot,s_duh.s_remote] = ...
                                      o_abfragen_werte_liste_f(s_liste,s_duh.s_prot,s_duh.s_remote);
	
	if( end_flag )
       return;
	end
	if( option_flag )
        
        switch option
            
            case 1

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
                    
				s_frage.frage          = sprintf('1. Signalnamen aus %g Datensätze auswählen ?',length(data_selection));
				s_frage.command        = 'signal1';
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

                if( ~exist('s_frage','var') )
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
                end                    
				s_frage.frage          = sprintf('2. Signalnamen aus %g Datensätze auswählen ?',length(data_selection));
				s_frage.command        = 'signal';
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
            
            case 3
                
                clear s_frage
                s_frage.c_liste{1}     = ' + : Addition ';
                s_frage.c_liste{2}     = ' - : Subtraktion';
                s_frage.c_liste{3}     = ' : : Division';
                s_frage.c_liste{4}     = ' * : Multiplikation';
                s_frage.c_name{1}      = '+';
                s_frage.c_name{2}      = '-';
                s_frage.c_name{3}      = ':';
                s_frage.c_name{4}      = '*';
				s_frage.frage          = 'welches Vorschrift ?';
				s_frage.command        = 'calc';
				s_frage.single         = 1;
				s_frage.prot           = 0;
				
				[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = char(s_frage.c_name(selection(1)));
                end
                

            case 4
                clear s_frage
                s_frage.frage  = 'Welcher neue Name für das neue Signal?';
                s_frage.type     = 'char';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = char(value);
                end

        end
	end
end

% Auswerten
% 
% 
name1      = s_liste(1).c_value{1};
name2      = s_liste(2).c_value{1};
vorschrift = s_liste(3).c_value{1};
new_name   = s_liste(4).c_value{1};

for i=1:length(data_selection)
    
    % data index
    i_data = data_selection(i);
    
    % Namen des Datasets
    c_names = fieldnames(s_duh.s_data(i_data).d);

    vek1_found = 0;
    vek2_found = 0;
    for j=1:length(c_names)
                    
            if( strcmp(c_names{j},name1) )
                
                vek1_found = 1;
                
            elseif( strcmp(c_names{j},name2) )
                
                vek2_found = 1;
            end
            
            if( vek1_found && vek2_found )
                
                break
            end
    end
    if( vek1_found && vek2_found )
        
        if( strcmp(vorschrift,'+') )
            
            s_duh.s_data(i_data).d.(new_name) = s_duh.s_data(i_data).d.(name1) ...
                                              + s_duh.s_data(i_data).d.(name2);

            s_duh.s_data(i_data).u.(new_name) = s_duh.s_data(i_data).u.(name1)                                         
            
        elseif( strcmp(vorschrift,'-') )
            
            s_duh.s_data(i_data).d.(new_name) = s_duh.s_data(i_data).d.(name1) ...
                                              - s_duh.s_data(i_data).d.(name2);

            s_duh.s_data(i_data).u.(new_name) = s_duh.s_data(i_data).u.(name1)                                         

        elseif( strcmp(vorschrift,'*') )

            s_duh.s_data(i_data).d.(new_name) =  s_duh.s_data(i_data).d.(name1) ...
                                              .* s_duh.s_data(i_data).d.(name2);

            s_duh.s_data(i_data).u.(new_name) = [s_duh.s_data(i_data).u.(name1),'*',s_duh.s_data(i_data).u.(name2)];                                         
                                          
        else
            s_duh.s_data(i_data).d.(new_name) =  s_duh.s_data(i_data).d.(name1) ...
                                              ./ not_zero(s_duh.s_data(i_data).d.(name2));
            s_duh.s_data(i_data).u.(new_name) = [s_duh.s_data(i_data).u.(name1),'/',s_duh.s_data(i_data).u.(name2)];                                         
        end

    end    
end