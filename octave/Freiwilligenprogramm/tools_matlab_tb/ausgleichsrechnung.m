function a = ausgleichsrechnung(A,F)
%
% a = ausgleichsrechnung(A,F)
%
% Koefizienten aus Ausgleichrechnung für F = A*a
%
% z.B gilt der Ansatz f = a1 + a2 * x + a3 * x^2 + a4 * y
% Messungen mit fi = a1 + a2 * xi + a3 * xi^2 + a4 * yi , i = 1...n
%
% F = [f1, f2, f3 ... fn]'
% 
% A = [1, x1, x1^2, y1;
%      1, x2, x2^2, y2;
%      1, x3, x3^2, y3;
%      ...
%      1, xn, xn^2, yn];
%
% a = [a1, a2, a3, a4]'
%
%
[n,m]   = size(A);
[n1,m1] = size(F);

if( n == m1 && n1 == 1 )
    F = F';
elseif( n ~= n1 )
    error('ausgleichsrechnung_error: A(%i,%i) ungleich F(%i,%i)',n,m,n1,m1);
elseif( m1 ~= 1 )
    error('ausgleichsrechnung_error: F(%i,%i) ist kein Vektor',n,m,n1,m1);
end

V = A'*F;
N = A'*A;

if( abs(det(N)) <= eps )
    error('ausgleichsrechnung_error: det(A''*A) ist null, keine Inverse möglich');
end

a = N\V;