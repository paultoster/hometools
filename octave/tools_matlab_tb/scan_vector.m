function err = scan_vector
%scan_vector.m
% TZB/BFR Berthold 3052 08.12.95
% aus vektorg3.m 
%
% err = scan_vector
%
%' Utility zur Dateneingabe über Mouse ' )
%' Es wird ein Achsenkreuz aufgespannt,')
%' indem mit mouse-klick der Wert eingegeben wird.')
%' Es koennen meherere Kurven eingegeben werden.')
%' Die einzelnen Kurven koennen auf den ersten eigegebenen')
%' x-Vektor ueber spline skaliert werden.')
%' Die Kurven werden in Dia-Format gespeichert.')
%' ')

disp(' Utility zur Dateneingabe über Mouse ' )
disp(' Es wird ein Achsenkreuz aufgespannt,')
disp(' indem mit mouse-klick der Wert eingegeben wird.')
disp(' Es koennen meherere Kurven eingegeben werden.')
disp(' Die einzelnen Kurven koennen auf den ersten eigegebenen')
disp(' x-Vektor ueber spline skaliert werden.')
disp(' Die Kurven werden in Dia-Format gespeichert.')
disp(' ')

i=0;
s_d_scvec = [];
s_u_scvec = [];
interpol = 0;
%
% Kurvenzahl und Datei
%
datname=input('Name der Datei Dia-ASCII-Format (z.B. test) :','s');

nkurv  = input('Wieviele Kurven sollen aus dem Diagramm aufgenommen werden ? :');
if nkurv <= 0
     nkurv = 1;
end   
   
disp(' ')
if nkurv > 1  
   disp('Sollen alle Kurve auf díe 1. x-Koordinateneingabe skaliert werden ?')
   interpol= input('(j/n) :','s');
   if( interpol == 'j' | interpol == 'J' ...
     | interpol == 'y' |  interpol == 'Y')
      interpol = 1;
   else
      interpol = 0;
   end    
end
disp('Sollen Einheiten zugeordnet werden ')
unit_flag = input('(j/n) :','s');
if( unit_flag(1) == 'j' | unit_flag(1) == 'J' ...
  | unit_flag(1) == 'y' |  unit_flag(1) == 'Y')
      unit_flag = 1;
else
      unit_flag = 0;
end    
%
% Gewünschte Achsenskalierung
%
figure
axis([0 1 0 1]);grid on 
hold on
disp(' Vorgehen:')
disp(' 1) Folie mit Diagramm auf Bildschirm aufkleben und Diagramm in die richtige Größe ziehen')
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
text(xb(2),yb(2),' 0','era','back');

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

xw(1) = input('x0 = ');
yw(1) = input('y0 = ');;
xw(2) = input('x1 = ');
yw(2) = yw(1);
xw(3) = xw(1);
yw(3) = input('y1 = ');

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

  if( (interpol == 0)  ...
    | (i == 1 & interpol == 1) ...
    )
        xint  = x;
        nint  = n;
        namex = input('Name für X-Vektor (z.B. xgraf) :','s');
        s_d_scvec = setfield(s_d_scvec,namex,x);
        if( unit_flag )
            nameu = input('Einheit für X-Vektor (z.B. s) :','s');
            s_u_scvec = setfield(s_u_scvec,namex,nameu);
        end
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

  namey=input('Name für Y-Vektor (z.B. ygraf) :','s');
  s_d_scvec = setfield(s_d_scvec,namey,y);
  if( unit_flag )
      nameu = input('Einheit für Y-Vektor (z.B. m/s) :','s');
      s_u_scvec = setfield(s_u_scvec,namey,nameu);
  end
  disp(' ')

end     

if( unit_flag )
    diasave(s_d_scvec,s_u_scvec,datname);
else
    diasave(s_d_scvec,datname);
end
echo off
hold off
close
disp('End')
