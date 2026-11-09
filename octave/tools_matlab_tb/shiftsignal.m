function xout = shiftsignal(x,di)
%
% xout = shiftsignal(x,di)
%
% Schiebt Signal un di-Stützstellen
%
% di > 0 nach hinten
% di < 0 nach vorne
%

[n,m] = size(x);
if(  m > n )
  flag = 1;
  x = x';
  a = n;
  n = m;
  m = a;
else
  flag = 0;
end

di = round(di);
xout = zeros(n,m);

if( di > 0 )
  for j = 1:m
    for i=1:di
      xout(i,j) = x(1,j);
    end
    for i=di+1:n
      xout(i,j) = x(i-di,j);
    end
  end
else
  di = abs(di);
  for j = 1:m
    for i=1:n-di
      xout(i,j) = x(i+di,j);
    end
    for i=n-di+1:n
      xout(i,j) = x(n,j);
    end
  end
end