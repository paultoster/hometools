function Delta = radius(Delta,ared,pred,flagTR,norm_s,rtol,alpha1,alpha2,gamma1,gamma2,optnRad)
% Delta = radius(Delta, rho, alpha1, alpha2, gamma1, gamma2) updates
% the trust-region radius Delta.

% alpha1 < alpha2 < 1      
% gamma1 < 1 < gamma2      

% Check parameters.

if (alpha2 >= 1) | (alpha1 >= alpha2) | (gamma2 <= 1) |...
(gamma1 >= 1) 
error('radius: Wrong parameters alpha1, alpha2, gamma1, gamma2')
end

% Update radius.

if optnRad == 'STEP'
   rho = ared/pred;
   if rho < alpha1      
      Delta = gamma1 * norm_s;      % reduce
   elseif (rho > alpha2) & (flagTR == 'AC')
      Delta = gamma2 * Delta;      % enlarge
   end
elseif optnRad == 'SIMP'
   rho = ared/pred;
   if rho < alpha1      
      Delta = gamma1 * Delta;      % reduce
   elseif rho > alpha2         
      Delta = gamma2 * Delta;      % enlarge
   end
elseif optnRad == 'DECR'
   if ared <= 0 
      Delta = gamma1 * norm_s;      % reduce
   elseif (ared > 0) & (flagTR == 'AC')
      Delta = gamma2 * Delta;      % enlarge
   end
end
                  
% Note: if rho \in [alpha1, alpha2], no change.
