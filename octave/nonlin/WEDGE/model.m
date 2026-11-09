function [g,G,b,B] = model(D,df,lOut,AlgOptn,n,m)
% If AlgOptn = 'Quadra':
% [g,G,b,B] = model(D,df,lOut) finds the coefficients g and G of the
% interpolating quadratic and the coefficients b and B of the 
% taboo surface. The quantities b and B are normalized, so that 
% sqrt( norm(b)^2 + 1/2*norm(B,'fro')^2 ) = 1.
%
% If AlgOptn = 'Linear':
% [g,G,b,B] = model(D,df,lOut) finds hte coefficient g of the interpolation 
% linear model, and the vector b normal to the taboo surface (with ||b|| = 1).
%
% Input:   
%     D    n by m = 1/2*(n+1)*(n+2)-1 matrix whose columns contain
%     the displacement vectors between the current iterate x and each 
%     satellite y_l (i.e., D(:,l) = y_l - x).
%  
%     df   m-column vector containing the function value differences 
%         corresponding to D; that is, df(l) = f(y_l) - f(x).
%
%     lOut index in the interval [1,m] of the leaving satellite.
%   
if AlgOptn == 'Linear'
%
% Find QR factorization of a permutatiion of matrix D. This permutation
% places the column D(:,lOut) as the last column. 
%
   [Q,R] = qr(D(:,[1:lOut-1, lOut+1:m, lOut]));
%
% Solve for the vector "g", using a permutation of "df" that is consistent 
% with that of the matrix D.
% Note that the normal "b" to the taboo region is simply the last column of Q.
%
   aux = R' \ df([1:lOut-1, lOut+1:m, lOut]);
   g = Q*aux;
   b = Q(:,m);
%
% The output matrices G and B are irrellevant. Set them to zero.
%
   G = zeros(m); B = zeros(m);

elseif AlgOptn == 'Quadra'
   P = [];
%
% Form the common coefficient matrix of the linear systems.
%
   for l = 1:m
       col = D(:,l);
       for i = 1:n
           for j = i+1:n
               col = [col;D(i,l)*D(j,l)];
           end
       end
       col = [col;1/sqrt(2)*D(:,l).^2];
       P = [P,col];
   end
%
% Factor matrix.
%
   [L,U] = lu(P');
%
% Find entries of g and G.
%
   longVector = L \ df;
   longVector = U \ longVector;
%
% Form g and G
%
   g = longVector(1:n);

   k = n + 1;
   for i = 1:n
       for j = i+1:n
           G(i,j) = longVector(k);
           G(j,i) = G(i,j);
           k = k + 1;
       end
   end
   for i = 1:n
       G(i,i) = sqrt(2)*longVector(k);
       k = k + 1;
   end
%
% Find entries of b and B.
%
   longVector = L \ [zeros(lOut-1,1);1+df(lOut);zeros(m-lOut,1)];
   longVector = U \ longVector;
%
% Normalize b and B 
% NB: norm(longVector) = sqrt( norm(b)^2 + 1/2*norm(B,'fro')^2 ).
%
   longVector = longVector/norm(longVector);
%
% Form b and B.
%
   b = longVector(1:n);
   k = n + 1;
   for i = 1:n
       for j = i+1:n
           B(i,j) = longVector(k);
           B(j,i) = B(i,j);
           k = k + 1;
       end
   end
   for i = 1:n
       B(i,i) = sqrt(2)*longVector(k);
       k = k + 1;
   end
else
   error('Wrong value of AlgOptn in the specs file')
end



