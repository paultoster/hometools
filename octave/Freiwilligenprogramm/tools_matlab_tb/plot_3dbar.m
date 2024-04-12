function h = plot_3dbar(hin,x,y,z,dx,dy,color)
%
% plot_3dbar(ifd,x,y,z,dx,dy,color)
%
% Plottet in x,y,z eine 3d-Säule vertikal 
%
% hin       double      figure-Nummer (wenn null oder kleiner, dann neu
%                       erstellen)
% x         double      x-Koordinate
% y         double
% z         double
% dx        double      Breite in x-Richtung 
% dy        double      Breite in y-Richtung
% color     3x1 double  Farbe z.B [0,0,1] (siehe set_plot_standards)
%

x0 = x-dx/2;
x1 = x+dx/2;

y0 = y-dy/2;
y1 = y+dy/2;

z0 = z;
z1 = 0;

if( hin <= 0 )
    h=figure;
else
    h=figure(hin);
end

hold on
patch([x0,x1,x1,x0],[y0,y0,y0,y0],[z0,z0,z1,z1],color)
patch([x0,x0,x0,x0],[y0,y1,y1,y0],[z0,z0,z1,z1],color)
patch([x0,x1,x1,x0],[y1,y1,y1,y1],[z0,z0,z1,z1],color)
patch([x1,x1,x1,x1],[y0,y1,y1,y0],[z0,z0,z1,z1],color)
patch([x0,x1,x1,x0],[y0,y0,y1,y1],[z0,z0,z0,z0],color)
patch([x0,x1,x1,x0],[y0,y0,y1,y1],[z1,z1,z1,z1],color)
hold off