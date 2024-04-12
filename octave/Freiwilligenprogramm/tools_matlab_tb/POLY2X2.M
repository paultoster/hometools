%polynom3.m

% TZB Berthold 3052 4/98

disp(' ')
disp(' Zeigt 2 Polynome n=2 ' )
disp(' ')
disp(' y = f(x) = a0+a1*x+a2*x^2')
disp(' ')
disp(' wobei die Punkte x0,y0,x1>x0,y1 sowie die Steigungen ')
disp(' y0d = df(x0)/dx, y1d = df(x1)/dx festliegen')
disp(' Es werden zwei Polynome gebildet, die an der Stelle xs (x0<xs<x1)')
disp(' mit geleicher Steigung ineienander übergehen')
%
%
disp('Feste Parameter :')
x0 = 0
y0 = 0
x1 = 10
y1 = 100
disp('Eingabeparameter :')
disp(' ')
y0d=input('y0d = ');
y1d=input('y1d = ');
xs =input('xs = ');
%
%
n=101;
x=[x0:(x1-x0)/(n-1):x1]';

ns = floor((xs-x0)/(x1-x0)*n);

if ns == 0
  xt1=0;
else
  xt1=x(1:ns);
end
  
if ns >= n
  xt2=0;
else
  xt2=x(ns+1:n);
end

if abs(xs-x0) <= 1e-10
  A1=0;
  B1=0;
else
  A1 = -(-2*y1+x1*y1d-xs*y1d+2*y0+y0d*xs-2*y0d*x0+x1*y0d)/(-xs*x0+x0^2+x1*xs-x1*x0);
  B1 = y0d;
end

if abs(x1-xs) <= 1e-10
  A2=0;
  B2=0;
else
  A2 = (y0d*xs-xs*y1d-2*y1-y0d*x0+2*y0+2*x1*y1d-y1d*x0)/(-x0+x1)/(x1-xs);
  B2 = -(y0d*xs-xs*y1d-2*y1-y0d*x0+2*y0+x1*y1d)/(-x0+x1)
end

ys= A1/2*(xs-x0)^2+B1*(xs-x0)+y0;

yt1=y0+(B1+A1/2*(xt1-x0)).*(xt1-x0);
yt2=ys+(B2+A2/2*(xt2-xs)).*(xt2-xs);

ydt1=A1*(xt1-x0)+B1;
ydt2=A2*(xt2-xs)+B2;

yds = A1*(xs-x0)+B1;

if ns == 0
 y = yt2;
 yd= ydt2;
elseif ns >= n
 y = yt1;
 yd= ydt1;
else
 y = [yt1',yt2']';
 yd= [ydt1',ydt2']';
end


ydh1=(y1d-y0d)/(x1-x0)*(x-x0)+y0d;
ydh2=(y1d-y0d)/(x1-x0)*(xs-x0)+y0d;
%clg

figure(1)
plot(x,y);
xlabel('x-Wert')
xlabel('y-Wert')
title('2 Polynome n=2');
grid on
hold on
figure(2)
plot(x,[yd,ydh1]);
xlabel('x-Wert')
xlabel('dy/dx-Wert')
title('2 Polynome n=2');
grid on
hold on
delta=ydh2-yds
