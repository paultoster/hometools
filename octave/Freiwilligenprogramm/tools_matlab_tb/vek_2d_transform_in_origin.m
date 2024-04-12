function [xvec,yvec] = vek_2d_transform_in_origin(xvec,yvec)
%
% [xvec,yvec] = vek_2d_transform_in_origin(xvec,yvec)
% 
% turns path into origin position with transforming into
% 
% xvec(1) = 0.;
% yvec(1) = 0.;
% atan2(yvec(2)-yvec(1),xvec(2)-xvec(1) = 0.;   ( yaw angle of first piece in direction yaw = 0 deg)
% ******************************************************************************/

  n = min(length(xvec), length(yvec));
  
  if( n == 1 )
    xvec(1) = 0.;
    yvec(1) = 0.;
  else
    
    xoffset = 0.;
    yoffset = 0.;
    dx      = xvec(1);
    dy      = yvec(1);
    
    [syaw,cyaw] = vek_2d_cos_sin_dx_dy(yvec(2)-yvec(1), xvec(2)-xvec(1));
    [xvec,yvec] = vek_2d_shift_and_transform( xvec, yvec, xoffset, yoffset, dx, dy, 0, cyaw, syaw,0);

  end

end
