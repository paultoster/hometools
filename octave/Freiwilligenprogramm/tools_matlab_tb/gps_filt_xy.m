function [xmod,ymod,yawmod,errflag] = gps_filt_xy(xgps,ygps,delta_s_build,s_filt)
%
% [xmod,ymod,yawmod] = gps_filt_xy(xgps,ygps,delta_s_build,s_filt)
% [xmod,ymod,yawmod,errflag] = gps_filt_xy(xgps,ygps,delta_s_build,s_filt)
%
%   if( ~exist('s_filt','var') )
%     s_filt = 10.0;
%   end
  errflag = 0;
  if( ~exist('s_filt','var') )
    s_filt = 10.0;
  end
  
  xmod = [];
  ymod = [];
  yawmod = [];

  [sgps,alpha1,c01] = path_calc_aplha_kappa(xgps,ygps);
  
  [sgps,xyout] = elim_nicht_monoton(sgps,[xgps,ygps],0.001,1);
  xgps = xyout(:,1);
  ygps = xyout(:,2);
  
  if( length(sgps) <= 1 )
    xmod   = 0.0;
    ymod   = 0.0;
    yawmod = 0.0;
    return;
  end
    
  
  x1 = butter2_filter(sgps,xgps,s_filt,1);
  y1 = butter2_filter(sgps,ygps,s_filt,1);
%   x1 = xgps;
%   y1 = ygps;
  [s1,alpha1,c01] = path_calc_aplha_kappa(x1,y1);
  
  [x2,y2,s2,alpha2,c02,c12,errflag] = path_calc_smooth_path(x1,y1,delta_s_build);
  
  alpha2 = Winkel_2pi_Sprung(alpha2,'rad');
  if( ~errflag && min([length(s2),length(x2),length(y2),length(alpha2)]) > 1 ) 
    xmod = interp1(s2,x2,s1,'linear','extrap');
    ymod = interp1(s2,y2,s1,'linear','extrap');
    yawmod = interp1(s2,alpha2,s1,'linear','extrap');
  else
    xmod   = x1;
    ymod   = y1;
    yawmod = alpha1;
  end
    
  if( 0 )
  figure(200)
  plot(xgps,ygps,'k-')
  hold on
  plot(x1,y1,'r-')
  plot(x2,y2,'b-')
  plot(xmod,ymod,'g-')
  hold off
  grid on
  
  figure(201)
  plot(time,xgps,'k-')
  hold on
  plot(time,x1,'r-')
  plot(time,xmod,'g-')
  hold off
  grid on
  title('x')
  figure(202)
  plot(time,ygps,'k-')
  hold on
  plot(time,y1,'r-')
  plot(time,ymod,'g-')
  hold off
  grid on
  title('y')
  figure(203)
  plot(time,alpha1*180/pi,'k-')
  hold on
  plot(time,yawmod*180/pi,'g-')
  hold off
  grid on
  title('yawmod')

  figure(204)
  plot(alpha2*180/pi,'k-')
  grid on
  title('alpha2')
  end

end
