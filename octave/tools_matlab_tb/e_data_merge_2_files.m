function [okay,e] = e_data_read_mat(filein1,filein2,fileout)
%
% [okay,e] = e_data_read_mat
% [okay,e] = e_data_read_mat(filein1,filein2,fileout)
%
% merge mit zwei Dateien mit e-Struktur
%
% e            e-Datenstruktur mit e.signame.time    Zeitvektor
%                                  e.signame.vec     Vektor oder cellaray
%                                                    mit Vektor zu jedem Zeitpunkt
%                                  e.signame.lin     Linear/constant bei
%                                                    Interpolation
%                                  e.signame.unit    Einheit
%                                  e.signame.comment Kommentar
%              
%              Anstatt auch
%
%                                  e.signame.param   numerischer Wert oder
%                                                    Vektor
%                                  e.signame.unit    Einheit
%                                  e.signame.comment Kommentar
%
  okay = 1;
  e    = [];
  if( ~exist('filein1','var') || isempty(filein1) )
    s_frage.comment   = 'Erste e-mat-Dateie (e_*.mat) auswählen';
    s_frage.start_dir = pwd;
    s_frage.file_spec   = '*_e.mat';
    s_frage.file_number = 1;
    
    [file_okay,c_filesnames] = o_abfragen_files_f(s_frage);

    if( ~file_okay )
      warning('keine Datei ausgewählt !!!');
      okay = 0;
      return
    else
      filein1 =  c_filesnames{1};
    end
  else
    if( iscell(filein1) )
      filein1 = filein1{1};
    end
    if( ~ischar(filein1) )
      error('%s: filename: %s  ist kein character',mfilename,filein1)
    end
  end  
  if( ~exist(filein1,'file') )
      warning('Dateiname: %s existiert nicht',filein1);
      okay = 0;
      return;
  end
  if( ~exist('filein2','var') || isempty(filein2) )
    s_frage.comment   = 'Zweite e-mat-Dateie (e_*.mat) auswählen';
    s_frage.start_dir = pwd;
    s_frage.file_spec   = '*_e.mat';
    s_frage.file_number = 1;
    
    [file_okay,c_filesnames] = o_abfragen_files_f(s_frage);

    if( ~file_okay )
      warning('keine Datei ausgewählt !!!');
      okay = 0;
      return
    else
      filein2 =  c_filesnames{1};
    end
  else
    if( iscell(filein2) )
      filein2 = filein2{1};
    end
    if( ~ischar(filein2) )
      error('%s: filename: %s  ist kein character',mfilename,filein2)
    end
  end  
  if( ~exist('fileout','var') || isempty(fileout) )
    s_frage.comment   = 'Ausgabe e-mat-Dateie (e_*.mat) angeben';
    s_frage.start_dir = pwd;
    s_frage.file_spec   = '*_e.mat';
    s_frage.file_number = 1;
    
    [file_okay,c_filesnames] = o_abfragen_files_f(s_frage);

    if( ~file_okay )
      warning('keine Datei ausgewählt !!!');
      okay = 0;
      return
    else
      fileout =  c_filesnames{1};
    end
  else
    if( iscell(fileout) )
      fileout = fileout{1};
    end
  end  
  
  s1     = load(filein1);
  s2     = load(filein2);
  % Prüfen, ob estruct-Format:
  if( ~data_is_estruct_format_f(s1) )
    warning('Datei %s ist nicht im estruct-Format (e.name.time,e.name.vec)',filein1);
    okay = 0;
  end
  if( ~data_is_estruct_format_f(s2) )
    warning('Datei %s ist nicht im estruct-Format (e.name.time,e.name.vec)',filein2);
    okay = 0;
  end
  e  = merge_struct_f(s1.e,s2.e);
  save(fileout,'e');
end