function c_lines = build_cell_description_each_line_of_file(filename,printmfile)
%
% tt = build_cell_description_each_line_of_file(filename,printmfile)
% tt = build_cell_description_each_line_of_file(cellarray,printmfile)
%
% Bildet cellarray mit dem Inhalt der Zeilen aus dem File mit filename (string) und wenn
% printmfile angegeben (string), dann schreibt in dieses File die Behele für ein die cellarray
% erstellung
%
% oder nimmt Cellarray
% 
  if( ~exist('printmfile','var') )
    printmfile = '';
  end

  if( iscell(filename) )
    c_lines = filename;
    nzeilen = length(c_lines);
  else
    if( ~exist(filename,'file') )
      error('filename: %s existiert nicht',filename);
    end
  
    [ okay,c_lines,nzeilen ] = read_ascii_file( filename );
  
    if( ~okay )
      error('Datei: %s konnte nicht gelesen werden',filename);
    end
  end  
  if( ~isempty(printmfile) )
    
    [fid,message] = fopen(printmfile,'w');

    if( fid < 0 )
      error('%s\n',message);
      return
    end

    fprintf(fid,'function c = mfunction\n');
    fprintf(fid,'\n');
    fprintf(fid,'  c = ...\n');
    fprintf(fid,'  {''%s'' ...\n',c_lines{1});
    for i=2:nzeilen
      c_lines{i}=str_change_single_f(c_lines{i},'''','''''');
      fprintf(fid,'  ,''%s'' ...\n',c_lines{i});
    end
    fprintf(fid,'  };\n');
    fprintf(fid,'end\n');
    fclose(fid);
  end
end