function [y,u] = vec_convert_unit(y,unit_in,unit_out)
%
% y = vec_convert_unit(yin,unit_in,unit_out)
%
% Konvertiert Vektor yin mit unit_in in y mit unit_out
%
  [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,unit_out);
 
  if( ~isempty(errtext) )
    error(errtext);
  end
 
  y = y * fac + offset;
  u = unit_out;
end