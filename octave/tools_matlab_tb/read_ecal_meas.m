function [data,okay,mess_dir,mess_file] = read_ecal_meas(mess_path)
%
% [data,okay,mess_dir,mess_file] = read_ecal_meas;
% [data,okay,mess_dir,mess_file] = read_ecal_meas(mess_path);
% [data,okay,mess_dir,mess_file] = read_ecal_meas(mess_file);
%
% mess_path    path with measurement
%
% data         measurement-structure if more measurements => last
%              measurement
% okay         =1 if okay
% mess_dir     last mesurement path
% mess_dir     last mesurement file name

  okay = 1;

  if( ~exist('mess_path','var') )
    mess_path = '';
    mess_file = '';
  else
    if( ~exist(mess_path,'file') )
      mess_file = '';
    else
      mess_file = mess_path;
    end
    if( ~exist(mess_path,'dir') )
      mess_path = '';
    end
  end
  
  if( isempty(mess_path) )
    if( qlast_exist(1) )
      start_dir      = qlast_get(1);
    else
      start_dir      = pwd;
    end
  else
    start_dir = mess_path;
  end
  
  if( isempty(mess_file) )
    s_frage.comment     = 'Pfad mit den Matlab-ecal-Messungen auswählen (*_ecal.mat) ';
    s_frage.start_dir   = start_dir;
    s_frage.file_number = 1;
    [okay,c_filenames]  = o_abfragen_files_f(s_frage);
    mess_file           = c_filenames{1};
  end
  
  load(mess_file);
  s_file = str_get_pfe_f(mess_file);
  mess_dir = s_file.dir;
end