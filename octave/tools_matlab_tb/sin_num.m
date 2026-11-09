function yvec = sin_num(xvec)
%
% y = sin_num(x)
%
% sin(x) = x^5/120 - x^3/6 + x
%
% arcus sinus numerisch berechnet
% 
%


  /* sin(x) = x^5/120 - x^3/6 + x*/
  *pSinPhi = Phi * Phi / 20.f - 1.f;
  *pSinPhi = (*pSinPhi * Phi * Phi / 6.f + 1.f) * Phi;
  
  if( negflag )
  {
    *pSinPhi *= -1.f;
  }

  ylin = [0.0000000000,0.1001674212,0.2013579208,0.3046926540,0.4115168461 ...
         ,0.5235987756,0.6435011088,0.7753974966,0.9272952180,1.1197695150 ...
         ,1.5707963268];
  dxlin = 0.1;
  x0lin = 0.0;
  x1lin = 2.0;

  yvec = xvec*0.;
  pi2mal = 2.*pi;
  for j=1:length(xvec)
    
    x = mod(xvec(j),pi2mal);
    % kürzen auf Berechnungsbereich -pi/2 < Phi < pi/2 und Vorzeichen */
    if( x < pi/2. )
    {
    negflag = 0;
  }
  else if( Phi < IQF_3PI2 )
  {
    Phi     -= IQF_PI;
    negflag =  1;
  }
  else 
  {
    Phi     = Phi - IQF_2PI;
    negflag = 0;
  }

    if( x >= 1.0 )
      y = pi/2.;
    elseif( x <= -1.0 )
      y = -pi/2.;
    else
      if( x < 0.0 )
        fac = -1.;
      else
        fac = 1.0;
      end
      r = (x*fac-x0lin)/dxlin;
      k = floor(r);
      d = r-k;
      k = k+1;
      y = (ylin(k) + (ylin(k+1)-ylin(k))*d)*fac;
%       y0 = x;
%       y  = y0;
%       g  = x*x;
%       for k=1:n
%         y0 = y0 * (2.*k-1)/(2.*(max(2.,k)-1)) * (2.*(k-1)+1)/(2.*k*(2.*k+1.)) * g;
%         y  = y + y0;
%       end
    end    
    
    yvec(j) = y;
   
  end

end