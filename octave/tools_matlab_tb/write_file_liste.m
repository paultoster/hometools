function write_file_liste(dir_name,file_ext,sub_pathes,type)
%
% write_file_liste(dir_name,file_ext,sub_pathes,type)
%
% Schreibt eine cell-array-Liste mit den gewünschten Dateien
%
%
% dir_name		    char	  Verzeichnis welches durchsucht werden soll
% file_ext        char    Dateiendung, kann auch '*' f?r alle sein
%                         Beispiele 'dat', '*.dat', 'dat;txt' oder
%                         '*.dat;*.txt'
%                         (default '*')
% sub_pathes		  0/1		  Alle Unterverzeichnisse mit ducrhsuchen
%                         (default: 0)
% type                    1: an den Bildschirm (default)

  if( ~exist('type','var' ) )
    type = 1;
  end
  if( ~exist('sub_pathes','var' ) )
    sub_pathes = 0;
  end  
  if( ~exist('file_ext','var' ) )
    file_ext = 0;
  end
  
  [file_list,n] =suche_files_f(dir_name,file_ext,sub_pathes);
  
  c = cell(1,n+1);
  for i=1:n
    if( i == 1  )
      c{i} = sprintf('c_file_list = {''%s'' ...',file_list(i).full_name);
    else
      c{i} = sprintf('              ,''%s'' ...',file_list(i).full_name);
    end
  end
  c{n+1} = sprintf('              };');
  
  if( type == 1 )
    
    for i=1:length(c)      
      fprintf('%s\n',c{i});
    end
  end
end
    



