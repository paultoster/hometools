function [yawvec,yawoffset] = vek_2d_yaw_reduce_vec(yawvec,yawoffset0)
%
% [yawvec,yawoffset] = vek_2d_yaw_reduce_vec(yavec)
% [yawvec,yawoffset] = vek_2d_yaw_reduce_vec(yavec,yawoffset0)
%
  if( ~exist('yawoffset0','var') )
    yawoffset0 = 0.;
  end
  
  yawoffset =yawoffset0;
  for i=2:length(yawvec)
    [yawnew,yawoffset] = vek_2d_yaw_reduce(yawvec(i),yawvec(i-1),yawoffset);
    yawvec(i) = yawnew;
  end

end