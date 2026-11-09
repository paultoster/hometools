function s_duh = duh_daten_bearb_peak_filter4(data_selection,s_duh)

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'signal'           ,''       ,'Auf welches Signal als Zählersignal verwenden' ...
             ,0      ,'criterium'        ,'>'      ,'Aufsteigend (>) oder absteigend (<) ' ...
             ,0      ,'increment'        ,1        ,'absolutes Increment mit dem der Zähler zählt' ...
             ,0      ,'tolerance'        ,2        ,'Toleranz, mit der der Fehlerwert erkannt wird' ...
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
                    
				s_frage.frage          = sprintf('Zähler-Signalnamen aus %g Datensätze auswählen ?',length(data_selection));
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

                s_frage.c_liste{1}     = ' > : Zähler ist aufsteigend';
                s_frage.c_liste{2}     = ' < : Zähler ist absteigend';
                s_frage.c_name{1}      = '>';
                s_frage.c_name{2}      = '<';
				s_frage.frage          = 'welches Kriterium ?';
				s_frage.command        = 'criterium';
				s_frage.single         = 1;
				s_frage.prot           = 0;
				
				[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = char(s_frage.c_name(selection(1)));
                end
            case 3 % Inkrement

				s_frage.frage     = 'Mit welchem Inkrement (absolut) wird der Zähler gezählt';
				s_frage.prot      = 0;
				s_frage.command   = 'increment';
				s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    s_liste(option).c_value{1} = value;
                    s_liste(option).tbd        = 0;
                end

            case 4 % Toleranz

				s_frage.frage     = 'Mit welcher Toleranz soll der Fehler abgefragt werden';
				s_frage.prot      = 0;
				s_frage.command   = 'tolerance';
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
s_par.signal_name = s_liste(1).c_value{1};
s_par.criterium   = s_liste(2).c_value{1};
s_par.increment   = s_liste(3).c_value{1};
s_par.tolerance   = s_liste(4).c_value{1};

for i=1:length(data_selection)
    i1 = data_selection(i);
    [s_duh.s_data(i1).d,c_comment] = peak_filter4_f(s_duh.s_data(i1).d,s_par);

    for k=1:length(c_comment)
        a = sprintf('\n%s',c_comment{k});
        o_ausgabe_f(a,0);
    end
end
