function [s,pred,betasol,flag] = LinSubProb(m,Delta,g,norm_g,gamma,b)
% The function [s,flag] = LinSubProb(...) solves
% the subproblem with linear objective and "pac-man" trust
% region.
% INPUT:  n         Dimension of the problem.
%         Delta     Trust region radius.
%         g         gradient of the model.
%         norm_g    norm of g.
%         gamma     Parameter of the wedge constraint.
%         Q, R      Q-R decomposition of the matrix D of displacements
%                   between satellites and current iterate (d_i = y_i - x).
%                   The last column of D MUST be the displacement between
%                   x and the leaving satellite.
% b spans orthogonal space to displacements d_1 ... d_{n-1} 
% OUTPUT: s         Solution.
%         flag      =  1  if the geometric condition was not active;
%                   =  2  if it was active
%                   = -1  if no reduction in the model could be obtained
%                         (i.e., pred <= 0).

%
% Marcelo Marazzi, 7/26/98.
% Updated notation and arguments 9/1/98.

gb = g'*b;

cond = gb / norm_g;   

if abs(cond) >= gamma
   s = - (Delta / norm_g) * g;
   flag = 1;
   betasol = 0;
else
   gbar = g / norm_g;      % Normalized for numerical reasons only.
   gbarb = gbar'*b;
   beta = roots([1-gamma^2, -2*gbarb*(1-gamma^2), (gbarb)^2-gamma^2]);
   if beta(1) < 0 & beta(2) < 0
      disp('LinSubProb: ERROR - both roots are negative.'); 
   elseif beta(1) > 0 & beta(2) > 0
      disp('LinSubProb: ERROR - both roots are positive.'); 
   else
      if gb < 0 
         if beta(1) > 0
            betasol = beta(1);
         else
            betasol = beta(2);  
         end
      elseif gb > 0
         if beta(1) < 0
            betasol = beta(1);
         else
            betasol = beta(2);  
         end   
      else                        % There are two solutions.
         betasol = beta(1);       % Pick any one.
         disp('LinSubProb: WARNING - Multiple solutions.'); 
      end
      s = ( Delta/norm(-gbar+betasol*b) ) * (- gbar + betasol * b);    
      flag = 2;
   end
end
pred = -g'*s;
if pred <= 0
   flag = -1;
end



