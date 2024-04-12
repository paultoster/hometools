function    dspa_namen_anzeigen_f(data)
%
% dspa_namen_anzeigen_f(data)
%
% Dspace-Datenformat; Datennamen (Kanäle) anzeigen
%

n = length(data.Y);

if( n == 0 )
    
    error('suche_index_in_dspa_f: length of data.Y == 0');
end

for i=1:n

    fprintf('%s\n',data.Y(i).Name);
end

