function vec = vec_set_first_values_if_zero(vec,nvalue,toleranz)
%
% vec = vec_set_first_values_if_zero(vec,nvalue,toleranz)
% vec = vec_set_first_values_if_zero(vec,nvalue)
%
% proof if one of first nvalues are not zero (toleranz) 
% set first non valid values to the first valid value
% 
%
% vec      vector
% nvalue   look nvalue for non zero value
% toeranz  (default: eps)
  
  if( ~exist('toleranz','var') )
    toleranz = eps;
  end
  
  toleranz = abs(toleranz);
  i0 = 0;
  n = length(vec);
  for i=1:min(n,nvalue)    
    if( abs(vec(i)) > toleranz )
      val0 = vec(i);
      i0   = i;
      break;
    end
  end
  for i=1:i0-1
    vec(i) = val0;
  end  
end

