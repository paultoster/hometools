%vektorg2.m

% TZB/BFR Berthold 3052 30.08.95

disp(' Utility zur Dateneingabe über Mouse ' )
disp(' Es wird ein Achsenkreuz aufgespannt,')
disp(' indem mit mouse-klick der Wert eingegeben wird.')
%
% Gewünschte Achsenskalierung
%
clf reset
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
disp(' ')
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
% Werte eingeben
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

x = [];
y = [];
n = 0;
% Loop, picking up the points.
but = 1;
while but == 1
   [xi,yi,but] = ginput(1);
   if but == 1
     plot(xi,yi,'go','era','back') % doesn't matter what erase mode is
                                % used so long as its not NORMAL
     n = n + 1;
     text(xi,yi,[' ' int2str(n)],'era','back');
     x = [x; xi];
     y = [y; yi];
   end  
end

%disp('pause: <Enter>');pause
echo off
hold off
close

fx = xw(2)/(xb(2)-xb(1));
fy = yw(3)/(yb(3)-yb(1));

x = (x-xb(1))*fx;
y = (y-yb(1))*fy;

but = 3;
while ~(but == 0 | but == 1)
      disp(' ')
      but=input('Sollen die Werte abgespeichert werden (0=nein/1=ja) :');
      disp(' ')
end

if but == 1

   datname=input('Name der Datei Matrixx-ASCII-Format (z.B. test.saa) :','s');
   disp(' ')
   [fid, message] = fopen(datname,'w');
   if fid <= 2
      disp(message)
   else
      i=0;
      matsav(fid,' ',i,1);
      namex=input('Name für X-Vektor (z.B. xgraf) :','s');
      disp(' ')
      matsav(fid,namex,x,0);
      namey=input('Name für Y-Vektor (z.B. ygraf) :','s');
      disp(' ')
      matsav(fid,namey,y,0);
   end   
   fclose(fid);
end   
disp('End')
