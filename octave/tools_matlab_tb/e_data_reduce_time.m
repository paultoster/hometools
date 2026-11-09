function [e,flag] = e_data_reduce_time(e,tstart,tend,zero_flag)
%
% e = e_data_reduce_time(e,tstart,tend,zero_flag)
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...
% tstart      Startzeit für Eingrenzung, wenn nicht benutzt, dann tstart = -1
% tend        Endzeit für Eingrenzung, wenn nicht benutzt, dann tend = -1
% zero_flag   flag Zeitvektor geht aus null raus
%
% flag        if measurement is regduced flag = 0, otherwise flag = 0;
% 
  
  c_names = fieldnames(e);
  ne      = length(c_names);
  tmin = 1.e60;
  flag = 0;
  for ie=1:ne
%     if( strcmp('PlannerVehDsrdTraj_pointRear_x',c_names{ie}) )
%       a = 0;
%     end
    if( e_data_is_timevec(e,c_names{ie}) )
      nt      = min(length(e.(c_names{ie}).time),length(e.(c_names{ie}).vec));

      if( tstart > 0. )
        i0 = suche_index(e.(c_names{ie}).time,tstart,'>=');
        if( i0 < 1 )
          i0 = 1;
        end
      else
        i0 = 1;
      end
      if( (tend > 0.) && (tend > tstart) )
        i1 = suche_index(e.(c_names{ie}).time,tend,'====');
        if( i1 > nt )
          i1 = nt;
        end
      else
        i1 = nt;
      end
      if( (i1 >= i0) && ((i0 > 1) || (i1 < nt)) )
        flag = 1;
      end
      try 
        if( i1 >= i0 )
          e.(c_names{ie}).time = e.(c_names{ie}).time(i0:i1);
          if( iscell(e.(c_names{ie}).vec) )
            cvec = {};
            for jj=i0:i1
              cvec = cell_add(cvec,e.(c_names{ie}).vec{jj});
            end
            e.(c_names{ie}).vec = cvec;
          elseif( isnumeric(e.(c_names{ie}).vec) )
            e.(c_names{ie}).vec  = e.(c_names{ie}).vec(i0:i1);
          end
          if( e.(c_names{ie}).time(1) < tmin ) 
            if( i0 == i1 )
              e.(c_names{ie}).time = [];
              e.(c_names{ie}).vec  = [];
            else
              tmin = e.(c_names{ie}).time(1);
            end
          end
        else
              e.(c_names{ie}).time = [];
              e.(c_names{ie}).vec  = [];
        end
      catch
        error('Error_%s: e.(%s) geht nicht',mfilename,c_names{ie});
      end
    end
  end
  if( zero_flag )
    for ie=1:ne
      if( e_data_is_timevec(e,c_names{ie}) )
        e.(c_names{ie}).time = e.(c_names{ie}).time - tmin;
      end
    end
  end
end