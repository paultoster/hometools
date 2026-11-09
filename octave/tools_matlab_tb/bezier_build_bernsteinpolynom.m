function p = bezier_build_bernsteinpolynom(grad,inum)
%
% p = bezier_build_bernsteinpolynom(grad,i)
%
% grad    Grad der Bezier-Funtion (ordnung waere plus eins)
% i       0 ... grad, Funktion zu dem entspr. Punkt Pi
%
%           /grad\
% Bi,n(t) = |    | * t^i * (1-t)^(n-i)
%           \ i  /
%
% B0,2(t) = 

  fac = binominalkoeffizient(grad,inum);

  roots = [];

  for i=1:inum
    roots = [roots;0.0];  
  end

  nn = grad-inum;

  for i=1:nn
    roots = [roots;1.0];
    fac   = fac * (-1.);
  end

  s = polynom_build_with_roots(roots,fac);
  p = s.polynom;
end
  
  