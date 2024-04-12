function a = poly_from_roots(roots)
%
% a = poly_from_roots(roots_vector)
%
% Berechnet das Polynom aus roots/nullstellen
%
% a = [an,an-1, ..., a0]'
% für 
% y = an*x^n + an-1*x^(n-1) + ... + a0
%
% wenn plot_flag, dann einfaches Plot dazu

   m = min (size (roots));
   n = max (size (roots));
   if (m == 0)
     a = 1;
     return;
   elseif (m == 1)
     v = roots;
   elseif (m == n)
     v = eig (roots);
   end

   a = zeros(1, n+1);
   a(1) = 1;
   for j = 1:n
     b = a;
     for i=2:j+1
       a(i) = a(i)-v(j)*b(i-1);
     end
%      a(2:(j+1)) = a(2:(j+1)) - v(j) .* a(1:j);
   end

   if (all (all (imag (roots) == 0)))
     a = real (a);
   end

end
