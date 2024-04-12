function fliste = cg_get_ecal_dirs
%
%  fliste = cg_get_ecal_dirs;
% 
%  asks for start dir to search for ecal measurements pathzes
%
% Ausgabe:
% Struktur-Liste:
%
% fliste(i).name        = 'measxyz'          Name
% fliste(i).meas_dir    = 'd:\abc\measxyz'   Verzeichnis
% fliste(i).can_file    = 'calogXXX.asc'     can-asc-file
% fliste(i).ecal        = 0/1                ist ecal-Messung vorhanden
% fliste(i).tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
% fliste(i).description = 0/1                ist description-file vorhanden
% fliste(i).ecal_files  = {...}              liste mit hdf5-Files

  q.read_type = 1;
  q.start_dir = qlast_get(1);
  q.ECALread  = 1;
  q.CANread   = 0;

  fliste = cg_get_can_asc_filenames(q);

end
