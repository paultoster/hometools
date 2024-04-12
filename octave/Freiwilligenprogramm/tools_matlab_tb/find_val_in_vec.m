function  index_liste = find_val_in_vec(vec,val,tol)
%
% index_liste = find_val_in_vec(vec,val,tol)
%
% Sucht Wert val in Vektor vec innerhalb der Toleranz tol (def:1e-6):
% Gibt index_liste als vektor zurück, wenn nicht gefunden index = [] if( index )
% geht.

index_liste = [];

if( isempty(vec) )
  return;
end

if( ~isnumeric(vec) )
    error('find_val_in_vec: vec von find_val_in_vec(vec,val,tol) muß numerisch sein');
end
if( ~isnumeric(val) )
    error('find_val_in_vec: val von find_val_in_vec(vec,val,tol) muß numerisch sein');
end
if( ~exist('tol','var') )
    tol = 1.0e-6;
else
    tol = abs(tol);
end

[nrow,ncol] = size(vec);
nval = length(val);
nvec = nrow*ncol;
for i=1:nvec
    for j = 1:nval
        if( abs(vec(i)-val(j)) < tol )
            index_liste(length(index_liste)+1) = i;
        end
    end
end
if( length(index_liste) == 0 )
    index_liste = [];
else
    index_liste = index_liste';
end

        
    
    
    