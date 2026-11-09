function [file_list,i_file_list] = suche_files_f(path_spec,file_spec,all_dir_flag,path_is_file_flag,name_of_body)
%
% [file_list,file_list_len] = suche_files_f(path_spec,file_spec)
% [file_list,file_list_len] = suche_files_f(path_spec,file_spec,all_dir_flag)
% [file_list,file_list_len] = suche_files_f(path_spec,file_spec,all_dir_flag,path_is_file_flag)
% [file_list,file_list_len] = suche_files_f(path_spec,file_spec,all_dir_flag,path_is_file_flag,name_of_body)
%
% path_spec		    char	  Verzeichnis welches durchsucht werden soll
% file_spec       char    Dateiendung, kann auch '*' f?r alle sein
%                         Beispiele 'dat', '*.dat', 'dat;txt' oder
%                         '*.dat;*.txt'
% all_dir_flag		0/1			(default:0) Alle Unterverzeichnisse mit ducrhsuchen
% path_is_file_flag 0/1   (default:0) path_spec ist ein file mit vollständigen Pfad 
% name_of_body            (default: '') Soll dieser Anteil in body des Filenamens sein
%                                       zB name_of_body='ABC'  ist 'ABC.ini'
%                                       oder name_of_body='ABC*' ist
%                                       'ABC.ini' und z.B. 'ABCdef.ini'
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

if( ~exist('file_spec','var') )
    file_spec = '*';
end
if( ~exist('all_dir_flag','var') )
    all_dir_flag = 0;
end
if( ~exist('path_is_file_flag','var') )
  path_is_file_flag = 0;
end
if( ~exist('name_of_body','var') )
  name_of_body = '';
end


if( ~path_is_file_flag )
  if( all_dir_flag )
      c_dir = s_subpathes_f(path_spec);
  elseif( ischar(path_spec) )
      c_dir = {path_spec};
  else
      c_dir = path_spec;
  end
end
c_fspec = str_split(file_spec,';');
[m,n] = size(c_fspec);
c_espec = cell(m,n);
for i=1:length(c_fspec)
  ttt = c_fspec{i};
  i1=max(strfind(char(ttt),'.'));
  if( ~isempty(i1) )
      c_fspec{i} = char(ttt(i1+1:length(c_fspec{i})));
      if( i1 > 1 )
        c_espec{i} = str_change_f(char(ttt(1:i1-1)),'*','');
      else
       c_espec{i} = '';
      end
  else
    c_espec{i} = '';
  end
end

if( path_is_file_flag )
  if( ischar(path_spec) )
    file_name = {path_spec};
  else
    file_name = path_spec;
  end
  c_dir = {};
  for i=1:length(file_name)
    s_f = str_get_pfe_f(file_name{i});
    c_dir = cell_add(c_dir,s_f.dir);
    file_name{i} = fullfile(s_f.dir,[s_f.name,'.',c_fspec{min(length(c_fspec),i)}]);
  end
end

file_list   = [];
i_file_list = 0;

for icd = 1:length(c_dir)
    
    if( path_is_file_flag )
      dirlist = dir(file_name{icd});
    else
      dirlist = dir(c_dir{icd});
    end

%     if( length(dirlist) == 0 && ~all_dir_flag )
%         error('suche_files_f: path_spec ist nicht gültig')
%         frprintf('\n path_spec = %s\n',path_spec);
%         return
%     end

    j =0;
    clear file_list_min
    for i=1:length(dirlist)

        if( ~dirlist(i).isdir )

            i1 = max(strfind(char(dirlist(i).name),'.'));
            if( isempty(i1) )
                found_spec = '';
                body_name  = dirlist(i).name;
            else
                found_spec = char(dirlist(i).name(i1+1:length(dirlist(i).name)));
                if( i1 > 1 )
                  body_name = dirlist(i).name(1:i1-1);
                else
                  body_name = '';
                end
            end

            for k=1:length(c_fspec)
              if( strcmpi(c_fspec{k},found_spec) || path_is_file_flag || strcmp(c_fspec{k},'*') )
                if(  isempty(c_espec{k}) ...
                  || (str_find_f(body_name,c_espec{k},'rs') == (length(body_name)-length(c_espec{k})+1)) ...
                  )
                  j = j+1;
                  file_list_min(j) = dirlist(i);
                end
              end
            end
%         else
%             if( ~strcmp(dirlist(i).name,'.') & ~strcmp(dirlist(i).name,'..') )
%                 j            = j+1;
%                 file_list(j) = dirlist(i);
%                 found_flag   = 1;
%             end
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
              fprint "Error"
            end
        end
    end    
end

if( ~isempty(name_of_body) )
  liste_names = {};
  for i=1:i_file_list
    liste_names = cell_add(liste_names,file_list(i).body);
  end
  cliste = cell_find_names(liste_names,name_of_body);
  i_file_list_2 = 0;
  for i = 1:length(cliste)
    for j = 1:i_file_list
      if( strcmpi(cliste{i},file_list(j).body) )
        i_file_list_2 = i_file_list_2 + 1;
        file_list_2(i_file_list_2) = file_list(j);
      end
    end
  end
  file_list   = file_list_2;
  i_file_list = i_file_list_2;
end
%fprintf('pathlist \n');
%for i=1:length(pathlist)
%    
%    fprintf('%s\n',pathlist(i).name)
%end
