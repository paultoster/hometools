function    [ifound,dsmin] = contour_finde_naechsten_punkt(x0,y0,x,y,isearch)
%=====================================================================
%=====================================================================

% Finde in x(),y() den den isearch-ten Punkt zu x0,y0
% d.h. isearch = 1 nächster Punkt
%              = 2 zweit nächster Punkt etc.

ifound = 0;
n = length(x);
if( isearch > n )
    return
end

ds = [];

for i=1:n    
    ds(i) = sqrt( (x0-x(i))^2 + (y0-y(i))^2 );
end

[X,I] = sort(ds);

ifound = I(max(isearch,1));
dsmin  = X(max(isearch,1));
return
