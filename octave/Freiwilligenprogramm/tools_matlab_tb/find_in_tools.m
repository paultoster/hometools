function find_in_tools(text,dir1)
%

if( nargin < 1 )
    text = '*';
end

text = lower(text);

if( nargin < 2 )
    dir1 = pwd;
end

cpath = {};
sdir = dir(dir1);
head_flag = 1;
okay_flag = 0;
for is=1:length(sdir)

    % Verzeichnis
    %============
    if( sdir(is).isdir )
      if( strcmpi(text,sdir(is).name) )
        okay_flag = 1;
        path_spec = fullfile(dir1,text);
        file_list = suche_files_f(path_spec,'m');
        for i=1:length(file_list)
          sfile = str_get_pfe_f(file_list(i).full_name);

          if( strcmpi(sfile.ext,'m')  )
            fprintf('m-File: %s\n',sfile.name);
          end
        end
      end
    end

end

if( ~okay_flag )

  for is=1:length(sdir)

      % Verzeichnis
      %============
      if( sdir(is).isdir )

          % Sammeln, wenn nicht . .. oder irgendwie alt old
          %===============================================
          if( ~strcmp(sdir(is).name,'.') && ...
              ~strcmp(sdir(is).name,'..') && ...
              isempty(strfind(lower(sdir(is).name),'old')) && ...
              isempty(strfind(lower(sdir(is).name),'alt')) ...
            )

            cpath{length(cpath)+1} = [dir1,'\',sdir(is).name];
          end

      else

          sfile = str_get_pfe_f(sdir(is).name);

          if( strcmpi(sfile.ext,'m') && ( ~isempty(strfind(lower(sfile.name),text)) || strcmp('*',text) ) )


              if( head_flag )
                  fprintf('\nIn Verzeichnis: %s\n\n',dir1);
                  head_flag = 0;
              end

              fprintf('m-File: %s\n',sfile.name);
          end
      end
  end

  for ic=1:length(cpath)
     find_in_tools(text,cpath{ic});
  end
end
