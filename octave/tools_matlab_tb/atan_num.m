function yvec = atan_num(xvec,n)
%
% y = atan_numeric(x)
%
% arcus tangens numerisch berechnet
% Taylorreihe mit n-Gliedern von 0 gezählt
%
ylin = [0.0000000000,0.0996686525,0.1973955598,0.2914567945,0.3805063771 ...
       ,0.4636476090,0.5404195003,0.6107259644,0.6747409422,0.7328151018 ...
       ,0.7853981634,0.8329812667,0.8760580506,0.9151007006,0.9505468408 ...
       ,0.9827937232,1.0121970115,1.0390722595,1.0636978224,1.0863183978 ...
       ,1.1071487178];
dxlin = 0.1;
x0lin = 0.0;
x1lin = 2.0;

  yvec = xvec*0.;
  for j=1:length(xvec)
    x = xvec(j);
    if( (x >= x1lin) || (x <= -x1lin) )
      y0 = -1.0/x;
      g  = y0*y0;
      y  = sign(x) * pi/2 + y0;
      for k=1:n
        y0 = y0 * (-1.0) * (2*k-1)/(2*k+1) * g;
        y  = y + y0;
      end
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
    end    
    
    yvec(j) = y;
   
  end

end