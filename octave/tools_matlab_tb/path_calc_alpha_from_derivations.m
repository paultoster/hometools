function alpha = path_calc_alpha_from_derivations(xp,yp)
%
% alpha = path_calc_alpha_from_derivations(xp,yp)
%
% Calculation of yawangle with alpha = atan(yp/xp)
%
  n     = min(length(xp),length(yp));
  alpha = zeros(n,1);
  % yawangle
  for i=1:n    
    alpha(i) = atan2(yp,xp);
  end
end
