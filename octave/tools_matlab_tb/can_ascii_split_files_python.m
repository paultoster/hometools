function can_ascii_split_files_python(q)
%
% can_ascii_split_files_python(q)
%
% Sucht Can-Dateien und zerstückelt sie, wenn größer als vorgegeben
% Zeit:
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
%                       (q.read_list angeben)
%                                                           % q.read_type         = 1  Verzeichnis wird durch Abfrage bestimmt
%                                                           %                          Alle Unterverzeichnisse werden untersucht
%                                                           %                          q.start_dir angeben
%                                                           %                     = 2  übergeordnetes Verzeichnis angeben
%                                                           %                          q.read_meas_path angeben
%                                                           %                     = 3  Liste mit einzulesenden Messverzeichnissen 
%                                                           %                          q.read_list = {'dir1',dir2'}oder
%                                                           %                          explizite Canalyser-Ascii Dateien in
%                                                           %                          q.read_list = {'datei1.asc','datei2.asc'}
%                                                           %                         angeben
% q.start_dir        (q.read_type = 1,2) Start-Dir zum Suchen 
% q.read_meas_path   (q.read_type = 3) Verzeichnis unter dem alle 
%                                      Messungen gewandelt werden
% q.read_list        (q.read_type = 4) Liste mit Dateien (Canalyser-ascii)
%                                      oder Verzeichnissen
% q.tmax             Zeitspanne der Zerstückelung
% q.zero_time        0/1 zero time in erster Datei
% q.dat_name_add     Dateinamenszusatz für die Ausgabe
%                    z.B. input canlog.asc 
%                    q.dat_name_add = '_split';q.tmax = 100;
%                    => canlog_split_0_100.asc,canlog_split_100_200.asc,...
% q.use_dir_name     1: verwendet als ausgabe den Verzeichnisnamen
%
  if( ~exist('q','var') )
    q.read_type = 2;
  end
 
  if( ~check_val_in_struct(q,'read_type','num',1) )
    q.read_type = 2; % CAN-ascii-Dateien auswählen
  end
  if( ~check_val_in_struct(q,'start_dir','char',1) )
    q.start_dir = 'D:\'; 
  end
  if( (q.read_type == 3) &&  ~check_val_in_struct(q,'read_meas_path','char',1) )
   error('q.read_meas_path angeben'); 
  end
  if( (q.read_type == 4) &&  ~check_val_in_struct(q,'read_list','cell',1) )
   error('q.read_list angeben'); 
  end
  if( ~check_val_in_struct(q,'tmax','num',1) )
    q.tmax = 100; 
  end
  if( ~check_val_in_struct(q,'zero_time','num',1) )
    q.zero_time = 1; 
  end
  if( ~check_val_in_struct(q,'dat_name_add','char',1) )
    q.dat_name_add = '_split'; 
  end
  if( ~check_val_in_struct(q,'use_dir_name','num',1) )
    q.use_dir_name = 1; 
  end
  
  q.TACCread = 0;
  q.CANread  = 1;
  fliste   = cg_get_can_asc_filenames(q);
  
  n_fliste = length(fliste);
  
  %-----------------------------------------------------
  % Liste durchlaufen
  %-----------------------------------------------------
  for i_fliste = 1:n_fliste
    
    if( isempty(fliste(i_fliste).name) )
      [c_names,ncount] = str_split(fliste(i_fliste).meas_dir,'\');
      name = 'mat_out';
      for i = ncount:-1:1
        if( ~isempty(c_names{i}) )
            name = c_names{i};
            break;
        end
      end
      fliste(i_fliste).name = name;
    end
    
    fread = fullfile(fliste(i_fliste).meas_dir,fliste(i_fliste).can_file);
    s_file = str_get_pfe_f(fread);
    
    if( q.use_dir_name )     
      fout   = fullfile(s_file.dir,[fliste(i_fliste).name,q.dat_name_add,'.',s_file.ext]);
    else
      fout   = fullfile(s_file.dir,[s_file.name,q.dat_name_add,'.',s_file.ext]);
    end
    
    
    command = ['d:\tools\python\can_mess_doublicate_asc.py ',fread,' ',fout,' ',num2str(q.tmax),' ',num2str(q.zero_time)];
    [status,result] = dos(command);

    if( status )
      result
    end
   
  end
  

end
                                                               