function  [okay,d,u,h] = data_get_fields_duh_f(s_data)

okay = 1;
d = [];
u = [];
h = {};

% Globale struktur prüfen
if( ~strcmp(class(s_data),'struct') ...
  | ~strcmp(class(s_data.d),'struct') ...
  )
    okay = 0;
    return
end

% Werte aus s_data.d auswählen
% Feldnamen bestimmen
c_dnames = fieldnames(s_data.d);

% Anzahl der Feldnamen prüfen
dlen = length(c_dnames);
if( dlen == 0 )
    okay = 0;
    return
end

% Werte aus den Feldnamen prüfen und zuordenen
found_flag = 0;
for i=1:dlen
  
    if( i == 116 )
      a = 0;
    end
    dname = char(c_dnames{i});
    child = getfield(s_data.d,dname);
    
    if( strcmp(class(child),'double') )
        d.(dname) = child;
        found_flag = 1;
    elseif( strcmp(class(child),'single') )
        d.(dname) = child;
        found_flag = 1;
    elseif( iscell(child) )
        d.(dname) = child;
        found_flag = 1;
    end
    
end
    
% Wenn keine Werte gefunden
if( ~found_flag )
    okay = 0;
    return
end

% Einheiten zurodnen
if( isfield(s_data,'u') && isstruct(s_data.u) )

    % Feldnamen bestimmen
    c_unames = fieldnames(s_data.u);

    % Anzahl der Feldnamen prüfen
    ulen = length(c_unames);
end
    
c_dnames = fieldnames(d);
dlen = length(c_dnames);

if( isfield(s_data,'u') && isstruct(s_data.u) && (ulen > 0) )
    
    for i=1:dlen
        
        dname = char(c_dnames{i});
        found_flag = 0;
        for j=1:ulen
            uname = char(c_unames{j});
            if( strcmp(dname,uname) && ischar(c_unames{j}) )
                found_flag = 1;
                u.(dname) = s_data.u.(c_unames{j});
                break;
            end
        end
        if( ~found_flag )
            u.(dname) = '-';
        end
    end
else
    for i=1:dlen
        dname = char(c_dnames{i});
        u.(dname) = '-';
    end
end

if( isfield(s_data,'h') )
    h = s_data.h;
end
len = length(h);
h{len+1} = [datestr(now),' read-duh-data'];


                       
