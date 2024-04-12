function file_list = suche_one_file_f(path_spec,file_name,all_dir_flag)
%
% file_list = suche_one_file_f(path_spec,file_spec,all_dir_flag)
%
% path_spec		    char	  Verzeichnis welches durchsucht werden soll
% file_name       char    Dateiname
% all_dir_flag		0/1			Alle Unterverzeichnisse mit ducrhsuchen
%
% file_list(i).name     char    Name mit extension
%             .full_name char   vollerName mit Pfad
%             .body     char    Name ohne extension
%             .dir     char    Pfad
%             .ext      char    Endung
%             .date     char    datum letzte Änderung
%             .bytes    double  Bytelänge
%
% z.B. file_list = suche_files_f('D:\CAN_Messungen','asc',0);
%

if( ~exist('file_name','var') )
    error('%s: Parameter file_name muß angegeben werden',mfilename);
end
if( ~exist('all_dir_flag','var') )
    all_dir_flag = 0;
end

if( all_dir_flag )
    
    c_dir = s_subpathes_f(path_spec);
else
    c_dir = {path_spec};
end



file_list   = [];
i_file_list = 0;

for icd = 1:length(c_dir)
    
    dirlist = dir(c_dir{icd});

    j =0;
    clear file_list_min
    for i=1:length(dirlist)

        if( ~dirlist(i).isdir )


            if( strcmpi(file_name,char(dirlist(i).name)) )
                j = j+1;
                file_list_min(j) = dirlist(i);
            end
        end
    %    fprintf('%s\n',dirlist(i).name)
    end
    if( exist('file_list_min','var') )
        for i=1:length(file_list_min)

            i_file_list = i_file_list + 1;
            
            file_list(i_file_list).full_name = fullfile(c_dir{icd},file_list_min(i).name);

            s_f  = str_get_pfe_f(file_list(i_file_list).full_name);

            file_list(i_file_list).body  = s_f.name;
            file_list(i_file_list).dir   = s_f.dir;
            file_list(i_file_list).ext   = s_f.ext;
            file_list(i_file_list).name  = [s_f.name,'.',s_f.ext];
            
            dlist = dir(file_list(i_file_list).full_name);
            try
              file_list(i_file_list).date  = dlist(1).date;
              file_list(i_file_list).bytes = dlist(1).bytes;
            catch
              print "Error"
            end
        end
    end    
end
%fprintf('pathlist \n');
%for i=1:length(pathlist)
%    
%    fprintf('%s\n',pathlist(i).name)
%end
