function n = anzahl_werte(vek,vorschrift,schwelle,epsilon)
%
% n = anzahl_werte(vek,vorschrift,schwelle,epsilon)
%
% Anzahl Werte auf Vektor vek, die nach der Vorschrift die vorgegebene Schwelle erfüllen
% epsilon (default eps) wird nur für <=,==,>= benutzt
%
% vorschrift        '<','<=','==','>=','=='
%
if(  ~exist('epsilon','var') )
    
    epsilon = eps;
end
n = 0;
m = length(vek);

switch(vorschrift)
    
    case '<'
        
        for i=1:m
            
            if( vek(i) < schwelle )
                n = n+1;
            end
        end
    case '<='
        schwelle = schwelle + epsilon
        for i=1:m
            
            if( vek(i) <= schwelle )
                n = n+1;
            end
        end
    case '=='
        for i=1:m
            
            if( abs(vek(i)-schwelle) <= epsilon )
                n = n+1;
            end
        end
    case '>='
        schwelle = schwelle - epsilon
        for i=1:m
            
            if( vek(i) >= schwelle )
                n = n+1;
            end
        end
    case '>'
        for i=1:m
            
            if( vek(i) > schwelle )
                n = n+1;
            end
        end
end
        
        
        