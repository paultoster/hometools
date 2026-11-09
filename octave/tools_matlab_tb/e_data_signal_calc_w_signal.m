function [timevec,valvec] = e_data_signal_calc_w_signal(e,signame1,signame2,calctype)
%
% e = e_data_signal_calc_w_signal(e,signame1,signame2,calctype)
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...
% signame1     signal-Name als Basis
%
% signame2    signal-Name to calc with
%
% calctyp     'add'   add signame1 + signame2
%             'sub'   subtract signame1 - signame2
%
% signame2 will be interpolate to timebase of signalname1
% 

  if( ~isfield(e,signame1) )
    error('signame1 = <%s> is not in e',signame1);
  end
  if( ~isfield(e,signame2) )
    error('signame2 = <%s> is not in e',signame2);
  end
  
  if( ~e_data_is_timevec(e,signame1) )
    error('signame1 = <e.%s> is not a time-Vektor',signame1);
  end
  if( ~e_data_is_timevec(e,signame2) )
    error('signame2 = <e.%s> is not a time-Vektor',signame2);
  end
  
  vec2 = interp1(e.(signame2).time,e.(signame2).vec,e.(signame1).time,'linear','extrap');
  
  timevec = e.(signame1).time;
  if( calctype(1) == 'a' )
    valvec  = e.(signame1).vec + vec2;
  else
    valvec  = e.(signame1).vec - vec2;
  end
  
end