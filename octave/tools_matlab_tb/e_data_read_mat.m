function [okay,e,f,rpath] = e_data_read_mat(filename)
%
% [okay,e,f] = e_data_read_mat;
% [okay,e,f] = e_data_read_mat(filename)
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
% f            voller Dateiname
% rpath        Pfad-Name
  okay = 1;
  e    = [];
  f    = '';
  rpath= '';
  if( ~exist('filename','var') || isempty(filename) )
    s_frage.comment   = 'e-mat-Dateien (e_*.mat) auswählen';
    s_frage.start_dir = pwd;
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
  % Prüfen, ob estruct-Format:
  if( data_is_estruct_format_f(s) )
        e = s.e;
  else
    warning('Datei %s ist nicht im estruct-Format (e.name.time,e.name.vec)',filename);
    okay = 0;
  end
end