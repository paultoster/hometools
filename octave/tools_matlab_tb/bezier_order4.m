function [x,y] = bezier_order4(x0, y0, x1, y1, x2, y2, x3, y3,t,iabl)
%
% [x,y] = bezier_order4(x0, y0, x1, y1, x2, y2, x3, y3,t)
% 
% t     0.0 ... 1.0
% iabl  = 0,1,2  Ableitung 0, 1, 2

  if( ~exist('iabl','var') )
    iabl = 0;
  end
  einsmt = 1-t;
  if( iabl == 0 )
    a      = [(einsmt^3),3.*t*(einsmt^2),3*(t^2)*einsmt,(t^3)];
  elseif( iabl == 1 )
    a      = [-3*einsmt^2,-6.*einsmt*t+3.*einsmt^2,-3*t^2+6*einsmt*t,3.*t^2];
  else
    a      = [6.*einsmt,6.*t-12.*einsmt,-12*t+6.*einsmt,6.*t];
  end
  x      = a * [x0;x1;x2;x3];
  y      = a * [y0;y1;y2;y3];
end