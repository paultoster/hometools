function  [okay,d,u,h] = data_get_fields_struct_vector_f(s_data)

okay = 1;
d = [];
u = [];
h = {};

% Globale struktur prüfen
if( ~isstruct(s_data) )
    okay = 0;
    return
end

% Werte aus s_data auswählen
% Feldnamen bestimmen
c_dnames = fieldnames(s_data);

% Anzahl der Feldnamen prüfen
dlen = length(c_dnames);
if( dlen == 0 )
    okay = 0;
    return
end

% Werte aus den Feldnamen prüfen und zuordenen
found_flag = 0;
for i=1:dlen
    dname = char(c_dnames{i});
    child = getfield(s_data,dname);
    
    if( isnumeric(child) )
        d.(dname) = child;
        found_flag = 1;
    end
    
end
    
% Wenn keine Werte gefunden
if( ~found_flag )
    okay = 0;
    return
end

% Einheiten, die es nicht gibt

c_unames = fieldnames(d);
for i=1:length(c_unames)
    u.(c_unames{i}) = '';
end

% Kommentar
h{1} = [' read-struct-vector-data'];


                       
