function e_signal = e_data_signal_convert_unit(e_signal,unit_out)
%
% e_signal = e_data_signal_convert_unit(e_signal,unit_out)
%
% Wandelt das Signal in unit_out, wenn möglich
%
% Signal aus e-Datenstruktur       e_signal.time    Zeitvektor
%                                  e_signal.vec     Vektor oder cellaray
%                                                    mit Vektor zu jedem Zeitpunkt
%                                  e_signal.lin     Linear/constant bei
%                                                    Interpolation
%                                  e_signal.unit    Einheit
%                                  e_signal.comment Kommentar
%
% unit_out                         Ausgabe Einheit z.B. 'km'

  if( ~isfield(e_signal,'unit') )
    error('e_data_signal_convert_unit: e_signal.unit nicht vorhanden')
  end
  if( ~isfield(e_signal,'vec') )
    error('e_data_signal_convert_unit: e_signal.vec nicht vorhanden')
  end
  
  [fac,offset,errtext] = get_unit_convert_fac_offset(e_signal.unit,unit_out);
  
  if( length(errtext) )
    error('e_data_signal_convert_unit: %s',errtext);
  end
  
  e_signal.vec  = e_signal.vec * fac + offset;
  e_signal.unit = unit_out;

end