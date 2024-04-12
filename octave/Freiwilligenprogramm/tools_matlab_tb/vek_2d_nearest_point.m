function [iact,ddmin] = vek_2d_nearest_point(xvec,yvec,x0,y0)
%
% iact = vek_2d_nearest_point(xvec,yvec,x0,y0)
%
% calculation of nearest point
%

  n = min(length(xvec),length(yvec));

  iact  = 1;
  ddmin = 1./eps;
  for i=1:n

    dx = xvec(i)-x0;
    dy = yvec(i)-y0;

    dd = dx*dx+dy*dy;
    if( dd < ddmin )
      iact = i;
      ddmin = dd;
    end
  end
end

