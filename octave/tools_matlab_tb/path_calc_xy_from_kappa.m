function [alpha,x,y,ds] = path_calc_xy_from_kappa(s,kappa,alpha0,x0,y0,TypeOfCurvePreCalc)
%
% [alpha,x,y] = path_calc_xy_from_kappa(s,kappa,alpha0,x0,y0,TypeOfCurvePreCalc)
%
% x,y = f(s,kappa,alpha0,x0,y0)
% TypeOfCurvePreCalc = 0   :   curvature at knot
% TypeOfCurvePreCalc = 1   :   curvature between knot (not implemented)
%
% s                vector displacement from path fom knot to knot
% kappa            vector curvature at knot
%
% alpha            vector gradient atan(dy/dx) at knot
% x                vector x at knot
% y                vector y at knot

if( ~exist('TypeOfCurvePreCalc','var') )
  TypeOfCurvePreCalc = 0;
end

n      = min(length(s),length(kappa));
alpha  = s*0.0;
x      = s*0.0;
y      = s*0.0;
ds     = s*0.0;

alpha(1) = alpha0;
x(1)     = x0;
y(1)     = y0;
for i=2:n
  ds(i-1)  = s(i)-s(i-1);
  alpha(i) = alpha(i-1) + kappa(i)*ds(i-1);
  x(i)     = x(i-1)     + cos(alpha(i-1))*ds(i-1);
  y(i)     = y(i-1)     + sin(alpha(i-1))*ds(i-1);
end
ds(n) = ds(n-1);
