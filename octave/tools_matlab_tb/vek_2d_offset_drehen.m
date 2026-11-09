function [xout,yout] = vek_2d_offset_drehen(xvec,yvec,x0,y0,alpha,typedreh,typeoffset)
%
% [xout,yout] = vek_2d_offset_drehen(xvec,yvec,x0,y0,alpha[,typedreh])
%
% Zieht x0,y0 ab und dreht auf alpha
% Wenn typeoffset = 1, dann wird der Offset wieder draufgerechnet
%
% xvec          x-vektor
% yvec          y-vektor
% x0,y0         Offset-werte
% alpha         Winkel 
% drehtype      0: (default)Dreht Koordinatensystem um alpha d.h ein Vektor von
%                  0,0 -> 1,0 und alpha = pi/2, dann ist Vektor nach unten
%                  0,0 -> 0,-1
%                  oder anders ausgedrückt: Die Kurve wird um -alpha
%                  gedreht, hat die Kurve im Ursprung einen Winkel von x
%                  deg, dann ist die Kurve im Ursprung entlang der x-Achse
%               1: Dreht Vektor um diesen Winkel d.h ein Vektor von
%                  0,0 -> 1,0 und alpha = pi/2, dann ist Vektor nach oben
%                  0,0 -> 0,1
% offsettype    0: Der Offset wird vor drehen abgezogen (default)
%               1: Der Offset wird vor drehen abgezogen uns nach drehen
%               wieder addiert
%

  if( ~exist('typedreh','var') )
    typedreh = 0;
  end
  if( ~exist('typeoffset','var') )
    typeoffset = 0;
  end
  
  [xout,yout] = vek_2d_drehen(xvec-x0(1),yvec-y0(1),alpha,typedreh);
  
  if( typeoffset )
    xout = xout + x0(1);
    yout = yout + y0(1);
  end
end