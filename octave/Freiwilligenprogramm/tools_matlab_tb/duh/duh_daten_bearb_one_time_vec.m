% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function s_duh = duh_daten_bearb_one_time_vec(data_selection,s_duh)


% Zeitvektoren suchen
icount = 0;
for i=1:length(data_selection)
    
    i_data = data_selection(i);

    c_names = fieldnames(s_duh.s_data(i_data).d);

    clear s_t s_v
    i_t = 0;
    i_v = 0;
    for j=1:length(c_names)
        
        text = lower(char(c_names{j}));
        
        if( length(strfind(text,'time')) > 0 | j == 1 )
            i_t = i_t + 1;
            s_t(i_t).name = char(c_names(j));
            command = sprintf('s_t(i_t).n = length(s_duh.s_data(i_data).d.%s);',char(c_names(j)));
            eval(command);
            command = sprintf('s_t(i_t).delta_t = s_duh.s_data(i_data).d.%s(2)-s_duh.s_data(i_data).d.%s(1);',char(c_names(j)),char(c_names(j)));
            eval(command);
            %* Für die Frageliste
            icount = icount + 1;
            s_frage.c_liste{icount} = sprintf('%s delta_t = %g (data_set:%i)',s_t(i_t).name,s_t(i_t).delta_t,i_data);
            s_frage.c_name{icount}  = s_t(i_t).name;
            command = sprintf('c_time{icount} = s_duh.s_data(i_data).d.%s;',char(c_names(j)));
            eval(command);
        else
            i_v = i_v + 1;
            s_v(i_v).name = char(c_names(j));
            command = sprintf('s_v(i_v).n = length(s_duh.s_data(i_data).d.%s);',char(c_names(j)));
            eval(command);            
            
        end
    end
    
    for j=1:length(s_v)
        
        s_v(j).i_t = 0;
        for k=1:length(s_t)
            
            if( s_t(k).n == s_v(j).n ) % zugehöriger Zeitvektor
                s_v(j).i_t = k;
                break;
            end
        end
    end
    
    s_col(i).s_t = s_t;
    s_col(i).s_v = s_v;
end

% Zeitvektor aussuchen

if( length(data_selection) > 1 )
    s_frage.frage          = sprintf('Einen Zeitvektor auswählen (der in allen DAtensätzen enthalten ist) ?');
else
    s_frage.frage          = sprintf('Einen Zeitvektor auswählen  ?');
end
s_frage.command        = 'name';
s_frage.single         = 1;
s_frage.prot           = 1;
s_frage.prot_name     = 1;
s_frage.sort_list      = 1;

[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);


time = c_time{selection};

for i=1:length(data_selection)
    
    i_data = data_selection(i);    
    s_v = s_col(i).s_v;
    s_t = s_col(i).s_t;
    
    
    for j=1:length(s_v)
        
        if( s_v(j).i_t ~= 0 )
            command = sprintf('s_duh.s_data(i_data).d.%s = interp1(s_duh.s_data(i_data).d.%s,s_duh.s_data(i_data).d.%s,time,''linear'',''extrap'');' ...
                                 ,s_v(j).name,s_t(s_v(j).i_t).name,s_v(j).name);
            eval(command);
        end
    end            
    for j=1:length(s_t)
        
        command = sprintf('s_duh.s_data(i_data).d.%s = time;' ...
                                 ,s_t(j).name);
        eval(command);
    end            
end