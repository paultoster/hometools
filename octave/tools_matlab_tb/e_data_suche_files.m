function [okay,file_list,file_list_len] = e_data_suche_files(path_spec,all_dir_flag)

%
% [okay,file_list,file_list_len] = e_data_suche_files(path_spec,all_dir_flag);
%
%   Sucht in einem Verzeichnis nach mat-Files mit name_e.mat
%
%   path_spec		    char	  Verzeichnis welches durchsucht werden soll
%   all_dir_flag		0/1			Alle Unterverzeichnisse mit ducrhsuchen
%
%   file_list(i).name     char    Name mit extension
%               .full_name char   vollerName mit Pfad
%               .body     char    Name ohne extension
%               .dir     char    Pfad
%               .ext      char    Endung
%               .date     char    datum letzte Änderung
%               .bytes    double  Bytelänge
%
% i = 1:file_list_len
% 
  okay          = 1;
  file_list     = [];
  file_list_len = 0;
  
  [file_list0,file_list_len0] = suche_files_f(path_spec,'mat',all_dir_flag,0);
  
  for i=1:file_list_len0
    
    ll   = length(file_list0(i).body);
    
    if( (file_list0(i).body(ll-1) == '_') && (file_list0(i).body(ll) == 'e') )
      file_list_len = file_list_len + 1;
      if( file_list_len == 1 )
        file_list = file_list0(i);
      else
        file_list(file_list_len) = file_list0(i);
      end
    end
  end
end