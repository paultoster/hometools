function [s,x,y,theta,kappa] = calc_curvature_2_vec(ds_kappa,ds,x0,y0,theta0)
%
% [s,x,y,theta,kappa] = calc_curvature_2_vec(ds_kappa,ds,x0,y0,theta0)
%
% oder
%
% s                   = calc_curvature_2_vec(ds_kappa,ds,x0,y0,theta0)
%
% mit s.s,s.x,s.y,s.theta,s.kappa
%
%   ds_kappa = {{'gerade', s, delta_s_uebergang} ...
%              ,{'ugerade', s, delta_s_uebergang} ... Ubergangsgerade auch sanft
%              ,{'kurve',  theta, delta_s_uebergang, kappa} ...
%              ,{'skurve',  theta, delta_s_uebergang, kappa} ...  % sanfter Übergang
%              ,{'nsin', nsinus, dx_sinus,dy_sinus, delta_s_vor} ...
%              }; 
%
%  'gerade':    s                       [m] Länge der Gerade
%               delta_s_uebergang       [m] Länge des Übergangs am Anfang,
%                                           linear von Krümmung des
%                                           Vorgängers auf Krümmung null
%                                           für Gerade zu kommen
%  'kurve':    theta                    [rad] Winkelbereich für den
%                                             Kreisbogen mit vorgegeber Krümmung
%                                             
%               delta_s_uebergang       [m]   Länge des Übergangs am Anfang,
%                                             linear von Krümmung des
%                                             Vorgängers auf vorgegebene
%                                             Krümmung für den Kreisbogen
%               kappa                   [1/m] Krümmung des Kreisbogens
%
%  'skurve':    theta                    [rad] Winkelbereich für den
%                                             Kreisbogen mit vorgegeber Krümmung
%                                             
%               delta_s_uebergang       [m]   Länge des Übergangs am Anfang,
%                                             linear von Krümmung des
%                                             Vorgängers auf vorgegebene
%                                             Krümmung für den Kreisbogen
%               kappa                   [1/m] Krümmung des Kreisbogens
%  'nsin':     nsinus                   [-]   Anzahl der Sinuswellen
%              dx_sinus                 [m]   Länge einer Sinusschwingung
%              dy_sinus                 [m]   Amplitude des Sinus
%              delta_s_vor              [m]   Vorlauflänge die benutzt wird 
%                                             um von der Krümmung des Vorgängerstücks
%                                             auf die Krümmung im ersten
%                                             Scheitelpunkt des Sinus zu
%                                             kommen
  n = length(ds_kappa);
  
  s     = 0.0;
  x     = x0;
  y     = y0;
  theta = theta0;
  kappa = 0.0;
  ns = 1;
  
  for i=1:n
    type = ds_kappa{i}{1};
    if( type(1) == 'g' ) % 'gerade'
      deltas = ds_kappa{i}{2};
      ssin   = ds_kappa{i}{3};
      s0     = s(ns);
      theta0 = theta(ns);
      nkappa = max(1,floor(ssin/ds));
      dkappa = (0.0-kappa(ns))/nkappa;
      while( (s(ns) < s0+ssin) )
        ns = ns + 1;
        s(ns)     = s(ns-1)+ds;
        kappa(ns) = kappa(ns-1)+dkappa;
        theta(ns) = theta(ns-1) +  kappa(ns)*ds;
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
        
      end
      while( s(ns) < s0+deltas )
        ns        = ns+1;
        s(ns)     = s(ns-1)+ds;
        kappa(ns) = 0.0;
        theta(ns) = theta(ns-1);
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
      end
    elseif( type(1) == 'u' ) % 'gerade'
      deltas = ds_kappa{i}{2};
      ssin   = ds_kappa{i}{3};
      s0     = s(ns);
      theta0 = theta(ns);
      nkappa = max(1,floor(ssin/ds));
      svec    = [0.:ds:ssin]';
      kappavec = step_function(svec,0,ssin,kappa(ns),0.0);
      ikappa    = 1;
      while( (s(ns) < s0+ssin) )
        ns = ns + 1;
        ikappa = min(ikappa+1,nkappa);
        s(ns)     = s(ns-1)+ds;
        kappa(ns) = kappavec(ikappa);
        theta(ns) = theta(ns-1) +  kappa(ns)*ds;
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
        
      end
      while( s(ns) < s0+deltas )
        ns        = ns+1;
        s(ns)     = s(ns-1)+ds;
        kappa(ns) = 0.0;
        theta(ns) = theta(ns-1);
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
      end
    elseif( type(1) == 'k' ) % 'kurve'
      dtheta = ds_kappa{i}{2};
      ssin   = ds_kappa{i}{3};
      k1     = ds_kappa{i}{4};
        
      s0     = s(ns);
      theta0 = theta(ns);
      nkappa = max(1,floor(ssin/ds));
      dkappa = (k1-kappa(ns))/nkappa;
      endflag = 0;
      while( ~endflag && (s(ns) < s0+ssin) )
        ns = ns + 1;
        s(ns)     = s(ns-1)+ds;
        kappa(ns) = kappa(ns-1)+dkappa;
        theta(ns) = theta(ns-1) +  kappa(ns)*ds;
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
        
        if( abs(theta(ns) - theta0 ) >= dtheta )
          endflag = 1;
        end
      end
      while( abs(theta(ns) - theta0 ) < dtheta )
        ns = ns + 1;
        s(ns)     = s(ns-1)+ds;
        kappa(ns) = k1;
        theta(ns) = theta(ns-1) +  kappa(ns)*ds;
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
      end
    elseif( type(1) == 's' ) % 'skurve'
      dtheta = ds_kappa{i}{2};
      ssin   = ds_kappa{i}{3};
      k1     = ds_kappa{i}{4};
        
      s0     = s(ns);
      theta0 = theta(ns);
      nkappa = max(1,floor(ssin/ds));
      endflag = 0;
      svec    = [0.:ds:ssin]';
      kappavec = step_function(svec,0,ssin,kappa(ns),k1);
      ikappa    = 1;
      while( ~endflag && (s(ns) < s0+ssin) )
        ns = ns + 1;
        ikappa = min(ikappa+1,nkappa);
        s(ns)     = s(ns-1)+ds;
        kappa(ns) = kappavec(ikappa);
        theta(ns) = theta(ns-1) +  kappa(ns)*ds;
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
        
        if( abs(theta(ns) - theta0 ) >= dtheta )
          endflag = 1;
        end
      end
      while( abs(theta(ns) - theta0 ) < dtheta )
        ns = ns + 1;
        s(ns)     = s(ns-1)+ds;
        kappa(ns) = k1;
        theta(ns) = theta(ns-1) +  kappa(ns)*ds;
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
      end
    elseif( type(1) == 'n' ) % 'nsin'
      nsin   = ds_kappa{i}{2};
      x0     = ds_kappa{i}{3};
      y0     = ds_kappa{i}{4};
      svor   = ds_kappa{i}{5};
        
      s0     = s(ns);
      theta0 = theta(ns);
      
      [ss,kk] = nsinus_build_kappa_in_s(ds,nsin,tan(theta0),kappa(ns),x0,y0,svor);
      
      n = length(ss);
      
      for i=1:n
        ns        = ns+1;
        s(ns)     = s(ns-1)+ds;
        kappa(ns) = kk(i);
        theta(ns) = theta(ns-1) +  kappa(ns)*ds;
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
      end
    elseif( type(1) == 'e' )  % emcos
      xend   = ds_kappa{i}{2};
      x0     = ds_kappa{i}{3};
      y0     = ds_kappa{i}{4};
      ssin   = ds_kappa{i}{5};
        
      s0     = s(ns);
      theta0 = theta(ns);
      
      [ss,kk] = emcos_build_kappa_in_s(ds,xend,x0,y0);
      
      nkappa = max(1,floor(ssin/ds));
      deltakappa = (kk(1)-kappa(ns));
      dkappa     = deltakappa/nkappa;
      n = length(ss);
      
      for i=1:n
        ns        = ns+1;
        s(ns)     = s(ns-1)+ds;
        ii = min(i,nkappa+1);
        dk = deltakappa - dkappa*(ii-1.);
        kappa(ns) = kk(i)- dk;
        theta(ns) = theta(ns-1) +  kappa(ns)*ds;
        x(ns)     = x(ns-1)+ds*cos(theta(ns));
        y(ns)     = y(ns-1)+ds*sin(theta(ns));
      end
    end
  end
  if( nargout == 1 )
    Sout.s     = s;
    Sout.x     = x;
    Sout.y     = y;
    Sout.theta = theta;
    Sout.kappa = kappa;
    
    s = Sout;
  end
end
function [s,k] = sinus_build_kappa_in_s(ds,xend,x0,y0)
        
  dx  = ds/10;
  x   = [0.0:dx:xend]';
  y   = y0*sin(x/x0*2*pi);
  fac = 2*pi/x0;
  xx  = x*fac;
  k1  = (-fac*fac*sin(xx)*y0);
  k2  = 1+ (fac*cos(xx)*y0).^2;
  k   = k1./(k2.^1.5);
      
  ss  = 0.0;
  kk  = 0.0;
  nn = 1;
  xx0 = x(1);
  yy0 = y(1);
     
  n = length(x);
  
  for i=1:n
    
    delta = sqrt((x(i)-xx0)^2 + (y(i)-yy0)^2);
    
    if( (delta >= ds) || (i == n) )
      nn = nn+1;
      kk  = [kk;k(i)];
      ss  = [ss;ss(nn-1)+delta];
      xx0 = x(i);
      yy0 = y(i);
    end
  end
  
  n = floor(ss(nn)/ds)+1;
  s = [0:ds:ds*(n-1)]';
  k = interp1(ss,kk,s,'linear','extrap');
end
function [ss,kk] = nsinus_build_kappa_in_s(ds,n,ypstart,kappastart,dx_sinus,dy_sinus,svor)
  
  % Übergang zu Sinus
  %------------------
  ystart   = 0;
  yppstart = kappastart * (1+ypstart^2)^1.5;
  yend     = dy_sinus;
  ypend    = 0.0;
  yppend   = -4*pi*pi/dx_sinus/dx_sinus*dy_sinus;
  
  p   = polynom_approx_bound_5(0.0,ystart,ypstart,yppstart,svor,yend,ypend,yppend);
  pp  = polyder(p);
  ppp = polyder(pp);
  
  dx   = ds/100;
  x    = [0.0:dx:svor]';
  y    = polyval(p,x);
  yp   = polyval(pp,x);
  ypp  = polyval(ppp,x);
  k2  = 1+ (yp).^2;
  k   = ypp./(k2.^1.5);
  
  [ss1,kk1] = kappa_xy_in_s(x,y,k,ds);
  n1        = length(ss1);
    
  % n mal Sinus
  %------------
  x   = [0.0:dx:dx_sinus*n]';
  fac = 2*pi/dx_sinus;
  xx  = x*fac;
  
  y   = dy_sinus*sin(xx+pi/2.);
  yp  = dy_sinus*fac*cos(xx+pi/2.);
  ypp = -dy_sinus*fac*fac*sin(xx+pi/2.);
  k2  = 1+ (yp).^2;
  k   = ypp./(k2.^1.5);
  [ss2,kk2] = kappa_xy_in_s(x,y,k,ds);
  n2        = length(ss2);
  
  % Übergang aus dem Sinus
  %-----------------------
  ystart   = dy_sinus;
  ypstart  = 0.0;
  yppstart = -4*pi*pi/dx_sinus/dx_sinus*dy_sinus;
  yend     = 0.;
  ypend    = 0.0;
  yppend   = 0.0;
  
  p   = polynom_approx_bound_5(0.0,ystart,ypstart,yppstart,svor,yend,ypend,yppend);
  pp  = polyder(p);
  ppp = polyder(pp);
  
  dx   = ds/100;
  x    = [0.0:dx:svor]';
  y    = polyval(p,x);
  yp   = polyval(pp,x);
  ypp  = polyval(ppp,x);
  k2  = 1+ (yp).^2;
  k   = ypp./(k2.^1.5);
  
  [ss3,kk3] = kappa_xy_in_s(x,y,k,ds);
  n3      = length(ss3);
  
  ss      = [ss1;ss2(2:n2)+ss1(n1);ss3(2:n3)+ss1(n1)+ss2(n2)];
  kk      = [kk1;kk2(2:n2);kk3(2:n3)];
 
end
function [s,k] = emcos_build_kappa_in_s(ds,xend,x0,y0)
        
  dx  = ds/100;
  x   = [0.0:dx:xend]';
  fac = 2*pi/x0;
  xx  = x*fac;
  
  y   = 0.5*y0*(1.0-cos(xx));
  yp  = 0.5*fac*y0*sin(xx);
  ypp = 0.5*fac*fac*y0*cos(xx);
  k2  = 1+ (yp).^2;
  k   = ypp./(k2.^1.5);
      
  ss  = 0.0;
  kk  = k(1);
  nn = 1;
  xx0 = x(1);
  yy0 = y(1);
     
  n = length(x);
  
  for i=1:n
    
    delta = sqrt((x(i)-xx0)^2 + (y(i)-yy0)^2);
    
    if( (delta >= ds) || (i == n) )
      nn = nn+1;
      kk  = [kk;k(i)];
      ss  = [ss;ss(nn-1)+delta];
      xx0 = x(i);
      yy0 = y(i);
    end
  end
  
  n = floor(ss(nn)/ds)+1;
  s = [0:ds:ds*(n-1)]';
  k = interp1(ss,kk,s,'linear','extrap');
  
  % [s,alpha,k,dkappa] = path_calc_aplha_kappa(x,y,0,ds,0.01,1);
  
  
end
function   [sout,kout] = kappa_xy_in_s(x,y,k,ds)
  ss  = 0.0;
  kk  = k(1);
  nn = 1;
  xx0 = x(1);
  yy0 = y(1);
     
  n = length(x);
  
  for i=1:n
    
    delta = sqrt((x(i)-xx0)^2 + (y(i)-yy0)^2);
    
    if( (delta >= ds) || (i == n) )
      nn = nn+1;
      kk  = [kk;k(i)];
      ss  = [ss;ss(nn-1)+delta];
      xx0 = x(i);
      yy0 = y(i);
    end
  end
  
  n = floor(ss(nn)/ds)+1;
  sout = [0:ds:ds*(n-1)]';
  kout = interp1(ss,kk,sout,'linear','extrap');
end