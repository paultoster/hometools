function [tstartmax,tstartmin,tstartvec] = e_data_get_tstart(e)
%
% [tstartmax,tstartmin,tstartvec] = e_data_get_tstart(e)
%
% tstartmax letzte Start-Zeit
% tstartmin erste Startzeit
% tstartvec Startzeiten aller Signale
%
% Aus e-Struktur wird die Start-Zeit ausgelesen
%
%    e.('signame').time    zeitvektor
%    e.('signame').vec     Wertevektor
%    e.('signame').unit    Einheit
%    e.('signame').comment Kommentar
%    e.('signame').lin     1 linear interpolieren
%                          0 konstant interpolieren
%    e.('signame').leading_time_name    Damit wird alle mit diesem Namen
%                                       versehenen Vektoren mit dieser Zeitbasis aus e gleich in d-STruktur
%                                       gewandelt
%
tstartmax = 0.0;
tstartmin = 0.0;
tstartvec = [];

csigname = fieldnames(e);
n        = length(csigname);
if( n == 0 )
  warning('%s: e-Structure has no signals',mfilename);
  return
end

tstartvec      = zeros(n,1);

notfoundflag = 1;

if( n > 0 )
  notfoundflag = 0;
  tstartvec(1) = e.(csigname{1}).time(1);
  tstartmax    = e.(csigname{1}).time(1);
  tstartmin    = e.(csigname{1}).time(1);
  
end
for i=2:n
  if( e_data_is_timevec(e,csigname{i}) )
    tstartvec(i) = e.(csigname{i}).time(1);
    tstartmax    = max(tstartmax,e.(csigname{i}).time(1));
    tstartmin    = min(tstartmin,e.(csigname{i}).time(1));
%     if( tstart > 60. )
%       a = 0;
%     end
  end
end
if( notfoundflag )
  warning('%s: in e-Structure with signals no time-Vector found',mfilename);
  return
end
  