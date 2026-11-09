function [xvec,yvec] = vek_2d_get_vehicle_contour_from_fa_ra(xfa,yfa,xra,yra,wheelbase,width)
%
% [xvec,yvec] = vek_2d_get_vehicle_contour_from_fa_ra(xfa,yfa,xra,yfa,wheelbase,width)
%
%
% get vehicle contour
%  
  n = 7;
  xvec = zeros(n,1);
  yvec = zeros(n,1);
  
  yaw = atan2(yfa-yra,xfa-xra);
  cyaw = cos(yaw);
  syaw = sin(yaw);

  cleftyaw = -syaw;
  sleftyaw = cyaw;
  crightyaw = syaw;
  srightyaw = -cyaw;
  
  % links vorne
  xvec(1) = xfa + cleftyaw * width/2;
  yvec(1) = yfa + sleftyaw * width/2;
  % links hinten
  xvec(2) = xra + cleftyaw * width/2;
  yvec(2) = yra + sleftyaw * width/2;
  % rechts hinten
  xvec(3) = xra + crightyaw * width/2;
  yvec(3) = yra + srightyaw * width/2;
  % rechts vorne
  xvec(4) = xfa + crightyaw * width/2;
  yvec(4) = yfa + srightyaw * width/2;
  % mitte leicht zurück
  xvec(5) = xfa - cyaw * wheelbase*0.2;
  yvec(5) = yfa - syaw * wheelbase*0.2;
  % links vorne
  xvec(6) = xvec(1);
  yvec(6) = yvec(1);
  % rechts vorne
  xvec(7) = xvec(4);
  yvec(7) = yvec(4);
  
end