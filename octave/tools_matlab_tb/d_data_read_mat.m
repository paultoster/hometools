function  [okay,d,u,h,f] = d_data_read_mat(filename,change_e_end)
%
% [okay,d,u,h,f] = d_data_read_mat(filename)
% [okay,d,u,h,f] = d_data_read_mat(filename,change_e_end)
%
% Liest Matlab-Daten in d-Struktur ein
%
% filename           Matlabfilename, wenn leer, dann Aussuchen
%
% change_e_end       :1 if file-name in body has 'name_e.mat' change to 'name.mat'
%                    :0 don't check
%                    default: 1
%
% okay               = 1 okay
% d                  Datenstruktur äquidistant fängt mit Zeitvektor (Spaltenvektor) an
%                    d.time = [0;0.01;0.02; ... ]
%                    d.F    = [1;1.05;1.10; ... ]
%                    ...
% u                  Unitstruktur mit Unitnamen
%                    u.time = 's'
%                    u.F    = 'N'
%                    ...
% h                  Header-Cellarray mit Kommentaren
%                    h{1} sind möglicherweise als Kurztext die Aktionen,
%                    die mit den Daten durchgeführt werden enthalten.
%                    h{2} kann mit einer Kommentar-Struktur c enthalten
%                    (c.time ='Zeit', c.F = 'anderer Kommentar')
%
% f                  Filename

  if( ~exist('filename','var') )
    filename = '';
  end
  if(  ~exist('change_e_end','var') )
    change_e_end = 1;
  end
  if( isdir(filename) )
    start_dir = filename;
    filename = '';
  else
    start_dir = '.';
  end
  if( isempty(filename) )
    s_frage.file_spec   = '*.mat';
    s_frage.file_number = 1;
     s_frage.start_dir  = start_dir;
    [okay,c_filenames] = o_abfragen_files_f(s_frage);
    if( ~okay )
         warning('Keine datei auswählen');
          d = struct;
          u = struct;
          h = {};
          f = filename;
         return
    end
    filename = c_filenames{1};
  end
  
  % check ending in body of filename if '_e'
  if( change_e_end )
    s_file = str_get_pfe_f(filename);
    if( (length(s_file.name) > 2) && (s_file.name(end) == 'e') && (s_file.name(end-1) == '_') )
      filename = fullfile(s_file.dir,[s_file.name(1:end-2),'.',s_file.ext]);
    end
  end

 [okay,c_d,c_u,c_h,n] = d_cell_data_read_mat(filename);

 d = struct;
 u = struct;
 h = {};
 f = filename;
 if( n == 0 )
   okay = 0;
 end
 if( okay )
   
   d = c_d{1};
   u = c_u{1};
   h = c_h{1};
 end
   

end