%Einladen von matlabdaten in workspace
% mit Abfrage des Files
[matload_file_17287,matload_pathname_17287] = uigetfile( ...
                                  {'*.mat','MAT-files (*.mat)'; ...
                                   '*.*',  'All Files (*.*)'}, ...
                                   'Matlab-File einladen');
                               
load(fullfile(matload_pathname_17287,matload_file_17287));

clear matload_pathname_17287 matload_file_17287