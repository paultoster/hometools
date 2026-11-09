function [syaw,cyaw] = vek_2d_cos_sin_dx_dy(dy, dx)
%
% [syaw,cyaw] = vek_2d_cos_sin_dx_dy(dy, dx)
%

  yaw = atan2(dy,dx);
  syaw = sin(yaw);
  cyaw = cos(yaw);
 
end