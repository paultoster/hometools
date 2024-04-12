function [xvec,yvec] = vek_2d_add_points_at_end(xvec,yvec,npoints,type,ds)
%
% [xvec,yvec] = vek_2d_add_points_at_end(xvec,yvec,npoints,type,ds)
%
% xvec,yvec wird um npoints verlängert mit
% type = 'heading' prolongs with heading
% ds         delta s to next point, if < 0 => mean(dsvec)

if( ~exist('npoints','var') )
  npoints = 1;
end
if( ~exist('type','var') )
  type = 'heading';
end
if( ~exist('ds','var') )
  ds = -1.0;
end



nx = length(xvec);
ny = length(yvec);
n  = min(nx,ny);

if( nx > n ), xvec = xvec(1:n); end
if( ny > n ), yvec = yvec(1:n); end

if(ds < 0.0 )
  [s,ds,alpha] =vek_2d_s_ds_alpha(xvec,yvec);
  ds = mean(ds);
end

if( strcmpi(type,'heading') )
  
  calpha = cos(alpha(n-1));
  salpha = sin(alpha(n-1));
  
  for i=1:npoints
    xvec(n+1) = xvec(end) + ds * calpha;
    yvec(n+1) = yvec(end) + ds * salpha;
  end  
else
  error('type = %s not available',type);
end


end