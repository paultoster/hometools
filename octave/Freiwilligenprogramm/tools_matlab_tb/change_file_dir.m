function f = change_file_dir(filename,dir_path)
%
% f        = change_file_dir(filename,dir);
%
% Wechselt Pfad aus

  s_file = str_get_pfe_f(filename);  
  if( ~isempty(s_file.ext) )
    f = fullfile(dir_path,[s_file.name,'.',s_file.ext]);
  else
    f = fullfile(dir_path,s_file.name);
  end
  
end