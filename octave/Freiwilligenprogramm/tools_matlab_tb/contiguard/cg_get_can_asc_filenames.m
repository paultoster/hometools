function fliste = cg_get_can_asc_filenames(q)
%
% fliste = cg_get_asc_filenames(q)
%
% q.read_type      = 1  Verzeichnisse müssen ausgewählt werden
%                       q.start_dir angeben, um
%                       Daten-Verzeichnis auszuwählen
%                       (tacc-Messordner oder Ordner mit
%                       CAN-ascii-Dateien)
%                       (q.start_dir angeben)
%                  = 2  CAN-ascii-Dateien auswählen
%                       (q.start_dir angeben)
%                  = 3  übergeordnetes Verzeichnis zu Einlesen 
%                       angeben q.read_meas_path angeben
%                       (q.read_meas_path angeben)
%                  = 4  Liste mit einzulesenden Messverzeichnissen 
%                       q.read_list = {'dir1',dir2'}oder
%                       explizite Canalyser-Ascii Dateien in
%                       q.read_list = {'datei1.asc','datei2.asc'}
%                       angeben
                  % = 5  namexyz_e.mat-Datei einlesen und
                  %      Nachbearbeitung nochmal durchführen
                  % = 6  Verzeichnis auswählen, mit dem
                  %      Namen des  Verzeichnisses wird die
                  %      gespeichert
%                  (default: 2)
%
% q.start_dir        (q.read_type = 1,2) Start-Dir zum Suchen 
%
% q.file_number      (q.read_type = 2)  Anzahl der Dateien =0 beliebig (=0 default) 
% 
% q.read_meas_path   (q.read_type = 3) Verzeichnis unter dem alle 
%                                      Messungen gewandelt werden
% q.read_list        (q.read_type = 4) Liste mit Dateien (Canalyser-ascii)
%                                      oder Verzeichnissen
%
% q.TACCread         = 1   TACC-Messungen sollen eingelsen werden (default 0)
% q.CANread          = 1   CAN-Daten sollen einegelesen werden (default 1)
% q.ECALread         = 1   ECAL-Daten sollen eingelsen werden
%
% q.CANFileNameExclude   cell  auszuschliessende can-Datei-Namen
% q.CANFileNameTACC      char  ausschliesslicher can-Datei-Name bei
%                              TACC-Messung
%
% Ausgabe:
% Struktur-Liste:
%
% fliste(i).name        = 'measxyz'          Name
% fliste(i).meas_dir    = 'd:\abc\measxyz'   Verzeichnis
% fliste(i).can_file    = 'calogXXX.asc'     can-asc-file
% fliste(i).ecal        = 0/1                ist ecal-Messung vorhanden
% fliste(i).tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
% fliste(i).description = 0/1                ist description-file vorhanden
% fliste(i).ecal_files  = {...}              liste mit hdf5-Files

 if( ~check_val_in_struct(q,'TACCread','num',1) )
   q.TACCread = 0;
 end
 if( ~check_val_in_struct(q,'ECALread','num',1) )
   q.ECALread = 0;
 end
 if( ~check_val_in_struct(q,'CANread','num',1) )
   q.CANread = 1;
 end
 if( ~check_val_in_struct(q,'read_type','num',1) )
   q.read_type = 2;
 end
 if( ~check_val_in_struct(q,'start_dir','char',1) )
   q.start_dir = get_drive(pwd);
 end
 if( ~check_val_in_struct(q,'file_number','numeric',1) )
   q.file_number = 0;
 end
 
 if( q.read_type == 3 && ~check_val_in_struct(q,'read_meas_path','char',1) )
   error('%s_error: q.read_meas_path nicht angegeben',mfilename);
 end
 if( q.read_type == 3 && ~exist(q.read_meas_path,'dir') )
   error('%s_error: q.read_meas_path = <%s> konnte nicht gefunden werden',mfilename,q.read_meas_path);
 end
   
 if( q.read_type == 4 && ~check_val_in_struct(q,'read_list','cell',1) )
   error('%s_error: q.read_list nicht angegeben',mfilename);
 end
   
  if( ~check_val_in_struct(q,'CANFileNameExclude','cell') )
    q.CANFileNameExclude = {};
  end
  if( check_val_in_struct(q,'CANFileNameTACC','cell') )
    error('%s_error: q.CANFileNameTACC ist cellarray, soll aber char sein',mfilename);
  end
  if( ~check_val_in_struct(q,'CANFileNameTACC','char') )
    q.CANFileNameTACC = '';
  else
    s_file = str_get_pfe_f(q.CANFileNameTACC);
    q.CANFileNameTACC = s_file.name;    
  end
  % Proof Names
  for i= 1:length(q.CANFileNameExclude)
    
    s_file = str_get_pfe_f(q.CANFileNameExclude{i});
    q.CANFileNameExclude{i} = s_file.name;
  end
  
  can_gz_files_len = 0;
  % Pfad auswählen, wenn read_type == 1
  if( q.read_type == 1 )
    % Path auswählen
    %---------------
    s_frage.comment   = 'Pfad mit den Messungen auswählen';
    s_frage.start_dir = q.start_dir;
    [path_okay,c_dirname] = o_abfragen_dir_f(s_frage);
    if( path_okay )
      q.read_meas_path = c_dirname{1};
    else
      fliste = [];
      return
    end
  % Datei auswählen, wenn read_type == 2
  elseif( q.read_type == 2 )
    % Path auswählen
    %---------------
    s_frage.comment   = 'CAN-Ascii-Dateien auswählen';
    s_frage.start_dir = q.start_dir;
    s_frage.file_spec   = '*.asc';
    s_frage.file_number = q.file_number;
    
    [file_okay,c_filenames] = o_abfragen_files_f(s_frage);

    if( file_okay )
      q.read_list = c_filenames;
      q.read_type = 4;
    else
      fliste = [];
      return
    end
  elseif( q.read_type == 5 )
    % Path auswählen
    %---------------
    s_frage.comment   = 'Pfad mit den Messungen auswählen';
    s_frage.start_dir = q.start_dir;
    [path_okay,c_dirname] = o_abfragen_dir_f(s_frage);
    if( path_okay )
      q.read_meas_path = c_dirname{1};
    else
      fliste = [];
      return
    end
  end

  % Anlegen von allen tacc-dirs (inclusive TaskData)
  % und can_files
  %-------------------------------------------------
  if( (q.read_type == 1) || (q.read_type == 3)|| (q.read_type == 5) )
    
    if( q.ECALread ) % ECAL-Messungen suchen
      ecal_dirs      = get_ecal_files(q.read_meas_path);
      can_files      = suche_files_ext(get_sub_dirs(ecal_dirs),'asc');
      can_files_len  = length(can_files);

    else

      if( q.CANread ) % Canalyser-Messung suchen
        [can_files,can_files_len]       = suche_files_f(q.read_meas_path,'asc',1);
        [can_gz_files,can_gz_files_len] = suche_files_f(q.read_meas_path,'gz',1);
      else
        can_files = [];can_files_len = 0;
      end
      
      if( q.TACCread ) % TACC-Messung suchen
        [tacc_dirs,tacc_dirs_len] = suche_dir(q.read_meas_path,1,'TaskData');
      else
        tacc_dirs = {};tacc_dirs_len = 0; 
      end
    end
    
  else
    n = length(q.read_list);
    can_files     = [];
    can_files_len = 0;
    can_gz_files     = [];
    can_gz_files_len = 0;
    tacc_dirs     = {};
    tacc_dirs_len = 0;
    for i = 1:n
      if( exist(q.read_list{i},'file') == 2 )
        can_file = suche_files_f(q.read_list{i},'asc',0,1);
        can_files_len = can_files_len + 1;
        if( can_files_len == 1 )
          can_files = can_file;
        else
          can_files(can_files_len) = can_file;
        end
        can_gz_file = suche_files_f(q.read_list{i},'gz',0,1);
        if( ~isempty(can_gz_file) )
          can_gz_files_len = can_gz_files_len + 1;
          if( can_gz_files_len == 1 )
            can_gz_files = can_gz_file;
          else
            can_gz_files(can_gz_files_len) = can_gz_file;
          end
        end
        
        
      elseif( exist(q.read_list{i},'dir') == 7 )
        
         tt = str_change_f(q.read_list{i},'/','\');
         [c_names,icount] = str_split(tt,'\');
         
         if( strcmpi(c_names{icount},'TaskData') )
           
            tacc_dirs_len            = tacc_dirs_len +1 ;
            tacc_dirs{tacc_dirs_len} = q.read_list{i};
            
            dd = c_names{1};
            for idd=2:icount-1,dd=fullfile(dd,c_names{idd});end
            
            [cf,cf_len] = suche_files_f(dd,'asc',1);
            for j=1:cf_len
              can_files_len = can_files_len + 1;
              if( can_files_len == 1 )
                can_files = cf(j);
              else
                can_files(can_files_len) = cf(j);
              end
            end
            [cf,cf_len] = suche_files_f(q.read_list{i},'gz',1);
            for j=1:cf_len
              can_gz_files_len = can_gz_files_len + 1;
              if( can_gz_files_len == 1 )
                can_gz_files = cf(j);
              else
                can_gz_files(can_gz_files_len) = cf(j);
              end
            end
         else
           dd = fullfile(q.read_list{i},'TaskData');
           if( exist(dd,'dir') == 7 )
             tacc_dirs_len            = tacc_dirs_len +1 ;
             tacc_dirs{tacc_dirs_len} = dd;
           end
          [cf,cf_len] = suche_files_f(q.read_list{i},'asc',1);
          for j=1:cf_len
            can_files_len = can_files_len + 1;
            if( can_files_len == 1 )
              can_files = cf(j);
            else
              can_files(can_files_len) = cf(j);
            end
          end
          [cf,cf_len] = suche_files_f(q.read_list{i},'gz',1);
          for j=1:cf_len
            can_gz_files_len = can_gz_files_len + 1;
            if( can_gz_files_len == 1 )
              can_gz_files = cf(j);
            else
              can_gz_files(can_gz_files_len) = cf(j);
            end
          end
         end 
         
         % ecal
         ecal_dirs     = get_ecal_files(q.read_list{i});
      else
        error('cg_get_filenames: Angegebenes Verzeichnis oder Datei <%s> nicht vorhanden',q.read_list{i});
      end        
    end
  end    
  if( can_gz_files_len > 0 )
    [can_files,can_files_len] = cg_get_filenames_unzip(can_files,can_files_len,can_gz_files,can_gz_files_len,1);
  end
  if( q.ECALread )
    fliste = cg_read_meas_data_get_ecal_filenames_find(ecal_dirs,can_files,can_files_len);
  else
    fliste = cg_read_meas_data_get_filenames_find(can_files,can_files_len,tacc_dirs,tacc_dirs_len,q.TACCread,q.CANFileNameExclude,q.CANFileNameTACC);
  end
  
  if( q.read_type == 5 )
    fliste = fliste(1);
    % CAN-File-Path zu meas_dir
    rel_dir = get_rel_dir(fliste.meas_dir,q.read_meas_path);
    if( ~isempty(fliste.can_file) )
      fliste.can_file = fullfile(rel_dir,fliste.can_file);
    end
    % measure-path
    fliste.meas_dir = q.read_meas_path;
    % Verzeichnis name
    liste = cell_get_from_pathname(fliste.meas_dir);
    fliste.name = liste{end};
    
    
    % ecal-Dateien
    liste = suche_files_f(fliste.meas_dir,[fliste.name,'.hdf5'],1,0);
    files = {};
    for iii = 1:length(liste)
      files = cell_add(files,liste(iii).full_name);
    end
    fliste.ecal_files = files;
    
  end
end
function fliste = cg_read_meas_data_get_filenames_find(can_files,can_files_len,tacc_dirs,tacc_dirs_len,tacc_read,CANFileNameExclude,CANFileNameTACC)
%
% Bildet Liste aus can_files und tacc_dirs
%
  fliste     = [];
  fliste_len = 0;
  
  [can_files,can_files_len] = cg_read_meas_data_proof_can_files(can_files,can_files_len,CANFileNameExclude);
  %----------------------------
  % A) keine tacc_dir angegeben
  %----------------------------  
  if( (can_files_len > 0) &&  (tacc_dirs_len == 0) )
    for i=1:can_files_len
      
      fliste_len = fliste_len +1;
      
      f = cg_read_meas_data_get_filenames_f_can_files(can_files(i));
      if( ~tacc_read )
        f.tacc             = 0;  %  Es sollen ja keine tac_dirs verwendet werden
      end
      if( isempty(fliste) )
        fliste = f;
      else
        fliste(fliste_len) = f;  %  Einsortieren
      end
    end
  %----------------------------
  % B) keine can_files angegeben
  %----------------------------
  elseif( (can_files_len == 0) &&  (tacc_dirs_len > 0) )
    for i=1:tacc_dirs_len      
      f = cg_read_meas_data_get_filenames_f_tacc_dirs(tacc_dirs{i});
      if( f.tacc > 0 )
          f.can_file         = '';  % Kein CAN-File
          fliste_len         = fliste_len +1;
          if( isempty(fliste) )
            fliste = f;
          else
            fliste(fliste_len) = f;  %  Einsortieren
          end
      end
    end
  %-------------------------------------
  % C) tacc_dirs und can_files angegeben
  %-------------------------------------
  elseif( (can_files_len > 0) &&  (tacc_dirs_len > 0) )
    % CAN-Files durchgehen
    for i=1:can_files_len
      
      % Alle CAN-Files nehmen, wenn CANFileNameTACC leer
      % aber wenn nicht leer, dann nur dieses File nehmen
      if( isempty(CANFileNameTACC) || strcmpi(CANFileNameTACC,can_files(i).body) )
      
        fliste_len = fliste_len +1;

        f = cg_read_meas_data_get_filenames_f_can_files(can_files(i));

        % in tacc_dirs suchen
        ifound = cell_find_f(tacc_dirs,fullfile(f.meas_dir,'TaskData'),'fl');
        if( ~isempty(ifound) )
          f.tacc             = 1;  %  Übereinstimmung gefunden
          tacc_dirs = cell_cut(tacc_dirs,ifound(1)); % Wird entnommen
        else
          f.tacc             = 0;  %  keine Übereinstimmung gefunden
        end

        if( isempty(fliste) )
          fliste = f;
        else
          fliste(fliste_len) = f;  %  Einsortieren
        end
      end
    end
    % Tacc-Verzeichnis durchsuchen
    tacc_dirs_len = length(tacc_dirs);
      
    for i=1:tacc_dirs_len      
      f = cg_read_meas_data_get_filenames_f_tacc_dirs(tacc_dirs{i});
      if( f.tacc > 0 )
          f.can_file         = '';  % Kein CAN-File
          fliste_len         = fliste_len +1;
          if( isempty(fliste) )
            fliste = f;
          else
            fliste(fliste_len) = f;  %  Einsortieren
          end
      end
    end 
  end
%       fliste(1).name        = s2_file.body;
%       fliste(1).meas_dir    = ecal_master_dir;
%       fliste(1).tacc        = 0;
%       fliste(1).can_file    = '';
%       fliste(1).ecal        = 1;
%       fliste(1).ecal_files  = ecal_files;
%       fliste(1).description = 0;
        
 
end
function fliste = cg_read_meas_data_get_ecal_filenames_find(ecaldirs,can_files,can_files_len)
    %       fliste(1).name        = s2_file.body;
    %       fliste(1).meas_dir    = ecal_master_dir;
    %       fliste(1).tacc        = 0;
    %       fliste(1).can_file    = '';
    %       fliste(1).can_file_list = {};
    %       fliste(1).ecal        = 1;
    %       fliste(1).ecal_files  = ecal_files;
    %       fliste(1).description = 0;
    fliste = struct([]);
    for i=1:length(ecaldirs)
      fliste(i).name        = get_last_name_from_dir(ecaldirs{i});
      fliste(i).meas_dir    = ecaldirs{i};
      fliste(i).tacc        = 0;
      fliste(i).can_file    = '';
      fliste(i).can_file_list = {};
      for j=1:can_files_len
        if( is_dir_in_dir(ecaldirs{i},can_files(j).dir) )
          fliste(i).can_file    = fullfile(get_subdirs_from_dir(ecaldirs{i},can_files(j).dir),[can_files(j).name,'.',can_files(j).ext]);
          fliste(i).can_file_list = cell_add(fliste(i).can_file_list,fliste(i).can_file);
        end
      end
      fliste(i).ecal        = 1;
      fliste(i).ecal_files  = {};
      fliste(i).description = 0;
    end
end
function [can_files,can_files_len_out] = cg_read_meas_data_proof_can_files(can_files,can_files_len,CANFileNameExclude)

  % double files
  i = 1;
  while( i <= can_files_len)
    flag = 1;
    for j=i+1:can_files_len
      if( strcmpi(can_files(i).full_name,can_files(j).full_name) )
        flag = 0;
        for k=j+1:can_files_len
          can_files(k-1)=can_files(k);
        end
        can_files_len = can_files_len-1;
        break;
      end
    end
    if( flag )
      i = i +1;
    end
  end
    
  n  = length(CANFileNameExclude);
  n1 = length(can_files);
  if( n && n1 )
    for j=1:length(CANFileNameExclude)
      indexlist = struct_find_all_in_field(can_files,'body',CANFileNameExclude{j});
      can_files = struct_delete_item(can_files,indexlist);
%       flag = 0;
%       for i=1:length(can_files)
%         if( strcmpi(can_files(i).body,CANFileNameExclude{j}) )
%           iout = i;
%           flag = 1;
%           break;
%         end
%       end
%       if( flag )
%         can_files = struct_delete_item(can_files,iout);
%       end
    end
  end
  can_files_len_out = length(can_files);
end
function f = cg_read_meas_data_get_filenames_f_can_files(can_file)
% bildet aus can_file ein struktur-element mit
% f.name        = 'measxyz'          Name
% f.meas_dir    = 'd:\abc\measxyz'   Verzeichnis
% f.can_file    = 'calogXXX.asc'     can-asc-file
% f.tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
% f.description = 0/1                ist description-file vorhanden

  f.meas_dir = can_file.dir;
  f.can_file = [can_file.body,'.',can_file.ext];
  f.can_file_list = {f.can_file};
  % name bilden
  %-------------------
  i0 = str_find_f(can_file.name,'canlog','vs');
  if( i0 > 0 ) 
    [c_names,ncount] = str_split(can_file.dir,'\');
    name = 'mat_out';
    for i = ncount:-1:1
        if( ~isempty(c_names{i}) )
            name = c_names{i};
            break;
        end
    end
    f.name     = name;
    
    if( exist(fullfile(can_file.dir,'description.txt'),'file') )
      f.description = 1;
    else
      f.description = 0;
    end

  else
    f.name        = can_file.body;
    f.description = 0;    
  end
  
  tacc_dir = fullfile(can_file.dir,'TaskData');
  if( exist(tacc_dir,'dir') )
    f.tacc = 1;
  else
    f.tacc = 0;
  end

end
     
function ff = cg_read_meas_data_get_filenames_f_tacc_dirs(tacc_dir)
% bildet aus tacc_dir
% f.name        = 'measxyz'          Name
% f.meas_dir    = 'd:\abc\measxyz'   Verzeichnis
% f.can_file    = 'calogXXX.asc'     can-asc-file
% f.tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
% f.description = 0/1                ist description-file vorhanden


  % tacc
  i0 = str_find_f(lower(tacc_dir),'taskdata','vs');
  if( exist(tacc_dir,'dir') )
    dd = dir(tacc_dir);
  else
    dd = [];
  end
  if( i0 > 0 && length(dd) > 1 )
    
      if( (i0 > 1) && ((tacc_dir(i0-1) == '\') || (tacc_dir(i0-1) == '/')) )
          i0 = i0-1;
      end
      if( i0 > 1 )
          i0 = i0-1;
      end
      f.meas_dir = tacc_dir(1:i0);
      f.tacc     = 1;
      
      [c_names,ncount] = str_split(f.meas_dir,'\');
      name = 'mat_out';
      for i = ncount:-1:1
          if( ~isempty(c_names{i}) )
              name = c_names{i};
              break;
          end
      end
      f.name     = name;
      
      f.can_file = '';
      f.can_file_list = {};
      [can_files,can_files_len] = suche_files_f(f.meas_dir,'asc',0);
      for i=1:can_files_len
        i0 = str_find_f(lower(can_files(i).name),'canlog','vs');
        if( i0 > 0 )
            f.can_file = can_files(i).name;
            f.can_file_list = cell_add(f.can_file_list,f.can_file);
        end
      end

      if( exist(fullfile(f.meas_dir,'description.txt'),'file') )
        f.description = 1;
      else
        f.description = 0;
      end
      
  else
      f.meas_dir    = tacc_dir;
      f.tacc        = 0;
      f.can_file    = '';
      f.can_file_list    = {};
      f.description = 0;
      f.name        = '';
  end

  ff.meas_dir    = f.meas_dir;
  ff.can_file    = f.can_file;
  ff.can_file_list    = f.can_file_list;
  ff.name        = f.name;
  ff.description = f.description;
  ff.tacc        = f.tacc;
end
function [cf,cf_len] = cg_get_filenames_unzip(cf,cf_len,cfgz,cfgz_len,delete_gz)

  if( ~exist('delete_gz','var') )
    delete_gz = 0;
  end
  for i = 1:cfgz_len
    tt = str_cut_ae_f(cfgz(i).dir,'\');
    [c_names,ncount] = str_split(tt,'\');
    flag = 1;
    dirout = cfgz(i).dir;
    if( strcmp(c_names{ncount},'TaskData') )
      flag = 2;  % Datei entzippen und ein Verzeichnis höher kopieren
      dirout = '';
      for ii = 1:ncount-1
        dirout = fullfile(dirout,c_names{ii});
      end      
    end
    if( flag )
      % entzippen
      fprintf('%s: Unzip: <%s>\n',mfilename,cfgz(i).full_name);
      try
        gunzip(cfgz(i).full_name,dirout);
        if( delete_gz )
          fprintf('%s: Delete: <%s>\n',mfilename,cfgz(i).full_name);
          delete(cfgz(i).full_name)
        end
        % Suchen in cf-Liste
        flag = 1;
        for j=1:cf_len
          if( strcmp(cfgz(i).dir,cf(j).dir) )
            flag = 0;
            break;
          end
        end
        if( flag )
          [file_list,i_file_list] = suche_files_f(fullfile(dirout,cfgz(i).body),'*',0,1);
          cf_len = cf_len+1; 
          if( cf_len == 1 )
            cf = file_list(1);
          else
            cf(cf_len) = file_list(1);
          end
        end
      catch
        warning('Datei: %s konnte nicht entzippt werden',cfgz(i).full_name)
      end
    end
  end
    
end
