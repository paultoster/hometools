function [tendmax,tendmin,tendvec] = e_data_get_tend(e)
%
% [tendmax,tendmin,tendvec] = e_data_get_tend(e)
%
% tendmax letzte End-Zeit
% tendmin erste Endzeit
% tendvec Endzeit aller Signale
%
% Aus e-Struktur wird die End-Zeit ausgelesen
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
tendmax = 0.0;
tendmin = 0.0;
tendvec = [];

csigname = fieldnames(e);
n        = length(csigname);
if( n == 0 )
  warning('%s: e-Structure has no signals',mfilename);
  return
end

tendvec      = zeros(n,1);

notfoundflag = 1;

if( n > 0 )
  notfoundflag = 0;
  tendvec(1) = e.(csigname{1}).time(end);
  tendmax    = e.(csigname{1}).time(end);
  tendmin    = e.(csigname{1}).time(end);
  
end
for i=2:n
  if( e_data_is_timevec(e,csigname{i}) )
    tendvec(i) = e.(csigname{i}).time(end);
    tendmax    = max(tendmax,e.(csigname{i}).time(end));
    tendmin    = min(tendmin,e.(csigname{i}).time(end));
%     if( tend > 60. )
%       a = 0;
%     end
  end
end
if( notfoundflag )
  warning('%s: in e-Structure with signals no time-Vector found',mfilename);
  return
end
  