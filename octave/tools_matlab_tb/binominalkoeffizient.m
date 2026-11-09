function f = binominalkoeffizient(n,k)
%
% f = binominalkoeffizient(n,k)
%     / n \
% f = |   |
%     \ k /
%
  if( k == 0 )
    f = 1;
  elseif( 2*k > n )
    f = binominalkoeffizient(n, n-k);
  else
    f =  (n+1-k) / k * binominalkoeffizient(n,k-1);
  end
end
