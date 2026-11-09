function [ okay,c_lines,nzeilen ] = read_ascii_file( file_name )
%
% [ okay,c_lines,nzeilen ] = read_ascii_file( file_name )
%
% Liest Ascii-Datei und gibt die Zeilen in c_lines (cellarray) ohne "\n" zurück

  okay = 1;
  c_lines = {};
  nzeilen = 0;
  [fid,message] = fopen(file_name,'r');

  if( fid < 0 )
    fprintf('%s\n',message);
    okay = 0;
    return
  end

  while 1
      tline = fgetl(fid);
      % Abbrechnen wenn Ende
      if( ~ischar(tline) )
          break
      else
        nzeilen = nzeilen + 1;
      end

      % Leerzeichen weg
      c_lines{nzeilen} = str_cut_e_f(tline,' ');
  end
  
  fclose(fid);
  
  if( nzeilen == 0 )
    okay = 0;
  end
      
end

