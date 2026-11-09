function f = fcn(x,CuteProb)
% f = fcn(x,CuteProb) returns the function value in f at x.
% CuteProb = 1: If you're running a CUTE problem.
%            0: If you're minimizing a user-defined function
%               (defined in user_ufn.m).
 
if CuteProb == 1        % Call CUTE tool.
   f = ufn(x);
elseif CuteProb == 0 	% Call User's function
   f = user_ufn(x);
else
   error('fcn: Wrong value of variable CuteProb.');
end

