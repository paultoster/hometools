function D = initialSat(x, Delta, m, inSatOptn, AlgOptn)
% 
% D = initialSat(x,Delta,inSatOptn) creates m = (n+1)*(n+2)/2 - 1 
% displacements so that y_l \equiv x + D(:,l) be used as initial
% satellite set.
% 
% inSatOptn = 'Splx'  Vertices and midpoints of random simplex in R^n.
% inSatOptn = 'Rand'  Randomly chosen in the interval [-Delta, Delta].
% inSatOptn = 'Debg'  Fixed simplex.

n = length(x);

if inSatOptn == 'Rand'
%
% Generate m random sample points around the current iterate
% within the initial trust region.
%
   D = rand(n,m);
   D = Delta * D + (ones(n,m) - D)*(-Delta);
elseif (inSatOptn == 'Splx') | (inSatOptn == 'Debg')
%
% Powell's idea of chosing the initial sample points as
% the vertices and midoints on the edges of a simplex in R^n
% (this is done only once, at the very first iteration).
%
%
%   *
%   |\
%   | \
%   |  \
%   #   o             Simplex in R^2
%   |    \
%   |     \
%   |      \          Here "x" denotes the starting point x_1. 
%   x---#---*         
%
%
% Note, if initial model is linear, only te vertices of the simplex are
% generated (points "*" in the figure).
%

%
%   Set D(:,1:n) = + or - Delta e_i (vertices of the simplex),
%   where the sign is randomly determined. Here e_i denotes the vectors of all 
%   zeros, with a 1 at the ith entry.
%   (Points "*" in the figure.)
%
   D = zeros(n,m);
   for i = 1:n
       if (inSatOptn == 'Splx')       % simplex in random orthant
          plusOrMinus =  (-1)^round(10*rand);
          D(i,i) = plusOrMinus * Delta;
       elseif (inSatOptn == 'Debg')   % simplex in first orthant
          D(i,i) = Delta;
       end
   end
%  
%  Only for AlgOptn = 'Quadra':
%  Set D(:, n+1:n+c) to the midpoints between each vertex different from the 
%  starting point on the edges of the simplex; here c is the combinatorial number 
%  n-choose-2. (Points "o" in the figure.)
%  
   if AlgOptn == 'Quadra'
      nMidPoint = 0;    % midpoint number
      for i = 1:n-1
          for j = i+1:n
              nMidPoint = nMidPoint + 1;
              D(:,n + nMidPoint) = 0.5 * (D(:,i) + D(:,j));
          end
      end
%
%  Set D(:,n+c+1:n+c+n) to the midpoints between each of the vertices and the starting 
%  point. (Points "#" in the figure.) 
%
      for i = 1:n
          D(:,n + nMidPoint + i) = 0.5 * D(:,i);
      end
   end 
else
      error('Wrong value of inSatOptn');
end
  

