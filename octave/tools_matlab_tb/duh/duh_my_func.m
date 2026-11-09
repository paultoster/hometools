% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function [d,u,h] = duh_my_func(d,u,h)

% Neue Daten hinzufügen, immer auch uniit hinzufügen !!!!

if( isfield(d,'Timer_1_1') )
    d.time = d.Timer_1_1;
    if( isfield(u,'Timer_1_1') )
        u.time = u.Timer_1_1;
    else
        u.time = 's';
    end
end


% Header

len = length(h);
h{len+1} = 'Bearbeitet mit duh_my_func';