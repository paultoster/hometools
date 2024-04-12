function files = get_files_from_path(varargin)
%
% files = get_files_from_path(['ext','mat'] ...
%                    ,['part_of_name','_mod'] ...
%                    ,['start_dir','d:\'] ... 
%                    ,['path','d:\abc\def'] ...
%                    ,['all_pathes',0] ...
%                    ,['comment',0] ...
%                    ,['print_on_screen',0])
% auch: ['path',{'d:\abc\def','d:\abc\ghj'}] 
% ext:      Extension, wenn weggelassen, dann alle Files
% start_dir: Bei Abfrage beginnendes Verzeichnis
% path:      Wenn Pfad bekannt kein Abfrage, ansonsten Abfrage
% all_pathes: 0 nur path ohne Unterpfade
%             1 alle Unterpfade (default)
% comment:   Zusatz-Kommentar bei Frage
% print_on_screen: 0: nix
%                  1: Schreibt alle Files an den Bildschirm
%                  2: Schreibt als Liste zum Kopieren
%
% output: cell-array mit vollständigen Dateinamen
%
get_all_flag = 1;
files = {};

path       = '';
ext        = '-';
start_dir  = '';
all_pathes = 1;
comment    = '';
part_of_name = '';
part_name_flag = 0;
not_part_of_name = '';
not_part_name_flag = 0;
print_on_screen = 0;

i = 1;
while( i+1 <= length(varargin) )

    c = lower(varargin{i});
    switch c
        case 'path'
            path = varargin{i+1};
        case 'ext'
            ext = varargin{i+1};
        case 'start_dir'
            start_dir = varargin{i+1};
        case 'all_pathes'
            all_pathes = varargin{i+1};
        case 'comment'
            comment = varargin{i+1};
        case 'part_of_name'
            part_of_name = varargin{i+1};
        case 'not_part_of_name'
            not_part_of_name = varargin{i+1};
        case 'print_on_screen'
            print_on_screen = varargin{i+1};
        otherwise

            error('%s: Attribut <%s> nicht okay',mfilename,varargin{i})

    end
    i = i+2;
end

if( ~exist('path','var') )
    path = {};
end

if( ischar(path) )
  path = {path};
end

ppath  = {};
nppath = 0;
for i = 1:length(path)
  if( exist(path{i},'dir') )
    nppath   = nppath + 1;
    ppath{nppath} = path{i};
  end
end
path = ppath;

i = str_find_f(ext,'.','rs');
if( i == length(ext) )
    ext = '';
elseif( i > 0 )
    ext = ext(i+1:length(ext));
end
if( isempty(ext) )
    get_all_flag = 1;
end

if( ~exist(start_dir,'dir') )
    
    d=getdrives;
    start_dir = d{1};
end
if( all_pathes )
    all_pathes = 1;
end

if( ~isempty(part_of_name) )
  part_name_flag = 1;
end
if( ~isempty(not_part_of_name) )
  not_part_name_flag = 1;
end

if( isempty(path) ) 
  s_frage             = [];
  if( get_all_flag )
      s_frage.comment     = sprintf('Verzeichnis auswählen %s',comment);
  else
      s_frage.comment     = sprintf('Verzeichnis für Dateien mit ext:%s auswählen %s',ext,comment);
  end

  s_frage.start_dir = start_dir;

  [okay,c_dirname] = o_abfragen_dir_f(s_frage);
else
  okay = 1;
  c_dirname = path;
end
if( okay )
  im = 0;
  for j = 1:length(path)
    s_files = suche_files_f(c_dirname{j},ext,all_pathes);
    for i=1:length(s_files)
      flag = 0;
      if( part_name_flag )
        if( str_find_f(s_files(i).body,part_of_name) > 0 )
          flag = 1;
        end
      else
          flag = 1;
      end
      if( not_part_name_flag )
        if( str_find_f(s_files(i).body,not_part_of_name) > 0 )
          flag = 0;
        end
      end
      if( flag )
        im = im +1;
        files{im} = s_files(i).full_name;
      end
    end
  end
  
  if( print_on_screen == 2)
    
    fprintf('liste = { ...\n');
    for ifiles = 1:length(files)
      if( ifiles == 1 )
        fprintf('        ''%s'' ...\n',files{ifiles});
      else
        fprintf('       ,''%s'' ...\n',files{ifiles});
      end
    end
    fprintf('        };\n');
    
  elseif( print_on_screen )
    for ifiles = 1:length(files)
      fprintf('%s\n',files{ifiles});
    end
    
  end
end