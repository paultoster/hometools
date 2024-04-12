function s = get_abs_rel_path(root_dir,file_liste,dirtype)
%
% s = get_abs_rel_path(root_dir,filename[,0])
% s = get_abs_rel_path(root_dir,dirname,1)
% s = get_abs_rel_path(root_dir,file_liste[,0])
% s = get_abs_rel_path(root_dir,dir_liste,1)
%
% root_dir       Verzeichnis in Relation zu den relativen Pfaden bzw. womit der relative Pfad gebildet wird
% filename       char      vollständigen  Filenamen
% dirname        char      Verzeichnisname
% file_liste     cellarray Liste mit vollständigen Filenamen
% dir_liste      cellarray Liste mit Verzeichnisnamen
% dirtype        0         take filename or file_liste
%                1         take dirname or dir_liste
%
% s(i).abs_dir   Absolutes Verzeichnis
% s(i).rel_dir   relatives Verzeichnis, wenn gleiches Laufwerk
% s(i).abs_fullfile   Datei mit Absolutes Verzeichnis
% s(i).rel_fullfile   DAtei mit relatives Verzeichnis, wenn gleiches Laufwerk
  s = [];
  if( ~exist('dirtype','var') )
    dirtype = 0;
  end
  
  if( ischar(file_liste) )
    file_liste = {file_liste};
  end
  n = length(file_liste);
  for i=1:n
    if( dirtype )
      sf.fullfile = file_liste{i};   % Gesamtfilename
      sf.dir      = file_liste{i};            % directory
      sf.name     = '';             % Body
      sf.filename = '';              % filename
      sf.ext      = '';              % Extension
      i0 = str_find_f(file_liste{i},':\');
      if( i0 > 1)
        sf.lw = file_liste{i}(1:i0-1);
      else
        sf.lw = '';
      end
    else
      sf = str_get_pfe_f(file_liste{i});
    end
    s(i).file_name = sf.filename;
     
    if( is_abs_dir(sf.dir) )
      s(i).abs_dir      = sf.dir;
      s(i).abs_fullfile = fullfile(sf.dir,sf.filename);
      sf2            = str_get_pfe_f(root_dir);
      if( strcmpi(sf.lw,sf2.lw) )
        s(i).rel_dir      = get_rel_dir(sf.dir,root_dir);
        s(i).rel_fullfile = fullfile(s(i).rel_dir,sf.filename);
      else
        s(i).rel_dir      = '';
        s(i).rel_fullfile = '';
      end
    else
      s(i).abs_dir      = get_abs_dir(sf.dir,root_dir);
      s(i).abs_fullfile = fullfile(s(i).abs_dir,sf.filename);
      s(i).rel_dir      = sf.dir;
      s(i).rel_fullfile = fullfile(s(i).rel_dir,sf.filename);
    end
  end
end
