function okay = write_ascii_file( file_name, c_lines )
%
% okay = write_ascii_file( file_name, c_lines )
%
% Schreibt die Text (Zeilen) in c_lines (cellarray) ohne "\n" in Ascii-Datei

  okay = 1;
  nzeilen = length(c_lines);
  if( nzeilen > 0 )
    [fid,message] = fopen(file_name,'w');

    if( fid < 0 )
      fprintf('%s\n',message);
      okay = 0;
      return
    end

    for i=1:nzeilen
      fprintf(fid,'%s\r\n',c_lines{i});
    end
  
    fclose(fid);
  end
      
end

