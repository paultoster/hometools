function t = poly_print_par(p,matlablike)
%
% t = poly_print_par(p,matlablike)
%
% Druckt Parameter aus
% p      Koeffizientenvektor
% matlablike       1: matlab-struktur [an an-1 ... a1 a0]
%                  0: meine alte struct [a0 a1 ... an-1 an]
%

  n = length(p);
  rText = '';
  for i = 1:n
    if(     i == 1 ), rText = sprintf('a%i * x^%i',n-i,n-i);
    elseif( i == n ), rText = sprintf('%s + a%i',rText,n-i);
    else              rText = sprintf('%s + a%i * x^%i',rText,n-i,n-i);
    end
  end
  t = sprintf('f(x) = %s\n\n',rText);    
  if( matlablike )
    for i = 1:n
      t = sprintf('%sa%i = %f = %e\n',t,n-i,p(i),p(i));
    end
  else
    for i = n:-1:1
      t = sprintf('%sa%i = %f = %g = %e\n',t,n-i,p(n-i+1),p(n-i+1),p(n-i+1));
    end
  end
  t = sprintf('%s\n',t);
  fprintf(t)
end