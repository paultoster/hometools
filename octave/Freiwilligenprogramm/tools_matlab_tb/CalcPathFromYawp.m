function [x,y,yaw,acc] = CalcPathFromYawp(time,v,yawp,yaw0,x0,y0)
%
% [x,y,yaw,acc] = CalcPathFromYawp(time,v,yawp,yaw0,x0,y0)
%
% Berechnet aus Gierate und Geschwindigkeit über Intgration den Pfad
%
 n   = length(time);
 x   = time * 0.0;
 y   = time * 0.0;
 yaw = time * 0.0;
 
 yaw(1) = yaw0;
 x(1)   = x0;
 y(1)   = y0;
 vx0    = v(1)*cos(yaw0);
 vy0    = v(1)*sin(yaw0);
 
 for i = 2:n
   dt     = time(i)-time(i-1);
   yaw(i) = yaw(i-1) + dt * (yawp(i-1)+yawp(i)) * 0.5;
   vx1    = v(i)*cos(yaw(i));
   vy1    = v(i)*sin(yaw(i));
   x(i)   = x(i-1) + dt * (vx0+vx1) * 0.5;
   y(i)   = y(i-1) + dt * (vy0+vy1) * 0.5;
   vx0    = vx1;
   vy0    = vy1;
 end
 if( nargout > 3 )
  [acc, ydiff] = diff_pt1_zp(time,v,0.5);
 end
end
   