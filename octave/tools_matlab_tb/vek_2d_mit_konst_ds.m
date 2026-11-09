function [xout,yout,sout,alpha,kappa] = vek_2d_mit_konst_ds(xvec,yvec,ds)
%
% [xout,yout] = vek_2d_mit_konst_ds(xvec,yvec,ds)
%
% Bildet Vektor mit konstantem Abstand (s Weg entlang) 
% äquidistant, und bildet Steigung alpha und Krümmung kappa
%
% xvec          x-vektor
% yvec          y-vektor
% ds            konstanter Abstand zwischen den Punkten 
% s             m   Weg
% alpha         rad Steigung
% kappa         1/m Krümmung

  TypeOfCurvePreCalc = 0;

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
 
  dxvec  = diff(xvec(:,1));
  dyvec  = diff(yvec(:,1));
  dsvec  = sqrt(dxvec.*dxvec+dyvec.*dyvec);
  svec   = cumsum([0.0;dsvec]);
  
  [svec1,xvec1] = elim_nicht_monoton(svec,xvec(:,1));
  [svec1,yvec1] = elim_nicht_monoton(svec,yvec(:,1));
  
  sout   = [svec1(1):ds:svec1(length(svec1))]';
  
  xout   = interp1(svec1,xvec1,sout,'linear','extrap');
  yout   = interp1(svec1,yvec1,sout,'linear','extrap');

  n     = length(xout);
  alpha = xout*0.0;
  kappa = xout*0.0;

  for i=1:n-1      
    dx       = xout(i+1)-xout(i);
    dy       = yout(i+1)-yout(i);
    alpha(i) = atan2(dy,dx);  
  end
  alpha(n) = alpha(n-1);
 

  % curvature at Trajectory-Points 
  for i=1:n-1
  
    if( i < n-2 )
    
      Curve1  = alpha(i+1)-alpha(i);

      % Sprung von -180 zu 180
      if( Curve1 > 0.9*pi ) 
      
        Curve1  = Curve1 - 2*pi;
      % Sprung von 180 zu -180
      elseif( Curve1 < (-0.9)*pi )
      
        Curve1  = Curve1 + 2*pi;
      end
    
    else
    
      Curve1 = 0;
    end

    Curve1 = Curve1/not_zero(ds);

    if( TypeOfCurvePreCalc == 0 )
    
      kappa(i) = Curve1;
    
    else
    
      if( i == 0 )
      
        % Curve0 = (TFloat)0;
        kappa(i) = 0.5 * Curve1;
      
      else 
      
        kappa(i) = (Curve1*ds(i)+Curve0*ds(i-1))/(ds(i)+ds(i-1));
      end
      Curve0 = Curve1;

    end  
  end
  kappa(n) = 0.0;

