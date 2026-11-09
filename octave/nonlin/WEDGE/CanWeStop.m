function infoStop = ...
       CanWeStop(Delta,iterNo,nf,f,DeltaTol,ITERMAX,FEVALMAX,fminimum,f0,tol_fmin)
%
% infoStop = CanWeStop()
% evaluates the stopping criteria.
%      * trust region radius < DeltaTol                (infoStop =  1)
%      * number of iterations >= ITERMAX               (infoStop =  2)
%      * f - fminimum <= tol_fmin*(f0 - fminimum)      (infoStop =  3)
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
elseif (isfinite(fminimum)) & (fRounded <= fminimum + tol_fmin * (f0 - fminimum))
   infoStop = 3;
else
   infoStop = 0;
end


