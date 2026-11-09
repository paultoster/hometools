function flag = vek_2d_compare_path(xvec1,yvec1,xvec2,yvec2,typ,tol)
%
% flag = vek_2d_compare_path(xvec1,yvec1,xvec2,yvec2,typ,[tol])
%
% type = 'change'
%
% compare xvec1 with xvec2 and yvec1 with yvec2 if it has changed return
% flag = 1
%
%
  if( ~exist('typ','var') )
    typ = 'change';
  end
  if( ~exist('tol','var') )
    tol = eps;
  end
  
  flag = 0;
  
  if( typ(1) == 'c' )
  
    n = length(xvec1);

    if( n ~= length(xvec2) )
      flag = 1;
      return;
    end
    for i=1:n    
      if( abs(xvec1(i)-xvec2(i)) >= tol )
        flag = 1;
        return;
      end
    end
    n = length(yvec1);

    if( n ~= length(yvec2) )
      flag = 1;
      return;
    end
    for i=1:n    
      if( abs(yvec1(i)-yvec2(i)) >= tol )
        flag = 1;
        return;
      end
    end
  else
    error('typ: %s not implemented',typ);
  end
end
    
  