function yapprox = approx_bspline_with_fac(yvec,iact,fac,iabl,type)
% yapprox = approx_bspline(xvec,yvec,iact,fac,iabl,type)
%
% Mit yvec(iact-1:iact+2) wird mit fac zwischen yvec(iact) und fac interpoliert (type = 0)
% bzw. yvec(iact:iact+3) wird mit fac zwischen yvec(iact) und fac interpoliert (type = 1)
% iabl       0: Wert (default)
%            1: erste Ableitung
%            2: zweite Ableitung
%
% type       0: Approximation mit i-1, ... , i+2 (default)
%            1: Approximation mit i, ... , i+3
 if( 1 )
  if( ~exist('iabl','var') )
    iabl = 0;
  end
  if( ~exist('type','var') )
    type = 0;
  end
  
  nvec = length(yvec);
    
  yi = zeros(4,1);
  a  = zeros(4,1);
  
  index = iact;

  if( type == 0 )

    if( index == 1 )
      t  = fac;
      yi(1) = yvec(1);
      yi(2) = yvec(2);
      yi(3) = yvec(3);
      yi(4) = yvec(4);
    elseif( index > (nvec-2) )  
      t  = fac;
      yi(1) = yvec(nvec-3);
      yi(2) = yvec(nvec-2);
      yi(3) = yvec(nvec-1);
      yi(4) = yvec(nvec);      
    else
      t  = fac;
      yi(1) = yvec(index-1);
      yi(2) = yvec(index);
      yi(3) = yvec(index+1);
      yi(4) = yvec(index+2);
    end
  else
    if( index == 1 )
      t  = fac;
      yi(1) = yvec(1);
      yi(2) = yvec(2);
      yi(3) = yvec(3);
      yi(4) = yvec(4);
    elseif( index > (nvec-3) )  
      t  = fac;
      yi(1) = yvec(nvec-4);
      yi(2) = yvec(nvec-3);
      yi(3) = yvec(nvec-2);
      yi(4) = yvec(nvec-1);      
    else
      t  = fac;
      yi(1) = yvec(index);
      yi(2) = yvec(index+1);
      yi(3) = yvec(index+2);
      yi(4) = yvec(index+3);
    end
  end

  if( iabl == 0 )
    a(2) = (1. - t);
    a(1) = a(2)*a(2)*a(2);
    a(2) = (((3. * t)-6.)* t * t ) + 4.;
    a(3) = (((((-3. * t)+3.)* t)+3.) * t ) + 1.;
    a(4) = t * t * t;
    y    = sum(yi.*a)/6.;
  elseif( iabl == 1 )
    a(2) = (1. - t);
    a(1) = -3. * a(2) * a(2);
    a(2) = ((9. * t)-12.)* t;
    a(3) = (((-9. * t)+6.)* t)+3.;
    a(4) = 3. * t * t;
    y    = sum(yi.*a)/6./dx;
  else
    a(1) = 1. - t;
    a(2) = (3. * t) - 2.;
    a(3) = (-3. * t) + 1.;
    a(4) = t;
    y    = sum(yi.*a)/dx/dx;
  end
  yapprox = y;
 else

  if( ~exist('iabl','var') )
    iabl = 0;
  end
  
  nvec = length(yvec);
    
  index = 1;
  
  A = [-1,3,-3,1;3,-6,3,0;-3,0,3,0;1,4,1,0];
  A = A/6;
  yi = zeros(4,1);
  
  
  x = xapprox(i);
  index = iact;
  t  = fac;

  if( index == 1          ), yi(1) = yvec(1);
  elseif( index-1 <= nvec ), yi(1) = yvec(index-1);
  else                       yi(1) = 0.0;
  end
  if( index <= nvec ), yi(2) = yvec(index);
  else                 yi(2) = yvec(nvec);
  end
  if( index+1 <= nvec ), yi(3) = yvec(index+1);
  else                   yi(3) = yvec(nvec);
  end
  if( index+2 <= nvec ), yi(4) = yvec(index+2);
  else                   yi(4) = yvec(nvec);
  end  


  if( iabl == 0 )
    a = A*yi;
    y = t*(t*(a(1)*t+a(2))+a(3))+a(4);
  elseif( iabl == 1 )
    a = A*yi;
    a = a .* [3;2;1;0];
    y = (t*(t*a(1)+a(2))+a(3))/dx;
  else
    a = A*yi;
    a = a .* [6;2;0;0];
    y = (t*a(1)+a(2))/dx/dx;
  end
  yapprox = y;
  
 end  
end