function [scan_x,scan_y] = scan_daten_einlesen_kurve_lesen(h_fig)
%
% [scan_x,scan_y] = scan_daten_einlesen_scan(h_fig)
% f_fig         bereits erstellte Figure mit dem Bild zum abscannen einer
%               Kurve
% scan_x        Vektor mit x-Werten
% scan_y        Vektor mit y-Werten
figure(h_fig);

%
% Gewünschte Achsenskalierung
%
disp(' Vorgehen:')
disp(' 1) Achsen skalieren: ')
%
% picking up x1 y1 .
%
scan_xb=ones(3,1);
scan_yb=ones(3,1);

disp(' ')
disp('    - Achsenkreuz auf Scandiagramm anklicken')
disp(' ')
[scan_xb(1),scan_yb(1)] = ginput(1);
plot(scan_xb(1),scan_yb(1),'ro','era','back');
text(scan_xb(1),scan_yb(1),' 0','era','back');

disp(' ')
disp('    - beliebiges x1 auf Scandiagramm scan_x-Achse anklicken')
disp(' ');
[scan_xb(2),scan_yb(2)] = ginput(1);
plot(scan_xb(2),scan_yb(2),'r+','era','back');
text(scan_xb(2),scan_yb(2),' x1','era','back');

disp(' ')
disp('    - beliebiges y1 auf Scandiagramm scan_y-Achse anklicken')
disp(' ')
[scan_xb(3),scan_yb(3)] = ginput(1);
plot(scan_xb(3),scan_yb(3),'r+','era','back');
text(scan_xb(3),scan_yb(3),' y1','era','back');

%
% Skalierwerte eingeben
%
disp(' 3) Achsenwerte x1 y1 eingeben ')
disp(' ')
scan_xw=ones(3,1);
scan_yw=ones(3,1);

scan_xw(1) = input('x0 = ');
scan_xw(2) = input('x1 = ');
scan_xw(3) = scan_xw(1);
scan_yw(1) = input('y0 = ');
scan_yw(2) = scan_yw(1);
scan_yw(3) = input('y1 = ');

scan_mx = (scan_xw(2)-scan_xw(1))/(scan_xb(2)-scan_xb(1));
scan_my = (scan_yw(3)-scan_yw(1))/(scan_yb(3)-scan_yb(1));

scan_bx = scan_xw(1) - scan_xb(1) * scan_mx;
scan_by = scan_yw(1) - scan_yb(1) * scan_my;

disp(' ')
scan_closed_graf = input('Soll Kurve geschlossen werden? (j/n) [def:n] :','s');
if( length(scan_closed_graf) == 0 )
  scan_closed_graf = 'n';
end

disp(' 4) Werte eingeben')
disp(' ')
disp('    - Mouse in das Diagramm führen !            ')
disp('    - Mit linker Mousetase Punkt auswählen      ')
disp('    - Mit rechter Mousetaste oder keyboardtaste beenden,')
disp('      wobei Cursor im Diagramm sein muß')

scan_x = [];
scan_y = [];
scan_n = 0;


if( scan_closed_graf(1) == 'j' | scan_closed_graf(1) == 'J' ...
| scan_closed_graf(1) == 'y' |  scan_closed_graf(1) == 'y')

scan_closed_graf = 1;
else
scan_closed_graf = 0;
end

scan_but = 1;
while scan_but == 1
 [scan_xi,scan_yi,scan_but] = ginput(1);
 if scan_but == 1
   plot(scan_xi,scan_yi,'go','era','back') 
   scan_n = scan_n + 1;
   text(scan_xi,scan_yi,[' ' int2str(scan_n)],'era','back');
   scan_x = [scan_x; scan_xi];
   scan_y = [scan_y; scan_yi];
 end  
end

% Graf schliessen
if( scan_closed_graf )
  scan_x = [scan_x;scan_x(1)];
  scan_y = [scan_y;scan_y(1)];
end
scan_x = scan_x*scan_mx+scan_bx;
scan_y = scan_y*scan_my+scan_by;
