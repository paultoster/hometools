function fliste = cg_get_mat_filenames(q)
%
% fliste = cg_get_asc_filenames(q)
%
% q.read_type      = 1  Verzeichnis wird interaktiv ausgewählt
%                       q.start_dir angeben, um
%                       Daten-Verzeichnis auszuwählen
%                       (tacc-Messordner oder Ordner mit
%                       mat-Dateien)
%                       (q.start_dir angeben)
%                  = 2  mat-Dateien interaktiv auswählen
%                       (q.start_dir angeben)
%                  = 3  übergeordnetes Verzeichnis zu Einlesen 
%                       angeben q.read_meas_path angeben, 
%                       (q.read_meas_path angeben)
%                  = 4  Liste mit einzulesenden Messverzeichnissen 
%                       q.read_list = {'dir1',dir2'}oder
%                       explizite Canalyser-Ascii Dateien in
%                       q.read_list = {'datei1.asc','datei2.asc'}
%                       angeben
%                  (default: 2)
%
% q.start_dir        (q.read_type = 1,2) Start-Dir zum Suchen 
% 
% q.read_meas_path   (q.read_type = 3) Verzeichnis unter dem alle 
%                                      Messungen gewandelt werden
% q.read_list        (q.read_type = 4) Liste mit Dateien (Canalyser-ascii)
%                                      oder Verzeichnissen
%
% q.mat_type                           Typ der Matlabdatei
%                                      = 'd' oder '' (default) d-Daten
%                                        Struktur mit Vektoren und einer
%                                        Zeitbasis
%                                      = 'e' oder '' (default) e-Daten
%                                        Struktur mit Vektor-struktur mit
%                                        jeweiliger Zeitbasis (s. e_data_read_mat.m)
%                                      = 'b' oder '' (default) b-Daten
%                                        CAN-Ascci-Daten
%
% q.file_number                        0/n  beliebig/n-Anzahl
%
% Ausgabe:
% Struktur-Liste:
%
% fliste(i).name         = 'measxyz'          Name
% fliste(i).mat_dir      = 'd:\abc\measxyz'   Verzeichnis
% fliste(i).meas_dir     = fliste(i).mat_dir  Verzeichnis
% fliste(i).mat_file     = 'measxyz.mat'      mat-file
% fliste(i).mat_fullfile = 'measxyz.mat'      mat-file
% fliste(i).tacc         = 0/1                ist TaskData-Verzeichnis vorhanden
% fliste(i).description  = 0/1                ist description-file in TaskData-Verzeichnis vorhanden
%
 fliste = struct([]);
 pp = pwd;
 if( ~check_val_in_struct(q,'read_type','num',1) )
   q.read_type = 2;
 end
 if( ~check_val_in_struct(q,'start_dir','char',1) )
   q.start_dir = get_drive(pwd);
 end
 
 if( q.read_type == 3 && check_val_in_struct(q,'read_meas_path','char',1) )
   q.read_meas_path = {q.read_meas_path};
 end
 if( q.read_type == 3 && ~check_val_in_struct(q,'read_meas_path','cell',1) )
   cd(pp);
   error('%s_error: q.read_meas_path nicht angegeben',mfilename);
 end
 if( q.read_type == 3 )
   for i=1:length(q.read_meas_path)
     if( ~exist(q.read_meas_path{i},'dir') )
       cd(pp);
       error('%s_error: q.read_meas_path{i} = <%s> konnte nicht gefunden werden',mfilename,q.read_meas_path{i});
     end
   end
 end
   
 if( q.read_type == 4 && check_val_in_struct(q,'read_list','char',1) )
   q.read_list = {q.read_list};
 end
 if( q.read_type == 4 && ~check_val_in_struct(q,'read_list','cell',1) )
   cd(pp);
   error('%s_error: q.read_list nicht angegeben',mfilename);
 end
 
 if( ~check_val_in_struct(q,'mat_type','char',1) )
   q.mat_type = 'd';
 end
 
 if( ~check_val_in_struct(q,'file_number','num',1) )
   q.file_number = 0;
 end
 
 if(  ~strcmpi(q.mat_type,'d') ...
   && ~strcmpi(q.mat_type,'e') ...
   && ~strcmpi(q.mat_type,'b') ...
   )
   cd(pp);
   error('%_error: q.mat_type = ''%s'' nicht zulässig',q.mat_type)
 end

  read_dir_liste  = {};
  read_file_liste = {};
  % Pfad auswählen, wenn read_type == 1
  if( q.read_type == 1 )
    % Path auswählen
    %---------------
    if(     strcmpi(q.mat_type,'d') ), s_frage.comment   = 'Pfad mit der d-Matlab-Dateien auswählen';
    elseif( strcmpi(q.mat_type,'e') ), s_frage.comment   = 'Pfad mit der e-Matlab-Dateien auswählen';
    else                               s_frage.comment   = 'Pfad mit der b-Matlab-Dateien auswählen';
    end
    s_frage.start_dir = q.start_dir;
    [path_okay,c_dirname] = o_abfragen_dir_f(s_frage);
    if( path_okay )
      %if( strcmpi(get_type_of_matlabfilename(c_dirname{1}),q.mat_type) )
        read_dir_liste = cell_add(read_dir_liste,c_dirname{1});
      %else
      %  error('%s: matla-type der Messung<%s> mit <%s-Struktur> nicht okay',mfilename,c_dirname{1},q.mat_type);
      %end
    else
      cd(pp);
      fliste = [];
      return
    end
  % Datei auswählen, wenn read_type == 2
  elseif( q.read_type == 2 )
    % Path auswählen
    %---------------
    if(     strcmpi(q.mat_type,'d') ), s_frage.comment   = 'd-Matlab-Dateien auswählen';
    elseif( strcmpi(q.mat_type,'e') ), s_frage.comment   = 'e-Matlab-Dateien auswählen';
    else                               s_frage.comment   = 'b-Matlab-Dateien auswählen';
    end
    s_frage.start_dir = q.start_dir;
    s_frage.file_spec   = '*.mat';
    s_frage.file_number = q.file_number;
      
    [file_okay,c_filenames] = o_abfragen_files_f(s_frage);

    if( file_okay )
      q.read_list = {};
      for i=1:length(c_filenames)
        if( strcmpi(get_type_of_matlabfilename(c_filenames{i}),q.mat_type) )
          read_file_liste = cell_add(read_file_liste,c_filenames{i});
        else
          error('%s: matla-type der Messung<%s> mit <%s-Struktur> nicht okay',mfilename,c_filenames{i},q.mat_type);
        end
      end
    else
      cd(pp);
      fliste = [];
      return
    end
  elseif( q.read_type == 3 )
    read_dir_liste = cell_add(read_dir_liste,q.read_meas_path);
  else
  
    for i=1:length(q.read_list)
      
      if( exist(q.read_list{i},'dir') )
        read_dir_liste = cell_add(read_dir_liste,q.read_list{i});
      elseif( exist(q.read_list{i},'file') )
        read_file_liste = cell_add(read_file_liste,q.read_list{i});
      else
        cd(pp);
        error('%s_error: q.read_list{%i}=''%s'' konnte nicht gefunden werden',mfilename,i,q.read_list{i});
      end
    end
  end
% fliste(i).name         = 'measxyz'          Name
% fliste(i).mat_dir      = 'd:\abc\measxyz'   Verzeichnis
% fliste(i).meas_dir     = 'd:\abc\measxyz'   Verzeichnis
% fliste(i).mat_file     = 'measxyz.mat'      mat-file
% fliste(i).mat_fullfile = 'measxyz.mat'      mat-file
% fliste(i).tacc         = 0/1                ist TaskData-Verzeichnis vorhanden
% fliste(i).description  = 0/1                ist description-file in TaskData-Verzeichnis vorhanden
  cd(pp);  
  ifliste = 0;
  for i=1:length( read_dir_liste )
    
    mat_files = suche_files_f(read_dir_liste{i},'mat',1,0);
    
    for j=1:length(mat_files)
      if( strcmpi(get_type_of_matlabfilename(mat_files(j).full_name),q.mat_type) )
        
        ifliste = ifliste + 1;
        fliste(ifliste).name          = mat_files(j).body;
        fliste(ifliste).mat_dir       = mat_files(j).dir;
        fliste(ifliste).meas_dir      = mat_files(j).dir;
        fliste(ifliste).mat_file     = mat_files(j).name;
        fliste(ifliste).mat_fullfile = mat_files(j).full_name;
        if( exist(fullfile(mat_files(j).dir,'TaskData'),'dir') )
          fliste(ifliste).tacc        = 1;
        else
          fliste(ifliste).tacc        = 0;
        end
        if( exist(fullfile(mat_files(j).dir,'description.txt'),'file') )
          fliste(ifliste).description = 1;
        else
          fliste(ifliste).description = 0;
        end
      end
    end
  end
  for i=1:length( read_file_liste )
    
    s_file = str_get_pfe_f(read_file_liste{i});
    
    if( strcmpi(get_type_of_matlabfilename(read_file_liste{i}),q.mat_type) )

      ifliste = ifliste + 1;
      fliste(ifliste).name          = s_file.name;
      fliste(ifliste).mat_dir       = s_file.dir;
      fliste(ifliste).meas_dir      = s_file.dir;
      fliste(ifliste).mat_file      = s_file.filename;
      fliste(ifliste).mat_fullfile  = s_file.fullfile;
      if( exist(fullfile(s_file.dir,'TaskData'),'dir') )
        fliste(ifliste).tacc        = 1;
      else
        fliste(ifliste).tacc        = 0;
      end
      if( exist(fullfile(s_file.dir,'description.txt'),'file') )
        fliste(ifliste).description = 1;
      else
        fliste(ifliste).description = 0;
      end
    end
  end
end
