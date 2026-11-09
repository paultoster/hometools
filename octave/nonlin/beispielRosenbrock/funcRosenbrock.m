% -*- texinfo -*-
% @deftypefn {Function File} {} Rosenbrock (@var{x})
% Berechnet die Rosenbrockfunktion
% f(x1,x2) = 100*(x2-x1*x1)^2
% + (1-x1)^2
%
% @example
% @group
% f = Rosenbrock([0;1])
%      @result{} 101
% @end group
% @end example
%
% @seealso{}
% @end deftypefn

% Author: TB

function f = funcRosenbrock (x)
    global fcounter

    f = 100.0 * (x(2)-x(1)*x(1))^2 + (1.0 - x(1))^2;

	  % f = (4.0-x(1))^2 + (2.-x(2))^2

    fcounter = fcounter + 1;

end
