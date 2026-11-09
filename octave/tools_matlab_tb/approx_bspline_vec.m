function  yapproxvec = approx_bspline_vec(xvec,yvec,dPathVec,indexVec,iabl,type)
%
% yapprox = approx_bspline_vec(xvec,yvec,dPathVec,indexVec,iabl,type)
%
% Approximation von yvec = f(xvec)
%
% mit i = 1:min(length(dPathVec),length(indexVec))
%
% mit xi = xvec(indexVec(i)) + dPathVec(i) * (xvec(indexVec(i)+1)-xvec(indexVec(i)))
%
% yapprox(i) = approx_bspline(xvec,yvec,xi,iabl);
%
% dPathVec,indexVec ist mit vek_2d_intersection_vec() gerechnet
%
% iabl       0: Wert (default)
%            1: erste Ableitung
%            2: zweite Ableitung
% type       0: Approximation mit i-1, ... , i+2 (default)
%            1: Approximation mit i, ... , i+3

  if( ~exist('iabl','var') )
    iabl = 0;
  end
  if( ~exist('type','var') )
    type = 0;
  end

  n = min(length(dPathVec),length(indexVec));
  
  yapproxvec = zeros(n,1);
  
  nvec = min(length(xvec),length(yvec));
  
  for i=1:n
    if( i == 1650 )
      a = 0;
    end
    index = indexVec(i);
    if( index > (nvec-1) )
      index = nvec-1;
    end
    xi            = xvec(index) + dPathVec(i) * (xvec(index+1)-xvec(index));

    yapproxvec(i) = approx_bspline(xvec,yvec,xi,iabl,type);
  end
end