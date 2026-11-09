function yawvec = vek_2d_theta_reduce_n_vector(yawvec)
% yawvec = vek_2d_theta_reduce_n_vector(yawvec)
%
% template <typename TA> void Vek2DThetaReduceN_vector(std::vector<TA> &thetavec)
% {
%   TA      thetaoffset = (TA)0.0;
%   hlpfu_num_points_t inum,nnum = thetavec.size();
%   if(      thetavec[0] < (TA)(-HLPFU_PI) ) thetavec[0] += (TA)HLPFU_2PI;
%   else if( thetavec[0] > (TA)(HLPFU_PI)  ) thetavec[0] -= (TA)HLPFU_2PI;
% 
%   for(inum=1;inum<nnum;++inum)
%   {
%     Vek2DThetaReduce<TA>(thetavec[inum], thetavec[inum-1],thetaoffset);
%   }
% }
%
  yawoffset = 0.0;
  n = length(yawvec);
  if(     yawvec(1) < -pi ), yawvec(1) = yawvec(1)+2*pi;
  elseif( yawvec(1) > pi ),  yawvec(1) = yawvec(1)-2*pi;
  end
  
  for i=2:n
    [yawvec(i),yawoffset] = vek_2d_yaw_reduce(yawvec(i),yawvec(i-1),yawoffset);
  end
end
