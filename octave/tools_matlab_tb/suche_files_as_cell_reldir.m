function c_file_list = suche_files_as_cell_reldir(path_spec,file_spec,all_dir_flag,source_dir)
%
% c_file_list = suche_files_as_cell_reldir(path_spec,file_spec,all_dir_flag,source_dir)
%
% search of Files with path relative to source_dir => output in cellarray
% path_spec		    char	  Verzeichnis welches durchsucht werden soll
% file_spec       char    Dateiendung, kann auch '*' f?r alle sein
%                         Beispiele 'dat', '*.dat', 'dat;txt' oder
%                         '*.dat;*.txt'
% all_dir_flag		0/1			Alle Unterverzeichnisse mit ducrhsuchen
% source_dir              Pfad zu dem relativ ausgegeben wird
% c_file_list     cell    list of File no file c_file_list is empty

  c_file_list = {};
  [file_list,n] = suche_files_f(path_spec,file_spec,all_dir_flag,0);
  
  for i=1:n
    
    rel_dir     = get_rel_dir(file_list(i).dir,source_dir);
    target_file = fullfile(rel_dir,file_list(i).name);
    c_file_list = cell_add(target_file);
  end  
end