% $JustDate:: 21.04.05  $, $Revision:: 2 $ $Author:: Admin     $
% $JustDate:: 21 $, $Revision:: 2 $ $Author:: Admin     $
function  s_duh = duh_daten_bearb_x_slice(data_selection,s_duh)

s_frage    = 0;
s_liste = o_abfragen_werte_liste_erstellen_f ...
             (1      ,'signal'           ,''       ,'Mit welchem Signal reduzeren' ...
             ,1      ,'xmin'             ,0        ,'minimaler Wert' ...
             ,1      ,'xmax'             ,0        ,'maximaler Wert' ...
             ,1      ,'x0_offset'        ,0        ,'x-Signal mit null beginnen' ...
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
                    ic = 0;
                    for j=1:length(c_arr)
                        if( is_monoton_steigend(s_duh.s_data(data_selection(i)).d.(c_arr{j})) )
                            ic = ic+1;
                            s_set(i).c_names{ic} = c_arr{j};
                        end
                    end
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
                    
				s_frage.frage          = sprintf('Signalnamen aus %g Datensätze zum Reduzieren auswählen ?',length(data_selection));
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
				s_frage.frage     = 'xmin angeben';
				s_frage.prot      = 0;
				s_frage.command   = 'xmin';
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
				s_frage.frage     = 'xmax angeben';
				s_frage.prot      = 0;
				s_frage.command   = 'xmax';
				s_frage.type      = 'double';
		
                [okay,value] = o_abfragen_wert_f(s_frage);
                
                if( okay )
                    s_liste(option).c_value{1} = value;
                    s_liste(option).tbd        = 0;
                end
            case 4
                s_frage.comment  = 'x-Signal mit null beginnen?';
                s_frage.default  = 1;
                s_frage.def_value  = s_liste(option).c_value{1};

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


for i=1:length(data_selection)
    
    % data index
    i_data = data_selection(i);
    % trigger-signal
    signal = s_duh.s_data(i_data).d.(char(s_liste(1).c_value{1}));    
    % threshold-value
    xmin = s_liste(2).c_value{1};
    % type of trigger
    xmax = s_liste(3).c_value{1};

    if( xmin > xmax )
        d=xmax;
        xmax = xmin;
        xmin = d;
    end
    
    d = diff(signal);
    
    % Steigend oder fallend
    steig_flag = 1;
    for j=1:length(d)
        if( d(j) > 1e-20 )
            steig_flag = 1;
            break
        elseif( d(j) < -1e-20 )
            steig_flag = 0;
            break;
        end
    end
        
   start_found = 0;
   start_index = 1;
   end_index = length(signal);
   if( steig_flag )
        for j=1:length(signal)
            if( signal(j) >= xmin & ~start_found )
                
                start_found = 1;
                start_index = j;
            elseif( signal(j) > xmax & start_index )
                end_index = max(1,j-1);
                break;
            end
        end
    else
        for j=1:length(signal)            
            if( signal(j) <= xmax & ~start_found )
                
                start_found = 1;
                start_index = j;
            elseif( signal(j) < xmin & start_index )
                end_index = max(1,j-1);
                break;
            end
        end
    end
    
    c_names = fieldnames(s_duh.s_data(i_data).d);
    for j=1:length(c_names) 
        
        if( length(s_duh.s_data(i_data).d.(c_names{j})) == length(signal) )
            command = sprintf('s_duh.s_data(i_data).d.%s = s_duh.s_data(i_data).d.%s(%i:%i);',char(c_names{j}),char(c_names{j}),start_index,end_index);
            eval(command);
        end
    end
    
    if( s_liste(4).c_value{1} ) % Triggersignal nullen
        
        command = sprintf('s_duh.s_data(i_data).d.%s = s_duh.s_data(i_data).d.%s - s_duh.s_data(i_data).d.%s(1);' ...
                         ,char(s_liste(1).c_value{1}),char(s_liste(1).c_value{1}),char(s_liste(1).c_value{1}));
        eval(command);
    end

end