function  [x0,y0,r,turn] = estimate_radius_from_xy(xin,yin)
%
% (xi-x0)^2+(yi-y0)^2 = r^2
%  xi^2-2*xi*x0+x0^2 + yi^2-2*yi*y0+y0^2 = r^2
%  xi^2+yi^2 = xi*2*x0 + yi*2*y0 + r^2-x0^2-y0^2
%  xi^2+yi^2 = xi*theta(1) + yi*theta(2) + theta(3)
%  yvec      = [x,y,ones(n,1)]*theta
%  yvec      = xmat * theta
%  xmat'*yvec= (xmat'*xmat) * theta
%  
   nrun = 0;
   dphi   = 30*pi/180;
   phi    = 0.0;
   while(nrun < 5)
    phi  = dphi*nrun;
    [x,y] = vek_2d_drehen(xin,yin,phi,0);
    xmat     = [x y x*0.0+1];
    yvec     = (x.^2 + y.^2);
    M        = (xmat' * xmat);
    con      = rcond(M);
    if( abs(con) > eps ) 
      nrun     = 100;
      theta    = (xmat' * xmat)\(xmat' * yvec);
      x0        = theta(1)/2;
      y0        = theta(2)/2;
      r         = sqrt(theta(3)+x0*x0+y0*y0);
    else
      nrun      = nrun + 1;
      r         = 0;
      x0        = mean(x);
      y0        = mean(y);
    end
   end
   [x0,y0] = vek_2d_drehen(x0,y0,phi,1);
   
   vec0x = xin(1)-x0;
   vec0y = yin(1)-y0;
   vec1x = xin(end)-x0;
   vec1y = yin(end)-y0;
   
   val = vec0x*vec1y-vec0y*vec1x;
   
   if( val >= 0.0 )
     turn = 1.;
   else
     turn = -1.;
   end
   
end