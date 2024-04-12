function  s_duh = duh_daten_bearb_trigger_offset(data_selection,s_duh)

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'signal'           ,''       ,'Auf welches Signal triggern' ...
             ,1      ,'threshold'        ,0        ,'Schwelle auf die getriggert werden soll' ...
             ,1      ,'criterium'        ,'>'      ,'Triggern auf überschreiten (>) oder Unterschreiten (<) der Schwelle' ...
             ,1      ,'offset'           ,0        ,'Zeitoffset nach vorne (-) nach hinten (+)' ...
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
                    
				s_frage.frage          = sprintf('Signalnamen aus %g Datensätze zum Triggern auswählen ?',length(data_selection));
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
				s_frage.frage     = 'Schwelle für Trigger angeben';
				s_frage.prot      = 0;
				s_frage.command   = 'threshold';
				s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    s_liste(option).c_value{1} = value;
                    s_liste(option).tbd        = 0;
                end

            case 3

                s_frage.c_liste{1}     = ' > : Schwelle muß überschritten sein';
                s_frage.c_liste{2}     = ' < : Schwelle muß unterschritten sein';
                s_frage.c_liste{3}     = ' ->: Schwelle muß von unten überschritten werden';
                s_frage.c_liste{4}     = ' <-: Schwelle muß von oben unterschritten werden';
                s_frage.c_name{1}      = '>';
                s_frage.c_name{2}      = '<';
                s_frage.c_name{3}      = '->';
                s_frage.c_name{4}      = '<-';
				s_frage.frage          = 'welches Kriterium ?';
				s_frage.command        = 'criterium';
				s_frage.single         = 1;
				s_frage.prot           = 0;
				
				[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay ) % tbd muß zurückgesetzt werden
                    s_liste(option).tbd        = 0;
                    s_liste(option).c_value{1} = char(s_frage.c_name(selection(1)));
                end
            case 4 % peakfilter faktor

				s_frage.frage     = 'Offsetverschiebung nach vorne (negativ) nach hinten (positiv)';
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
    % trigger-signal
    command = sprintf('signal = s_duh.s_data(i_data).d.%s;',char(s_liste(1).c_value{1}));
    eval(command);
    % threshold-value
    threshold = s_liste(2).c_value{1};
    % type of trigger
    type      = s_liste(3).c_value{1};
    % offset
    t_offset = s_liste(4).c_value{1};
    
    index = find_trigger(signal,threshold,type);
    
    if( index == 0 ) % Threshold nicht erreicht
        
        text = sprintf('warning: trigger not reached for dataset:%s(%s)',s_duh.s_data(i_data).name,s_duh.s_data(i_data).h{1});
        
        o_ausgabe_f(text,s_duh.s_prot.debug_fid);
        input('<return> to continue','s')
        
    else
        
        c_names = fieldnames(s_duh.s_data(i_data).d);
        
        command = sprintf('time = s_duh.s_data(i_data).d.%s;',char(c_names{1}));
        eval(command);
        okay = 1;
        for i=2:length(time)
            if( time(i)-time(i-1) < 1.0e-8 )
                text = sprintf('warning: time-Vektor not monoton increasing for dataset:%s(%s)',s_duh.s_data(i_data).name,s_duh.s_data(i_data).h{1});
                o_ausgabe_f(text,s_duh.s_prot.debug_fid);
                input('<return> to continue','s')
                okay = 0;
                break;
            end
        end
        
        if( okay )
            % Verschiebung
            nend = length(time);
            if( t_offset > 0 )

                delta_t = t_offset;
                delta_i =  round(t_offset/max(1e-20,time(2) - time(1)));

                index = min(nend,index + delta_i);
            else
                tindex = time(index);
                if( tindex + t_offset < 0 )
                    delta_t = -tindex - t_offset;
                else
                    delta_t = 0;
                end
                delta_i =  round(t_offset/min(-1e-20,time(1) - time(2)));

                index = max(1,index - delta_i);
            end

            for j=1:length(c_names)
                command = sprintf('n_act = length(s_duh.s_data(i_data).d.%s);',char(c_names{j}));
                eval(command);

                if( n_act == nend )

                    command = sprintf('s_duh.s_data(i_data).d.%s = s_duh.s_data(i_data).d.%s(index:nend);',char(c_names{j}),char(c_names{j}));
                    eval(command);

                    if( j == 1 )
                        command = sprintf('s_duh.s_data(i_data).d.%s = s_duh.s_data(i_data).d.%s - s_duh.s_data(i_data).d.%s(1);',char(c_names{j}),char(c_names{j}),char(c_names{j}));
                        eval(command);
                        command = sprintf('s_duh.s_data(i_data).d.%s = s_duh.s_data(i_data).d.%s + delta_t;',char(c_names{j}),char(c_names{j}));
                        eval(command);
                    end
                end
            end
        end
    end
end