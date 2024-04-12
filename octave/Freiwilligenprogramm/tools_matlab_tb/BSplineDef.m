%==========================================================================
function obj = BSplineDef(d,dx,xvec,yvec,y0,yp0,ypp0)
%
% obj = BSplineDef(d,dx,xvec,yvec)
% obj = BSplineDef(d,dx,xvec,yvec,y0,yp0,ypp0)
%
% Definition Bspline Aperiodic
% d            order
% dx           length of one span
% xvec,yvec    Messungen mit yvec = f(xvec)
% y0           Anfangsbedingung Punkt
% yp0          Anfangsbedingung Steigung
% ypp0         Anfangsbedingung zweite Ableitung

  if( exist('y0','var') && exist('yp0','var') && exist('ypp0','var') )
    FlagAnfangsBeding = 1;
  else
    FlagAnfangsBeding = 0;
  end
  obj.m    = min(length(xvec),length(yvec));
  obj.xvec = xvec(1:obj.m);
  obj.yvec = yvec(1:obj.m);
    
  obj.L  = int32(round((obj.xvec(end)-obj.xvec(1))/dx));
  obj.dx = (obj.xvec(end)-obj.xvec(1))/double(obj.L);
  obj.d = int32(d);
  
  % multiple knot count M
  % multplie at breakpoints s
  [obj.mi,obj.M] = getMultipleNodesVectorAperidic(obj.L,obj.d);
  % [obj.mi,obj.M] = getMultipleNodesVectorPeridic(obj.L,obj.d);
  % NK nodes
  obj.NK = obj.L + 1 + obj.M;
  % NB basic functions
  obj.NB = obj.L + 1 + obj.M - obj.d;
  
  %        +-                -+
  % Bc{i} =| a1 b1 c1 ... end1|  knode 1 y = a1 + a2*x + ... an * x^(n-1)
  %        | a2 b2 c2 ... end2|  knode 2 y = b1 + b2*x + ... bn * x^(n-1)
  %        | ...              |  ...
  %        | an bn cn ... endn|  knode n y = end1 + end2*x + ... endn * x^(n-1)
  %        +-                -+ 
  obj.BC  = getBasicMatrix(obj.d,obj.L,obj.mi,obj.NK);
  
  % mit Anfangsbedingungen
   if( FlagAnfangsBeding && (obj.d >= 4) )
    % calculate weighting points Q
    obj.Q   = calcQVectorMitAnfBed(obj,y0,yp0,ypp0);
%     obj.Q   = calcQVectorMitAnfBed2(obj,y0,yp0,ypp0);
  else
    % calculate weighting points Q
    obj.Q   = calcQVector(obj);
  end
  
end
%==========================================================================
% %==========================================================================
% function obj = printParam(obj)
%   fprintf('Parameter BSplisneClass ===========================\n');
%   fprintf('order d: %i\n',obj.d);
%   fprintf('spans L: %i\n',obj.L);
%   fprintf('===================================================\n');
% end
%==========================================================================
%==========================================================================
function [mi,M] = getMultipleNodesVectorAperidic(L,d)
 mi = int32(ones(L+1,1));
 mi(0+1) = int32(d);
 mi(L+1) = int32(d);
 M       = 2*(d-1);
end
%==========================================================================
%==========================================================================
function [mi,M] = getMultipleNodesVectorPeridic(L,d)
 mi = int32(ones(L+1,1));
 M       = 0;
end
%==========================================================================
%==========================================================================
function BC  = getBasicMatrix(d,L,mi,NK)
%--------------------------------------------------------------------------
% Basic MAtrix for Aperiodic Spline
%--------------------------------------------------------------------------
  BC = cell(L,1);
  for i = 0:L-1
    BC{i+1} = zeros(d,d);
  end
  
  % Nodes calculation
  %------------------
  p = int32(0);
  q = int32(0);
  ki = zeros(NK,1);
  for i = 0:L
    for j = 1:mi(i+1)
      ki(p+1) = q;
      p       = p+1;
    end
    q = q+1;
  end

  
  for sigma = 0:(L-1)
   
    if( (sigma > (d-2)) && (sigma < (L+2-d)) )
      
      BC{sigma+1} = BC{sigma};
      
    else

      % find index bsigma of the first basic function whose support
      % includes the span
      bsigma = 0;
      for j = 0:sigma
        bsigma = bsigma + mi(j+1);
      end
      bsigma = bsigma - mi(0+1);
    
      % recurively calculate the basis polynominal Bsigma(b+i-1,d)
      % for span sigma

      B = zeros(d,d);
      for n = bsigma:bsigma+d-1 % Find all basis polynomials for chosen span

        s = BasicFunctions(sigma,n,d,ki);
        nn = length(s.polynom);
        %    +-                -+
        % B =| a1 b1 c1 ... end1|  knode 1 y = a1 + a2*x + ... an * x^(n-1)
        %    | a2 b2 c2 ... end2|  knode 2 y = b1 + b2*x + ... bn * x^(n-1)
        %    | ...              |  ...
        %    | an bn cn ... endn|  knode n y = end1 + end2*x + ... endn * x^(n-1)
        %    +-                -+ 
        for k = 1:d
          kk = nn-k+1;
          if( kk > 0 )
            B(k,n-bsigma+1) = s.polynom(kk);
          end
        end
      end
      BC{sigma+1} = B;
    end
  end
end
function s = BasicFunctions(sigma,n,iorder,k)
%
% recursivly called
%
  if( iorder == 1 )
    % Ground instance
    if( (sigma >= k(n+1)) && (sigma < k(n+1+1)) )
      s = polynom_build_with_roots([],1);
    else
      s = polynom_build_with_roots([],0.);
    end
  else
    
    % Recursive Rule
    try
    den = k(n+(iorder-1)+1) - k(n+1);
    catch
      aaaa= 0;
    end
    if( den == 0 )
      % ist null
      s1 = polynom_build_with_roots([],0.);
    else
      s1 = BasicFunctions(sigma,n,iorder-1,k);
      s1 = polynom_multiply_by_root(s1,double(k(n+1)-sigma));
      s1  = polynom_multiply_by_factor(s1,1./double(den));
    end
        
    den = k(n+iorder+1) - k(n+1+1);
    if( den == 0 )
      % ist null
      s2 = polynom_build_with_roots([],0.);
    else
      s2 = BasicFunctions(sigma,n+1,iorder-1,k);
      s2 = polynom_multiply_by_root(s2,double(k(n+iorder+1)-sigma));
      s2 = polynom_multiply_by_factor(s2,-1./double(den));          
    end
    s = polynom_add_polynom(s1,s2);
  end
end
% calculate weighting points Q
function  Q   = calcQVector(obj)
  
  ep = 1;
  A = zeros(obj.m,obj.NB);
  
  for i = 0:(obj.m-1)
    delta = obj.xvec(i+ep)-obj.xvec(0+ep);
    sigma = int32(floor(delta/obj.dx));
    if( sigma == obj.L )
      sigma = obj.L-1;
    end
    s     = (delta - double(sigma) * obj.dx)/obj.dx;
    b     = int32(sum(obj.mi(0+ep:sigma+ep)) - obj.d);
    
    svec = zeros(1,obj.d);
    svec(0+ep) = 1;
    for j=1:(obj.d-1)
      svec(j+ep) = svec(j-1+ep) * s;
    end
    
    G = zeros(obj.d,obj.NB);
    for j=b:(b+obj.d-1)
      G((j-b)+ep,j+ep) = 1;
    end
    
    try
      a         = svec * obj.BC{sigma+ep} * G;
      A(i+ep,:) = svec * obj.BC{sigma+ep} * G;
    catch
      a = 0;
    end
  end
  
  AA = (A'*A);
  f  = A'*obj.yvec;
  
  if( rank(AA) < obj.NB )
    error('%s: rank(A''*A) < obj.NB')
  end
  Q = AA\f;
    
end
% calculate weighting points Q
function  Q   = calcQVectorMitAnfBed(obj,y0,yp0,ypp0)
  ep = 1;
  % Berechnung der ersten 3 Gewichte mit y0,yp0,ypp0
  y0s   = y0;
  yp0s  = yp0 * obj.dx;
  ypp0s = ypp0 * obj.dx;
  g0 = y0s/not_zero(obj.BC{0+ep}(0+ep,0+ep));
  g1 = (yp0s - obj.BC{0+ep}(1+ep,0+ep) * g0) / not_zero(obj.BC{0+ep}(1+ep,1+ep));
  g2 = (ypp0s - 2.*obj.BC{0+ep}(2+ep,0+ep) * g0 - 2.*obj.BC{0+ep}(2+ep,1+ep) * g1) ...
     / not_zero(obj.BC{0+ep}(2+ep,2+ep)) / 2.;

%   B = obj.BC{0+ep}(0+ep:2+ep,0+ep:2+ep);
%   f = zeros(3,1);
%   f(1) = y0;
%   f(2) = yp0;
%   f(3) = ypp0/2.;
%   
%   if( rank(B) < 3 )
%     error('%s: rank(B) < (obj.d)',mfilename)
%   end
%   g = B\f;

  A = zeros(obj.m,obj.NB);
  
  for i = 0:(obj.m-1)
    delta = obj.xvec(i+ep)-obj.xvec(0+ep);
    sigma = int32(floor(delta/obj.dx));
    if( sigma == obj.L )
      sigma = obj.L-1;
    end
    s     = (delta - double(sigma) * obj.dx)/obj.dx;
    b     = int32(sum(obj.mi(0+ep:sigma+ep)) - obj.d);
    
    svec = zeros(1,obj.d);
    svec(0+ep) = 1;
    for j=1:(obj.d-1)
      svec(j+ep) = svec(j-1+ep) * s;
    end
    
    G = zeros(obj.d,obj.NB);
    for j=b:(b+obj.d-1)
      G((j-b)+ep,j+ep) = 1;
    end
    
    try
      a         = svec * obj.BC{sigma+ep} * G;
      A(i+ep,:) = svec * obj.BC{sigma+ep} * G;
    catch
      a = 0;
    end
  end
  
  % Aufteilung mit Abspaltung für g0,g1,g2
  B0    = A(0+ep:obj.m-1+ep,0+ep:2+ep);
  q     = [g0;g1;g2];
  yyvec = obj.yvec - B0 * q;
  B     = A(0+ep:obj.m-1+ep,3+ep:obj.NB-1+ep);
  
  BB = (B'*B);
  f  = B'*yyvec;
  
  if( rank(BB) < (obj.NB-3) )
    error('%s: rank(B''*B) < obj.NB-3')
  end
  QQ = BB\f;
  
  Q  = [q;QQ];
    
end

% calculate weighting points Q
function  Q   = calcQVectorMitAnfBed2(obj,y0,yp0,ypp0)
  ep = 1;
  % Berechnung der ersten 3 Gewichte mit y0,yp0,ypp0
  B = obj.BC{0+ep};
%   for i=0:obj.d-1
%     B(2+ep,i+ep) = B(2+ep,i+ep) * 2.;
%     B(3+ep,i+ep) = B(3+ep,i+ep) * 6.;
%   end
  f = zeros(obj.d,1);
  f(1) = y0;
  f(2) = yp0;
  f(3) = ypp0/2.;
  
  if( rank(B) < (obj.d) )
    error('%s: rank(B) < (obj.d)',mfilename)
  end
  g = B\f;
    
  A = zeros(obj.m,obj.NB);
  
  for i = 0:(obj.m-1)
    delta = obj.xvec(i+ep)-obj.xvec(0+ep);
    sigma = int32(floor(delta/obj.dx));
    if( sigma == obj.L )
      sigma = obj.L-1;
    end
    s     = (delta - double(sigma) * obj.dx)/obj.dx;
    b     = int32(sum(obj.mi(0+ep:sigma+ep)) - obj.d);
    
    svec = zeros(1,obj.d);
    svec(0+ep) = 1;
    for j=1:(obj.d-1)
      svec(j+ep) = svec(j-1+ep) * s;
    end
    
    G = zeros(obj.d,obj.NB);
    for j=b:(b+obj.d-1)
      G((j-b)+ep,j+ep) = 1;
    end
    
    try
      a         = svec * obj.BC{sigma+ep} * G;
      A(i+ep,:) = svec * obj.BC{sigma+ep} * G;
    catch
      a = 0;
    end
  end
  
  % Aufteilung mit Abspaltung für g0,g1,g2
  B0    = A(0+ep:obj.m-1+ep,0+ep:(obj.d-1)+ep);
  
  yyvec = obj.yvec - B0 * g;
  B     = A(0+ep:obj.m-1+ep,(obj.d-1)+ep:obj.NB-1+ep);
  
  BB = (B'*B);
  f  = B'*yyvec;
  
  if( rank(BB) < (obj.NB-3) )
    error('%s: rank(B''*B) < obj.NB-3',mfilename)
  end
  QQ = BB\f;
  
  Q  = [g;QQ];
    
end





