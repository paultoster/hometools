function yp0  = vek_2d_mean_derivation(xvec,yvec,x0,type)
%
% yp0  = vek_2d_mean_derivation(xvec,yvec,x0,type)
%
% get mean derivation dy/dx from points P(xvec,yvec) at x0
%
% x0   :     x - value for getting derivation (default x0 = 0.)
% type :     'lin'   linear (default)
%
%
  yp0 = 0.;
  if( ~exist('x0','var') )
    x0 = 0.0;
  end
  if( ~exist('type','var') )
    type = 'lin';
  end
  
  if( type(1) == 'l' )
    [polynom,Err] = poly_approx(xvec,yvec,1,0,1,0,'',1);
    yp0 = polynom(1);
  else
    error('%s: type : <%s> not programed ',mfilename,type);
  end
  