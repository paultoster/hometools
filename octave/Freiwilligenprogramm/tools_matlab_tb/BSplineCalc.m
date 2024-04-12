%==========================================================================
function [y,yp,ypp] = BSplineCalc(obj,x)
%
% y = BSplineCalc(obj,x)
%
% calculate spline at x 
%
% obj          structure from BSplineDef(d,dx,xvec,yvec)
% x            x-Value Input
% y            y-Value Output
%
  ep = 1;
  delta = x-obj.xvec(0+ep);
  sigma = int32(floor(delta/obj.dx));
  if( sigma >= obj.L )
     sigma = obj.L-1;
  end
  s     = (delta - double(sigma) * obj.dx)/obj.dx;
  b     = int32(sum(obj.mi(0+ep:sigma+ep)) - obj.d);
  
  svec  = zeros(1,obj.d);
  for j=0:(obj.d-1)
    expo = double(j);
    svec(j+ep) = s^expo;
  end

  g = zeros(obj.d,1);
  for j=b:(b+obj.d-1)
    g((j-b)+ep) = obj.Q(j+ep);
  end

  y = svec * obj.BC{sigma+ep} * g;
  
  for j=0:(obj.d-1)
    if( (j-1) < 0 )
      svec(j+ep) = 0.;
    elseif( (j-1) == 0 )
      svec(j+ep) = double(j);
    else
      expo = double(j-1);
      svec(j+ep) = double(j)*s^expo;
    end
  end
  
  yp = svec * obj.BC{sigma+ep} * g / obj.dx;
  
  for j=0:(obj.d-1)
    if( (j-2) < 0 )
      svec(j+ep) = 0.;
    elseif( (j-2) == 0 )
      svec(j+ep) = double(j);
    else
      expo = double(j-2);
      svec(j+ep) = double(j)*double(j-1)*s^expo;
    end
  end
  
  ypp = svec * obj.BC{sigma+ep} * g  / obj.dx  / obj.dx;

end
