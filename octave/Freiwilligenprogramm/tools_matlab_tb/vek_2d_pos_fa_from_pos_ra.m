function [xfavec,yfavec] = vek_2d_pos_fa_from_pos_ra(xravec,yravec,yawvec,wheelbase)
%
% [xfavec,yfavec] =vek_2d_pos_ra_from_pos_fa(xravec,yravec,yawvec,wheelbase)
%
%
% get front axle position from position rear position and yaw and wheelbase
%
  n = min(length(xravec),length(yravec));
  n = min(n,length(yawvec));
  
  
  xfavec = zeros(n,1);
  yfavec = zeros(n,1);
  
  for i=1:n
    xfavec(i) = xravec(i) + wheelbase * cos(yawvec(i));
    yfavec(i) = yravec(i) + wheelbase * sin(yawvec(i));
  end
  
end