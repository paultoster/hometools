function    index = dspa_suche_data_index_f(data,Name);
%
% index = dspa_suche_data_index_f(data,Name);
%
% Dspace-Datenstruktur nach einem Datenkanal suchen
% data    struct    Datenstruktur
% Name    char      Name des Kanals
%
index = 0;
n = length(data.Y);

if( n == 0 )
    
    error('suche_index_in_dspa_f: length of data.Y == 0');
end

for i=1:n
    
    if( strcmp(data.Y(i).Name,Name) )
        index = i;
        break
    end
end

if( index == 0 )
    fprintf('\n Name : %s\n',Name)
    error('suche_index_in_dspa_f: Name not found in data')
end