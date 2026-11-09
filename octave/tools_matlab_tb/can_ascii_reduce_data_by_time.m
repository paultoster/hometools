function okay = can_ascii_reduce_data_by_time(ascii_in_file,ascii_out_file,tstart,tend)
%
% okay = can_ascii_reduce_data_by_time(ascii_in_file,ascii_out_file,tstart,tend)
%
% reduziert eine Ascii-Messung auf den zeitlich vorgegebenen Bereich und
% nullt die Sache
  okay = 1;
  if( ~exist('ascii_in_file','var') || isempty(ascii_in_file))

    s_frage.comment      = 'CAN-Ascii-Datei';
    s_frage.file_spec    = '*.asc';
     s_frage.file_number = 1;
    [okay,c_filenames] = o_abfragen_files_f(s_frage);
    if( okay )
      ascii_in_file = c_filenames{1};
    else
      return;
    end
  end
  if(~exist('ascii_out_file','var') || isempty(ascii_out_file))
      clear s_frage
      s_frage.comment       = 'Ausgabe CAN-Ascii-Datei';
      s_frage.file_spec     = '*.asc';
      s_frage.put_file      = 1;
      S                     = str_get_pfe_f(ascii_in_file);
      s_frage.put_file_name = [S.name,'_ausgabe.asc'];
      [okay,c_filenames] = o_abfragen_files_f(s_frage);
      if( okay )
        ascii_out_file = c_filenames{1};
      else
        return;
      end
  end
  smess = can_mess_read_asc(ascii_in_file);
  n     = length(nmess);
  
  t0    = smess(1).zeit;
  t1    = smess(n).zeit;

  if( ~exist('tstart','var') )
    clear s_frage
    s_frage.frage = sprintf('Beginn des zu nutzenden bereichs tstart (%f/%f)',t0,t1);
    [okay,value] = o_abfragen_wert_f(s_frage);
    if( okay )
      tstart = value;
    else
      retun;
    end
  end
  if( ~exist('tend','var') )
    clear s_frage
    s_frage.frage = sprintf('Ende des zu nutzenden bereichs tend (-1, bis zum Ende der Messung)(%f/%f)',t0,t1);
    [okay,value] = o_abfragen_wert_f(s_frage);
    if( okay )
      tend = value;
    else
      retun;
    end
  end
  
  
  % Anfang
  if( tstart < 0.0 )
    i0 = 1;
    toffset = smess(1).zeit;
  elseif( tstart > t0 )
    i0 = 0;
    for i=1:n
      if( smess(i).zeit >= tstart )
        i0      = i;
        toffset = smess(i).zeit;
        break
      end
    end
    if( i0 == 0 )
      error('In datei <%s> konnte nicht der Anfangszeitpunkt tstart = %f gefunden werden',ascii_in_file,tstart);
    end
  else
    i0 = 1;
    toffset = 0.0;
  end
  
  % Ende
  if( (tend < 0.0) || (tend > t1) )
    i1 = n;
  else
    i0 = 0;
    for i=i0:n
      if( smess(i).zeit <= tend )
        i1      = i;
        break
      end
    end
    if( i0 == 0 )
      error('In datei <%s> konnte nicht der Endzeitpunkt tend = %f gefunden werden',ascii_in_file,tend);
    end
  end

  ii = 1;
  s1mess(ii) = smess(i0);
  s1mess(ii).zeit = s1mess(ii).zeit - toffset;
  
  for i=i0+1:i1;
    ii = ii+1;
    s1mess(ii) = smess(i);
    s1mess(ii).zeit = s1mess(ii).zeit - toffset;
  end
  
  okay = can_mess_write(ascii_out_file,s1mess);
end