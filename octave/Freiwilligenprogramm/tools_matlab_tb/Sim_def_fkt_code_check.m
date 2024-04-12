function fkt_code_out = Sim_def_fkt_code_check(fkt_code)
%
% fkt_code_out = Sim_def_fkt_code_check(fkt_code)
%
% Prüft und liest den Code ein für:
% fkt_code.include     cell array mit Includezeilen z.B.
%                             {'#include "abc.h"','float Dabd;','float InitDabd(void);'}
%                      oder text-Datei mit den Includezeilen
% fkt_code.init        cell array mit Fkt-Aufruf in Init z.B.
%                              {'Dabd = InitDabd();','runInit(&Dabd);'}
%                      oder text-Datei mit den Init-Fkt-Zeilen
% fkt_code.loop        cell array mit Fkt-Aufruf in Loop z.B.
%                              {'Dabd += 10.f;','runLoop(&Dabd);'}
%                      oder text-Datei mit den Loop-Fkt-Zeilen
% fkt_code.end         cell array mit Fkt-Aufruf in End z.B.
%                             {'runDone();'}
%                      oder text-Datei mit den End-Fkt-Zeilen
% fkt_code.add         cell array mit zusätzlichem Code
%                               {'float InitDabd(void)','{','return 0.f;','}'}
%                      oder text-Datei mit den End-Fkt-Zeilen
% fkt_code.h_file      cell array mit zusätzlichem Code für h-Filen z.B.
%                               {'extern float Dabd;'}
%                      oder text-Datei mit den End-Fkt-Zeilen

  fkt_code_out = [];
  
  % include
  if( isfield(fkt_code,'include') )
    if( ischar(fkt_code.include) )
      % Textdatei einlesen
      [ okay,c,n ] = read_ascii_file(fkt_code.include);
      if( ~okay )
        error('%s_error: Die Textdatei für die Fkt-include-Beschreibung: <%s> konnte nicht eingelesen werden !!!',mfilename,fkt_code.include);
      end
    elseif( ~iscell(fkt_code.include) )
        error('%s_error: fkt_code.include ist keine string für Textdatei und kein cellarray mit Code !!!');
    else
      c = fkt_code.include;
    end
    if( ~isempty(c) )
      fkt_code_out.include = c;
    end
  end      

  % init
  if( isfield(fkt_code,'init') )
    if( ischar(fkt_code.init) )
      % Textdatei einlesen
      [ okay,c,n ] = read_ascii_file(fkt_code.init);
      if( ~okay )
        error('%s_error: Die Textdatei für die Fkt-Init-Beschreibung: <%s> konnte nicht eingelesen werden !!!',mfilename,fkt_code.init);
      end
    elseif( ~iscell(fkt_code.init) )
        error('%s_error: fkt_code.init ist keine string für Textdatei und kein cellarray mit Code !!!');
    else
      c = fkt_code.init;
    end
    if( ~isempty(c) )
      fkt_code_out.init = c;
    end
  end
  
  % loop
  if( isfield(fkt_code,'loop') )
    if( ischar(fkt_code.loop) )
      % Textdatei einlesen
      [ okay,c,n ] = read_ascii_file(fkt_code.loop);
      if( ~okay )
        error('%s_error: Die Textdatei für die Fkt-loop-Beschreibung: <%s> konnte nicht eingelesen werden !!!',mfilename,fkt_code.loop);
      end
    elseif( ~iscell(fkt_code.loop) )
        error('%s_error: fkt_code.loop ist keine string für Textdatei und kein cellarray mit Code !!!');
    else
      c = fkt_code.loop;
    end
    if( ~isempty(c) )
      fkt_code_out.loop = c;
    end
  end
  
  % end
  if( isfield(fkt_code,'end') )
    if( ischar(fkt_code.end) )
      % Textdatei einlesen
      [ okay,c,n ] = read_ascii_file(fkt_code.end);
      if( ~okay )
        error('%s_error: Die Textdatei für die Fkt-end-Beschreibung: <%s> konnte nicht eingelesen werden !!!',mfilename,fkt_code.end);
      end
    elseif( ~iscell(fkt_code.end) )
        error('%s_error: fkt_code.end ist keine string für Textdatei und kein cellarray mit Code !!!');
    else
      c = fkt_code.end;
    end
    if( ~isempty(c) )
      fkt_code_out.end = c;
    end
  end
  
  % add
  if( isfield(fkt_code,'add') )
    if( ischar(fkt_code.add) )
      % Textdatei einlesen
      [ okay,c,n ] = read_ascii_file(fkt_code.add);
      if( ~okay )
        error('%s_error: Die Textdatei für die Fkt-add-Beschreibung: <%s> konnte nicht eingelesen werden !!!',mfilename,fkt_code.add);
      end
    elseif( ~iscell(fkt_code.add) )
        error('%s_error: fkt_code.add ist keine string für Textdatei und kein cellarray mit Code !!!');
    else
      c = fkt_code.add;
    end
    if( ~isempty(c) )
      fkt_code_out.add = c;
    end
  end
  
  % h_file
  if( isfield(fkt_code,'h_file') )
    if( ischar(fkt_code.h_file) )
      % Textdatei einlesen
      [ okay,c,n ] = read_ascii_file(fkt_code.h_file);
      if( ~okay )
        error('%s_error: Die Textdatei für die Fkt-add-Beschreibung: <%s> konnte nicht eingelesen werden !!!',mfilename,fkt_code.h_file);
      end
    elseif( ~iscell(fkt_code.h_file) )
        error('%s_error: fkt_code.add ist keine string für Textdatei und kein cellarray mit Code !!!');
    else
      c = fkt_code.h_file;
    end
    if( ~isempty(c) )
      fkt_code_out.h_file = c;
    end
  end

end