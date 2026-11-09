% -*- texinfo -*-
% @deftypefn {Function File} {} diffRosenbrock (@var{x})
% Berechnet die Ableitung von Rosenbrock funktion
%
% @example
% @group
% 
%      @result{} 
% @end group
% @end example
%
% @seealso{}
% @end deftypefn

% Author: TB

function dfdx = diffRosenbrock (x)

    global dfcounter
    
    dfdx = [-400.0*x(1)*(x(2)-x(1)*x(1)) - 2.0*(1.0-x(1)); ...
            200.0*(x(2)-x(1)*x(1))];

    dfcounter = dfcounter + 1;

