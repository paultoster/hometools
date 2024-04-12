function [h,file_name] = scan_daten_einlesen_figure_erstellen

disp(' Utility zur Dateneingabe über Mouse ' )
disp(' Es wird ein Achsenkreuz aufgespannt,')
disp(' indem mit mouse-klick der Wert eingegeben wird.')
disp(' ')

%
% Image einladen
%
s_frage.comment = 'jpeg-Datei mit Diagramm auswählen';
s_frage.file_spec = '*.jpg';
s_frage.file_number= 1;

[okay,c_filename] = o_abfragen_files_f(s_frage);
if( okay )
    
    file_name = c_filename{1};
    image_val  = imread(file_name);

    % Neue Figure
    h = figure;
    image(image_val);
    hold on
else
    file_name = '';
    h = figure;
    hold on
end
