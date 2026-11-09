function [xvec,yvec] = vek_2d_shift_and_transform(xvec,yvec,xoffset,yoffset,dx,dy,shift_add,cyaw,syaw,turn_pos)
%
% [xvec,yvec] = vek_2d_shift_neg_and_transform(xvec,yvec,xoffset,yoffset,dx,dy,shift_add,cyaw,syaw,turn_pos)
% 
% shift and transform x-y-vector
%  xvec,yvec        Vector to shift and turn
%  xoffset,yoffset  Offset for turning point
%  dx,dy            offset for shift
%  shift_add        0: subtract dx,dy
%                   1: add dx,dy
%  cyaw,syaw        cosinus and sinus of yaw angle
%  tutn_pos         0: turn negative around xoffset,yoffset
%                   1: turn positive around xoffset,yoffset
%
% * +-  -+   +-           -+   +-               -+   +-     -+
% * |xnew| = |cyaw  +/-syaw|   |xold-xoffset-/+dx|   |xoffset|
% * |ynew| = |+/-syaw  cyaw| * |yold-yoffset-/+dy| + |yoffset|
% * +-  -+   +-           -+   +-               -+   +-     -+
% ******************************************************************************/

  n = min(length(xvec), length(yvec));

  if( shift_add )
    ddx = dx;
    ddy = dy;
  else
    ddx = -dx;
    ddy = -dy;
  end
  if( turn_pos )
    a01 = -syaw;
    a10 = syaw;
  else
    a01 = syaw;
    a10 = -syaw;
  end
  for i=1:n
  
    x = xvec(i) - xoffset + ddx;
    y = yvec(i) - yoffset + ddy;

    xvec(i) = cyaw * x + a01  * y;
    yvec(i) = a10  * x + cyaw * y;

    xvec(i) = xvec(i) + xoffset;
    yvec(i) = yvec(i) + yoffset;
  end

end
