function [xvec,yvec,yawvec,svec,kappavec] = vek_2d_build_path_osci(x0,y0,yaw0,s0,kappa0,L,X,A,dl)
%
% [xvec,yvec,yawvec,svec,kappavec] = vek_2d_build_path_osci(x0,y0,yaw0,s0,kappa0,L,X,A,dl)
%
% build starting on x0,yo in direction yaw0 with kappa0 a path with a
% cosinus oasilation period length X/m, Amplitude A/m, length is L/m
% dl isadapted
%
%
  X = abs(X);
  L = abs(L);
  if( X < 0.01 || L < 0.01 )
    xvec(1) = x0;
    yvec(1) = y0;
    yawvec(1) = yaw0;
    kappavec(1) = kappa0;
    svec(1)     = s0;
  else    
    
    n = round(L/dl);
    dl = L/n;
    if( n == 0 )
      dl = L;
      n = 1;
    end
    n = n+1;

    xvec = zeros(n,1);
    yvec = zeros(n,1);
    yawvec = zeros(n,1);
    svec = zeros(n,1);
    kappavec = zeros(n,1);

    xvec(1) = 0.0;
    yvec(1) = 0.0;
    yawvec(1) = 0.0;
    
    yd = 0.0;
    ydd = 2*pi*pi*A/X/X;
    kappavec(1) = ydd/not_zero((sqrt(1+yd*yd))^3);
    svec(1)     = s0;
    
    

    om = 2*pi/X;
    Fd = pi*A/X;
    Fdd = 2*pi*pi*A/X/X;
    for i=2:n
      
      xvec(i) = xvec(i-1)+dl;
      yvec(i) = A/2.*(1.-cos(om*xvec(i)));
      yd      = Fd*sin(om*xvec(i));
      ydd     = Fdd*cos(om*xvec(i));
      yawvec(i) = atan(yd);

      kappavec(i) = ydd/not_zero((sqrt(1+yd*yd))^3);

      dx = xvec(i)-xvec(i-1);
      dy = yvec(i)-yvec(i-1);
      ds = sqrt(dx*dx+dy*dy);

      svec(i) = svec(i-1) + ds;
      
    end
    
    [xvec,yvec] = vek_2d_transform_shift(xvec,yvec,x0,y0,cos(yaw0),sin(yaw0),1);
    yawvec      = yawvec + yaw0;
  end                             
                                                 
end