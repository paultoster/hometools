function s = polynom_build_with_polynom(polynom)
%
% s = polynom_build_with_polynom(polynom)
%
% build struct polynom coefficient
%
% polynom = [a(m),a(m-1), ..., a(1)] : % y = a(m)*x^(m-1) + ... + a(1) * x^0
% =>
% y = root_factor * (x - roots(1)) * (x - roots(2) * ... * (x-roots(n))
%   
%
% new calclated:
% s.root_factor 
% s.roots       
% s.polynom       
%                                            
%
  s.root_factor = 0.;
  s.roots       = [];
  s.polynom     = polynom_coeff_proof(polynom);
  n         = length(s.polynom);
  if( n == 1 )
    s.roots = [];
    s.root_factor = s.polynom(1);
  else
    
    dx = 0.0;
    if( abs(s.polynom(1)) < eps )
      for i=1:100
        dx = i;
        s.polynom = polynom_coeff_shift_in_x(s.polynom,dx);
        if( abs(s.polynom(1)) > eps )
          break;
        end
      end
    end
    n         = n-1;
    A = diag(ones(n-1,1),-1);
    A(1,:) = -s.polynom(2:n+1)./s.polynom(1);
    try 
    s.roots = eig(A)';
    catch
      a = 0;
    end
    % shift back
    if( abs(dx) > eps )
      s.polynom = polynom_coeff_shift_in_x(s.polynom,-dx);
      for i=1:length(s.roots)
        s.roots(i) = s.roots(i) - dx;
      end
    end

    % Build factor
    for i=0:100
      x = i;
      y = 1.;
      for j=1:length(s.roots)
        y = y * (x - s.roots(j));
      end

      if( abs(y) > eps )
       y1 = polyval(s.polynom,x);
       s.root_factor = y1/y;
       break;
      else
        s.root_factor = 0;
      end
    end
  end
end
