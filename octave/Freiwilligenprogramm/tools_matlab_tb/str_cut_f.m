function  text_new = str_cut_f(text_string,text_such,regel)
%
% text_new = str_cut_f(text_string,text_such,regel)
%
% Sucht text_such in text_string nach der Regel und schneidet den Text raus:
% 'a' alle (default)
% 'v' vorwärts einmal
% 'r' rückwärts einmal

if( nargin == 2 )
    
    regel = 'a';
end

go_on = 1;
while( go_on )
	i = strfind(text_string,text_such);
	l1 = length(text_string);
	l2 = length(text_such);
	
	% nichts gefunden
	if length(i) == 0
        text_new = text_string;
        break;
	end

	% String Suchen First
	if( (regel(1) == 'v') | (regel(1) == 'V') )
        ielim = min(i);
        go_on = 0;
        
	elseif( (regel(1) == 'r') | (regel(1) == 'R') )
        ielim = max(i);
        go_on = 0;
	else
        ielim = min(i);
        go_on = 1;
	end
	
	if( ielim == 1 )
        text_new = text_string(ielim+l2:l1);
    elseif( ielim+l2 > l1 )
        text_new = text_string(1:ielim-1);
    else
        text_new = [text_string(1:ielim-1),text_string(ielim+l2:l1)];
    end
    
    if( go_on )
        text_string = text_new;
    end
end
    