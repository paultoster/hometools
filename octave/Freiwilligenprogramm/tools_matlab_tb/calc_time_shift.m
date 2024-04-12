function [dtmean,dtvec] = calc_time_shift(time,vecref,vecact,increase_flag)
%
% [dtmean,dtvec] = calc_time_shift(time,vecref,vecact,increase_flag)
%
  dtmean  = 0.0;
  ndtmean = 0;
  ntime = length(time);
  dtvec = time*0.0;
  dvec  = diff(vecref);
  n     = length(dvec);
  for i=1:n
    if( increase_flag )
      % soll ansteigend und ref größer act
      if( (dvec(i) > 0.00001) && (vecref(i) >= vecact(i)) )
        for j=i:ntime
          if( vecact(j) >= vecref(i) )
            dtvec(i) = time(j)-time(i);
            ndtmean  = ndtmean + 1;
            dtmean   = dtmean + dtvec(i);
            break
          end
        end
      end
    else % decrease
      % soll abfallend sein und ref kleiner act
      if( (dvec(i) < -0.00001) && (vecref(i) <= vecact(i)) )
        for j=i:ntime
          if( vecact(j) <= vecref(i) )
            dtvec(i) = time(j)-time(i);
            ndtmean  = ndtmean + 1;
            dtmean   = dtmean + dtvec(i);
            break
          end
        end
      end
    end
  end

  if( ndtmean )
    dtmean = dtmean / ndtmean;
  end
end