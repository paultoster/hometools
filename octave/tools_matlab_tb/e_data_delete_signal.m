function e = e_data_delete_signal(e,signame)
%
% e = e_data_delete_channel(e,signame);
%
% Delete signal from e-Struktur 
%
% e            e-Datenstruktur mit e.signame.time    Zeitvektor
%                                  e.signame.vec     Vektor oder cellaray
%                                                    mit Vektor zu jedem Zeitpunkt
%                                  e.signame.lin     Linear/constant bei
%                                                    Interpolation
%                                  e.signame.unit    Einheit
%                                  e.signame.comment Kommentar
%
% signame               char channel name

  if( ~exist('signame','var') || isempty(signame) )
    error('%s: ''signame muss'' angegeben werden',mfilename)
  end
  

  if( isfield(e,signame) ) % neu anlegen
    e = rmfield(e,signame);
  end
end