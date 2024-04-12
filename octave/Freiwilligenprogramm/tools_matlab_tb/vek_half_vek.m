function [x,y] = vek_half_vek(xin,yin)
%
% x = vek_half_vek(xin,yin)
%
% der gespiegelte Anteil (vek_double_vek) des Vektors wird wieder
% weggenommen
  [n1,m1] = size(xin);
  [n2,m2] = size(yin);
  n = min(n1,n2);
  m = min(m1,m2);
  if( n > m )
    x = xin(n-(n+1)/2+1:n,1:m);
    y = yin(n-(n+1)/2+1:n,1:m);
  else
    x = xin(1:n,m-(m+1)/2+1:m);
    y = yin(1:n,m-(m+1)/2+1:m);
  end
end