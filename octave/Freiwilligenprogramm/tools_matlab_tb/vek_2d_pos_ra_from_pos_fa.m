function [xravec,yravec] = vek_2d_pos_ra_from_pos_fa(xfavec,yfavec,yawvec,wheelbase)
%
% [xravec,yravec] =vek_2d_pos_ra_from_pos_fa(xfavec,yfavec,yawvec,wheelbase)
%
%
% get rear axle position from position fa and yaw and wheelbase
%
  n = min(length(xfavec),length(yfavec));
  n = min(n,length(yawvec));
  
  
  xravec = zeros(n,1);
  yravec = zeros(n,1);
  
  for i=1:n
    xravec(i) = xfavec(i) - wheelbase * cos(yawvec(i));
    yravec(i) = yfavec(i) - wheelbase * sin(yawvec(i));
  end
  
end