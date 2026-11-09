function  s_duh = duh_daten_bearb_offset_factor(data_selection,s_duh)

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'signal'           ,''       ,'Welches Signal' ...
             ,0      ,'reziprok'         ,0        ,'Flag um reziproken Wert aus Signal zu berechnen' ...
             ,1      ,'factor'           ,1        ,'Faktor' ...
             ,1      ,'offset'           ,0        ,'Offset' ...
             ,0      ,'new_name'         ,0        ,'Neuer Name mit angehängtem _fo' ...
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
                clear s_frage
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
                    
				s_frage.frage          = sprintf('Signalnamen aus %g Datensätze auswählen ?',length(data_selection));
				s_frage.command        = 'signal';
				s_frage.single         = 0;
				s_frage.prot           = 0;
				
				%[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listboxsort_f(s_frage,s_duh.s_prot,s_duh.s_remote);

    
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd        = 0;
                    for isec = 1:length(selection)
                        s_liste(option).c_value{isec} = char(s_frage.c_name(selection(isec)));
                    end
%                else
%                    return;
                end
                
            
            case 2
                s_frage.comment  = 'Signal reziprok rechnen (1/signal)?';
                s_frage.default  = 1;
                s_frage.def_value  = ~s_liste(option).c_value{1};

                if( o_abfragen_jn_f(s_frage) )
                    s_liste(option).c_value{1} = 1;
                else
                    s_liste(option).c_value{1} = 0;
                end
                s_liste(option).tbd     = 0;
            case 3            
				s_frage.c_comment{1} = 'Min/Max-Werte';
                for i=1:length(data_selection)
                    command = sprintf('valmin = min( s_duh.s_data(data_selection(i)).d.%s );',char(s_liste(1).c_value{1}));
                    eval(command)
                    command = sprintf('valmax = max( s_duh.s_data(data_selection(i)).d.%s );',char(s_liste(1).c_value{1}));
                    eval(command)
                    s_frage.c_comment{1+i} = sprintf('%f / %f',valmin,valmax);
                end
				s_frage.frage     = 'Faktor angeben (signal= signal*factor+offset)';
				s_frage.prot      = 0;
				s_frage.command   = 'factor';
				s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    s_liste(option).c_value{1} = value;
                    s_liste(option).tbd        = 0;
                end

            case 4            
				s_frage.c_comment{1} = 'Min/Max-Werte';
                for i=1:length(data_selection)
                    command = sprintf('valmin = min( s_duh.s_data(data_selection(i)).d.%s );',char(s_liste(1).c_value{1}));
                    eval(command)
                    command = sprintf('valmax = max( s_duh.s_data(data_selection(i)).d.%s );',char(s_liste(1).c_value{1}));
                    eval(command)
                    s_frage.c_comment{1+i} = sprintf('%f / %f',valmin,valmax);
                end
				s_frage.frage     = 'Offset angeben (signal= signal*factor+offset)';
				s_frage.prot      = 0;
				s_frage.command   = 'offset';
				s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    s_liste(option).c_value{1} = value;
                    s_liste(option).tbd        = 0;
                end
            case 5
                s_frage.comment  = 'Neuer Name mit angehängtem _fo ?';
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
% 
% 
% for i=1:length(data_selection)
%     
%     % data index
%     i_data = data_selection(i);
%     
%     factor         = s_liste(2).c_value{1};
%     offset         = s_liste(3).c_value{1};
%     new_name_flag  = s_liste(5).c_value{1};
% 
% 
%     for isec = 1:length(s_liste(1).c_value)
%                     
%         if( isfield(s_duh.s_data(i_data).d, char(s_liste(1).c_value{isec})) )
% 
%             command = sprintf('s_duh.s_data(i_data).d.%s = s_duh.s_data(i_data).d.%s * factor + offset;', ...
%                               char(s_liste(1).c_value{isec}),char(s_liste(1).c_value{isec}));
%             eval(command);
%             
%             vektor = s_duh.s_data(i_data).d.(
%         end
%     end
% end

c_names_select = s_liste(1).c_value;
reziprok_flag  = s_liste(2).c_value{1};
factor         = s_liste(3).c_value{1};
offset         = s_liste(4).c_value{1};
new_name_flag  = s_liste(5).c_value{1};

for i=1:length(data_selection)
    
    % data index
    i_data = data_selection(i);
    
    % Namen des Datasets
    c_names = fieldnames(s_duh.s_data(i_data).d);
    
    
    for j=1:length(c_names)
        
        for k=1:length(c_names_select)
            
            if( strcmp(c_names{j},c_names_select{k}) )
                
                if( reziprok_flag )
                    vektor = 1./not_zero(s_duh.s_data(i_data).d.(c_names{j}));
                else
                    vektor = s_duh.s_data(i_data).d.(c_names{j});
                end
                
            	vektor =  vektor * factor + offset;

                if( new_name_flag )
                    s_duh.s_data(i_data).d.([c_names{j},'_fo']) = vektor;
                    s_duh.s_data(i_data).u.([c_names{j},'_fo']) = s_duh.s_data(i_data).u.(c_names{j});
                else
                    s_duh.s_data(i_data).d.(c_names{j}) = vektor;
                end
                                                                       
            end
        end
    end    
end