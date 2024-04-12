% $JustDate:: 16.08.05  $, $Revision:: 1 $ $Author:: Tftbe1    $
function  s_duh = duh_daten_bearb_kanal_(data_selection,s_duh)

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'signal'           ,''       ,'Welches Signal' ...
             ,1      ,'factor'           ,1        ,'Faktor' ...
             ,1      ,'offset'           ,0        ,'Offset' ...
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
				s_frage.single         = 1;
				s_frage.prot           = 0;
				s_frage.sort_list      = 1;
				
				[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = char(s_frage.c_name(selection(1)));
%                else
%                    return;
                end
                
            
            case 2            
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

            case 3            
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
        end
	end
end

% Auswerten


for i=1:length(data_selection)
    
    % data index
    i_data = data_selection(i);
    
    factor = s_liste(2).c_value{1};
    offset = s_liste(3).c_value{1};
    
    command = sprintf('s_duh.s_data(i_data).d.%s = s_duh.s_data(i_data).d.%s * factor + offset;', ...
                      char(s_liste(1).c_value{1}),char(s_liste(1).c_value{1}));
    eval(command);
    
end