function xvecout = vec_delete(xvec,ivec,i1)
%
% vek2 = vec_delete(vek1,i)
% vek2 = vec_delete(vek1,ivec)
% vek2 = vec_delete(vek1,i0,i1)
%

  if( ~exist('ivec','var') )
      error('vec_delete: ivec ist nicht vorhanden')
  end
  if( exist('i1','var') )
      i0   = ivec(1);
      if( i1 < i0 )
        %error('i1 > i0, sollte umgekehrt sein');
        xvecout = xvec;
        return
      else
        ivec = i0:1:i1;
      end
  end
  [n,m] = size(xvec);
  if( n > m )
    i0 = 1;
    xvecout = [];
    n = length(xvec);
    flag = 1;
    for i = ivec
      if( i <= n )
        i1 = i-1;
        if( i1>=i0 )
          xvecout = [xvecout;xvec(i0:i1)];
        end
        i0 = i1+2;
      else
        xvecout = [xvecout;xvec(i0:n)];
        flag    = 0;
      end
    end
    if( flag )  
      xvecout = [xvecout;xvec(i0:n)];
    end
  else
    i0 = 1;
    xvecout = [];
    n = length(xvec);
    flag = 1;
    for i = ivec
      if( i <= n )
        i1 = i-1;
        if( i1>=i0 )
          xvecout = [xvecout,xvec(i0:i1)];
        end
        i0 = i1+2;
      else
        xvecout = [xvecout,xvec(i0:n)];
        flag    = 0;
      end
    if( flag )  
      xvecout = [xvecout,xvec(i0:n)];      
    end
    end
  end
end 
 