function [xout,yout] = PosToKlothoid(x,y,delta_d)
%
% [xout,yout] = PosToKlothoid(x,y,delta_d)
% 
% Bildet die Strecke in Klothoidenform ab
% x,y in [m]
% dleta_d ist äquidistante Abstand
%
  xout = [];
  yout = [];

  n = min(length(x),length(y));
  x = x(1:n);
  y = y(1:n);

  % alle Werte rausnehmen, die kleiner delta_d sind
  d = sqrt(diff(x).^2+diff(y).^2);

  xin = x(1);
  yin = y(1);
  for i=2:n
    if( d(i-1) > delta_d )
      xin = [xin;x(i)];
      yin = [yin;y(i)];
    end
  end

  d = xin(2)-xin(1);
  while( abs(d) < eps )
    xin = xin(2:length(xin));
    yin = yin(2:length(yin));
    d   = xin(2)-xin(1);
  end

  alph0  = atan2(yin(2)-yin(1),xin(2)-xin(1));
  alphs  = 0;
  C0     = 0.;
  n      = length(xin);
  xt     = xin';
  yt     = yin';
  xk     = xt(1);
  yk     = yt(1);
  for i=1:n-1

    calph0 = cos(alph0);
    salph0 = sin(alph0);

    A      = [calph0,salph0;-salph0,calph0];
    v      = [xt;yt];
    vt     = A*v;
    xt = vt(1,:);
    yt = vt(2,:);
    dy = yt(i+1)-yt(i);
    dx = xt(i+1)-xt(i);

    vk  = [xk;yk];
    vkt = A*vk;
    xk  = vkt(1,:);
    yk  = vkt(2,:);
    nk = length(xk);

    C1 = 3.*(2*(dy)-C0*(dx)^2)/(dx)^3;

    d   = 0;
    xk0 = xk(nk);
    yk0 = yk(nk);
    while(d < dx)

      d = d + delta_d;
      e = (C0+C1*d/3.)*d*d/2.;
       
      xk = [xk,xk0+d];
      yk = [yk,yk0+e];
      nk = nk+1;
    end

    % neue werte für nächste Schleife bilden
    alphs = alphs+alph0;
    alph0 = atan((C0+C1*dx/2.)*dx);
    C0    = C0+C1*dx;
  
  end

  while( alphs > 2*pi )
    alphs = alphs-2*pi;
  end
  while( alphs < -2*pi )
    alphs = alphs+2*pi;
  end

  calph0 = cos(alphs);
  salph0 = sin(alphs);

  A    = [calph0,-salph0;salph0,calph0];
  vk   = [xk;yk];

  vkt  = A*vk;
  xout = vkt(1,:)';
  yout = vkt(2,:)';
  
  
end
    