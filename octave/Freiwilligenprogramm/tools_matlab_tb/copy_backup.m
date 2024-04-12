function [status, message] = copy_backup(tfile,add_to_bak)
%
% [status, message] = copy_backup(tfile,add_to_bak)
%
  s_file = str_get_pfe_f(tfile);
  
  bfile  = fullfile(s_file.dir,[s_file.name,add_to_bak,'.',s_file.ext]);
  
  [status, message] = copyfile(tfile,bfile);
  
end