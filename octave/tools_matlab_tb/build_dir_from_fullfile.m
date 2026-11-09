function [okay,errtext] = build_dir_from_fullfile(fullfilename)
%
% [okay,errtext] = build_path_from_fullfile(fullfilename)
%
%
  okay    = 1;
  errtext = '';
  s_file = str_get_pfe_f(fullfilename);
  
  if( ~isempty(s_file.dir) )
    [okay,errtext] = build_dir(s_file.dir,0);
  end
end
    