function flag = is_abs_dir(sdir)
%
% flag = is_abs_dir(sdir)
%
  flag   = 0;
  sdir = str_change_f(sdir,'/','\');
  cnames = str_split(sdir,'\');

  if( str_find_f(cnames{1},':') )
    flag = 1;
  end
end