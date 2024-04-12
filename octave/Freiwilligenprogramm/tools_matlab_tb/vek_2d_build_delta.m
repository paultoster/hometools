function dvec = vek_2d_build_delta(xvec,yvec)
%
% dvec = vek_2d_build_delta(xvec,yvec)
%   i = 1:n
%   dx = x(i+1) - x(i);
%   dy = y(i+1) - y(i);
%   dvce(i) = sqrt(dx*dx + dy *dy);
%   dvec(n) = 0;
% dvec = vek_2d_build_delta([x0,x1],[y0,y1])
%   dx = x1 - x0;
%   dy = y1 - y0;
%   dvce(1) = sqrt(dx*dx + dy *dy);
%   dvec(2) = 0;
%
  [n,m] = size(xvec);
  dx   = diff(xvec);
  dy   = diff(yvec);
  if( n >= m )
    dvec = [sqrt(dx.*dx + dy.*dy);0.0];
  else
    dvec = [sqrt(dx.*dx + dy.*dy),0.0];
  end
end