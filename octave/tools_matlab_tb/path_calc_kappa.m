function [kappa,radius] = path_calc_kappa(alpha,ds,n,TypeOfCurvePreCalc,kappamin)
%
% kappa = path_calc_kappa(alpha,ds,n,TypeOfCurvePreCalc)
% [kappa,radius] = path_calc_kappa(alpha,ds,n,TypeOfCurvePreCalc,[kappamin=1/1000])
%
% Calculation of curvature with alpha(i) und ds(i) i = 1:n-1
%
% TypeOfCurvePreCalc = 0   :   curvature at knot (default 0 )
% TypeOfCurvePreCalc = 1   :   curvature between knot
%
% alpha            Steigung entlang der Bahn 
%                  alpha(i) = atan((y(i+1)-y(i))/(x(i+1)-x(i)))
% ds               Streckendifferenz 
%                  ds(i)    = s(i+1) - s(i)
% 
% kappa(i)         curvature at knot mit kappa(n) = 0
%

  if( ~exist('kappamin','var') )
    kappamin = 1./1000.;
  end

  kappa = alpha*0.0;
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

    Curve1 = Curve1/not_zero(ds(i));

    if( TypeOfCurvePreCalc == 0 )
    
      kappa(i) = Curve1;
    
    else
    
      if( i == 1 )
      
        % Curve0 = (TFloat)0;
        kappa(i) = 0.5 * Curve1;
      
      else 
      
        kappa(i) = (Curve1*ds(i)+Curve0*ds(i-1))/(ds(i)+ds(i-1));
      end
      Curve0 = Curve1;

    end  
  end
  kappa(n) = 0.0;
  
  radius = kappa*0.0;
  
  for i=1:n
    if( (kappa(i) > kappamin) || (kappa(i) < -kappamin) )
      radius(i) = 1/kappa(i);
    elseif( kappa(i) >= 0. )
      radius(i) = 1/kappamin;
    else
      radius(i) = 1/(-kappamin);
    end
  end
end
