function [ydiff_f, ydiff] = diff_pt1_zp(x,y,T)
%
% [ydiff_f, ydiff] = diff_pt1_zp(x,y,T)
%
%  x        Zeitvektor
%  y        Signalvektor
%  T        Zeitkonstante
%
% ydiff     diff-Werte
% ydiff_f   diff-Werte gefiltert
%
if nargin < 3
    fprintf('[ydiff_filt, ydiff] = diff_pt1(x,y,T)\n\n')
   error('Error_diff_pt1: Zuwenig Argumente min 3')
end

[nx,mx]=size(x);
[ny,my]=size(y);

if( (nx ~= ny) || (mx ~= my) ) 
   error('Error_diff_pt1: x und y haben nicht die gleiche Dimension')
end

if( (mx == 1) && (nx >= 1) ) 
   is_zeilen_vektor = 1;
elseif( (nx == 1) && (mx >= 1) )
   is_zeilen_vektor = 0;
else
   error('Error_diff_pt1: x,y sind Matrizzen')
end


delx = diff(x);

if min(abs(delx)) < 1.0e-10
   error('Error_diff_pt1: x ist nicht monoton steigend')
end

ydiff   = x*0;
ydiff_f = x*0;

for i=2:mx*nx

    ydiff(i)   = (y(i)-y(i-1))/(x(i)-x(i-1));
%    ydiff_f(i) = pt1_filter_online(ydiff(i),ydiff_f(i-1),x(i)-x(i-1),T*1000,256);
end

if( T > 1e-30 )
    ydiff_f = pt1_filter_zp(x,ydiff,T);
else
    ydiff_f = ydiff;
end

