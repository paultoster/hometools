function ydiff = differenziere(x,y,order,forward)
%
% ydiff = differenziere(x,y,order[,forward])
%
% forward = 1 (default)
% ydiff(i) = (y(i+1)-y(i))/(x(i+1)-x(i))
% ydiff(n) = ydiff(n-1);
% forward = 0
% ydiff(i) = (y(i)-y(i-1))/(x(i)-x(i-1))
% ydiff(1) = ydiff(2);
%
% orer = 1 oder 2

if nargin < 2
   error('Error_differenziere: Zuwenig Argumente min 2')
elseif nargin == 2
   order = 1;
   forward = 1;
elseif nargin == 3
   forward = 1;
end

[nx,mx]=size(x);
[ny,my]=size(y);

if nx ~= ny || mx ~= my 
   error('Error_differenziere: x und y haben nicht die gleiche Dimension')
end

if mx == 1 && nx >= 1 
   is_zeilen_vektor = 1;
elseif nx == 1 && mx >= 1
   is_zeilen_vektor = 0;
else
   error('Error_differenziere: x,y sind Matrizzen')
end


delx = diff(x);

if min(abs(delx)) < 1.0e-10
   error('Error_differenziere: x ist nicht monoton steigend')
end

if order == 1
   
   ydiff = diff(y)./delx;

   if( forward )
     if is_zeilen_vektor == 1
        ydiff = [ydiff',ydiff(length(delx))]';
     else
        ydiff = [ydiff,ydiff(length(delx))];
     end
   else
     if is_zeilen_vektor == 1
        ydiff = [ydiff(1),ydiff']';
     else
        ydiff = [ydiff(1),ydiff];
     end
   end
else
   
   zdiff = diff(y)./delx;
   ydiff(1) = zdiff(1);
   for i=2:length(zdiff)
      ydiff(i) = 0.5*(zdiff(i-1)+zdiff(i));
   end
   ydiff(length(zdiff)+1)=zdiff(length(zdiff));
   if( is_zeilen_vektor == 1 )
    ydiff = ydiff';
   end
end

