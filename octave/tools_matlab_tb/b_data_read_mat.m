function [okay,b,f] = b_data_read_mat(filename)
%
% [okay,b,f] = b_data_read_mat(filename)
%
% b            b-Datenstruktur mit b.time(i)    Zeit
%                                  b.id(i)      ID-Botschaft
%                                  b.channel(i) Channel-Nr von 1 an
%                                  b.len(i)     DLC bytelength
%                                  b.byte0(i)   Vektor mit byte0 von 8 bytes
%                                  b.byte1(i)   Vektor mit byte1 von 8 bytes
%                                  b.byte2(i)   Vektor mit byte2 von 8 bytes
%                                  b.byte3(i)   Vektor mit byte3 von 8 bytes
%                                  b.byte4(i)   Vektor mit byte4 von 8 bytes
%                                  b.byte5(i)   Vektor mit byte5 von 8 bytes
%                                  b.byte6(i)   Vektor mit byte6 von 8 bytes
%                                  b.byte7(i)   Vektor mit byte7 von 8 bytes
%                                  b.receive(i) =1 Rx =0 Tx
%
  okay = 1;
  b    = [];
  if( ~exist('filename','var') )
    s_frage.comment   = 'b-mat-Dateien (*_b.mat) auswählen';
    s_frage.start_dir = pwd;
    s_frage.file_spec   = '*.mat';
    s_frage.file_number = -1;
    
    [file_okay,c_filenames] = o_abfragen_files_f(s_frage);

    if( ~file_okay )
      c_filenames = {};
    end
  else
    if( ischar(filename) )  
  end
  
  if( ~exist(filename,'file') )
    warning('Dateiname: %s existiert nicht',filename);
    okay = 0;
    return;
  end
  
  s  = load(filename);
  f  = filename;  
  % Prüfen, ob bstruct-Format:
  if( data_is_bstruct_format_f(s) )
    b = s.b;
  else
    warning('Datei %s ist nicht im bstruct-Format (b(i).time,b(i).id,b(i).channel,b(i).len,b(i).bytes,b(i).receive)',filename);
    okay = 0;
  end

end