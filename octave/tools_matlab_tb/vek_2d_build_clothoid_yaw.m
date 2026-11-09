function [xvec,yvec,yawvec,svec,kappavec] = vek_2d_build_clothoid_yaw(x0,y0,yaw0,s0,kappa0,YAW,kappaend,ds)
%
% [xvec,yvec,yawvec,svec,kappavec] = vek_2d_build clothoid_s(x0,y0,s0,kappa0,YAW,kappaend,ds)
%
% build starting on x0,yo in direction yaw0 with kappa0 a path with a
% clothoid with ANgle YAW ending with kappa, in segments of ds
%
%
%
  YAW = abs(YAW);
  if( kappa0 >= 0.0 )
    kappa0 = max(kappa0,1/1000.);
  else
    kappa0 = min(kappa0,-1/1000.);
  end
  if( YAW < 0.01 )
    xvec(1) = x0;
    yvec(1) = y0;
    yawvec(1) = yaw0;
    kappavec(1) = kappa0;
    svec(1)     = s0;
  else    


    xvec(1) = x0;
    yvec(1) = y0;
    yawvec(1) = yaw0;
    kappavec(1) = kappa0;
    svec(1)     = s0;
    i           = 1;
    flag = 1;
    while( flag  )
    
      i = i+1;
      
      dyaw    = kappavec(i-1) *ds;
 
      yawend = yawvec(i-1)+dyaw;

      if( abs(yawend-yaw0) > YAW )
        flag = 0;
        if( yawend-yaw0 > 0.0 )
          yawend = yaw0+YAW;
        else
          yawend = yaw0 - YAW;
        end
        
        ds     = (yawend-yawvec(i-1))/not_zero(kappavec(i-1));
      end
      
      svec = [svec;svec(i-1) + abs(ds)];
      yawvec = [yawvec;yawend];

      kappavec = [kappavec;(kappa0 + (kappaend-kappa0)/YAW* abs(yawvec(i)-yawvec(1)))];


      xvec = [xvec;xvec(i-1) + ds * cos(yawvec(i))];
      yvec = [yvec;yvec(i-1) + ds * sin(yawvec(i))];

    end
  end                             
                                                 
end