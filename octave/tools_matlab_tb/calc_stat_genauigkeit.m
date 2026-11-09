function [dval,dvalvec] = calc_stat_genauigkeit(time,vecref,vecact)
%
% [dval,dvalvec] = calc_time_shift(time,vecref,vecact)
%
  dval  = 0.0;
  ndval = 0;
  ntime = length(time);
  dvalvec = [];
  dvec  = diff(vecref);
  n     = length(dvec);
  istatus = 1;  % 0: start, 1: end
  for i=2:n
    % soll ansteigend und ref größer act
    if( (dvec(i) < 0.00001) && (dvec(i) > -0.00001) )
      istatus = 0;
    else
      if( istatus == 0 )
       ndval = ndval + 1;
       dval  = dval + abs(vecref(i) - vecact(i));
       dvalvec = [dvalvec;abs(vecref(i) - vecact(i))];
       istatus = 1;
      end
    end
  end
 
  if( ndval )
    dval = dval / ndval;
  end
end