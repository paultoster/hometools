function y = root_num(x,nroot,nord)
%
% y = root_num(x,nroot,nord)
%
% nroot     2 Quadratwurzel
%           3 Kubikwurzel, etc
% nord      Ordnung der Taylerreihe
fac = 2.^nroot;
if( nroot <= 1.0 )
  error('nroot = %f muss größe eins sein',nroot)
end
m = 1/nroot;
if( x >= 0.0 )
  n = 0;
  while( x > 2.0 )
    n = n+1;
    x = x/fac;
  end
  x1 = x-1.;
  sum = 0.;
  for i=nord:-1:1
    a = 1;
    for j = 1:i
      a = a * (m-j+1);
      a = a/j;
    end
    sum = (sum+a)*x1;
  end
  sum = sum + 1;
  
  y = sum * 2.^n;
  
else
  n = 0;
  while( x < -2.0 )
    n = n+1;
    x = x/fac;
  end
  x1 = 1-x;
  sum = 0.;
  for i=nord:-1:1
    a = 1;
    for j = 1:i
      a = a * (m-j+1);
      a = a/j;
    end
    sum = (sum+a)*x1;
  end
  sum = sum + 1;
  
  y = sum * 2.^n;
end

