function val = not_zero(val,eps)
%
% val = not_zero(val,[eps])
%
% Minimiert Wert auf eps, wenn eps nicht angegeben:
% => eps = 1e-20
%
%
if( isnumeric(val) )
    
    if( ~exist('eps','var') )
        eps = 1e-20;
    end

    [nrow,ncol] = size(val);
    
    for irow=1:nrow
        
        for icol=1:ncol
            
            if( val(irow,icol) >= 0.0 )
                
                val(irow,icol) = max(eps,val(irow,icol));
            else
                val(irow,icol) = min(-eps,val(irow,icol));
            end
        end
    end
end

