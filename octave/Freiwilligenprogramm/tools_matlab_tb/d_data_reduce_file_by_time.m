function  okay = d_data_reduce_file_by_time(tstart,tend,zero_flag,filename,type,filenameout)
%
% okay = d_data_reduce_file_by_time(tstart,tend,zero_flag)
% okay = d_data_reduce_file_by_time(tstart,tend,zero_flag,filename)
% okay = d_data_reduce_file_by_time(tstart,tend,zero_flag,filename,type)
% okay = d_data_reduce_file_by_time(tstart,tend,zero_flag,filename,type,filenameout)
%
% Liest Matlab-Daten ein reduziert und speichert
%
% tstart      Startzeit für Eingrenzung, wenn nicht benutzt, dann tstart = -1
% tend        Endzeit für Eingrenzung, wenn nicht benutzt, dann tend = -1
% zero_flag   flag Zeitvektor geht aus null raus
% filename    Matlabfilename, wenn leer, dann Aussuchen
%             Type zum Rausschreiben:
% type = 'dspa','mat_dspa'    Dspace-Format (Matlab) (für Wave
%                  geeignet, der erste Vektor ist dann der unabhängige Vektor
%      = 'duh','mat_duh'     Data-Unit-Header-Format (Matlab) (wie
%                  diaread)
%      = 'vec'     Einzelne Vektoren (Matlab)
%      = 'csv'     CSV-Format
%      = 'dia'     Diadem-Format r32
%      = 'dia_asc' Diadem-Format ascii
%      = 'm'       M-Datenformat
%
% filenameout      neuer Ausgabe-Filename
%
% okay               = 1 okay
  okay = 1;
  if( ~exist('tstart','var') )
    clear s_frage
    s_frage.frage     = 'Wert für tstart';
    s_frage.type      = 'double';
    [okay,tstart] = o_abfragen_wert_f(s_frage);
    if( ~okay ) 
      return;
    end
  end
  if( ~exist('tend','var') )
  if( ~exist('tend','var') )
    clear s_frage
    s_frage.frage     = 'Wert für tend';
    s_frage.type      = 'double';
    [okay,tend] = o_abfragen_wert_f(s_frage);
    if( ~okay ) 
      return;
    end
  end
  end
  if( ~exist('zero_flag','var') )
    clear s_frage
    s_frage.frage     = 'Wert für zero_flag';
    s_frage.type      = 'double';
    [okay,zero_flag] = o_abfragen_wert_f(s_frage);
    if( ~okay ) 
      return;
    end
  end
  if( ~exist('filename','var') )
    filename = '';
  end
  if( ~exist('type','var') )
    type = 'duh';
  end
  

  [okay,d,u,h,f] = d_data_read_mat(filename);
  
  if( ~exist('filenameout','var') )
    filenameout = f;
  end
  
  if( ~okay )
    error('[okay,d,u,h,f] = d_data_read_mat(%s) ist nicht okay ',f);
  else
    
    d    = d_data_reduce_time(d,tstart,tend,zero_flag);    
    okay = d_data_save(filenameout,d,u,h,type);
  end
  
  
end