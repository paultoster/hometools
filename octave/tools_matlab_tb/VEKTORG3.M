%vektorg3.m

% TZB/BFR Berthold 3052 30.08.95

disp(' Utility zur Dateneingabe über Mouse ' )
disp(' Es wird ein Achsenkreuz aufgespannt,')
disp(' indem mit mouse-klick der Wert eingegeben wird.')
disp(' Es koennen meherere Kurven eingegeben werden.')
disp(' Die einzelnen Kurven koennen auf den ersten eigegebenen')
disp(' x-Vektor ueber spline skaliert werden.')
disp(' Die Kurven werden in Matrixx-Format gespeichert.')

clf reset
i=0;
%
% Kurvenzahl und Datei
%
datname=input('Name der Datei Matrixx-ASCII-Format (z.B. test.saa) :','s');
[fid, message] = fopen(datname,'w');
if fid <= 2
   disp(message)
   return
else
   matsav(fid,' ',i,1);
   disp(' ')
   nkurv  = input('Wieviele Kurven sollen aus dem Diagramm aufgenommen werden ? :');
   if nkurv <= 0
     nkurv = 1;
   end
end   
   
disp(' ')
if nkurv > 1  
   disp('Sollen alle Kurve auf díe 1. x-Koordinateneingabe skaliert werden ?')
   interpol= input('(j/n) :','s');
   if interpol == 'j'
      interpol = 1;
   elseif interpol == 'J'
      interpol = 1;
   elseif interpol == 'y'
      interpol = 1;
   elseif interpol == 'Y'
      interpol = 1;
   else
      interpol = 0;
   end
else
    interpol = 0;
end
%
% Gewünschte Achsenskalierung
%
axis([0 1 0 1]);grid on 
hold on
disp(' Vorgehen:')
disp(' 1) Folie mit Diagramm auf Bildschirm aufkleben')
disp(' 2) Achsen skalieren: ')
%
% picking up x1 y1 .
%
xb=ones(3,1);
yb=ones(3,1);

disp(' ')
disp('    - Nullpunkt auf Foliendiagramm anklicken')
disp(' ')
[xb(1),yb(1)] = ginput(1);
plot(xb(1),yb(1),'ro','era','back');

disp(' ')
disp('    - beliebiges x1 auf Foliendiagramm x-Achse anklicken')
disp(' ');
[xb(2),yb(2)] = ginput(1);
plot(xb(2),yb(2),'r+','era','back');
text(xb(2),yb(2),' x1','era','back');

disp(' ')
disp('    - beliebiges y1 auf Foliendiagramm y-Achse anklicken')
disp(' ')
[xb(3),yb(3)] = ginput(1);
plot(xb(3),yb(3),'r+','era','back');
text(xb(3),yb(3),' y1','era','back');

%
% Skalierwerte eingeben
%
disp(' 3) Achsenwerte x1 y1 eingeben ')
disp(' ')
xw=ones(3,1);
yw=ones(3,1);

xw(1) = 0.;
yw(1) = 0.;
xw(2) = input('x1 = ');
yw(2) = 0.;
yw(3) = input('y1 = ');
xw(3) = 0.;

disp(' 4) Werte eingeben')
disp(' ')
disp('    - Mouse in das Diagramm führen !            ')
disp('    - Mit linker Mousetase Punkt auswählen      ')
disp('    - Mit rechter Mousetaste oder keyboardtaste beenden,')
disp('      wobei Cursor im Diagramm sein muß')

for i=1:nkurv
  x = [];
  y = [];
  n = 0;
  
  disp(' ')
  disp('Kurve Nr.:');disp(i);

  but = 1;
  while but == 1
     [xi,yi,but] = ginput(1);
     if but == 1
       plot(xi,yi,'go','era','back') 
       n = n + 1;
       text(xi,yi,[' ' int2str(n)],'era','back');
       x = [x; xi];
       y = [y; yi];
     end  
  end


  fx = xw(2)/(xb(2)-xb(1));
  fy = yw(3)/(yb(3)-yb(1));

  x = (x-xb(1))*fx;
  y = (y-yb(1))*fy;

  if interpol == 1

     if i == 1
        xint  = x;
        nint  = n;
        namex = input('Name für X-Vektor (z.B. xgraf) :','s'); 
        matsav(fid,namex,x,0);
     else
        if xint(1) < x(1)
           yint = y(1) + (y(2)-y(1))/(x(2)-x(1))*(xint(1)-x(1));
           x = [xint(1) x']';
           y = [yint y']';
        end
        if xint(nint) > x(n)
           yint = y(n) + (y(n)-y(n-1))/(x(n)-x(n-1))*(xint(nint)-x(n));
           x = [x' xint(nint)]';
           y = [y' yint]';
        end      
        y = interp1(x,y,xint,'linear');
     end
     
  end

  namey=input('Name für Y-Vektor (z.B. ygraf) :','s');
  disp(' ')
  matsav(fid,namey,y,0);

end     

echo off
hold off
close

fclose(fid);
disp('End')
