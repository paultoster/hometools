function [xout,yout] = vek_2d_drehen(xvec,yvec,alpha,type)
%
% [xout,yout] = vek_2d_drehen(xvec,yvec,alpha[,type])
%
% Dreht Koordinatensystem auf alpha
% xvec          x-vektor
% yvec          y-vektor
% alpha         Winkel 
% type          0: (default)Dreht Koordinatensystem um alpha d.h ein Vektor von
%                  0,0 -> 1,0 und alpha = pi/2, dann ist Vektor nach unten
%                  0,0 -> 0,-1
%                  oder anders ausgedrückt: Die Kurve wird um -alpha
%                  gedreht, hat die Kurve im Ursprung einen Winkel von x
%                  deg, dann ist die Kurve im Ursprung entlang der x-Achse
%               1: Dreht Vektor um diesen Winkel d.h ein Vektor von
%                  0,0 -> 1,0 und alpha = pi/2, dann ist Vektor nach oben
%                  0,0 -> 0,1
%

  if( ~exist('type','var') )
    type = 0;
  end
  if( type )
    alpha = -alpha;
  end
  xtrans = 0;
  [n,m] = size(xvec);
  if( m > n )
    xvec = xvec';
    xtrans = 1;
  end
  ytrans = 0;
  [n,m] = size(yvec);
  if( m > n )
    yvec = yvec';
    ytrans = 1;
  end
  X = [xvec(:,1),yvec(:,1)]';
  T = [cos(alpha),sin(alpha);-sin(alpha),cos(alpha)];
  Y = T*X;

  xout = Y(1,:)';
  yout = Y(2,:)';
  if( xtrans )
    xout = xout';
  end
  if( ytrans )
    yout = yout';
  end
end