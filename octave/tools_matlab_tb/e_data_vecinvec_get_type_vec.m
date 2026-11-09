function [time,vec] = e_data_vecinvec_get_type_vec(e,signame,type)
%
% [time,vec] = e_data_vecinvec_get_first_vec(e,signame,type)
%
% signame       Signal-Name (Signal muss ein vecinvec - Signal sein
% type          'first'    erster gültiger Wert mit einem Vektor
%               'last'     letzter gültiger Wert mit einem Vektor
%
%
% Aus e-Struktur 
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
  time = [];
  vec  = [];
  if( e_data_is_vecinvec(e,signame) )
    
    n = length(e.(signame).time);
    if( strcmpi(type,'first') )
      nvec = 1:n;
    else
      nvec = n:-1:1;
    end
      
    for i=nvec
      if( ~isempty(e.(signame).vec{i}) )
        time = e.(signame).time(i);
        vec  = e.(signame).vec{i};
        break;
      end
    end
  end
end
  