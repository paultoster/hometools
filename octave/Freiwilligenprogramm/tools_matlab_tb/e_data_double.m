function e = e_data_double(e,type)
%
% e = e_data_double(e,type)
%
% e            e-Datenstruktur mit e.time,e.vec,e.lin
%             ...
% type      1: verdoppelt nach der letzten Zeit eines Signals
% 
  
  c_names = fieldnames(e);
  ne      = length(c_names);
  
  [tstartmax,tstartmin,tstartvec] = e_data_get_tstart(e);
  [tendmax,tendmin,tendvec]       = e_data_get_tend(e);
  for ie=1:ne
%     if( strcmp('PlannerVehDsrdTraj_pointRear_x',c_names{ie}) )
%       a = 0;
%     end
    if( e_data_is_timevec(e,c_names{ie}) )
      
      if( (e.(c_names{ie}).time(1)-tstartmin) < 1.e-2 )
        dt = 0.01;
      else
        dt = 0.0;
      end
      
      timevec = [e.(c_names{ie}).time;(e.(c_names{ie}).time-tstartmin+dt+tendmax)];
      
      if( iscell(e.(c_names{ie}).vec) )
        vec = cell_add(e.(c_names{ie}).vec,e.(c_names{ie}).vec);
      else
        vec = [e.(c_names{ie}).vec;e.(c_names{ie}).vec];
      end
      e.(c_names{ie}).time = timevec;
      e.(c_names{ie}).vec  = vec;
    end
  end
end