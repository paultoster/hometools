function [x,y] = vek_double_vek(xin,yin)
%
% x = vek_double_vek(xin,yin)
%
% der Vektor wird nach vorne gespiegelt uns angeheftet
  [n1,m1] = size(xin);
  [n2,m2] = size(yin);
  n = min(n1,n2);
  m = min(m1,m2);
  if( n > m )
    x = zeros(2*n-1,m);
    y = zeros(2*n-1,m);
    for i=1:m
      x(:,i) = [2.0*xin(1,i)-xin(n:-1:2,i);xin(1:n,i)];
      y(:,i) = [2.0*yin(1,i)-yin(n:-1:2,i);yin(1:n,i)];
    end
  else
    x = zeros(n,2*m-1);
    y = zeros(n,2*m-1);
    for i=1:n
      x(i,:) = [2.0*xin(i,1)-xin(i,2:m),xin(i,1:m)];
      y(i,:) = [2.0*yin(i,1)-yin(i,2:m),yin(i,1:m)];
    end
  end
end