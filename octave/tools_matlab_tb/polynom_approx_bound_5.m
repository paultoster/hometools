function p = polynom_approx_bound_5(x0,y0,yp0,ypp0,x1,y1,yp1,ypp1)
%
%
%  Polynom 5. Ordung mit Wert, Ableitung und zweite Ableitung in zwei
%  Punkten
%

  y = [y0,yp0,ypp0,y1,yp1,ypp1]';
  A = [x0^5,     x0^4,     x0^3,    x0^2,    x0,    1.;
       5.*x0^4,  4.*x0^3,  3.*x0^2, 2.*x0,   1.,    0.;
       20.*x0^3, 12.*x0^2, 6.*x0,   2.,      0.,    0.;
       x1^5,     x1^4,     x1^3,    x1^2,    x1,    1.;
       5.*x1^4,  4.*x1^3,  3.*x1^2, 2.*x1,   1.,    0.;
       20.*x1^3, 12.*x1^2, 6.*x1,   2.,      0.,    0.];
   
  if( abs(det(A)) < eps )
    error('det(A) == 0 kein Inversion')
  end
  p = A\y;
end
