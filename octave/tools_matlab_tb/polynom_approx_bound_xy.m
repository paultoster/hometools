function p = polynom_approx_bound_xy(N,xvec,yvec,b0,b1)
%
% p = polynom_approx_bound_xy(N,xvec,yvec,b0,b1)
%
% pOlynominal approximation with boundary for yvec(xvec) with
% boundary condition b0 at start and b1 at end, with Order N
%
% N           order : N+1 > length(b0)+length(b1)
% xvec(1:n)   x-Vector path
% yvec(1:n)   y-Vector path
% b0          boundary condition at xvec(1) for y 
%             b0 = []             no value (default)
%                  [y0]          (value only) or 
%                  [y0,yp0]      (+derivation) or 
%                  [y0,yp0,ypp0] (+second deriv)
% b1          boundary condition at xvec(n) for y
%
% Output
% p = [aN; aN-1; ... a1, a0]

  if( ~exist('b0','var') )
    b0 = [];
  end
  if( ~exist('b1','var') )
    b1 = [];
  end
  n  = min(length(xvec),length(yvec));
  xstart = xvec(1);
  xend   = xvec(n);
  
  nN = N+1;
  nb0 = length(b0);
  nb1 = length(b1);
  
  if( nN <= nb0+nb1 )
    error('Order N=%i is to small N+1 > length(b0)=%i+length(b1)=%i ',N,nb0,nb1);
  end
  
  if(  (nb0  > 0) && (nb1  > 0) && (n-2 < nN-nb0-nb1) )
    error('Anzahl der Punkte ist zu gering n > %i',nN-nb0-nb1+1)
  end
  if(  ((nb0 == 0) && (nb1  > 0) && (n-1 < nN-nb0-nb1)) ...
    || ((nb0  > 0) && (nb1 == 0) && (n-1 < nN-nb0-nb1)) ...
    )
    error('Anzahl der Punkte ist zu gering n > %i',nN-nb0-nb1)
  end
  
  %
  % bbilde 
  % nc  Anzahl der direkt alesbaren Parameter (xvec(1),xvec(n) == 0)
  % na  Anzahl der verbelibenden boundaries na+nc == nb0+nb1
  % nb  Anzahl der verbleibenden Parameter zur approximation
  % atype = 1 Bilde A mit b1 und C mit b0 (abs(xstart) < eps)
  % atype = 2 Bilde A mit b1 und kein C (isempty(b0))
  % atype = 3 Bilde kein A isempty(b1) und C mit b0
  % atype = 4 Bilde A mit b0 und C mit b1 abs(xend) < eps)   +
  % atype = 5 Bilde A mit b0 und kein C  (isempty(b1)) abs(xstart) > eps +
  % atype = 6 Bilde kein A isempty(b0) und C mit b1 (abs(xend) < eps) +
  % atype = 7 Bilde A mit b0+b1 kein C (abs(xstart) > eps) (abs(xend) > eps) +
  % atype = 8 Bild kein A,C keine boundaries
  %
  % Bilde y = A*a+B*b+C*c
  if( nb0+nb1 == 0 )
    p = polynom_approx_bound_xy_8(N,xvec,yvec);
  elseif( nb0 == 0 )
    if( abs(xend) < eps )
      p = polynom_approx_bound_xy_6(N,xvec,yvec,b1);
    else
      p = polynom_approx_bound_xy_2(N,xvec,yvec,b1);
    end
  elseif( nb1 == 0 )
    if( abs(xstart) < eps )
      p = polynom_approx_bound_xy_3(N,xvec,yvec,b0);
    else
      p = polynom_approx_bound_xy_5(N,xvec,yvec,b0);
    end
  elseif( abs(xstart) < eps )
      p = polynom_approx_bound_xy_1(N,xvec,yvec,b0,b1);
  elseif( abs(xend) < eps )
      p = polynom_approx_bound_xy_4(N,xvec,yvec,b0,b1);    
  else
    p = polynom_approx_bound_xy_7(N,xvec,yvec,b0,b1);    
  end
end
function p = polynom_approx_bound_xy_1(N,xvec,yvec,b0,b1)
  % atype = 1 Bilde A mit b1 und C mit b0

  n  = min(length(xvec),length(yvec));
  xend   = xvec(n);
  
  nN = N+1;
  nb0 = length(b0);
  nb1 = length(b1);

  na = nb1;
  y  = zeros(na,1);
  for i=1:na,y(i) = b1(i);end

  nc = nb0;
  c  = zeros(nc,1);
  for i=nc:-1:1,c(i) = b0(nc+1-i);end
  if( abs(xend) < eps )
    error('xstart == 0 und xend == 0 geht nicht')
  end
  
  nb = nN-na-nc;
  A = zeros(na,na);
  nNA = nN;
  for j=1:na
    fac = 1.0;
    for i=1:na
      exp    = max(0,(nNA-j-(i-1)));
      A(i,j) = fac*(xend^exp);
      fac    = fac*exp;
    end
  end
  C = zeros(na,nc);
  nNC = nc;
  for j=1:nc
    fac = 1.;
    for i=1:na
      exp    = max(0,(nNC-j-(i-1)));
      C(i,j) = fac*(xend^exp);
      fac    = fac*exp;
    end
  end
  B = zeros(na,nb);
  nNB = nN-na;
  for j=1:nb
    fac = 1.0;
    for i=1:na
      exp    = max(0,(nNB-j-(i-1)));
      B(i,j) = fac*(xend^exp);
      fac    = fac*exp;
    end
  end
    
  % y = A*a+B*b+C*c
  % Bilde a = A^-1*y - A^-1*B*b - A^-1*C*c
  %       a = D - E*b - F*c
  %       D = A^-1*y
  %       E = A^-1*B
  %       F = A^-1*C
  if( abs(det(A)) < eps )
    error('det(A) == 0 kein Inversion')
  end
  D = A\y;
  E = A\B;
  F = A\C;

  yy = zeros(n-2,1);
  SA = zeros(n-2,na);
  SB = zeros(n-2,nb);
  SC = zeros(n-2,nc);
  i = 0;
  for ii = 2:n-1
    i = i+1;
    yy(i) = yvec(ii);
    for j=1:na
      exp = nNA - j;
      SA(i,j) = xvec(ii)^exp;
    end
    for j=1:nb
      exp = nNB - j;
      SB(i,j) = xvec(ii)^exp;
    end
    for j=1:nc
      exp = nNC - j;
      SC(i,j) = xvec(ii)^exp;
    end
  end

  Y = yy - SA*D - (SC - SA*F)*c;
  X = SB - SA*E;
  b = X\Y;
  
  a = D - E*b - F*c;

  p = [a;b;c];

end
function p = polynom_approx_bound_xy_2(N,xvec,yvec,b1)
  % atype = 2 Bilde A mit b1 und kein C (isempty(b0))

  n  = min(length(xvec),length(yvec));
  xend   = xvec(n);
  
  nN = N+1;
  nb1 = length(b1);

  na = nb1;
  nc = 0;
  nb = nN-na-nc;
  y  = zeros(na,1);
  for i=1:na,y(i) = b1(i);end

  A = zeros(na,na);
  nNA = nN;
  for j=1:na
    fac = 1.0;
    for i=1:na
      exp    = max(0,(nNA-j-(i-1)));
      A(i,j) = fac*(xend^exp);
      fac    = fac*exp;
    end
  end
  B = zeros(na,nb);
  nNB = nN-na;
  for j=1:nb
    fac = 1.0;
    for i=1:na
      exp    = max(0,(nNB-j-(i-1)));
      B(i,j) = fac*(xend^exp);
      fac    = fac*exp;
    end
  end
  
  % y = A*a+B*b
  % Bilde a = A^-1*y - A^-1*B*b
  %       a = D - E*b - F*c
  %       D = A^-1*y
  %       E = A^-1*B
  if( abs(det(A)) < eps )
    error('det(A) == 0 kein Inversion')
  end
  D = A\y;
  E = A\B;
   
  yy = zeros(n-1,1);
  SA = zeros(n-1,na);
  SB = zeros(n-1,nb);
  i = 0;
  for ii = 1:n-1
    i = i+1;
    yy(i) = yvec(ii);
    for j=1:na
      exp = nNA - j;
      SA(i,j) = xvec(ii)^exp;
    end
    for j=1:nb
      exp = nNB - j;
      SB(i,j) = xvec(ii)^exp;
    end
  end

  Y = yy - SA*D;
  X = SB - SA*E;
  b = X\Y;
  a = D - E*b;

  p = [a;b];
end
function p = polynom_approx_bound_xy_3(N,xvec,yvec,b0)
  % atype = 3 Bilde kein A isempty(b1) und C mit b0

  n  = min(length(xvec),length(yvec));
  
  nN = N+1;
  nb0 = length(b0);

  na = 0;
  nc = nb0;
  nb = nN-na-nc;
  c  = zeros(nc,1);
  for i=nc:-1:1,c(i) = b0(nc+1-i);end
  
  nNB = nN;
  nNC = nc;

  yy = zeros(n-1,1);
  SB = zeros(n-1,nb);
  SC = zeros(n-1,nc);
  i = 0;
  for ii = 2:n
    i = i+1;
    yy(i) = yvec(ii);
    for j=1:nb
      exp = nNB - j;
      SB(i,j) = xvec(ii)^exp;
    end
    for j=1:nc
      exp = nNC - j;
      SC(i,j) = xvec(ii)^exp;
    end
  end

  Y = yy - SC*c;
  X = SB;
  b = X\Y;    
  p = [b;c];

end
function p = polynom_approx_bound_xy_4(N,xvec,yvec,b0,b1)
  % atype = 4 Bilde A mit b0 und C mit b1
  n  = min(length(xvec),length(yvec));
  xstart = xvec(1);
  
  nN = N+1;
  nb0 = length(b0);
  nb1 = length(b1);

  na = nb0;
  y  = zeros(na,1);
  for i=1:na,y(i) = b0(i);end

  nc = nb1;
  c  = zeros(nc,1);
  for i=nc:-1:1,c(i) = b1(nc+1-i);end

  nb = nN-na-nc;
  
  A = zeros(na,na);
  nNA = nN;
  for j=1:na
    fac = 1.0;
    for i=1:na
      exp    = max(0,(nNA-j-(i-1)));
      A(i,j) = fac*(xstart^exp);
      fac    = fac*exp;
    end
  end
  C = zeros(na,nc);
  nNC = nc;
  for j=1:nc
    fac = 1.;
    for i=1:na
      exp    = max(0,(nNC-j-(i-1)));
      C(i,j) = fac*(xstart^exp);
      fac    = fac*exp;
    end
  end
  B = zeros(na,nb);
  nNB = nN-na;
  for j=1:nb
    fac = 1.0;
    for i=1:na
      exp    = max(0,(nNB-j-(i-1)));
      B(i,j) = fac*(xstart^exp);
      fac    = fac*exp;
    end
  end

  % y = A*a+B*b+C*c
  % Bilde a = A^-1*y - A^-1*B*b - A^-1*C*c
  %       a = D - E*b - F*c
  %       D = A^-1*y
  %       E = A^-1*B
  %       F = A^-1*C
  if( abs(det(A)) < eps )
    error('det(A) == 0 kein Inversion')
  end
  D = A\y;
  E = A\B;
  F = A\C;

  yy = zeros(n-2,1);
  SA = zeros(n-2,na);
  SB = zeros(n-2,nb);
  SC = zeros(n-2,nc);
  i = 0;
  for ii = 2:n-1
    i = i+1;
    yy(i) = yvec(ii);
    for j=1:na
      exp = nNA - j;
      SA(i,j) = xvec(ii)^exp;
    end
    for j=1:nb
      exp = nNB - j;
      SB(i,j) = xvec(ii)^exp;
    end
    for j=1:nc
      exp = nNC - j;
      SC(i,j) = xvec(ii)^exp;
    end
  end

  Y = yy - SA*D - (SC - SA*F)*c;
  X = SB - SA*E;
  b = X\Y;
  a = D - E*b - F*c;

  p = [a;b;c];
end
function p = polynom_approx_bound_xy_5(N,xvec,yvec,b0)
  % atype = 5 Bilde A mit b0 und kein C  (isempty(b1))
  n  = min(length(xvec),length(yvec));
  xstart = xvec(1);

  nN = N+1;
  nb0 = length(b0);
  
  na = nb0;
  nc = 0;
  nb = nN-na-nc;
  y  = zeros(na,1);
  for i=1:na,y(i) = b0(i);end

  A = zeros(na,na);
  nNA = nN;
  for j=1:na
    fac = 1.0;
    for i=1:na
      exp    = max(0,(nNA-j-(i-1)));
      A(i,j) = fac*(xstart^exp);
      fac    = fac*exp;
    end
  end
  B = zeros(na,nb);
  nNB = nN-na;
  for j=1:nb
    fac = 1.0;
    for i=1:na
      exp    = max(0,(nNB-j-(i-1)));
      B(i,j) = fac*(xstart^exp);
      fac    = fac*exp;
    end
  end

  % Bilde a = A^-1*y - A^-1*B*b
  %       a = D - E*b - F*c
  %       D = A^-1*y
  %       E = A^-1*B
  if( abs(det(A)) < eps )
    error('det(A) == 0 kein Inversion')
  end
  D = A\y;
  E = A\B;

  yy = zeros(n-1,1);
  SA = zeros(n-1,na);
  SB = zeros(n-1,nb);
  i = 0;
  for ii = 2:n
    i = i+1;
    yy(i) = yvec(ii);
    for j=1:na
      exp = nNA - j;
      SA(i,j) = xvec(ii)^exp;
    end
    for j=1:nb
      exp = nNB - j;
      SB(i,j) = xvec(ii)^exp;
    end
  end

  Y = yy - SA*D;
  X = SB - SA*E;
  b = X\Y;
  a = D - E*b;    
  p = [a;b];
end
function p = polynom_approx_bound_xy_6(N,xvec,yvec,b1)
  % atype = 6 Bilde kein A isempty(b0) und C mit b1
  n  = min(length(xvec),length(yvec));
  
  nN = N+1;
  nb1 = length(b1);
  
  na = 0;
  nc = nb1;
  nb = nN-na-nc;
  c  = zeros(nc,1);
  for i=nc:-1:1,c(i) = b1(nc+1-i);end
  
  nNB = nN;
  nNC = nc;

  yy = zeros(n-1,1);
  SB = zeros(n-1,nb);
  SC = zeros(n-1,nc);
  i = 0;
  for ii = 1:n-1
    i = i+1;
    yy(i) = yvec(ii);
    for j=1:nb
      exp = nNB - j;
      SB(i,j) = xvec(ii)^exp;
    end
    for j=1:nc
      exp = nNC - j;
      SC(i,j) = xvec(ii)^exp;
    end
  end

  Y = yy - SC*c;
  X = SB;
  b = X\Y;    
  p = [b;c];
end
function p = polynom_approx_bound_xy_7(N,xvec,yvec,b0,b1)
  % atype = 7 Bilde A mit b0+b1 kein C
  n  = min(length(xvec),length(yvec));
  xstart = xvec(1);
  xend   = xvec(n);
  
  nN = N+1;
  nb0 = length(b0);
  nb1 = length(b1);

  na = nb0+nb1;
  y  = zeros(na,1);
  for i=1:nb0,y(i) = b0(i);end
  for i=nb0+1:na,y(i) = b1(i-nb0);end

  nc    = 0;
  nb = nN-na-nc;

  A = zeros(na,na);
  nNA = nN;
  for j=1:na
    fac = 1.0;
    for i=1:nb0
      exp    = max(0,(nNA-j-(i-1)));
      A(i,j) = fac*(xstart^exp);
      fac    = fac*exp;
    end
  end
  for j=1:na
    fac = 1.0;
    for i=1:nb1
      exp    = max(0,(nN-j-(i-1)));
      A(nb0+i,j) = fac*(xend^exp);
      fac    = fac*exp;
    end
  end
  B = zeros(na,nb);
  nNB = nN-na;
  for j=1:nb
    fac = 1.0;
    for i=1:nb0
      exp    = max(0,(nN-na-j-(i-1)));
      B(i,j) = fac*(xstart^exp);
      fac    = fac*exp;
    end
  end
  for j=1:nb
    fac = 1.0;
    for i=1:nb1
      exp        = max(0,(nN-na-j-(i-1)));
      B(nb0+i,j) = fac*(xend^exp);
      fac        = fac*exp;
    end
  end
  
  % Bilde a = A^-1*y - A^-1*B*b
  %       a = D - E*b - F*c
  %       D = A^-1*y
  %       E = A^-1*B
  if( abs(det(A)) < eps )
    error('det(A) == 0 kein Inversion')
  end
  D = A\y;
  E = A\B;
  
  yy = zeros(n-2,1);
  SA = zeros(n-2,na);
  SB = zeros(n-2,nb);
  i = 0;
  for ii = 2:n-1
    i = i+1;
    yy(i) = yvec(ii);
    for j=1:na
      exp = nNA - j;
      SA(i,j) = xvec(ii)^exp;
    end
    for j=1:nb
      exp = nNB - j;
      SB(i,j) = xvec(ii)^exp;
    end
  end

  Y = yy - SA*D;
  X = SB - SA*E;
  b = X\Y;
  a = D - E*b;

  p = [a;b];

end
function p = polynom_approx_bound_xy_8(N,xvec,yvec)
  % atype = 8 Bild kein A,C keine boundaries

  n  = min(length(xvec),length(yvec));
  
  xskal = max(abs(xvec));
  yskal = max(abs(yvec));
  
  xvec = xvec/xskal;
  yvec = yvec/yskal;
  
  nN = N+1;
  % nc  Anzahl der direkt alesbaren Parameter (xvec(1),xvec(n) == 0)
  % na  Anzahl der verbelibenden boundaries na+nc == nb0+nb1
  % nb  Anzahl der verbleibenden Parameter zur approximation
  % atype = 8 Bild kein A,C keine boundaries
  na    = 0;
  nc    = 0;
  nb = nN-na-nc;

  % Bilde A,C,B
  nNB = nN;

  yy = zeros(n,1);
  SB = zeros(n,nb);
  i = 0;
  for ii = 1:n
    i = i+1;
    yy(i) = yvec(ii);
    for j=1:nb
      exp = nNB - j;
      SB(i,j) = xvec(ii)^exp;
    end
  end

  % Löst SB * p = yy
  if( rank(SB) < nb )
    error('%s: rank(SB) < nb=%i',mfilename,nb)
  end
  p = SB\yy;
  
  for i=1:length(p)
    p(i) = p(i) * yskal / xskal^(nb-i);
  end
    
end
