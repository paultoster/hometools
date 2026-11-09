function [xvec,yvec,yawvec,svec,kappavec] = vek_2d_build_clothoid_s(x0,y0,yaw0,s0,kappa0,S,kappaend,ds)
%
% [xvec,yvec,yawvec,svec,kappavec] = vek_2d_build clothoid_s(x0,y0,s0,kappa0,S,kappaend,ds)
%
% build starting on x0,yo in direction yaw0 with kappa0 a path with a
% clothoid with length S ending with kappa, in segments of ds
% ds is adapted to fit in S
%
%
  S = abs(S);
  if( S < 0.01 )
    xvec(1) = x0;
    yvec(1) = y0;
    yawvec(1) = yaw0;
    kappavec(1) = kappa0;
    svec(1)     = s0;
  else    
    n = round(S/ds);
    ds = S/n;
    if( n == 0 )
      ds = S;
      n = 1;
    end
    n = n+1;

    xvec = zeros(n,1);
    yvec = zeros(n,1);
    yawvec = zeros(n,1);
    svec = zeros(n,1);
    kappavec = zeros(n,1);

    xvec(1) = x0;
    yvec(1) = y0;
    yawvec(1) = yaw0;
    kappavec(1) = kappa0;
    svec(1)     = s0;

    for i=2:n

      svec(i) = svec(i-1) + ds;

      kappavec(i) = kappa0 + (kappaend-kappa0)/S*(svec(i)-svec(1));

      dyaw = kappavec(i) * ds;

      yawvec(i) = yawvec(i-1)+dyaw;

      xvec(i) = xvec(i-1) + ds * cos(yawvec(i));
      yvec(i) = yvec(i-1) + ds * sin(yawvec(i));

    end
  end                             
                                                 
end