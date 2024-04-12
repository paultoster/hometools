function  s_duh = duh_daten_bearb_stat_calc(data_selection,s_duh)

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'signal'           ,''       ,'Welches Signal' ...
             ,0      ,'data_save'        ,0        ,'als Data-Set speichern' ...
             ,0      ,'max'              ,1        ,'Maximalwert' ...
             ,0      ,'min'              ,1        ,'Minimalwert' ...
             ,0      ,'mean'             ,1        ,'Mittelwert' ...
             ,0      ,'std'              ,1        ,'Standardabweichung' ...
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
                
            
            case 2            
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
            case 3            
				s_frage.frage = 'Soll Maximalwert berechnet werden';
				s_frage.prot      = 0;
				s_frage.command   = 'max';
				s_frage.default   = 1;
                s_frage.def_value = 'j';
		                
                [flag] = o_abfragen_jn_f(s_frage);
                
                if( okay )
                    if( flag )
                        s_liste(option).c_value{1} = 1;
                    else
                        s_liste(option).c_value{1} = 0;
                    end
                    s_liste(option).tbd        = 0;
                end

            case 4            
				s_frage.frage = 'Soll Minimalwert berechnet werden';
				s_frage.prot      = 0;
				s_frage.command   = 'min';
				s_frage.default   = 1;
                s_frage.def_value = 'j';
		                
                [flag] = o_abfragen_jn_f(s_frage);
                
                if( okay )
                    if( flag )
                        s_liste(option).c_value{1} = 1;
                    else
                        s_liste(option).c_value{1} = 0;
                    end
                    s_liste(option).tbd        = 0;
                end

            case 5            
				s_frage.frage = 'Soll Mittelwert berechnet werden';
				s_frage.prot      = 0;
				s_frage.command   = 'mean';
				s_frage.default   = 1;
                s_frage.def_value = 'j';
		                
                [flag] = o_abfragen_jn_f(s_frage);
                
                if( okay )
                    if( flag )
                        s_liste(option).c_value{1} = 1;
                    else
                        s_liste(option).c_value{1} = 0;
                    end
                    s_liste(option).tbd        = 0;
                end

            case 6            
				s_frage.frage = 'Soll Standardabweichung berechnet werden';
				s_frage.prot      = 0;
				s_frage.command   = 'std';
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

sig_liste = s_liste(1).c_value;
flag_save = s_liste(2).c_value{1} ~= 0;
flag_max  = s_liste(3).c_value{1} ~= 0;
flag_min  = s_liste(4).c_value{1} ~= 0;
flag_mean = s_liste(5).c_value{1} ~= 0;
flag_std  = s_liste(6).c_value{1} ~= 0;

if( flag_max || flag_min || flag_mean || flag_std)

    d = [];
    u = [];
    h{1} = [datestr(now),' calc-statistik'];
    
    for i=1:length(data_selection)
    
        % data index
        i_data = data_selection(i);
        
        
        s_duh.s_output=duh_output(s_duh.s_output,1, ...
            sprintf('---------------------------------------------------------------------------\n'));
        s_duh.s_output=duh_output(s_duh.s_output,1,sprintf('Datenname : %s\n',s_duh.s_data(i_data).name));

        % Header
        h{i+1} = s_duh.s_data(i_data).name;

        % Loop over signal
        for isig = 1:length(sig_liste)

            if( isfield(s_duh.s_data(i_data).d,sig_liste{isig}) )
                
                if( flag_max )
                    
                    nameval = [sig_liste{isig},'_max'];
                    
                    val = max(s_duh.s_data(i_data).d.(sig_liste{isig}));
                    uval = s_duh.s_data(i_data).u.(sig_liste{isig});
                    
                    if( ~isfield(d,nameval) )
                        d.(nameval) = val;
                        u.(nameval) = uval;
                    else
                        d.(nameval) = [d.(nameval);val];
                    end
                    
                    s_duh.s_output=duh_output(s_duh.s_output,1,sprintf('%s  = %20.15e\n',nameval,val));
                end
                if( flag_min )
                    
                    nameval = [sig_liste{isig},'_min'];
                    
                    val = min(s_duh.s_data(i_data).d.(sig_liste{isig}));
                    uval = s_duh.s_data(i_data).u.(sig_liste{isig});
                    
                    if( ~isfield(d,nameval) )
                        d.(nameval) = val;
                        u.(nameval) = uval;
                    else
                        d.(nameval) = [d.(nameval);val];
                    end
                    s_duh.s_output=duh_output(s_duh.s_output,1,sprintf('%s  = %20.15e\n',nameval,val));
                end
                if( flag_mean )
                    
                    nameval = [sig_liste{isig},'_mean'];
                    
                    val = mean(s_duh.s_data(i_data).d.(sig_liste{isig}));
                    uval = s_duh.s_data(i_data).u.(sig_liste{isig});
                    
                    if( ~isfield(d,nameval) )
                        d.(nameval) = val;
                        u.(nameval) = uval;
                    else
                        d.(nameval) = [d.(nameval);val];
                    end

                    s_duh.s_output=duh_output(s_duh.s_output,1,sprintf('%s  = %20.15e\n',nameval,val));
                end
                if( flag_std )
                    
                    nameval = [sig_liste{isig},'_std'];
                    
                    val = std(s_duh.s_data(i_data).d.(sig_liste{isig}));
                    uval = s_duh.s_data(i_data).u.(sig_liste{isig});
                    
                    if( ~isfield(d,nameval) )
                        d.(nameval) = val;
                        u.(nameval) = uval;
                    else
                        d.(nameval) = [d.(nameval);val];
                    end

                    s_duh.s_output=duh_output(s_duh.s_output,1,sprintf('%s  = %20.15e\n',nameval,val));
                end
            end
        end

    end
    
    if( flag_save && isstruct(d) )
        s_duh.n_data = s_duh.n_data + 1;
        s_duh.s_data(s_duh.n_data).d           = d;
        s_duh.s_data(s_duh.n_data).u           = u;
        s_duh.s_data(s_duh.n_data).h           = h;
        s_duh.s_data(s_duh.n_data).file        = ['stat_',num2str(s_duh.n_data)];
        s_duh.s_data(s_duh.n_data).name        = ['stat_',num2str(s_duh.n_data)];;
        s_duh.s_data(s_duh.n_data).c_prc_files = '';
    end    
end