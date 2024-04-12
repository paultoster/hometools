function [timevec,okay] = e_data_get_signal_time(e,signame)
%
% [timevec,okay] = e_data_get_signal_time(e,signame)
%
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
  timevec = [];
  okay    = 1;

  csigname = fieldnames(e);
  n        = length(csigname);

  ifound  = cell_find_f(csigname,signame,'f');

  if( isempty(ifound) )
    okay = 0;
  else
    if( e_data_is_timevec(e,signame) )
      time = e.(signame).time;
    else
      okay = 0;
    end
  end
end
  