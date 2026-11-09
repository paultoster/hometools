function yaw = vek_2d_yaw_reduce_to_pi(yaw)
%
% yawnew = vek_2d_yaw_reduce_to_pi(yaw)
% reduce to -pi <= yaw <= pi
%
  if( yaw >= 0. )
    while( yaw >  (pi)  ) yaw = yaw - 2*pi; end
  else
    while( yaw <  (-pi) ) yaw = yaw + 2*pi; end
  end
end