function [t0,t1] = get_time_overlap(cellvecs)
%
% [t0,t1] = get_time_overlap(cellvecs)
%
%  find time overlap of n- timevecs
%  cellvecs = {timevec1,timevec2, ... , timevecn};
%
%  t0    maximum of tstart
%  t1    minimum of tend

  n = length(cellvecs);
  
  t0 = -1000.;
  t1 = 0.0;
  for i=1:n
    if( ~isnumeric(cellvecs{i}) )
      error('Error_%s: %i-ter cellvecs ist nicht numerisch',mfilename);
    end
    if( ~is_monoton_steigend(cellvecs{i}) )
      error('Error_%s: %i-ter cellvecs ist nicht monoton steigend',mfilename);
    end
    t1 = max(t1,max(cellvecs{i}));
  end
  
  for i=1:n
    [n,m] = size(cellvecs{i});
    if( n >= m )
      for j = 1:m         
        t0 = max(t0,cellvecs{i}(1,j));
        t1 = min(t1,cellvecs{i}(end,j));
      end
    else
      for j = 1:n
        t0 = max(t0,cellvecs{i}(j,1));
        t1 = min(t1,cellvecs{i}(j,end));
      end
    end
  end
end