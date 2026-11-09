function [yawnew,yawoffset] = vek_2d_yaw_reduce(yawnew,yawold,yawoffset)
%
% [yawnew,yawoffset] = vek_2d_yaw_reduce(yawnew,yawold,yawoffset)
%
  while( yawnew >  (2*pi) ) yawnew = yawnew - 2*pi; end
  while( yawnew <  (-2*pi) ) yawnew = yawnew + 2*pi; end

  if( (yawnew - (yawold+yawoffset)) > (2*pi * 0.85) ) 
  
    yawoffset = yawoffset + 2*pi;
  
  elseif( (yawnew - (yawold+yawoffset)) < (2*pi * -0.85) ) 
  
    yawoffset = yawoffset - 2*pi;
  end
  yawnew = yawnew - yawoffset;

end