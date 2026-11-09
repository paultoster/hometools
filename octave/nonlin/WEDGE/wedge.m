function [x,f,inform,k,nf,nAct,nActRed] = wedge(x,f,gamma,pname)
% [x,f,inform,k,nf,nAct,nActRed] = WEDGE(x,f,gamma,pname)
% minimizes a nonlinear function of n > 1 variables using only function
% values.
%
% Input parameters:
% x             initial guess
% f             function value at x
% gamma         real value in interval (0, 1) (width of wedge).
% pname         problem name (e.g., 'ROSENBR')
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
fout = OpenOutFiles(pname);       % Open output file .out 
printVersion(fout,Version);
setSpecs;                         % Read in Specs file
n = length(x);
f0 = f;        % Store initial obj value (used in stopping test).
%
% Set the number of satellites m.
%
if AlgOptn == 'Linear'
   m = n;
elseif AlgOptn == 'Quadra'
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
D = initialSat(x, Delta, m, inSatOptn, AlgOptn);
%
% Evaluate f at each satellite
%
fY = zeros(m,1);
for l = 1:m
    fY(l) = fcn(x + D(:,l),CuteProb);
end
nf = nf + m;
%
% Check whether some of the initial satellites have 
% lower value than x1. If so, swap with x1.  
%
[fYmin,lmin] = min(fY);
printX1(fout,f,fYmin,pname);
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
printIter(k,nf,f,Delta,iterType,gamma,[],[],...
      [],infoWedge,fout,inform,iPrint,DeltaTol,ITERMAX,fminimum)
%
% Main Loop
%
while inform == 0
    k = k + 1;
%
%   Stopping test
%
    inform = CanWeStop(Delta,k,nf,f,DeltaTol,ITERMAX,...
                       FEVALMAX,fminimum,f0,tol_fmin);

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
    [g,G,b,B] = model(D,fY-f,lOut,AlgOptn,n,m);
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
    if AlgOptn == 'Quadra'
       [s,infoWedge,pred,redQ_tr,s_tr,iter,par,theta,gamma,infoGqtpar] = ...
          quadSubProb(g,G,Delta,B,b,gamma,dTheta,subpTechnique,...
          rtol,atol,maxit,par,fracOptRed);
    elseif AlgOptn == 'Linear'
       [s,pred,theta,infoWedge] = LinSubProb(m,Delta,g,norm_g,gamma,b);
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
    fplus = fcn(xplus,CuteProb);
    nf = nf + 1;
%
%   Trust region active ?
%
    norm_s = norm(s);
    if (norm_s >= (1-rtol)*Delta) & (norm_s <= (1+rtol)*Delta)    
       flagTR = 'AC';
    else
       flagTR = 'IN';
    end
%
%   Update Delta according to trust region rules.
% 
    ared = f - fplus;
    Delta = radius(Delta,ared,pred,flagTR,norm_s,rtol,alpha1,...
                   alpha2,gamma1,gamma2,optnRad);
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

printIter(k,nf,f,Delta,iterType,gamma,theta,flagTR,...
  norm_g,infoWedge,fout,inform,iPrint,DeltaTol,ITERMAX,fminimum)

end % of "while".

printExitStatus(inform,DeltaTol,ITERMAX,fminimum,iPrint,fout);

fclose('all');








