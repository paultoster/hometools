function y = step_function(x,x0,x1,y0,y1,type)
%
% y = step_function(x,x0,x1,y0,y1,type)
% Übergangsfunktion von y0 auf y1 über x1-x0 
% type = 'default': (Defaulteinstellung)
%
% y = y0 wenn                                   x <= x0
%   = y0+(y1-y0) * ((x-x0)/(x1-x0))^2 
%                * {3-2*[(x-x0)/(x1-x0)]}  x0 < x <  x1
%   = y1                                        x >= x1
%
if( ~exist('type','var') )
    type = 'default';
end
y = x*0;
for i=1:length(x)
    switch(type)
        case 'default'
            if( x(i) <= x0 )
                y(i) = y0;
            elseif( x(i) >= x1 )
                y(i) = y1;
            else
                y(i) = y0 + (y1-y0) * ((x(i)-x0)/(x1-x0))^2 ...
                         * (3.0-2.0*(x(i)-x0)/(x1-x0));
            end
        otherwise
            error(sprintf('step_function_error:type= %s falsch',type));
    end
end