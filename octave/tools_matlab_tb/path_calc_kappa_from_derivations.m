function kappa = path_calc_kappa_from_derivations(xp,xpp,yp,ypp)
%
% kappa = path_calc_kappa_from_derivations(xp,xpp,yp,ypp)
%
% Calculation of curvature with kappa = (xp*ypp-xpp*yp)/(xp^2+yp^2)^(3/2)
%
  n = min(length(xp),length(xpp));
  n = min(n,length(yp));
  n = min(n,length(ypp));
  kappa = zeros(n,1);
  % curvature
  for i=1:n
    
    den = xp(i)*xp(i)+yp(i)*yp(i);
    if( den < eps )
      den = eps;
    else
      den = sqrt(den^3);
    end
    
    kappa(i) = (xp(i)*ypp(i)-yp(i)*xpp(i))/den;
  end
end
