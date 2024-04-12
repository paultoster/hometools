%polynom3.m

% TZB Berthold 3052 4/98

disp(' ')
disp(' Zeigt Polynome aus Bezier mit 3 Punkten ' )
disp(' wobei der dritte Punkt xs,ys aus den Steigungen y0d und y1d in')
disp(' den Punkten x0,y0, und x1,y1 berechnet wird')
%
disp('Feste Parameter :')
x0 = 0
y0 = 0
x1 = 10
y1 = 100
yd = (y1-y0)/(x1-x0);
disp('Eingabeparameter :')
yd
y0d=input('y0d = ');
y1d=input('y1d = ');
%
%
if x1 <= x0
  disp(' [x0,x1]')
  [x0,x1]
  disp(' Fehler: x1 <= x0')
elseif sign(y0d*y1d*yd)*sign(yd) < 0
  disp(' [yd,y0d,y1d]')
  [yd,y0d,y1d]
  disp(' Fehler: Vorzeichen Steigung yd=(y1-y0)/(x1-x0) != y0d != y1d')
elseif sign((yd-y0)*(y1-yd)) < 0
  disp(' [yd,y0d,y1d]')
  [yd,y0d,y1d]
  disp(' Fehler: Diese steigungen können nicht realisiert werden')
else
  EPS = 1e-10;
  D = y1d - y0d;

  if abs(D) < EPS
    xs = x1;
    ys = y1;
  else
    xs = (y0-x0*y0d-y1+x1*y1d)/D;
    ys = y0d*(xs-x0)+y0;
  end

  E = 2*xs-x0-x1;

  if abs(E) < EPS
    B1 = -x0/(x1-x0);
    B2 = 1/(x1-x0);
    B3 = 0;
    B4 = 0;
    B5 = 0;
  else
    B1 = (xs-x0)/E;
    B2 = 0;
    B3 = -sign(E);
    B4 = (xs^2-x0*x1)/E/E;
    B5 = -1/E;
  end
  
  x=[x0:(x1-x0)/100:x1]';
  
  B = B1 + B2*x + B3 * sqrt( B4 + B5*x );
  
  y = y0*(1-B).*(1-B) + y1*B.*B + ys*2*B.*(1-B);
  
  xhilf=[x0,xs,x1]';
  yhilf=[y0,ys,y1]';
  
  figure(1)
  plot(x,y,xhilf,yhilf);
  xlabel('x-Wert')
  ylabel('y-Wert')
  title('Bezier n=3');
  grid on
  hold on
end
