% x0=0;y0=1;
% x1=1;y1=0.8;
% 
% x3=1;y3=0;
% x2=0;y2=0.4;
% 
% g0=z.*z.*z-z.*z-z+1;g1=z.*(z-1).*(z-1);
% g2=z.*z.*(1-z);g3=z.*z.*(2-z);
% f1=x0*g0+x1*g1+x2*g2+x3*g3;
% f2=y0*g0+y1*g1+y2*g2+y3*g3;

x0 = 0;
y0 = 0;
x1 = 10;
y1 = 1;
xs = 0.5;
ys = 0;
yp0 = 0.01; %1000000;
yp1 = 0.6; %0.1;

%
% Berechnung:
x = [x0:0.01:x1]';


D = yp1 - yp0;
if( abs(D) < eps )

    xs = x1;
    ys = y1;
else
    xs = (y0-x0*yp0-y1+x1*yp1)/D;
    ys = yp0*(xs-x0)+y0;
end


[x,y,z,A] = calc_bezier('P0',[x0,y0],'P1',[x1,y1],'yp0',yp0,'yp1',yp1,'x',x);

%

Px = [x0;x1];
Py = [y0;y1];
Qx = [x1;xs;x0];
Qy = [y1;ys;y0];

figure
plot(x,y,'g-')
hold on
plot(Px,Py,'k-')
plot(Qx,Qy,'r-')
hold off
grid on

