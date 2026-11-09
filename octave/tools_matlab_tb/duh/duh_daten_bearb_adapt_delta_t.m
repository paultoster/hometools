% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function s_duh = duh_daten_bearb_adapt_delta_t(data_selection,s_duh)

% Abtastung fragen
s_frage.frage        = 'Welche Abtastzeit verwenden';
s_frage.command      = 'delta_t';
s_frage.type         = 'double';
s_frage.min          = 0;


[okay,delta_t,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

% Zeitvektoren und Wertevektior anpassen
for i=1:length(data_selection)
    
    i_data  = data_selection(i);
    c_names = fieldnames(s_duh.s_data(i_data).d);
    
    if( ~is_monoton_steigend(s_duh.s_data(i_data).d.(c_names{1})) )

        warning('duh_amin:duh_daten_bearb_adapt_delta_t' ...
               ,'\n\nMessignal <%s> aus %i. Datensatz <%s> is nicht monoton steigend' ...
               ,c_names{1} ...
               ,i_data ...
               ,s_duh.s_data(i_data).name);
        return
    end
end
    
for i=1:length(data_selection)
    
    i_data  = data_selection(i);
    c_names = fieldnames(s_duh.s_data(i_data).d);
    icount = 0;
    clear s_col
    
            
            
    icount                 = icount + 1;            
    s_col(icount).n        = length(s_duh.s_data(i_data).d.(c_names{1}));
    s_col(icount).time     = s_duh.s_data(i_data).d.(c_names{1});
    s_col(icount).time_new = [s_col(icount).time(1):delta_t:s_col(icount).time(length(s_col(icount).time))]';
            
    
    for j=1:length(c_names)
                
        if( j == 1 )
            
            t0 = s_duh.s_data(i_data).d.(c_names{j})(1);
            t1 = s_duh.s_data(i_data).d.(c_names{j})(length(s_duh.s_data(i_data).d.(c_names{j})));
            
            s_duh.s_data(i_data).d.(c_names{j}) = [t0:delta_t:t1]';
        else
            
            index = 0;
            for k=1:length(s_col)
                
                
                n = length(s_duh.s_data(i_data).d.(c_names{j}));
                if( s_col(k).n == n )
                    index = k;
                    break;
                end
            end
            
            if( index > 0 )
                
                s_duh.s_data(i_data).d.(c_names{j}) = interp1(s_col(index).time ...
                                                             ,s_duh.s_data(i_data).d.(c_names{j}) ...
                                                             ,s_col(index).time_new ...
                                                             ,'linear');
            end
        end
    end
            
        
        
end