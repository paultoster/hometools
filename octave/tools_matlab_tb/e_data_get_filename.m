function [okay,file_path,file_name,full_file_name] = e_data_get_filename(type)
%
% [okay,file_path,file_name,full_file_name] = e_data_get_filename
% [okay,file_path,file_name,full_file_name] = e_data_get_filename(type)
% 
% Ask for a e_data FileName start dir is pwd (no type-param or type = 0=
% type = 1: start in qlast_get(1)  (stored last meas-path)
%
  okay = 1;
  rpath= '';

  if( ~exist('type','var') )
    type = 0;
  end
  
  if( type == 0 )
    dirmess = pwd;
  else
    dirmess  = qlast_get(1);
  end
    
  s_frage.comment   = 'e-mat-Dateien (e_*.mat) auswählen';
  s_frage.start_dir = dirmess;
  s_frage.file_spec   = '*_e.mat';
  s_frage.file_number = 1;

  [file_okay,c_filesnames] = o_abfragen_files_f(s_frage);

  if( ~file_okay )
    warning('keine Datei ausgewählt !!!');
    okay = 0;
    return
  else
    filename =  c_filesnames{1};
  end
      
  if( ~exist(filename,'file') )
      warning('Dateiname: %s existiert nicht',filename);
      okay = 0;
      return;
  end
  
  full_file_name = filename;
  file_path      = fullfile_get_dir(filename);
  file_name      = get_file_name(filename);
  
end