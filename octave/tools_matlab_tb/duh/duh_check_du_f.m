function    u = duh_check_du_f(d,u)

c_names_d = {};
c_names_u = {};
if( ~isstruct(d) )
    error('duh_check_du_f: d muss eine Struktur sein')
end
c_names_d = fieldnames(d);
if( isstruct(u) )
    c_names_u = fieldnames(u);
end

for i=1:length(c_names_d)
    found_flag = 0;
    for j=1:length(c_names_u)
        
        if( strcmp(c_names_d{i},c_names_u{j}) )
            found_flag = 1;
            break;
        end
    end
    
    if( ~found_flag )
        u.(c_names_d{i}) = '';
    end
end

c_names_u = fieldnames(u);

if(length(c_names_u) > length(c_names_d) )

    for i=1:length(c_names_u)
        found_flag = 0;
        for j=1:length(c_names_d)
        
            if( strcmp(c_names_u{i},c_names_d{j}) )
                found_flag = 1;
                break;
            end
        end
    
        if( ~found_flag )
            u = rmfield(u,c_names_u{i});
        end
    end
end

% Prüfe, ob Einheit eins tring ist
c_names_u = fieldnames(u);

for i=1:length(c_names_u)
    
    if( ~strcmp(class(u.(c_names_u{i})),'char') )
        
        u.(c_names_u{i}) = '-';
    end
end
