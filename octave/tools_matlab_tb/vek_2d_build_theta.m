function yawvec = vek_2d_build_theta(xvec,yvec,yawvec,i0,i1)
%
% yawvec = vek_2d_build_theta(xvec,yvec)
% yawvec = vek_2d_build_theta(xvec,yvec,yawvec,i0,i1)
%
% build yaw angle from path
% i0 = 1,2,3, ...
% i1 = 1,2,3, ... n

  n = min(length(xvec),length(yvec));

  if( ~exist('i0','var') )
    i0 = 1;
  end
  if( ~exist('in','var') )
    i1 = n;
  end
  if( ~exist('yawvec','var') )
    yawvec = [];
  end

  n = min(n,i1);
  if( n > length(yawvec) )
    if( n - i0 > 1 )
      for i=i0+1:n
        dx = xvec(i)-xvec(i-1);
        dy = yvec(i)-yvec(i-1);

        yawvec(i-1) = atan2(dy,dx);
      end
      yawvec(n) = yawvec(n-1);
      yawvec = vek_2d_theta_reduce_n_vector(yawvec);
    end
  end
end