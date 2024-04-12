function flag = is_file_in_dir(filename,search_dir,searchsubs)
%
% flag = is_file_in_dir(file,search_dir)
% flag = is_file_in_dir(file,search_dir,1)
%
% is file in search dir and all subs
%
% % flag = is_file_in_dir(file,search_dir,0)
%
% is file in search dir (no search in subs)
%
%
  flag = 0;
  if( ~exist('searchsubs','var') )
    searchsubs = 1;
  end
  if( searchsubs )
    c_all_dir_list = get_sub_dirs(search_dir);
  elseif( ischar(search_dir) )
    c_all_dir_list = {search_dir};
  elseif( iscell(search_dir) )
    c_all_dir_list = search_dir;
  else
    error('%s_error: search_dir is not cell or char',mfilename);
  end
  s_file = str_get_pfe_f(filename);
  
  % wenn kein Verzeichnis angegeben, in search_dir suchen
  if( isempty(s_file.dir) || strcmp(s_file.dir,'.') )
    [flag,~] = suche_file_in_dir(search_dir,filename,searchsubs);
  else
    ifound = cell_find_f(c_all_dir_list,s_file.dir,'vl');
    if( ~isempty(ifound) )
      flag = 1;
    end
  end
  
  
end
