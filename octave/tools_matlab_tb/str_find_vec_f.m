function  index = str_find_vec_f(c_text,text_such,einmal_flag)
%
% index = find_val_in_vec(c_text,text_such,einmal_flag)
%
% Sucht text_such in array c_text:
% Gibt den gefundenen array-Index zurück (auch meherere Stellen)
% wenn nicht gefunden, dann 0 zurückgegeben
% Wenn einmal_flag gesetzt, dann sucht er nur einmal

if( nargin < 3 )
    einmal_flag = 0;
end

index = [];
len = length(c_text);
found_flag = 0;
for i=1:len
    if( strcmp(text_such,c_text{i}) )
        index = [index,i];
        found_flag = 1;
    end
    if( found_flag & einmal_flag )
        break
    end
end
if( length(index) == 0 )
    index = 0;
else
    index = index';
end

        
    
    
    