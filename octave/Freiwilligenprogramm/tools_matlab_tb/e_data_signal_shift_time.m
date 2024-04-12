function e = e_data_signal_shift_time(e,csigname,tshift,cutoff)
%
% e = e_data_signal_shift_time(e,signame,tshift,cutoff)
% e = e_data_signal_shift_time(e,csigname,tshift,cutoff)
%
% shift time with e.signal.time = e.signal.time - tshift;
% and cut off if time is negative
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...
% signame     signal-Name der geändert werden soll bzw 
%             csigname als cell array wenn leer {} dann alle
% tshift      e.signal.time = e.signal.time - tshift;
% cutoff      cut off negative time
% 
  if( isempty(csigname) )
    csigname = fieldnames(e);
  elseif( ischar(csigname) )
    csigname = {csigname};
  end
  
  if( ~exist('cutoff','var') )
    cutoff = 0;
  end
  
  
  ne      = length(csigname);
  for ie=1:ne
    if( e_data_is_timevec(e,csigname{ie}) )
      nt      = min(length(e.(csigname{ie}).time),length(e.(csigname{ie}).vec));
      
      e.(csigname{ie}).time = e.(csigname{ie}).time - tshift;
      if( cutoff )
        if( e.(csigname{ie}).time(1) < 0.0 )
          i0 = 1;
          for i=1:nt          
            if( e.(csigname{ie}).time(i) >= 0.0 )
              i0 = i;
              break;
            end
          end
        end
        e.(csigname{ie}).time = e.(csigname{ie}).time(i0:nt);
        e.(csigname{ie}).vec = e.(csigname{ie}).vec(i0:nt);
      end
    end
  end
end