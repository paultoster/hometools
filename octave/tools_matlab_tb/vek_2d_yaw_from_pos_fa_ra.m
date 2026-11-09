function yawvec = vek_2d_yaw_from_pos_fa_ra(xfavec,yfavec,xravec,yravec)
%
% yawvec = vek_2d_yaw_from_pos_fa_ra(xfavec,yfavec,xravec,yravec)
%
% get yaw vector with position from rear axle to front axle
%
  n = min(length(xfavec),length(yfavec));
  n = min(n,length(xravec));
  n = min(n,length(yravec));
  
  yawvec = zeros(n,1);
  
  for i=1:n
    
    yawvec(i) = atan2(yfavec(i)-yravec(i),xfavec(i)-xravec(i));

  end
  
end