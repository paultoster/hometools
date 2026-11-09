function yapprox = approx_pchip(xvec,yvec,xapprox,iabl)
%
% yapprox = approx_pchip(xvec,yvec,xapprox,iabl)
%
% Piecewise Cubic Hermite Interpolating Polynomial (PCHIP)
%
% iabl       0: Wert (default)
%            1: erste Ableitung
%            2: zweite Ableitung

  if( ~exist('iabl','var') )
    iabl = 0;
  end
  
  nvec = min(length(xvec),length(yvec));
  xvec = xvec(1:nvec);
  yvec = yvec(1:nvec);
  
  if( ~is_monoton_steigend(xvec) )
    error('%s_error: xvec ist nicht monoton stegend',mfilename);
  end

  P = pchip(xvec,yvec);
  
  % erste Ableitung
  if( iabl > 0.5 )
    P = approx_pchip_der(P);
  end
  % zweite Ableitung
  if( iabl > 1.5 )
    P = approx_pchip_der(P);
  end
  yapprox = ppval(P,xapprox);
end
function     P = approx_pchip_der(P)
  if( P.order > 0 )
    [n,m] = size(P.coefs);
    coefs1 = zeros(n,m-1);
    for i=1:n
      pd  = polyder(P.coefs(i,1:m));
      npd = length(pd);
      if( npd == (m-1) )
        coefs1(i,:) = pd;
      else
        k = (m-1)-npd;
        for j=1:npd
          coefs1(i,j+k) = pd(j);
        end
      end
    end
    P.coefs = coefs1;
    P.order = m-1;
  end
end