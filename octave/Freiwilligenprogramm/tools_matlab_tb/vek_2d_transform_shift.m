function [xvecout,yvecout] = vek_2d_transform_shift(xvec,yvec,xoffset,yoffset,cyaw,syaw,turn_pos)
%
%  [xvecout,yvecout] = vek_2d_transform_shift(xvec,yvec,xoffset,yoffset,cyaw,syaw,turn_pos)
%
% xvec,yvec        Vector to shift and turn
% xoffset,yoffset  Offset for turning point
% cyaw,syaw        cosinus and sinus of yaw angle
% turn_pos         0: turn negative around zero
%                  1: turn positive around zero
% 
% * +-  -+   +-          -+   +-   -+   +-     -+
% * |xnew| = |cyaw   -syaw|   |xold |   |xoffset|   turn_pos = 1
% * |ynew| = |syaw    cyaw| * |yold | + |yoffset|
% * +-  -+   +-          -+   +-   -+   +-     -+
% * +-  -+   +-          -+   +-   -+   +-     -+
% * |xnew| = |cyaw    syaw|   |xold |   |xoffset|   turn_pos = 0
% * |ynew| = |-syaw   cyaw| * |yold | + |yoffset|
% * +-  -+   +-          -+   +-   -+   +-     -+


  n = min(length(xvec),length(yvec));
  
  xvecout = zeros(n,1);
  yvecout = zeros(n,1);
  
  for i=1:n
    if( turn_pos )
      xvecout(i) =  xvec(i) * cyaw - yvec(i) * syaw + xoffset;
      yvecout(i) =  xvec(i) * syaw + yvec(i) * cyaw + yoffset;
    else
      xvecout(i) =   xvec(i) * cyaw + yvec(i) * syaw + xoffset;
      yvecout(i) =  -xvec(i) * syaw + yvec(i) * cyaw + yoffset;
    end
  end
end