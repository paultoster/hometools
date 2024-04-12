function [okay,b,f] = b_data_read_asc(filename)
%
% [okay,b,f] = b_data_read_asc(filename)
% [okay,b,f] = b_data_read_asc
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
  f    = '';
  b    = [];
  if( ~exist('filename','var') )
    s_frage.comment   = 'Canalyser-ascii-Dateien (*.asc) auswählen';
    s_frage.start_dir = pwd;
    s_frage.file_spec   = '*.asc';
    s_frage.file_number = 1;
    
    [file_okay,c_filenames] = o_abfragen_files_f(s_frage);

    if( ~file_okay )
      filename = '';
    else
      filename = c_filenames{1};
    end
  end
  
  if( ~exist(filename,'file') )
    warning('Dateiname: %s existiert nicht',filename);
    okay = 0;
    return;
  end

  D=dir(filename);
  
  if( D.bytes > 0 )
    b = mexReadCANBytes(filename);
    f  = filename;
  else
    okay = 0;
  end

end