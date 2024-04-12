function liste =  dspa_namen_f(data)
%
% liste =  dspa_namen_f(data)
%
% Dspace-Datenformat; Datennamen inclusive x-Vektor in cell-array-Liste aufnehmen
% liste{i}

n = length(data.Y);

if( n == 0 )
    
    error('suche_index_in_dspa_f: length of data.Y == 0');
end

liste = {};

liste_name{1} = data.X.Name;

for i=1:n
    liste{i+1} = data.Y(i).Name;
end

