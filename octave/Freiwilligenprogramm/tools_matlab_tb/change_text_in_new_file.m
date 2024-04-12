function [okay,mess] = change_text_in_new_file(filesource,filetarget,find_text,ersatz_text,case_insens)
%
% [okay,mess] = change_text_in_new_file(filesource,filetarget,find_text,ersatz_text)
% [okay,mess] = change_text_in_new_file(filesource,filetarget,find_text,ersatz_text,case_insens)
%
% Liset filesource ein ersetzt alle find_text strngs mit ersatz_text und
% schreibt text in filetarget
%
% find_text     char oder cell array gleicher Länge wie ersatz_text
% ersatz_text   char oder cell array gleicher Länge wie find_text
% case_insens   0: case sesitive
%               1: case insensitive
%
% okay = 1    Ist okay
% mess        Message, wenn nicht okay
  okay = 1;
  mess = '';
  if( ~exist('case_insens','var') )
    case_insens = 0;
  end
  if( ischar(find_text) )
      find_text = {find_text};
  end
  if( ischar(ersatz_text) )
      ersatz_text = {ersatz_text};
  end
  n = min(length(find_text),length(ersatz_text));
  if( ~exist(filesource,'file') )
    okay = 0;
    mess = sprintf('%s_error: Die Datei <%s> konnte nicht gefunden werden !!',mfilename,filesource);
    return;
  end
  
  a = dir(filesource);
  if( a.bytes > 0 )
    [okay,c_lines,nzeilen] = read_ascii_file(filesource);
    if( ~okay )
      mess = sprintf('%s_error: Die Datei <%s> konnte nicht gelesen werden',mfilename,filesource);
      return;
    end
    if( case_insens )
      c_lines = str_change_f(c_lines,find_text,ersatz_text,'ai');
    else
      c_lines = str_change_f(c_lines,find_text,ersatz_text,'a');
    end

    okay = write_ascii_file(filetarget,c_lines);
    if( ~okay )
      mess = sprintf('%s_error: Die Datei <%s> konnte nicht geschrieben werden',mfilename,filetarget);
      return;
    end
  end
end