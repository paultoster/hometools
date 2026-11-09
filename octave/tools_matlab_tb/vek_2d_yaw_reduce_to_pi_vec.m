function yawvec = vek_2d_yaw_reduce_to_pi_vec(yawvec)
%
% yawnew = vek_2d_yaw_reduce_to_pi(yaw)
% reduce to -pi <= yaw <= pi
%

 for i=1:length(yawvec)
  if( yawvec(i) >= 0. )
    while( yawvec(i) >  (pi)  ) yawvec(i) = yawvec(i) - 2*pi; end
  else
    while( yawvec(i) <  (-pi) ) yawvec(i) = yawvec(i) + 2*pi; end
  end
end