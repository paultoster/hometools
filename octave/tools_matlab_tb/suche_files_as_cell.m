function c_file_list = suche_files_as_cell(path_spec,file_spec,all_dir_flag,type)
%
% c_file_list = suche_files_as_cell(path_spec,file_spec,all_dir_flag,type)
%
% search of Files => output in cellarray
% path_spec		    char	  Verzeichnis welches durchsucht werden soll
% file_spec       char    Dateiendung, kann auch '*' f?r alle sein
%                         Beispiele 'dat', '*.dat', 'dat;txt' oder
%                         '*.dat;*.txt'
% all_dir_flag		0/1			Alle Unterverzeichnisse mit ducrhsuchen
% type            0       (default) output file-name without path
%                 1                 output file-name with path
% c_file_list     cell    list of File no file c_file_list is empty
  if( ~exist('type','var') )
    type = 0;
  end
  c_file_list = {};
  [file_list,n] = suche_files_f(path_spec,file_spec,all_dir_flag,0);
  
  for i=1:n
    
    if( type )
      c_file_list = cell_add(c_file_list,file_list(i).full_name);
    else
      c_file_list = cell_add(c_file_list,file_list(i).name);
    end  
end