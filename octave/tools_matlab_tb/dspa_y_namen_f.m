function liste =  dspa_y_namen_f(data)
%
% liste =  dspa_y_namen_f(data)
%
% Dspace-Datenformat; Datennamen ohne x-Vektor in cell-array-Liste aufnehmen
%
% liste{i}

n = length(data.Y);

if( n == 0 )
    
    error('suche_index_in_dspa_f: length of data.Y == 0');
end

liste = {};

for i=1:n
    liste{i} = data.Y(i).Name;
end

