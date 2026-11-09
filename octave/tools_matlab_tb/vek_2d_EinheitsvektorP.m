function e = vek_2d_EinheitsvektorP(X,Y)
%
% e = vek_2d_EinheitsvektorP(X,Y)
% 
% X = [x0,x1]
% Y = [y0,y1]
% e = [dx;
%      dy]/sqrt(dx^2+dy^2)
%
e = [0;0];
n = min(length(X),length(Y));
if( n > 1 )
  e = zeros(2,n-1);
  for i = 1:n-1
    dx     = (X(i+1)-X(i));
    dy     = (Y(i+1)-Y(i));
    d      = sqrt(dx^2+dy^2);
    e(1,i) = dx/d;
    e(2,i) = dy/d;
  end
end