function f = e_data_save_mat_save_path(e,filename,nopath)
%
% f = e_data_save_mat_save_path(e);
% f = e_data_save_mat_save_path(e,filename)
%
% save e_data and make qlast_set_measdir with path of file
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
% f            Dateiname mit Pfad
% nopath       [default 0]  do not store path
  
  if( ~exist('filename','var') )
    f = '';
  else
    if( ~exist('filename','file') )
      f  = filename;
    end
  end
  if( ~exist('nopath','var') )
    nopath = 0;
  end
  
  
        
  if( isempty(f) )
    s_frage.put_file=1;
    s_frage.comment   = 'e-mat-Dateiennamen';
    s_frage.file_spec   = '*_e.mat';
    s_frage.file_number = 1;
    
    
    [file_okay,c_filesnames] = o_abfragen_files_f(s_frage);

    if( ~file_okay )
      warning('keine Datei ausgewählt !!!');
      return
    else
      f =  c_filesnames{1};
    end
  end
  
  s_file = str_get_pfe_f(f);
  if( isempty(s_file.dir) )
    s_file.dir = pwd;
  end
  n = length(s_file.body);
  if( n == 1 )
    body = [s_file.body,'_e'];
    
  elseif( ~strcmp(s_file.body(n-1:n),'_e') )
     body = [s_file.body,'_e'];
  else
    body = s_file.body;
  end
  
  f = fullfile(s_file.dir,[body,'.mat']);
  
  % e-Struktur speichern
  %---------------------
  save(f,'e')
  fprintf('e-struct-Datei: <%s>\n',f);
  
  % set path
  if( ~nopath )
  qlast_set_measdir( s_file.dir );
  end
end