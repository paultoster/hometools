function flag = isfigure(htest)
%
% flag = isfigure(htest)
%
% Schautnach, ob figure htest vorhanden ist
fhandles = sort(get_fig_numbers);
flag = 0;
for i = 1:length(fhandles)
    
    if( htest == fhandles(i) )
        flag = 1;
        break;
    end
end