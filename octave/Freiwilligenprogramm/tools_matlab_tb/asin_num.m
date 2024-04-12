function yvec = asin_num(xvec)
%
% y = asin_num(x)
%
% arcus sinus numerisch berechnet
% 
%

  ylin = [0.0000000000,0.1001674212,0.2013579208,0.3046926540,0.4115168461 ...
         ,0.5235987756,0.6435011088,0.7753974966,0.9272952180,1.1197695150 ...
         ,1.5707963268];
  dxlin = 0.1;
  x0lin = 0.0;
  x1lin = 2.0;

  yvec = xvec*0.;
  for j=1:length(xvec)
    x = xvec(j);
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