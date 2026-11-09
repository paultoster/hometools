function polynom = polynom_coeff_proof(polynom)
%
% polynom = polynom_coeff_proof(polynom)
%
% check if polynom(1) is not zero

n = length(polynom);
if( n == 0 )
  error('%s: polynom is empty',mfilename);
end
while( (abs(polynom(1)) < eps) && ( n > 1) )
  polynom = polynom(2:end);
  n = length(polynom);
end
  