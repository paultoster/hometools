function [xvec,yvec,alphavec,kappavec,dsvec,nvec,kappamax] = ...
  vek_2d_polynom(xp,yp,alphap,kappap,i0, i1,type,nnew,dxmin,fac)
%
% Polynomberechnung
% [xvec,yvec,alphavec,kappavec,dsvec,nvec,kappamax] = vek_2d_polynom(xp,yp,alphap,kappap,i0, i1,type,nnew,dxmin,fac)
% 
% Es wird ein Polynom 3. Ord (type=1) Mit x0,y0,alpha0,x1,y1,alpha1 bzw. 3. Ord (type=2) Mit x0,y0,alpha0,kappa0,x1,y1,alpha1 berechnet
% type=1 soll für Stücke mit nur zwei Punkten benutzt werden, type = 3 für Enstücke mit aktuellem Lenkwinkel
% Dabei werden die übergebenen Punkte auf die x-Achse gedreht (mit alpha0) damit y=f(x) funktioniert
% Wenn aber der Abstand kleiner 2*dxmin ist werden die zwei Punkte zurückgegeben
% und wenn alpha1-alpha0 > 90° dann werden Bezierkurven verwendet da nicht mehr mit Polynom 3. oder 4. Ordnung abzubilden
% 
% xp(i0),xp(i1)                          Anfangspunkt, Endpunkt
% yp(i0),yp(i1)
% alphap(i0),alphap(i1)
% kappap(i0),kappap(i1)
%
% i0                                      erster Index
% i1                                      zweiter Index
% type                                    1:  Polynom 3. Ordnung mit x0,y0,alpha0,x1,y1,alpha1
%                                         2:  Polynom 4. Ordnung mit x0,y0,alpha0,kappa0,x1,y1,alpha1
%                                         3:  Polynom 4. Ordnung mit x0,y0,alpha0,x1,y1,alpha1,kappa1 = 0
%                                         4:  Polynom 5. Ordnung mit x0,y0,alpha0,kappa0,x1,y1,alpha1,kappa1=0
% nnew                                    Anzahl der neuen Punkte
% dxmin                                   minimaler Abstand (erst mal auf x.Achse
% fac                                     Verlängerung des Polynoms
% 
% Rückgabe:
% xvec,yvec,alphavec,kappavec,dsvec,nvec,kappamax
% xvec(i=1 ... nvec)                      n-Punkte
% yvec(i=1 ... nvec)
% alphavec(i=1 ... nvec)
% kappavec(i=1 ... nvec)
% dsvec(i=1 ... nvec)
% nvec                                    Anzahl der Punkte entsprechend nnew
% kappamax                                 maximal berechnetes kappa absolut
%
% in C:
% Vek2DPolynom(hlpfu_float_t *px,hlpfu_float_t *py,hlpfu_num_points_t *pn,hlpfu_num_points_t ndim,hlpfu_float_t *palpha0,hlpfu_float_t *palpha1,hlpfu_float_t *kappa0,uchar type,hlpfu_num_points_t nnew,hlpfu_float_t dxmin)

  DS_BEZIER = 1;
  
  xoffset = xp(i0);
  yoffset = yp(i0);

  alpha0   = vek_2d_yaw_reduce_to_pi(alphap(i0));
  alpha1   = vek_2d_yaw_reduce_to_pi(alphap(i1));

  calpha0  = cos(alpha0);
  salpha0  = sin(alpha0);
  dalpha   = alpha1-alpha0;
  cdalpha  = cos(dalpha);
  sdalpha  = sin(dalpha);

  % x-y Drehen und offset
  
  x0 =  calpha0 * (xp(i0)-xoffset) + salpha0 * (yp(i0)-yoffset);
  y0 = -salpha0 * (xp(i0)-xoffset) + calpha0 * (yp(i0)-yoffset);
  xp(i0) = x0;
  yp(i0) = y0;
  
  x1 =  calpha0 * (xp(i1)-xoffset) + salpha0 * (yp(i1)-yoffset);
  y1 = -salpha0 * (xp(i1)-xoffset) + calpha0 * (yp(i1)-yoffset);
  xp(i1) = x1;
  yp(i1) = y1;
  

  % Maximale/Minimale Anzahl
  %-------------------------
  if( nnew < 2 ) 
    nnew = 2;
  end
  d = xp(i1) * xp(i1) + yp(i1) * yp(i1);   % quadratischer Abstand x0=y0=0
  d1 = (2*dxmin)^2;
  
  xvec = zeros(nnew,1);
  yvec = zeros(nnew,1);
  alphavec = zeros(nnew,1);
  kappavec = zeros(nnew,1);
  dsvec = zeros(nnew,1);
  
  if( d < d1 ) % zu kleiner Abstand
  
    xp0 = xp(i0);
    yp0 = yp(i0);
    xp1 = xp(i1);
    yp1 = yp(i1);
    nnew  = 2;

    % alpha
    dx = xp1-xp0;
    dy = yp1-yp0;
    alphap0 = atan2(dy,dx);
    alphap1 = alphap0;

    kappap0 = 0;
    kappap1 = 0;
  
  elseif( abs(dalpha) > pi/2. )          % geht über ein Qudrant hinaus, keine Funktion möglich
  
    % Bezierkurve
    x0  = xp(i0);
    y0  = yp(i0);
    x01 = xp(i0) + DS_BEZIER; 
    y01 = yp(i0); 
    x1  = xp(i1);
    y1  = yp(i1);
    x11 = xp(i1) + DS_BEZIER * cdalpha; 
    y11 = yp(i1) + DS_BEZIER * sdalpha;
    
    d1 = fac/(nnew-1);
    for i=1:nnew
    
      d = d1 * (i-1);
      % g = z*(z*(z*a0+b0)+c0)+d0
      g0 = d*(d*(d-(1))-(1))+(1);
      g1 = d*(d*(d-(2))+(1));
      g2 = d*d*(d*(-3)+(4));
      g3 = d*d*(d-(1));
      
      xvec(i)  = x0*g0+x01*g1+x1*g2+x11*g3;
      yvec(i)  = y0*g0+y01*g1+y1*g2+y11*g3;
    end
    
    % alpha, kappa
    for i=1:nnew
    
      d = d1 * (i-1);
      % g = z*(z*a0+b0)+c0
      g0 = d*((3)*d-(2))-(1);
      g1 = d*((3)*d-(4))+(1);
      g2 = d*((-9)*d+(8));
      g3 = d*((3)*d-(2));
      % f = z*a0+b0
      f0 = (6)*d-(2);
      f1 = (6)*d-(4);
      f2 = (-18)*d+(8);
      f3 = (6)*d-(2);
      
      dx  = x0*g0+x01*g1+x1*g2+x11*g3;
      dy  = y0*g0+y01*g1+y1*g2+y11*g3;
      dxx = x0*f0+x01*f1+x1*f2+x11*f3;
      dyy = y0*f0+y01*f1+y1*f2+y11*f3;
      
      alphavec(i) = atan2(dy,dx);

      kappavec(i) = dyy;
    end
  
  else
  
    % Punkte festlegen 
    d1 = xp(i1)*fac;
    d = d1 / ((nnew-1));
    if( abs(d) < dxmin )
    
      nnew = ceil( abs(xp(i1))/dxmin )+1;
      if( nnew < 2 )
      
        nnew = 2;
        d    = d1;
      
      else
      
        d   = dxmin * sign(xp(i1));
      end
    end

    if( type == 1 )                                     % Polynom 3. Ordnung
    
      m1 = sdalpha/cdalpha;
      a3 = (m1 - (2) * yp(i1)/xp(i1))/xp(i1)/xp(i1);    % a3
      a2 = ((3) * yp(i1)/xp(i1) - m1)/x;            % a2
      
      
      for i = 1:nnew
      
        if( i < (nnew) ) 
          x0 = d * (i-1);
        else
          x0 = d1;
        end
        
        yvec(i)     = x0*x0*(a3*x0+a2);
        xvec(i)     = x0;

        dy        = x0*((3)*a3*x0+(2)*a2);
        dyy       = (6)*a3*x0+(2)*a2;

        alphavec(i) = atan(dy);
        kappavec(i) = dyy;

       
        
      end
    
    elseif( type == 2 )                      % Polynom 4. Ordnung
    
      m1 = sdalpha/cdalpha;
      a4  = (((((-3) * yp(i1)/xp(i1)) + m1)/xp(i1)) + kappap(i0)/(2))/xp(i1)/xp(i1);   % a4
      a3  = (((((4) * yp(i1)/xp(i1)) - m1)/xp(i1)) - kappap(i0))/xp(i1);               % a3
      a2  = kappap(i0)/(2);                                                            % a2
            
      for i = 1:nnew
      
        if( i < (nnew) ) 
          x0 = d * (i-1);
        else
          x0 = d1;
        end
        
        yvec(i)     = x0*x0*(x0*(a4*x0+a3)+a2);
        xvec(i)     = x0;

        dy        = x0*(x0*((4)*a4*x0+(3)*a3)+(2)*a2);
        dyy       = x0*((12)*a4*x0+(6)*a3)+(2)*a2;

        alphavec(i) = atan(dy);
        kappavec(i) = dyy;
        
      end
    
    elseif( type == 3 )                      % Polynom 4. Ordnung kappa1 = 0
    
      y1p = sdalpha/cdalpha;
      x1h2 = xp(i1)*xp(i1);
      a4  = ((3)*yp(i1)  - (2)*xp(i1)*y1p)/x1h2/x1h2;
      a3  = -((8)*yp(i1) - (5)*xp(i1)*y1p)/x1h2/xp(i1);
      a2  = ((6)*yp(i1)  - (3)*xp(i1)*y1p)/x1h2;                                                                       % a2
         
      for i = 1:nnew
      
        if( i < (nnew) ) 
          x0 = d * (i-1);
        else
          x0 = d1;
        end
        
        yvec(i)     = x0*x0*(x0*(a4*x0+a3)+a2);
        xvec(i)     = x0;

        dy        = x0*(x0*((4)*a4*x0+(3)*a3)+(2)*a2);
        dyy       = x0*((12)*a4*x0+(6)*a3)+(2)*a2;

        alphavec(i) = atan(dy);
        kappavec(i) = dyy;
        
      end
      
      
      
        x0               = d1*fac;
        yvec(nnew+1)     = yvec(nnew) + dy * (x0-xvec(nnew));
        xvec(nnew+1)     = x0;
        alphavec(nnew+1) = alphavec(nnew);
        kappavec(nnew+1) = (0);
        nnew = nnew+1;
        dsvec = zeros(nnew,1);
      
    
    else                                  % Polynom 5. Ordnung kappa1=0 
    
      yp1    = sdalpha/cdalpha;
      x1h3m2 = xp(i1)*xp(i1)*xp(i1)*(2);
      f1     = xp(i1)*yp1;
      f2     = kappap(i0)*xp(i1)*xp(i1);
      a5     = -((6)*f1 - (12)*yp(i1) + f2)/x1h3m2/xp(i1)/xp(i1);   % a5
      a4     = ((14)*f1 - (30)*yp(i1) + (3)*f2)/x1h3m2/xp(i1);      % a4
      a3     = -((8)*f1 - (20)*yp(i1) + (3)*f2)/x1h3m2;             % a3
      a2     = kappap(i0)/(2);                                      % a2
      
      for i = 1:nnew
      
        if( i < (nnew) ) 
          x0 = d * (i-1);
        else
          x0 = d1;
        end
        
        yvec(i)     = x0*x0*(x0*(x0*(a5*x0+a4)+a3)+a2);
        xvec(i)     = x0;

        dy        = x0*(x0*(x0*((5)*a5*x0+(4)*a4)+(3)*a3)+(2)*a2);
        dyy       = x0*(x0*((20)*a5*x0+(12)*a4)+(6)*a3)+(2)*a2;

        alphavec(i) = atan(dy);
        kappavec(i) = dyy;
        
      end
      
      
      x0               = d1*fac;
      yvec(nnew+1)     = yvec(nnew) + dy * (x0-xvec(nnew));
      xvec(nnew+1)     = x0;
      alphavec(nnew+1) = alphavec(nnew);
      kappavec(nnew+1) = (0);
      nnew = nnew+1;
      dsvec = zeros(nnew,1);
    end
  end
  
  % x-y Drehen und offset
  kappamax = (0);
  for  i=1:nnew
  
    x0 =  calpha0 * (xvec(i)) - salpha0 * (yvec(i));
    y0 =  salpha0 * (xvec(i)) + calpha0 * (yvec(i));
    
    xvec(i) = x0+xoffset;
    yvec(i) = y0+yoffset;

    % Berechnung kappa
    dy = tan(alphavec(i));
    dy = sqrt(((1)+dy*dy));
    dy = dy * dy * dy;
    kappavec(i) = kappavec(i) / not_zero(dy);

    if( abs(kappavec(i)) > kappamax ) 
      kappamax = abs(kappavec(i));
    end

    alphavec(i) = alphavec(i) + alpha0; 

    if( i > 1)
    
      x0 = xvec(i) - xvec(i-1);
      y0 = yvec(i) - yvec(i-1);

      dsvec(i-1) = not_zero(sqrt(x0*x0+y0*y0));
    end
  end
  dsvec(nnew) = dsvec(nnew-1);
  nvec = nnew;
end
