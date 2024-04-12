function e = e_data_expand_signals(e,csignalnames,time_end)
%
%   e = e_data_prolong_signals(e,csignalnames,time_end)
%
%  e                e-structure
%  csignalnames     cell-array with bsignale name 
%                   if empty take all signals
%
% time_end          time to prolong or reduce signal
%                   prolong with replay signals again


  if( isempty(csignalnames) )
    csignalnames = fieldnames(e);
  end
  
  % filter all signales from csignalnames, which are in the fieldnames
  cliste = cell_find_liste(fieldnames(e),csignalnames);
  
  for i=1:length(cliste)
    % make only sense for time-signals
    if( e_data_is_timevec(e,cliste{i}) )
      t1 = e.(cliste{i}).time(end);
      t0 = e.(cliste{i}).time(1);
      if( time_end < t1 )
        e = e_data_signal_reduce_time(e,cliste{i},-1.,time_end,0);
      else  
        flag = 1;
        while( flag )
          dt1 = time_end-t1;
          dt2 = t1-t0;
          if( dt1 > dt2 )
            dt1 = dt2;
          else
            flag = 0; % letzte Rechnung
          end
          i0 = 2;
          i1 = suche_index(e.(cliste{i}).time,t0+dt1,'===');
          i1 = min(length(e.(cliste{i}).time),ceil(i1));
          
          vec = e.(cliste{i}).time(i0:i1)+e.(cliste{i}).time(end)-e.(cliste{i}).time(1);
          e.(cliste{i}).time = [ e.(cliste{i}).time;vec];
          if( isnumeric(e.(cliste{i}).vec) )
            e.(cliste{i}).vec = [e.(cliste{i}).vec;e.(cliste{i}).vec(i0:i1)];
          else % cell
            for j=i0:i1
              e.(cliste{i}).vec = cell_add(e.(cliste{i}).vec,e.(cliste{i}).vec{j});
            end
          end 
          t1 = e.(cliste{i}).time(end);
        end
      end
    end    
  end
end

