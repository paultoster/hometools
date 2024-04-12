function q = build_vcproj_for_mex_sim_emodul_io_fkt(q)

  q.FKT_KENNUNG_START_INIT_FUNCTION_CALL = '/*##FKT_START_INIT_FUNCTION_CALL##*/';    
  q.FKT_KENNUNG_END_INIT_FUNCTION_CALL   = '/*##FKT_END_INIT_FUNCTION_CALL##*/';    
  q.FKT_KENNUNG_START_LOOP_FUNCTION_CALL = '/*##FKT_START_LOOP_FUNCTION_CALL##*/';    
  q.FKT_KENNUNG_END_LOOP_FUNCTION_CALL   = '/*##FKT_END_LOOP_FUNCTION_CALL##*/';    
  q.FKT_KENNUNG_START_END_FUNCTION_CALL = '/*##FKT_START_END_FUNCTION_CALL##*/';    
  q.FKT_KENNUNG_END_END_FUNCTION_CALL   = '/*##FKT_END_END_FUNCTION_CALL##*/';    
  q.FKT_KENNUNG_START_INCLUDE           = '/*##FKT_START_INCLUDE##*/';    
  q.FKT_KENNUNG_END_INCLUDE             = '/*##FKT_END_INCLUDE##*/';   
  q.FKT_KENNUNG_START_ADD_CODE          = '/*##FKT_START_ADD_CODE##*/';    
  q.FKT_KENNUNG_END_ADD_CODE            = '/*##FKT_END_ADD_CODE##*/';
  q.FKT_KENNUNG_START_H_FILE_CODE       = '/*##FKT_START_H_FILE_CODE##*/';    
  q.FKT_KENNUNG_END_H_FILE_CODE         = '/*##FKT_END_H_FILE_CODE##*/';
  
  % sim_MODUL_SIM.cpp suchen
  %---------------------------
  fktcppfile = '';
  for i=1:length(q.source_files)
    if(str_find_f(q.source_files{i}{1},'fkt_EMODUL_SIM.cpp'))
      fktcppfile = q.source_files{i}{1};
      fkthfile   = str_filename_change_ext(fktcppfile,'h');
      break;
    end
  end
  if( isempty(fktcppfile) )
    error(' Die Datei fkt_EMODUL_SIM.cpp konnte in q.source_files nicht gefunden werden');
  end

  % Einlesen
  [ okay,c,n ] = read_ascii_file(fktcppfile);
  if( ~okay )
    error('%s_error: fktcppfile: <%s> konnte nicht eingelesen werden !!!',mfilename,fktcppfile);
  end

% q.sim_def_fkt_code.include     cell array mit Includezeilen z.B.
%                                           {'#include "abc.h"','float Dabd;','float InitDabd(void);'}
%                                oder text-Datei mit den Includezeilen
% q.sim_def_fkt_code.init        cell array mit Fkt-Aufruf in Init z.B.
%                                           {'Dabd = InitDabd();','runInit(&Dabd);'}
%                                oder text-Datei mit den Init-Fkt-Zeilen
% q.sim_def_fkt_code.loop        cell array mit Fkt-Aufruf in Loop z.B.
%                                           {'Dabd += 10.f;','runLoop(&Dabd);'}
%                                oder text-Datei mit den Loop-Fkt-Zeilen
% q.sim_def_fkt_code.end         cell array mit Fkt-Aufruf in End z.B.
%                                           {'runDone();'}
%                                oder text-Datei mit den End-Fkt-Zeilen
% q.sim_def_fkt_code.add         cell array mit zusätzlichem Code
%                                           {'float InitDabd(void)','{','return 0.f;','}'}
%                                oder text-Datei mit den End-Fkt-Zeilen
% q.sim_def_fkt_code.h_file     cell array mit zusätzlichem Code für h-Filen z.B.
%                                           {'extern float Dabd;'}
%                                oder text-Datei mit den End-Fkt-Zeilen

  % q.sim_def_fkt_code bearbeiten

  % include
  [c,i0] = Kennung_bereinigen(c,q.FKT_KENNUNG_START_INCLUDE,q.FKT_KENNUNG_END_INCLUDE,1);
  if( isfield(q.sim_def_fkt_code,'include') )
    % Zellen einfügen
    c  = cell_insert(c,i0,q.sim_def_fkt_code.include);
  end
    
  % init
  [c,i0] = Kennung_bereinigen(c,q.FKT_KENNUNG_START_INIT_FUNCTION_CALL,q.FKT_KENNUNG_END_INIT_FUNCTION_CALL,1);
  if( isfield(q.sim_def_fkt_code,'init') )
    % Zellen einfügen
    c  = cell_insert(c,i0,q.sim_def_fkt_code.init);
  end
  
  % loop
  [c,i0] = Kennung_bereinigen(c,q.FKT_KENNUNG_START_LOOP_FUNCTION_CALL,q.FKT_KENNUNG_END_LOOP_FUNCTION_CALL,1);
  if( isfield(q.sim_def_fkt_code,'loop') )
    % Zellen einfügen
    c  = cell_insert(c,i0,q.sim_def_fkt_code.loop);
  end
  
  % end
  [c,i0] = Kennung_bereinigen(c,q.FKT_KENNUNG_START_END_FUNCTION_CALL,q.FKT_KENNUNG_END_END_FUNCTION_CALL,1);
  if( isfield(q.sim_def_fkt_code,'end') )
    % Zellen einfügen
    c  = cell_insert(c,i0,q.sim_def_fkt_code.end);
  end
  
  % add
  [c,i0] = Kennung_bereinigen(c,q.FKT_KENNUNG_START_ADD_CODE,q.FKT_KENNUNG_END_ADD_CODE,1);
  if( isfield(q.sim_def_fkt_code,'add') )
    % Zellen einfügen
    c  = cell_insert(c,i0,q.sim_def_fkt_code.add);
  end
  
  % fkt-Simfile schreiben
  %------------------
  okay = write_ascii_file(fktcppfile,c);
  if( ~okay )
    error('%s_error: Fehler bei Schreiben von fktcppfile: <%s>',mfilename,fktcppfile);
  end
  
  % h-File
  if( isfield(q.sim_def_fkt_code,'h_file') )
  
    % Einlesen
    [ okay,c,n ] = read_ascii_file(fkthfile);
    if( ~okay )
      error('%s_error: fkthfile: <%s> konnte nicht eingelesen werden !!!',mfilename,fkthfile);
    end
    
    [c,i0] = Kennung_bereinigen(c,q.FKT_KENNUNG_START_H_FILE_CODE,q.FKT_KENNUNG_END_H_FILE_CODE,1);

    % Zellen einfügen
    c  = cell_insert(c,i0,q.sim_def_fkt_code.h_file);

    % fkt-Simfile schreiben
    %------------------
    okay = write_ascii_file(fkthfile,c);
    if( ~okay )
      error('%s_error: Fehler bei Schreiben von fkthfile: <%s>',mfilename,fkthfile);
    end

  end

end

function [c,i0] = Kennung_bereinigen(c,KENN_START,KENN_END,errflag)

  iliste0 = cell_find_f(c,KENN_START,'n');
  iliste1 = cell_find_f(c,KENN_END,'n');
  
  if( errflag && isempty(iliste0) )
    error('%s_error: Die Kennung <%s> konnte nicht gefunden werden',mfilename,KENN_START);
  end
  if( errflag && isempty(iliste1) )
    error('%s_error: Die Kennung <%s> konnte nicht gefunden werden',mfilename,KENN_END);
  end
  
  if( ~isempty(iliste0) && ~isempty(iliste1) )
    i0 = iliste0(1)+1;
    i1 = iliste1(1)-1;
    if( i1 >= i0 )
      c  = cell_delete(c,i0,i1);
    end
  elseif( ~isempty(iliste0) && isempty(iliste1) )
    i0 = iliste0(1)+1;
    c  = cell_insert(c,i0,KENN_END);
  elseif( isempty(iliste0) && ~isempty(iliste1) )
    i0 = iliste1(1)-1;
    c  = cell_insert(c,i0,KENN_START);
    i0 = i0+1;
  else
    i0 = 1;
    c  = cell_insert(c,i0,KENN_START);
    c  = cell_insert(c,i0+1,KENN_END);
    i0 = 2;
  end
end
