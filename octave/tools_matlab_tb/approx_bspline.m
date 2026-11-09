function yapprox = approx_bspline(xvec,yvec,xapprox,iabl,type)
% yapprox = approx_bspline(xvec,yvec,xapprox,iabl,type)
%
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
  
  nvec = min(length(xvec),length(yvec));
  
  if( ~is_monoton_steigend(xvec) )
    error('%s_error: xvec ist nicht monoton stegend',mfilename);
  end
  
  n = length(xapprox);
  yapprox = xapprox*0.0;
  
  index = 1;
  yi = zeros(4,1);
  a  = zeros(4,1);
  
  for i =1:n
    x = xapprox(i);
    if( x < xvec(1) )
      index = 1;
    elseif( x >= xvec(nvec) )
      index = nvec;
    else
      for j = 1:nvec-1
        if( (x>= xvec(j)) && (x<xvec(j+1) ) )
          index = j;
          break;
        end
      end
    end
  
    if( type == 0 )
    
      if( index == 1 )
        dx = xvec(index+2)-xvec(index+1);
        t  = (x-xvec(index+1))/dx;
        yi(1) = yvec(1);
        yi(2) = yvec(2);
        yi(3) = yvec(3);
        yi(4) = yvec(4);
      elseif( index > (nvec-2) )  
        dx = xvec(nvec-1)-xvec(nvec-2);
        t  = (x-xvec(nvec-2))/dx;
        yi(1) = yvec(nvec-3);
        yi(2) = yvec(nvec-2);
        yi(3) = yvec(nvec-1);
        yi(4) = yvec(nvec);      
      else
        dx = xvec(index+1)-xvec(index);
        t  = (x-xvec(index))/dx;
        yi(1) = yvec(index-1);
        yi(2) = yvec(index);
        yi(3) = yvec(index+1);
        yi(4) = yvec(index+2);
      end
    else
      if( index == 1 )
        dx = xvec(index+1)-xvec(index);
        t  = (x-xvec(index))/dx;
        yi(1) = yvec(1);
        yi(2) = yvec(2);
        yi(3) = yvec(3);
        yi(4) = yvec(4);
      elseif( index > (nvec-3) )  
        dx = xvec(nvec-2)-xvec(nvec-3);
        t  = (x-xvec(nvec-3))/dx;
        yi(1) = yvec(nvec-4);
        yi(2) = yvec(nvec-3);
        yi(3) = yvec(nvec-2);
        yi(4) = yvec(nvec-1);      
      else
        dx = xvec(index+1)-xvec(index);
        t  = (x-xvec(index))/dx;
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
    yapprox(i) = y;
  end
 else

  if( ~exist('iabl','var') )
    iabl = 0;
  end
  
  nvec = min(length(xvec),length(yvec));
  
  if( ~is_monoton_steigend(xvec) )
    error('%s_error: xvec ist nicht monoton stegend',mfilename);
  end
  
  n = length(xapprox);
  yapprox = xapprox*0.0;
  
  index = 1;
  
  A = [-1,3,-3,1;3,-6,3,0;-3,0,3,0;1,4,1,0];
  A = A/6;
  yi = zeros(4,1);
  
  for i =1:n
    x = xapprox(i);
    if( x < xvec(1) )
      index = 1;
    elseif( x >= xvec(nvec) )
      index = nvec;
    else
      for j = 1:nvec-1
        if( (x>= xvec(j)) && (x<xvec(j+1) ) )
          index = j;
          break;
        end
      end
    end
    
    
    if( index+1 <= nvec )
      dx = xvec(index+1)-xvec(index);
      t  = (x-xvec(index))/dx;
    else
      dx = xvec(nvec)-xvec(nvec-1);
      t  = (x-xvec(nvec-1))/dx;
    end
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
    yapprox(i) = y;
  end
 end  
end