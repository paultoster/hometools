%polynom3.m

% TZB Berthold 3052 4/98

disp(' ')
disp(' Zeigt Polynom n=3 ' )
disp(' ')
disp(' y = f(x) = a0+a1*x+a2*x^2+a3*x^3')
disp(' ')
disp(' wobei der Punkt x0=0,y0=0 festliegt')
disp(' der Punkt x1,y1 ist als Variable im M-File definiert')
disp(' alpha0 gibt die Steigung im Punkt 0 an (Eingabeparameter)')
disp(' alpha1 gibt die Steigung im Punkt 1 an (Eingabeparameter)')
disp(' alpha0=alpha1=1 bedeutet lineare Verlauf zw. Punkt 0 und 1')
disp(' Siehe ../HilfeText/symbolic.txt')
%
%
disp('Feste Parameter :')
x1 = 65
y1 = 140
disp('Eingabeparameter :')
disp(' ')
alpha0=input('alpha0 = ');
alpha1=input('alpha1 = ');
%
%
x=[0:x1/100:x1]';

a0 = 0;

a1 = alpha0*y1/x1;

a2 = (3-2*alpha0-alpha1)*y1/x1/x1;

a3 = (alpha0+alpha1-2)*y1/x1/x1/x1; 

y = a0+x.*(a1+x.*(a2+x*a3));


%lg

plot(x,y),hold on,grid on
