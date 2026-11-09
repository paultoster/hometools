function [s,info,redQ,redQ_tr,s_tr,iter,par,theta,gamma,infoGqtpar] = ...
quadSubProb(g,G,Delta,B,b,gamma,dTheta,subpTechnique,rtol,atol,maxit,...
par,fracOptRed)
% quadSubProb solves the subproblem
% 
%  min g'*s + 1/2*s'*G*s  
%  s.t.
%  |b'*s + 1/2*s'*B*s| >= gamma*sqrt(||s||^2 + 1/2*||s*s'||^2)
%                     ||s|| <= Delta
%
% where ||.|| denotes the Euclidean norm for vectors and the
% Frobenius norm for matrices. It assumes that the input 
% quantities b, B are normalized, so that
% sqrt(||b||^2 + 1/2*||B||^2)) = 1.
% It uses the Minpack routine gqtpar.
%
% Non obvious INPUT parameters:
%
% G, B                     symmetric matrices of order n.    
% dTheta                   increment in the rotation angle.
% rtol, atol, maxit, par   gqtpar parameters.
%
% OUTPUT parameters:
%
% s                        solution found.
% 
% info                      information about the computed solution.
%      info =  1            Wedge not active.
%      info =  2            Wedge active. Not shrunk.
%      info =  3            Wedge active. Shrunk.
%      info = -1            No reduction in the model could be obtained.
%
%    
% redQ                     reduction attained by s.
% reqQ_tr                  reduction attained by the gqtpar step
%                          that solves the trust region (without 
%                          the wedge) problem. 
% iter,par,infoGqtpar      gqtpar outputs.
% theta                    angle that the trust region step was 
%                          rotated.
% gamma                    final value of gamma (same as input if 
%                          info = 1, 2; smaller than input if info = 3).
%                                            

% NB: taboo can be done more efficiently in terms of cos and sin. 

%
% Solve the TR subproblem without the wedge constraint.
%
[s_tr,redQ_tr,par,iter,z,infoGqtpar] = gqtpar(G,g,Delta,rtol,atol,maxit,par);
if infoGqtpar == 3
   warning('gqtpar: Rounding errors prevent further progress.')
elseif infoGqtpar == 4
   warning('gqtpar: Number of iterations has reached maxit.')
end
%
% Check whether the wedge constraint is satisfied
%
Bs_tr = B*s_tr;  
norm_step = norm(s_tr);
tabooSurfaceValue = taboo(s_tr,Bs_tr,b);
theta = 0;
funnyNorm_s_tr = funnyNorm(s_tr,norm_step);
wedgeRHS = gamma*funnyNorm_s_tr;
if abs(tabooSurfaceValue) >= wedgeRHS              % Wedge constr satisfied :)
   s = s_tr;
   redQ = redQ_tr;
   info = 1;
else                                          % Wedge constr. not satisfied :(
%%%%%%%%%%%%%% Begin Rotation Technique %%%%%%%%%%%%%%%%
   if subpTechnique == 'RTTN'
%  Compute eta, scale, orthogonalize and orient it. 
      eta = Bs_tr + b;
      eta = norm_step/norm(eta) * eta;
      eta = eta - s_tr'*eta / (norm_step^2) * s_tr;
%     Orient it.
      if tabooSurfaceValue < 0
         eta = -eta;
      end
%
%  Rotate s_tr.
%
      reachedDT = 0; reachedWorstRedQ = 0;
      etaGeta = eta'*G*eta;
      worstRedQ = fracOptRed * redQ_tr;
%
%  Quantities to compute q
%
      gs_tr = g'*s_tr; geta = g'*eta; Gs_tr = G*s_tr;
      s_trGs_tr = s_tr'*Gs_tr; etaGs_tr = eta'*Gs_tr;
      while (reachedDT == 0) & (reachedWorstRedQ == 0)
          theta = theta + dTheta;
          s = cos(theta)*s_tr + sin(theta)*eta;
          Bs = B*s;  % ! this can be done much more efficiently
          tabooSurfaceValue = taboo(s,Bs,b);
          funnyNorm_s = funnyNorm(s,norm_step);
          wedgeRHS = gamma*funnyNorm_s;
          if abs(tabooSurfaceValue) >= wedgeRHS
             reachedDT = 1;
          end
%
%         Evaluate q at each theta 
%
          redQ =  redQ_theta(theta,gs_tr,geta,s_trGs_tr,etaGeta,etaGs_tr);
          if redQ >= worstRedQ
             reachedWorstRedQ = 1;
          end
      end
      info = 2;
      if (reachedWorstRedQ == 1) & (reachedDT == 0) 
         gamma = abs(tabooSurfaceValue) / funnyNorm_s;      % Reduce gamma.
         info = 3;
      end
%%%%%%%%%%%%%%% End Rotation Technique %%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% Begin Dogleg Technique %%%%%%%%%%%%%%%%%%%
   elseif  subpTechnique == 'DGLG'
      reachedDT = 0; theta = 1; wedgeMax = -inf;
%
%     Compute Cauchy step sC
%
      [alpha,Gg,gg,gGg] = cauchy(g, G, Delta);
      sC = -alpha*g; d = s_tr - sC;

%     Constants needed later
      BsC = B*sC; Bd = B*d; gd = g'*d; Gd = G*d; dGd = d'*Gd; 
      if (-alpha*Gg + g)'*d <= 0      % \nabla(sC)'*(s_tr - sC)
         Case = 'EASY';
      else
         Case = 'HARD';
      fprintf('============= DgLg: Hard Case\n')
%
%    Compute thetaWorst in (0, 1] at which red(sC) is attained.
%
         resQ_sC = alpha*gg - 0.5 * alpha^2 * gGg; 
         thetaWorst = max(roots([resQ_sC, gd, 0.5*dGd]));
         if thetaWorst <= 0
	    error('thetaWorst is non positive')
         end
      end
      theta = theta - dTheta;
      WeAreAtTheEndOfThePath = 0;
      while (WeAreAtTheEndOfThePath == 0) & (reachedDT == 0)
            if theta == 0
%
%     We're at sC: this is the last pass through loop
%
               WeAreAtTheEndOfThePath = 1;  
            end
            s = sC + theta*d;
            norm_s = norm(s);
            Bs = BsC + theta*Bd;
            tabooSurfaceValue = taboo(s,Bs,b);
            wedgeLHS = abs(tabooSurfaceValue);
            funnyNorm_s = funnyNorm(s,norm_s);
            wedgeRHS = gamma*funnyNorm_s;
            wedge_s = wedgeLHS - wedgeRHS;
            if wedgeLHS >= wedgeRHS
               reachedDT = 1;     % Reached wedge boundary: exit loop
            elseif wedge_s >= wedgeMax
               wedgeMax = wedge_s;          % Record point that best
               wedgeLHSWedgeMax = wedgeLHS; % satisfies wedge 
               funnyNormWedgeMax = funnyNorm_s;
               thetaWedgeMax = theta; 
            end
            theta = max(theta - dTheta, 0);  % Trick so that the lowest
                                             % value be exactly zero
%
%     In the HARD case, search only for theta in {0} U [thetaWorst, 1]
%
            if (Case == 'HARD') & (theta < thetaWorst)
               theta = 0;  % Jump ahead to the end of path
            end
      end     % of while
%
%     If wedge boundary was reached, return current s. Otherwise,
%     return step that best satisfied wedge and close wedge a bit.
%
      info = 2;
      if reachedDT == 0
         theta = thetaWedgeMax;
         s = sC + theta*d;
         gamma = wedgeLHSWedgeMax / funnyNormWedgeMax;
         info = 3;
      end
%
%     Compute model reduction at solution found
%
      redQ = alpha*gg - theta*gd - 0.5*alpha^2*gGg ...
       - 0.5*theta^2*dGd - theta*sC'*Gd;
%
% For printing purposes only, reparametrize path (to be 
% consistent with ROTTN technique, theta = 0 should correspond 
% to s_tr, and theta = 1 to sC).
%
theta = 1 - theta;
%%%%%%%%%%%%%%% End Dogleg Technique %%%%%%%%%%%%%%%%%%%%%
   end % of elseif  subpTechnique == 'DGLG'
end
if redQ <= 0
   info = -1;
end



