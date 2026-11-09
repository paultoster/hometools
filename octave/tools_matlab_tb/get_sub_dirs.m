function all_dir_list = get_sub_dirs(start_dir)
%
% all_dir_list = get_sub_dirs(start_dir)
%
% start_dir     char     directory to search sub dirs
%               cell     list with directories to search sub dirs
%
% all_dir_list  cell     list with all sub dirs of start_dir
%

  if( ischar(start_dir) )
    start_dir = {start_dir};
  end
  if( ~iscell(start_dir) )
    error('get_sub_dirs_error: start_dir is not char or cell');
  end
  
  all_dir_list = {};
  for i= 1:length(start_dir)
    
    dd = start_dir{i};
    
    if( exist(dd,'dir') == 7 )
      all_dir_list = cell_add(all_dir_list,dd);
      [all_dir_list,dd] = get_sub_dirs_dir(all_dir_list,dd);
    end
  end
end
function [all_dir_list,dd] = get_sub_dirs_dir(all_dir_list,dd)


  sliste = dir(dd);
  
  for i=1:length(sliste)
    if( sliste(i).isdir && ~strcmp(sliste(i).name,'.') && ~strcmp(sliste(i).name,'..'))
      ddd = fullfile(dd,sliste(i).name);
      all_dir_list = cell_add(all_dir_list,ddd);
      [all_dir_list,ddd] = get_sub_dirs_dir(all_dir_list,ddd);
    end
  end
end