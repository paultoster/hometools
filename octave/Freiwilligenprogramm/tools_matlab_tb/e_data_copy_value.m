function e = e_data_copy_value(e,src_signame,dst_signame,fac,offset,dst_unit)
%
% e = e_data_copy_value(e,src_signame,dst_signame);
% e = e_data_copy_value(e,src_signame,dst_signame,fac,offset);
% e = e_data_copy_value(e,src_signame,dst_signame,fac,offset,dst_unit);
%
% Kopieren eines Signals src_signame zu dst_signame
%
% e            e-Datenstruktur mit e.dst_signame.time    Zeitvektor
%                                  e.dst_signame.vec     Vektor oder cellaray
%                                                        mit Vektor zu jedem Zeitpunkt
%                                  e.dst_signame.lin     Linear/constant bei
%                                                        Interpolation
%                                  e.dst_signame.unit    Einheit
%                                  e.dst_signame.comment Kommentar
%
% mit fac und offset:
% e.dst_signame.vec = e.src_signame.vec * fac + offset
%
% mit dst_unit: Umrechnung von src_signame zu dst_unit
%
 
  if( ~check_val_in_struct(e,src_signame,'struct',1) )
    error('%s: e.%s ist nicht zum kopieren vorhanden !!!',mfilename,src_signame)
  end
  if( ~check_val_in_struct(e.(src_signame),'time','num',1) )
    error('%s: e.%s.time ist nicht zum kopieren vorhanden !!!',mfilename,src_signame)
  end
  if( ~check_val_in_struct(e.(src_signame),'vec','num',1) )
    error('%s: e.%s.vec ist nicht zum kopieren vorhanden !!!',mfilename,src_signame)
  end
  if( ~check_val_in_struct(e.(src_signame),'unit','char',0) )
    error('%s: e.%s.unit ist nicht zum kopieren vorhanden !!!',mfilename,src_signame)
  end
  if( ~exist('fac','var') || isempty(fac) )
    fac = 1.0;
  end
  if( ~exist('offset','var') || isempty(offset) )
    offset = 0.0;
  end
  if( ~exist('dst_unit','var') || isempty(dst_unit) )
    dst_unit = e.(src_signame).unit; % damit ist fac_unit = 1.0,offset_unit = 0.0
  end
  
  % Einheitenwandlungs-Faktoren und -Offset
  [fac_unit,offset_unit,errtext] = get_unit_convert_fac_offset(e.(src_signame).unit,dst_unit);
  
  if( ~isempty(errtext) )
    error('%s: %s',mfilename,errtext);
  end
  
  % vollständiges kopieren
  e.(dst_signame) = e.(src_signame);
  
  % Einheitenwandlung
  e.(dst_signame).vec = e.(dst_signame).vec*fac_unit + offset_unit;
  % Zusatz Faktor
  e.(dst_signame).vec = e.(dst_signame).vec*fac + offset;
  % Einheit
  e.(dst_signame).unit = dst_unit;
  
end