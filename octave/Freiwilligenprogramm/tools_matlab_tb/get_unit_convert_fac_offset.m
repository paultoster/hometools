function [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,unit_out)
%
% [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,unit_out)
%
%  fac,offset  val_out =  vel_in * fac + offset
%  errtext     (optional) bei Fehler wird hier Text reingeschrieben
%              ansonsten ''
%
fac     = 0.0;
offset  = 0.0;
errtext = '';
if( ~ischar(unit_in) )
  if( nargout < 3 )
    error('unit_in ist kein char')
  else
    errtext = sprintf('unit_in ist kein char');
  end
elseif( ~ischar(unit_out) )
  if( nargout < 3 )
    error('unit_out ist kein char')
  else
    errtext = sprintf('unit_out ist kein char');
  end
end

if(  strcmp(unit_in,unit_out) ...
  || (strcmp(unit_in,'enum') && strcmp(unit_out,'-')) ...
  || (strcmp(unit_out,'enum') && strcmp(unit_in,'-')) ...
  || (strcmpi(unit_in,'enum') && strcmpi(unit_out,'enum') ) ...
  )
  fac    = 1.0;
  offset = 0.0;
elseif(  (strcmp(unit_in,'m/m') && strcmp(unit_out,'-')) ...
      || (strcmp(unit_in,'-') && strcmp(unit_out,'m/m')) ...
      )
  fac    = 1.0;
  offset = 0.0;    
elseif(  (strcmp(unit_in,'g') && strcmp(unit_out,'m/s/s')) ...
      )
  fac    = 9.81;
  offset = 0.0;    
else
  [okay1,unit1,fac1,offset1] = make_SI_unit(unit_in);
  if( ~okay1 )
    if( nargout < 3 )
      error('Die Input-Einheit <%s> konnte nicht gefunden werden in make_SI_unit',unit_in);
    else
      errtext = sprintf('Die Input-Einheit <%s> konnte nicht gefunden werden in make_SI_unit',unit_in);
    end
  end
  if( strcmp(unit_out,unit1) )
    fac    = fac1;
    offset = offset1;
  else
    [okay2,unit2,fac2,offset2] = make_SI_unit(unit_out);
    if( ~okay2 )
    if( nargout < 3 )
      error('Die Output-Einheit <%s> konnte nicht gefunden werden in make_SI_unit',unit_out);
    else
      errtext = sprintf('Die Output-Einheit <%s> konnte nicht gefunden werden in make_SI_unit',unit_out);
    end
      
    end
    if( strcmp(unit1,unit2) )
      fac    = fac1/fac2;
      offset = (offset1-offset2)/fac2;
    elseif( strcmp(unit1,'rad') && strcmp(unit2,'s') )
      fac    = fac1/fac2*180/pi*3600;
      offset = (offset1-offset2)/fac2;
    elseif( strcmp(unit1,'s') && strcmp(unit2,'rad') )
      fac    = fac1/fac2/180*pi/3600;
      offset = (offset1-offset2)/fac2;
    else
      if( nargout < 3 )
        error('Die Input-Einheit <%s> hat keine Entsprechung mit output-Einheit <%s>',unit_in,unit_out);
      else
        errtext = sprintf('Die Input-Einheit <%s> hat keine Entsprechung mit output-Einheit <%s>',unit_in,unit_out);
      end
      
    end
  end
end
