function abs_dir = get_abs_dir(rel_dir,proj_dir,build_flag)
%
% abs_dir = get_abs_dir(rel_dir,proj_dir)
% abs_dir = get_abs_dir(rel_dir,proj_dir,build_flag)
%
% build_flag = 1:  build proj_dir if not exist
%            = 0:  (default) don't build
%
  if( ~exist('build_flag','var') )
    build_flag = 0;
  end
  if( ~exist(proj_dir,'dir') && build_flag )
    
    [okay,errtext] = build_dir(proj_dir);

    if( ~okay )
      error('%s:  Fehler:%s',mfilename,errtext);
    end
  end
  old_dir = pwd;
  try
    cd(proj_dir);
    abs_dir = getfullpath(rel_dir);
    cd(old_dir);
  catch
    cd(old_dir);
    error('Es ist was schief gegangen: cd(''%s'');abs_dir = getfullpath(''%s'');',proj_dir,rel_dir);
  end
end