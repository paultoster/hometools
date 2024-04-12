function index = val_in_liste(value,liste, tol)
%
% index = val_in_liste(value,liste [,tol])
% ist der wert in der Liste, tol=1e-8 (default)
% Output index > 0 wenn enthalten(indexnummer), ansonsten 0
if( ~exist('tol','var') )
    tol = 1e-8;
end

index = 0;
if( isnumeric(value) & isnumeric(liste) )
    
    for i=1:length(liste)
        
        if( abs(value-liste(i)) <= tol )
            index = i;
            break;
        end
    end
elseif( iscell(liste) )
    
    for i=1:length(liste)
        
        if( isnumeric(value) & isnumeric(liste{i}) ...
          & abs(value-liste(i)) <= tol )
            index = i;
            break;
        elseif( ischar(value) & ischar(liste{i}) ...
          & strcmp(value,liste{i}) )
            index = i;
            break
        end
    end
else
    error('Den typ des Inputs ist nicht im Code entahleten')
end
