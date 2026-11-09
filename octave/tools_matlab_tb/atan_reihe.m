function alpha = atan_reihe( y,x )
%
% alpha = atan_reihe( y,x )
%

  if( x >= 0.0 )
    if( y >= 0 )
      alpha0 = 0.0; fac = 1.0;
    else
      alpha0 = 0.0; fac = -1.0;y = -y;
    end
  else
    if( y >= 0.0 )
      alpha0 = pi; fac = -1.0; x = -x;
    else
      alpha0 = pi; fac = 1.0;  x = -x; y = -y;
    end
  end
  
  if( x < 1e-10 )
    alpha = pi/2;
  else
%     d = sqrt(x*x+y*y);
%     d = y/d;
%     alpha = 1./9. + 9.*x*x/10./11.;
%     alpha = 1./7. + 7.*x*x/8.*alpha;
%     alpha = 1./5. + 5.*x*x/6.*alpha;
%     alpha = 1./3. + 3.*x*x/4.*alpha;
%     alpha = 1.    + 1.*x*x/2.*alpha;
%     alpha = alpha*d;

d0   = 0.5;
d1   = 0.85;
d2   = 1.2;
a0 = 0.463647609000806;
a1 = 0.704494064242218;
a2 = 0.876058050598193;

    d = y/x;
    if( d < d0 )
      d2 = d*d;
      alpha = 1./13. - d2/15.;
      alpha = 1./11. + d2*alpha;
      alpha = 1./9.  - d2*alpha;
      alpha = 1./7.  + d2*alpha;
      alpha = 1./5.  - d2*alpha;
      alpha = 1./3.  + d2*alpha;
      alpha = 1.     - d2*alpha;
      alpha = alpha*d;
    elseif( d < d1 )
      alpha = (a1-a0)/(d1-d0)*(d-d0)+a0;
    elseif( d < d2 )
      alpha = (a2-a1)/(d2-d1)*(d-d1)+a1;
    else
      d2 = 1./d/d;
      d  = 1./d;
      alpha = 1/13. - 1/15.*d2;
      alpha = 1/11. - alpha*d2;
      alpha = 1/9.  - alpha*d2;
      alpha = 1/7.  - alpha*d2;
      alpha = 1/5.  - alpha*d2;
      alpha = 1/3.  - alpha*d2;
      alpha = 1.    - alpha*d2;
      alpha = pi/2. - alpha*d;
    end
%     d = y/x;
%     dout = d;
%     if( d < 1 )
%       d2 = d*d;
%       alpha = 1./13. - d2/15.;
%       alpha = 1./11. + d2*alpha;
%       alpha = 1./9.  - d2*alpha;
%       alpha = 1./7.  + d2*alpha;
%       alpha = 1./5.  - d2*alpha;
%       alpha = 1./3.  + d2*alpha;
%       alpha = 1.     - d2*alpha;
%       alpha = alpha*d;
%     else
%       d2 = 1./d/d;
%       d  = 1./d;
%       alpha = 1/13. - 1/15.*d2;
%       alpha = 1/11. - alpha*d2;
%       alpha = 1/9.  - alpha*d2;
%       alpha = 1/7.  - alpha*d2;
%       alpha = 1/5.  - alpha*d2;
%       alpha = 1/3.  - alpha*d2;
%       alpha = 1.    - alpha*d2;
%       alpha = pi/2. - alpha*d;
%     end
  end
  alpha = (alpha-alpha0)*fac;
end

