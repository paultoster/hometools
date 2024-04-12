function [e,f] = e_data_read_mat_save_path(filename)
%
% e = e_data_read_mat_save_path;
% e = e_data_read_mat_save_path(filename)
% [e,f] = e_data_read_mat_save_path;
% [e,f] = e_data_read_mat_save_path(filename)
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
% es wird der messpfad mit qlast_set(1,rpath); gespeichert
% bzw. auch ausgelesen if( qlast_exist(1) )
%   q.start_dir      = qlast_get(1);
% else
%   q.start_dir      = 'D:\';
% end
% 
% rpath        Pfad-Name
% f            Dateiname mit Pfad
%
  okay = 1;
  e    = [];
  f    = '';
  rpath= '';
  
  if( ~exist('filename','var') )
    filename = '';
    if( qlast_exist(1) )
      dirmess = qlast_get(1);
    else
      dirmess = pwd;
    end
  else
    if( ~exist('filename','file') )
      if( exist('filename','dir') )
        dirmess  = filename;
        filemess = '';
      elseif( qlast_exist(1) )
        dirmess  = qlast_get(1);
        filemess = '';
      else
        dirmess  = pwd;
        filemess = '';
      end
    end
  end
      
  org_path = pwd;      
  
  if( isempty(filename) )
    s_frage.comment   = 'e-mat-Dateien (e_*.mat) auswählen';
    s_frage.start_dir = dirmess;
    s_frage.file_spec   = '*_e.mat';
    s_frage.file_number = 1;
    
    
    [file_okay,c_filesnames] = o_abfragen_files_f(s_frage);

    if( ~file_okay )
      warning('keine Datei ausgewählt !!!');
      okay = 0;
      return
    else
      filename =  c_filesnames{1};
    end
  else
    if( iscell(filename) )
      filename = filename{1};
    elseif( ~ischar(filename) )
      error('%s: filename: ist kein character',mfilename)
    end
  end  
  if( ~exist(filename,'file') )
      warning('Dateiname: %s existiert nicht',filename);
      okay = 0;
      return;
  end
  
  s     = load(filename);
  f     = filename;  
  rpath = get_path_from_fullfilename(f);
  qlast_set(1,rpath);
  % Prüfen, ob estruct-Format:
  if( data_is_estruct_format_f(s) )
        e = s.e;
  else
    warning('Datei %s ist nicht im estruct-Format (e.name.time,e.name.vec)',filename);
    okay = 0;
  end
  
  % Es gab in einer Messung e.GenericObjectList_data1_id anstatt
  % GenericObjectList_data_id, deswegen umkoppieren, Fehler mbeim einlesen
  names = fieldnames(e);
  [cold,cnew] = cell_find_names(names,'GenericObjectList_data1_*','GenericObjectList_data_*');
  for i=1:length(cold)
   e = e_data_rename_signal(e,cold{i},cnew{i});
  end
  
  cd(org_path);
end