function e = e_data_merge_2_signals(e,signame1,signame2,signameout,spec)
%
% e =e_data_merge_2_signals(e,signame1,signame2,signameout,spec);
%
% merge of two signals with specification
%
% e            e-Datenstruktur mit e.signame.time    Zeitvektor
%                                  e.signame.vec     Vektor oder cellaray
%                                                    mit Vektor zu jedem Zeitpunkt
%                                  e.signame.lin     Linear/constant bei
%                                                    Interpolation
%                                  e.signame.unit    Einheit
%                                  e.signame.comment Kommentar
%
% signame1               char first signalname
% signame2               char second signalname
% signameout             char output-Signalname
% spec                   char '+','-','*','/' (default '+')

  if( ~exist('signame1','var') || isempty(signame1) )
    error('%s: ''signame1 muss'' angegeben werden',mfilename)
  end
  if( ~isfield(e,signame1) )
    error('%s: e.signame1 muss vorhanden',mfilename)
  end  
  if( ~exist('signame2','var') || isempty(signame2) )
    error('%s: ''signame2 muss'' angegeben werden',mfilename)
  end
  if( ~isfield(e,signame2) )
    error('%s: e.signame2 muss vorhanden',mfilename)
  end  
  if( ~exist('signameout','var') || isempty(signameout) )
    error('%s: ''signameout muss'' angegeben werden',mfilename)
  end
  if( ~exist('spec','var') || isempty(spec) )
    spec = '+';
  end
  
  if( ~isfield(e,signameout) ) % neu anlegen
    if( isempty(e) )
      e = struct(signameout,[]);
    else
      e.(signameout) = [];
    end
  end
  
  e.(signameout) = e.(signame1);
  
  vec2           = interp1(e.(signame2).time,e.(signame2).vec,e.(signame1).time,'linear','extrap');
  
  [fac,offset]   = get_unit_convert_fac_offset(e.(signame2).unit,e.(signame1).unit);
  % val_out =  vel_in * fac + offset
  if( strcmp(spec,'+') )
     e.(signameout).vec = e.(signame1).vec + vec2*fac+offset;
  elseif( strcmp(spec,'-') )
     e.(signameout).vec = e.(signame1).vec - vec2*fac+offset;
  elseif( strcmp(spec,'*') || strcmp(spec,'.*') )
     e.(signameout).vec = e.(signame1).vec .* (vec2*fac+offset);
  elseif( strcmp(spec,'/') || strcmp(spec,'./') )
     e.(signameout).vec = e.(signame1).vec ./ not_zero(vec2*fac+offset);
  else
    error('%s: spec muss gleich ''+'',''-'',''*'' oder ''/'' sein',mfilename)
  end
end