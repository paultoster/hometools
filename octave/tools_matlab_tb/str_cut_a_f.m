function str = str_cut_a_f(str,del_str)
%
% str = str_cut_a_f(str,del_str)
%
% Schneide del_str aus str am Anfang aus
%
% z.B.  txt = str_cut_a_f('|abc|','|')
% => txt = 'abc|'
%
l1 = length(del_str);
l2 = length(str);

% Wenn del_str an erster Stelle gefunden wird
while( min(strfind(str,del_str)) == 1 )
    
    % wird dieser gelöscht 
    if( l1 < l2 )
        str = str(l1+1:l2);
    else
        str = '';
    end
    l2 = length(str);
end