function yint = integriere(x,y,order,y0)
%
% yint = integriere(x,y,order,y0)
%        order: 0 Euler
%        order: 1 Trapez
%        y0:    Offset

if nargin < 2
    fprintf('yint = integriere(x,y,order,yint0)\n\n')
   error('Error_integriere: Zuwenig Argumente min 2')
elseif nargin == 3
   y0    = 0.0;
elseif nargin == 2
   order           = 0;
   y0              = 0.0;
end

[nx,mx]=size(x);
[ny,my]=size(y);

if( (nx ~= ny) || (mx ~= my) ) 
   error('Error_integriere: x und y haben nicht die gleiche Dimension')
end

if( (mx == 1) && (nx >= 1) ) 
   is_zeilen_vektor = 1;
elseif( (nx == 1) && (mx >= 1) )
   is_zeilen_vektor = 0;
else
   error('Error_integriere: x,y sind Matrizzen')
end


delx = diff(x);

if min(abs(delx)) < 1.0e-10
   error('Error_integriere: x ist nicht monoton steigend')
end

yint    = [];
yint(1) = y0;
if order == 0
    for i=2:mx*nx
        yint(i) = yint(i-1) + delx(i-1)*y(i-1);
    end
   
else
    for i=2:mx*nx
        yint(i) = yint(i-1) + delx(i-1)*(y(i-1)+y(i))*0.5;
    end
end

if( is_zeilen_vektor )
    yint = yint';
end
