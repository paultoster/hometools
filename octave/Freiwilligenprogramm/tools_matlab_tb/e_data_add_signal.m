function e = e_data_add_signal(e,signame,sigunit,sigcomment,sigtime,sigvalue,siglin)
%
% e = e_data_add_signal(e,signame,sigunit,sigcomment,sigtime,value,siglin);
%
% Erweitert die e-Struktur um das signal zum einem Zeitpunkt
%
% e            e-Datenstruktur mit e.signame.time    Zeitvektor
%                                  e.signame.vec     Vektor oder cellaray
%                                                    mit Vektor zu jedem Zeitpunkt
%                                  e.signame.lin     Linear/constant bei
%                                                    Interpolation
%                                  e.signame.unit    Einheit
%                                  e.signame.comment Kommentar
%
% signame               char Signalname
% sigunit               char Einheit
% sigcomment            char Kommentar
% sigtime                  num           Zeitwert
% sigvalue                 num/cellarray Signalwert (kann auch cellarray sein)
% siglin                   soll linear behandelt werden

  if( ~exist('signame','var') || isempty(signame) )
    error('%s: ''signame muss'' angegeben werden',mfilename)
  end
  if( ~exist('sigunit','var') || isempty(sigunit) )
    sigunit = '-';
  end
  if( ~exist('sigcomment','var') || isempty(sigcomment) )
    sigcomment = '';
  end
  if( ~exist('siglin','var') || isempty(siglin) )
    siglin = 0;
  end

  e = e_data_add_value(e,signame,sigunit,sigcomment,sigtime,sigvalue,siglin);
end