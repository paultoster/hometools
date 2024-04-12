function s = kalman_param(A,B,Q,H,R,xstart)
%
%  xm(k) = A*xm(k-1)+B*u(k-1)
%  A     Systemmatrix n x n
%  B     Eingang n x 1
%  Q     Kovarianzmatrix Systemrauschen n x n
%  z(k) = H * x(k) m x 1
%  H     Messmatrix m x n
%  R     Kovarianzmatrix m x m
%  xstart Starvektor m x 1

  s = [];
  [n,m] = size(A);
  if( n ~= m )
    error('Sytemmatrix nicht n x n')
  end
  s.n = n;
  s.A = A;
  
  [n,m] = size(B);
  if( n ~= s.n )
    error('B-Matrix nicht an Systemmatrix A angepasst ')
  end
  
  s.B = B;
  
  [n,m] = size(Q);
  if( n ~= s.n || m ~= s.n)
    error('Kovarianzmatrix Q nicht an Systemmatrix A angepasst ')
  end
  
  s.Q = Q;
  
  [n,m] = size(H);
  if(  m ~= s.n)
    error('Messmatrix H nicht an Systemmatrix A angepasst ')
  end
  
  s.m = n;
  s.H = H;
  
  [n,m] = size(R);
  if(  m ~= s.m || n ~= s.m )
    error('Messmatrix R nicht an Messmatrix H angepasst ')
  end
  
  s.R = R;
  
  [n,m] = size(xstart);
  if(  n ~= s.n || m ~= 1 )
    error('Startvektor nicht an Systemmatrix A angepasst ')
  end
  
  s.x  = xstart;
  s.xm = xstart;
  
  
  s.I = diag(ones(s.n,1));
  s.P = zeros(s.n,s.n); 
  s.Pm = s.P;
  

end
