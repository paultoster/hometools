function txt = vec_get_str(vec)
%
% txt = vec_get_str(vec)
%
% vec = [1,2;2,3;4,5];  => txt = '[1,2;2,3;4,5]';
%
if( ~isnumeric(vec) )
    error('Parameter vec is kein Double')
end

[nrow,ncol] = size(vec);

txt = '[';

for irow = 1:nrow
    
    for icol = 1:ncol
        
        txt = [txt,num2str(vec(irow,icol))];
        
        if( icol ~= ncol )
            
            txt = [txt,','];
        end
    end
    
    if( irow ~= nrow )
        
        txt = [txt,';'];
    end
end

     txt = [txt,']'];