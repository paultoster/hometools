function e = e_data_signal_reduce_time(e,csigname,tstart,tend,zero_flag)
%
% e = e_data_reduce_bytime(e,signame,tstart,tend,zero_flag)
% e = e_data_reduce_bytime(e,csigname,tstart,tend,zero_flag)
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...
% signame     signal-Name der geändert werden soll bzw 
%             csigname als cell array wenn leer {} dann alle
% tstart      Startzeit für Eingrenzung, wenn nicht benutzt, dann tstart = -1
% tend        Endzeit für Eingrenzung, wenn nicht benutzt, dann tend = -1
% zero_flag   flag Zeitvektor geht aus null raus
% 
  if( isempty(csigname) )
    csigname = fieldnames(e);
  elseif( ischar(csigname) )
    csigname = {csigname};
  end
  
  
  ne      = length(csigname);
  tmin = 1.e60;
  for ie=1:ne
    if( e_data_is_timevec(e,csigname{ie}) )
      nt      = min(length(e.(csigname{ie}).time),length(e.(csigname{ie}).vec));

      if( tstart > 0. )
        i0 = suche_index(e.(csigname{ie}).time,tstart,'>=');
        if( i0 < 1 )
          i0 = 1;
        end
      else
        i0 = 1;
      end
      if( (tend > 0.) && (tend > tstart) )
        i1 = suche_index(e.(csigname{ie}).time,tend,'====');
        if( i1 > nt )
          i1 = nt;
        end
      else
        i1 = nt;
      end
      try 
        if( i1 >= i0 )
          e.(csigname{ie}).time = e.(csigname{ie}).time(i0:i1);
          e.(csigname{ie}).vec  = e.(csigname{ie}).vec(i0:i1);
          if( e.(csigname{ie}).time(1) < tmin ) 
            if( i0 == i1 )
              e.(csigname{ie}).time = [];
              e.(csigname{ie}).vec  = [];
            else
              tmin = e.(csigname{ie}).time(1);
            end
          end
        else
              e.(csigname{ie}).time = [];
              e.(csigname{ie}).vec  = [];
        end
      catch
        error('Error_%s: e.(%s) geht nicht',mfilename,csigname{ie});
      end
    end
  end
  if( zero_flag )
    for ie=1:ne
      e.(csigname{ie}).time = e.(csigname{ie}).time - tmin;
    end
  end
end