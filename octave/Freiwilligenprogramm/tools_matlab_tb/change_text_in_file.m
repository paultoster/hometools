function [okay,mess] = change_text_in_file(filename,find_text,ersatz_text)
%
% [okay,mess] = change_text_in_file(filename,find_text,ersatz_text)
%
% Ersetzt in filename alle find_text strngs mit ersatz_text
%
% okay = 1    Ist okay
% mess        Message, wenn nicht okay
  okay = 1;
  if( ~exist(filename,'file') )
    okay = 0;
    mess = sprintf('%s_error: Die Datei <%s> konnte nicht gefunden werden !!',mfilename,filename);
    return;
  end
  [okay,c_lines,nzeilen] = read_ascii_file(filename);
  if( ~okay )
    mess = sprintf('%s_error: Die Datei <%s> konnte nicht gelesen werden',mfilename,filename);
    return;
  end
  c_lines = str_change_f(c_lines,find_text,ersatz_text,'a');

  okay = write_ascii_file(filename,c_lines);
  if( ~okay )
    mess = sprintf('%s_error: Die Datei <%s> konnte nicht geschrieben werden',mfilename,filename);
    return;
  end
end