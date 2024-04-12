function [x,f,inform,k,nf,nAct,nActRed,dfnorm] = optnlin_nbegrenzt_TRW(x,f,o)
% [x,f,inform,k,nf,nAct,nActRed] = WEDGE(x,f,opt)
% minimizes a nonlinear function of n > 1 variables using only function
% values.
%
% Input parameters:
% x             initial guess
% f             function value at x
% o.gamma         real value in interval (0, 1) (width of wedge).
%
% (Other input parameters are initialized in the specs file setSpecs.m.)
%
% Output parameters:
% x             solution found
% f             function value at the solution found x 
% inform        the algorithm stops if either of the following
%               three criteria is met:
%      - trust region radius < DeltaTol                (inform =  1)
%      - number of iterations >= ITERMAX               (inform =  2)
%      - numer of function evaluations >= FEVALMAX     (infoStop =  4)
%      - relative stopping test 
%        (f - fminimum)/(f0 - fminimum) <= tol_fmin           
%        satisfied                                     (inform =  3) 
%      - relative stopping test dfnorm <= err          (inform = 5)
%      - no further progress can be made               (inform = -1)
% k             total nimber of iterations
% nf            total number of function evaluations
% nAct          number of times the wedge was active (and its width 
%               was *not* reduced)
% nActRed       number of times the wedge was active (and its width 
%               was reduced)
%
% Marcelo Marazzi, Northwestern University, 1999.

  Version = '04-Sep-2001';
  %fout = OpenOutFiles(pname);       % Open output file .out 
  %printVersion(fout,Version);
  n = length(x);
  f0 = f;        % Store initial obj value (used in stopping test).
  df = 0.;
  dfnorm = o.err*10;
  %
  % Set the number of satellites m.
  %
  if o.AlgOptn == 'Linear'
     m = n;
  elseif o.AlgOptn == 'Quadra'
     m = (n+1)*(n+2)/2 - 1;
  else
     error('Wrong value of AlgOptn in the specs file')
  end
  nf = 1;        % To account for the evaluation at the initial point.
  k = 0; inform = 0; nAct = 0; nActRed = 0;
  infoWedge = 1; iterType='?';   % So that they won't be undef 
  infoGqtpar = []; flagTR = [];  % when printing the 1st iter.
  %
  % Form initial satellite set
  %
  D = TrustRegionWedge_initialSat(x, o.Delta, m, o.inSatOptn, o.AlgOptn);
  %
  % Evaluate f at each satellite
  %
  fY = zeros(m,1);
  for l = 1:m
      fY(l) = o.func(x + D(:,l));
  end
  nf = nf + m;
  %
  % Check whether some of the initial satellites have 
  % lower value than x1. If so, swap with x1.  
  %
  [fYmin,lmin] = min(fY);
  %printX1(fout,f,fYmin,pname);
  if fYmin < f
     x = x + D(:,lmin); D(:,lmin) = -D(:,lmin); 
     for l = [1:lmin-1,lmin+1:m]
         D(:,l) = D(:,l) + D(:,lmin);
     end
     fY(lmin) = f; f = fYmin;
  end
  %
  % 0th iteration
  %
%   printIter(k,nf,f,Delta,iterType,gamma,[],[],...
%         [],infoWedge,fout,inform,iPrint,DeltaTol,ITERMAX,fminimum)
  TrustRegionWedge_printHeader(o.fid);
  TrustRegionWedge_printIter(k,nf,f,o.Delta,iterType,o.gamma,[],[],...
        [],infoWedge,1,inform,1,o.DeltaTol,o.ITERMAX,o.fminimum)

  %
  % Main Loop
  %
  while inform == 0
      k = k + 1;
  %
  %   Stopping test
  %
  if( k > 1000 )
    abc=0;
  end
      inform = TrustRegionWedgeCanWeStop(o.Delta,k,nf,f,dfnorm,o.DeltaTol,o.ITERMAX,...
                         o.FEVALMAX,o.fminimum,f0,o.tol_fmin,o.err);

      if inform > 0
         break        
      end
  %
  %   Find the farthest satellite
  %
      distanceMax = -inf;
      for l = 1:m
          distance = norm(D(:,l));
          if distance > distanceMax
             lMax = l;
             distanceMax = distance;
          end
      end
      lOut = lMax;     % Pick leaving satellite.
  %
  %   Form model
  %
      [g,G,b,B] = TrustRegionWedge_model(D,fY-f,lOut,o.AlgOptn,n,m);
      norm_g = norm(g);
  %
  %   Plot Stuff 1
  %
  %   gammaPlot = gamma;      % Store gamma (it may be reduced by quadSubProb)
  %
  %   End Plot Stuff 1
  %

  %
  %   Solve subproblem.
  %
      if( strcmp(o.AlgOptn,'Quadra') )
         [s,infoWedge,pred,redQ_tr,s_tr,iter,o.par,theta,gamma,infoGqtpar] = ...
            TRW_quadSubProb(g,G,o.Delta,B,b,o.gamma,o.dTheta,o.subpTechnique,...
            o.rtol,o.atol,o.maxit,o.par,o.fracOptRed,o.fid);
      elseif( strcmp(o.AlgOptn,'Linear') )
         [s,pred,theta,infoWedge] = TRWLinSubProb(m,o.Delta,g,norm_g,o.gamma,b,o.fid);
      end
  %
  %   Plot Stuff 2
  %
  %    onceMore = 'y';
  %    while onceMore == 'y'
  %          curves(g,G,b,B,gammaPlot,Delta,redQ_tr,s_tr,pred,pname,infoWedge)
  %          gammaPlot = input('Enter value of gamma [None]: ');
  %          if isempty(gammaPlot)
  %             onceMore = 'n';
  %          end
  %    end
  %
  %   End Plot Stuff 2
  %
      if infoWedge == 2        % Wedge active; not shrunk
         nAct = nAct + 1;     
      elseif infoWedge == 3    % Wedge active, shrunk
         nActRed = nActRed + 1;
      elseif infoWedge == -1   % No reduction in the model obtained.
  %      inform = -1;          % ! Reduce Delta and continue.
  %      break                 
      end
  %
  %   Evaluate f 
  %
      xplus = x + s;
      fplus = o.func(xplus);
      nf = nf + 1;
  %
  %   Trust region active ?
  %
      norm_s = norm(s);
      if (norm_s >= (1-o.rtol)*o.Delta) && (norm_s <= (1+o.rtol)*o.Delta)    
         flagTR = 'AC';
      else
         flagTR = 'IN';
      end
  %
  %   Update Delta according to trust region rules.
  % 
      ared = f - fplus;
      o.Delta = TRW_radius(o.Delta,ared,pred,flagTR,norm_s,o.rtol,o.alpha1,...
                     o.alpha2,o.gamma1,o.gamma2,o.optnRad);
  %
  %   Update satellite set and iterate.
  %
      if fplus < f                     % Successful 
         iterType = 'OK';
  %
  %      Update displacements (now from xplus).
  %
         D(:,lOut) = -s;
         D(:,[1:lOut-1,lOut+1:m]) = -s*ones(1,m-1) + D(:,[1:lOut-1,lOut+1:m]);
         fY(lOut) = f;
         dfnorm   = ared/not_zero(norm_s);
         x = xplus;
         f = fplus;
          
      else                              % Unsuccessful 
         if norm(D(:,lOut)) >=  norm_s  % Trial point enters satellite set   
            iterType = 'Rej+';
            D(:,lOut) = s;
            fY(lOut) = fplus;
         else                           % Trial point discarded
            iterType = 'Rej ';
         end
      end

%      printIter(k,nf,f,Delta,iterType,gamma,theta,flagTR,...
%        norm_g,infoWedge,fout,inform,iPrint,DeltaTol,ITERMAX,fminimum)
      if( (k < 10) || (mod(k,o.iterout) == 0) )
        TrustRegionWedge_printIter(k,nf,f,o.Delta,iterType,o.gamma,theta,flagTR,...
          norm_g,infoWedge,o.fid,inform,1,o.DeltaTol,o.ITERMAX,o.fminimum)
      end
  end % of "while".

%   printExitStatus(inform,DeltaTol,ITERMAX,fminimum,iPrint,fout);
  TRW_printExitStatus(inform,o.DeltaTol,o.ITERMAX,o.fminimum,1,o.fid,dfnorm);

%   fclose('all');
end
function D = TrustRegionWedge_initialSat(x, Delta, m, inSatOptn, AlgOptn)
% 
% D = initialSat(x,Delta,inSatOptn) creates m = (n+1)*(n+2)/2 - 1 
% displacements so that y_l \equiv x + D(:,l) be used as initial
% satellite set.
% 
% inSatOptn = 'Splx'  Vertices and midpoints of random simplex in R^n.
% inSatOptn = 'Rand'  Randomly chosen in the interval [-Delta, Delta].
% inSatOptn = 'Debg'  Fixed simplex.

  n = length(x);

  if( strcmp(inSatOptn,'Rand') )
  %
  % Generate m random sample points around the current iterate
  % within the initial trust region.
  %
     D = rand(n,m);
     D = Delta * D + (ones(n,m) - D)*(-Delta);
  elseif( strcmp(inSatOptn,'Splx') || strcmp(inSatOptn,'Debg') )
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
         if( strcmp(inSatOptn,'Splx') )       % simplex in random orthant
            plusOrMinus =  (-1)^round(10*rand);
            D(i,i) = plusOrMinus * Delta;
         elseif( strcmp(inSatOptn,'Debg') )  % simplex in first orthant
            D(i,i) = Delta;
         end
     end
  %  
  %  Only for AlgOptn = 'Quadra':
  %  Set D(:, n+1:n+c) to the midpoints between each vertex different from the 
  %  starting point on the edges of the simplex; here c is the combinatorial number 
  %  n-choose-2. (Points "o" in the figure.)
  %  
     if( strcmp(AlgOptn,'Quadra') )
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
end
function TrustRegionWedge_printHeader(fout)
            
  fid = fout; 	
  ffprintf(fid,' iter  nf     f         Delta     type    wedge    gamma    theta     tr     ||g||\n');
  ffprintf(fid,'-----------------------------------------------------------------------------------\n');
end
function TrustRegionWedge_printIter(iterNo,nf,f,Delta,iterType,gamma,theta,flagTR,...
              norm_g,infoWedge,fout,inform,iPrint,DeltaTol,ITERMAX,fminimum)
%
% Function that prints some iteration info.
% iPrint: 0  No output 
%         1  Only to file 
%         2  To file and screen 

  if infoWedge == 1
     iWedge = 'Inac';
  elseif infoWedge == 2
     iWedge = 'Act';
  elseif infoWedge == 3
     iWedge = 'ActRed';
  elseif infoWedge == -1
     iWedge = 'pred<=0';
  else
     error('printIter: Unknown value of infoWedge.')
  end

  fid = fout; 	
  for i=1:iPrint
     if iterNo == 0                % partial output at very first iteration
           ffprintf(fid,'%4i %4i %12.5e %9.2e           \n',...
           [iterNo, nf, f, Delta]);
     else
        ffprintf(fid,'%4i %4i %12.5e %9.2e %5s %8s %9.1e %9.1e %4s %10.2e\n',...
               [iterNo, nf, f, Delta], iterType, iWedge, gamma, theta, flagTR, norm_g);
     end

     fid = 1;  % Go back and print the same to the screen.
  end
end
function infoStop = ...
       TrustRegionWedgeCanWeStop(Delta,iterNo,nf,f,dfnorm,DeltaTol, ...
       ITERMAX,FEVALMAX,fminimum,f0,tol_fmin,err)
%
% infoStop = CanWeStop()
% evaluates the stopping criteria.
%      * trust region radius < DeltaTol                (infoStop =  1)
%      * number of iterations >= ITERMAX               (infoStop =  2)
%      * f - fminimum <= tol_fmin*(f0 - fminimum)      (infoStop =  3)
%      * dfnorm <= err                                 (infoStop =  5)
%      * numer of function evaluations >= FEVALMAX     (infoStop =  4)
%      * none of the above                             (infoStop  = 0)
%
% InfoStop = 3 is checked to 5 significant digits.
%

  %
  % The values of f and fminimum must have the same number of 
  % significant digits, say 5. Otherwise, if e.g. 
  % f = 1.0000000000000000001 and fminimum = 1.0000,
  % "f <= fminimum"  wouldn't evaluate to TRUE!)
  % Do the same with all the relevant quantities for consistency.
  %
  fString = num2str(f,'%12.4e');     % The '4' in '%12.4e' indicates      
  fRounded = str2double(fString);    % five significant digits.

  fString = num2str(f0,'%12.4e');     
  f0Rounded = str2double(fString);   

  fString = num2str(fminimum,'%12.4e');    
  fminRounded = str2double(fString);   

  %t = 5;                 % Number of digits in fminimum
  if Delta < DeltaTol
     infoStop = 1; 
  elseif iterNo >= ITERMAX
     infoStop = 2;
  elseif nf >= FEVALMAX
     infoStop = 4;
  %elseif (isfinite(fminimum)) & (f - fminimum <= 0.5 * 10^(1-t) * abs(fminimum))
  %   infoStop = 3;
  elseif (isfinite(fminimum)) && (fRounded <= fminimum + tol_fmin * (f0 - fminimum))
     infoStop = 3;
  elseif( dfnorm <= err )
     infoStop = 5;
  else
     infoStop = 0;
  end
end
function [g,G,b,B] = TrustRegionWedge_model(D,df,lOut,AlgOptn,n,m)
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
end
function [s,info,redQ,redQ_tr,s_tr,iter,par,theta,gamma,infoGqtpar] = ...
TRW_quadSubProb(g,G,Delta,B,b,gamma,dTheta,subpTechnique,rtol,atol,maxit,...
par,fracOptRed,fid)
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
  [s_tr,redQ_tr,par,iter,z,infoGqtpar] = mex_gqtpar(G,g,Delta,rtol,atol,maxit,par);
  if infoGqtpar == 3
     ffprintf(fid,'gqtpar: Rounding errors prevent further progress.\n');
  elseif infoGqtpar == 4
     ffprintf(fid,'gqtpar: Number of iterations has reached maxit.\n');
  end
  %
  % Check whether the wedge constraint is satisfied
  %
  Bs_tr = B*s_tr;  
  norm_step = norm(s_tr);
  tabooSurfaceValue = b'*s_tr + 0.5*s_tr'*Bs_tr;

  theta = 0;
  funnyNorm_s_tr = sqrt(norm_step^2 + 1/2*norm(s_tr*s_tr','fro')^2);

  wedgeRHS = gamma*funnyNorm_s_tr;
  if abs(tabooSurfaceValue) >= wedgeRHS              % Wedge constr satisfied :)
     s = s_tr;
     redQ = redQ_tr;
     info = 1;
  else                                          % Wedge constr. not satisfied :(
  %%%%%%%%%%%%%% Begin Rotation Technique %%%%%%%%%%%%%%%%
     if( strcmp(subpTechnique,'RTTN') )
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
        while( (reachedDT == 0) && (reachedWorstRedQ == 0) )
            theta = theta + dTheta;
            s = cos(theta)*s_tr + sin(theta)*eta;
            Bs = B*s;  % ! this can be done much more efficiently
            tabooSurfaceValue = b'*s + 0.5*s'*Bs;
            funnyNorm_s = sqrt(norm_step^2 + 1/2*norm(s*s','fro')^2);
            wedgeRHS = gamma*funnyNorm_s;
            if abs(tabooSurfaceValue) >= wedgeRHS
               reachedDT = 1;
            end
  %
  %         Evaluate q at each theta 
  %
            redQ =  TRW_redQ_theta(theta,gs_tr,geta,s_trGs_tr,etaGeta,etaGs_tr);
            if redQ >= worstRedQ
               reachedWorstRedQ = 1;
            end
        end
        info = 2;
        if( (reachedWorstRedQ == 1) && (reachedDT == 0) )
           gamma = abs(tabooSurfaceValue) / funnyNorm_s;      % Reduce gamma.
           info = 3;
        end
  %%%%%%%%%%%%%%% End Rotation Technique %%%%%%%%%%%%%%%%%%%

  %%%%%%%%%%%%%%% Begin Dogleg Technique %%%%%%%%%%%%%%%%%%%
     elseif( strcmp(subpTechnique,'DGLG') )
        reachedDT = 0; theta = 1; wedgeMax = -inf;
  %
  %     Compute Cauchy step sC
  %
        [alpha,Gg,gg,gGg] = TRW_cauchy(g, G, Delta);
        sC = -alpha*g; d = s_tr - sC;

  %     Constants needed later
        BsC = B*sC; Bd = B*d; gd = g'*d; Gd = G*d; dGd = d'*Gd; 
        if (-alpha*Gg + g)'*d <= 0      % \nabla(sC)'*(s_tr - sC)
           Case = 'EASY';
        else
           Case = 'HARD';
           ffprintf('============= DgLg: Hard Case\n')
  %
  %    Compute thetaWorst in (0, 1] at which red(sC) is attained.
  %
           resQ_sC = alpha*gg - 0.5 * alpha^2 * gGg; 
           thetaWorst = max(roots([resQ_sC, gd, 0.5*dGd]));
           if( thetaWorst <= 0 )
             error('thetaWorst is non positive')
           end
        end
        theta = theta - dTheta;
        WeAreAtTheEndOfThePath = 0;
        while( (WeAreAtTheEndOfThePath == 0) && (reachedDT == 0) )
              if theta == 0
  %
  %     We're at sC: this is the last pass through loop
  %
                 WeAreAtTheEndOfThePath = 1;  
              end
              s = sC + theta*d;
              norm_s = norm(s);
              Bs = BsC + theta*Bd;
%               tabooSurfaceValue = taboo(s,Bs,b);
              tabooSurfaceValue = b'*s + 0.5*s'*Bs;
              wedgeLHS = abs(tabooSurfaceValue);
%               funnyNorm_s = funnyNorm(s,norm_s);
              funnyNorm_s = sqrt(norm_s^2 + 1/2*norm(s*s','fro')^2);
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
              if( strcmp(Case,'HARD') && (theta < thetaWorst) )
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
end
function [s,pred,betasol,flag] = TRWLinSubProb(m,Delta,g,norm_g,gamma,b,fid)
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
        ffprintf(fid,'LinSubProb: ERROR - both roots are negative.'); 
     elseif beta(1) > 0 & beta(2) > 0
        ffprintf(fid,'LinSubProb: ERROR - both roots are positive.'); 
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
           ffprintf(fid,'LinSubProb: WARNING - Multiple solutions.\n'); 
        end
        s = ( Delta/norm(-gbar+betasol*b) ) * (- gbar + betasol * b);    
        flag = 2;
     end
  end
  pred = -g'*s;
  if pred <= 0
     flag = -1;
  end
end
function Delta = TRW_radius(Delta,ared,pred,flagTR,norm_s,rtol,alpha1,alpha2,gamma1,gamma2,optnRad)
% Delta = radius(Delta, rho, alpha1, alpha2, gamma1, gamma2) updates
% the trust-region radius Delta.

  % alpha1 < alpha2 < 1      
  % gamma1 < 1 < gamma2      

  % Check parameters.

  if (alpha2 >= 1) || (alpha1 >= alpha2) || (gamma2 <= 1) ||...
  (gamma1 >= 1) 
  error('radius: Wrong parameters alpha1, alpha2, gamma1, gamma2')
  end

  % Update radius.

  if( strcmp(optnRad,'STEP') )
     rho = ared/pred;
     if rho < alpha1      
        Delta = gamma1 * norm_s;      % reduce
     elseif( (rho > alpha2) && strcmp(flagTR,'AC'))
        Delta = gamma2 * Delta;      % enlarge
     end
  elseif( strcmp(optnRad,'SIMP') )
     rho = ared/pred;
     if rho < alpha1      
        Delta = gamma1 * Delta;      % reduce
     elseif rho > alpha2         
        Delta = gamma2 * Delta;      % enlarge
     end
  elseif( strcmp(optnRad,'DECR') )
     if ared <= 0 
        Delta = gamma1 * norm_s;      % reduce
     elseif( (ared > 0) && strcmp(flagTR,'AC') )
        Delta = gamma2 * Delta;      % enlarge
     end
  end

  % Note: if rho \in [alpha1, alpha2], no change.
end
function TRW_printExitStatus(inform,DeltaTol,ITERMAX,fminimum,iPrint,fout,dfnorm)
%
% At the end of the run, print exit status
%
  fid = fout; 
  for i=1:iPrint
     if inform == 1 
        ffprintf(fid,'\nSTOP: Trust region radius < DeltaTol = %9.2e\n\n', DeltaTol);
     elseif inform == 2
        ffprintf(fid,'\nSTOP: Number of iterations  >= ITERMAX = %4i\n\n', ITERMAX);
     elseif inform == 3
        ffprintf(fid,'\nSTOP: Objective value satisfies relative stopping test  w.r.t. f* = %9.2e\n\n', fminimum);
     elseif inform == 5
        ffprintf(fid,'\nSTOP: gradient satisfies relative stopping test  w.r.t. dfnorm = %9.2e\n\n', dfnorm);
     elseif inform == -1
        ffprintf(fid,'\nSTOP: No further progress can be made.\n\n');
     end
     fid = 1;  % Go back and print the same to the screen.
  end

end
function [alpha,Gg,gg,gGg] = TRW_cauchy(g, G, Delta)

  Gg = G*g;
  gGg = g'*Gg;
  gg = g'*g;
  norm_g = sqrt(gg);
  if gGg > 0
     alpha = min(gg/gGg, Delta/norm_g);
  else
     if gGg == 0 
        ffprintf(2,'Curvature along g is zero\n');
     end
     alpha = Delta/norm_g;
  end
end
function red = TRW_redQ_theta(theta,gs,geta,sGs,etaGeta,etaGs)

  c = cos(theta); s = sin(theta);
  red = -(c*gs + s*geta + 0.5*c^2*sGs + 0.5*s^2*etaGeta+ c*s*etaGs);
end