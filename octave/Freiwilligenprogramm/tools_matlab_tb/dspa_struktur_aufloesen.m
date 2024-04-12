% dspa_struktur_aufloesen
%
% Dspace-Datenstruktur dspa_data in Vektoren auflösen
%
if( ~exist('dspa_data','var') )
    error('dspa_struktur_aufloesen.m: Variable dspa_set existiert nicht')
end
command = [dspa_data.X.Name,'=dspa_data.X.Data'';'];
eval(command);

liste_namen = dspa_y_namen_f(dspa_data);

for i=1:length(liste_namen)
    
    index   = dspa_suche_data_index_f(dspa_data,char(liste_namen{i}));
    command = sprintf('=dspa_data.Y(%i).Data'';',index);
    command = [char(liste_namen{i}),command];
    eval(command);
end