function flag = ist_monton_steigend(vek)
%
% flag = ist_monton_steigend(vek)
% Ergebnis 1(true) oder 0(false)
flag = 0;
if( isnumeric(vek) )
    
    [n,m]=size(vek);
    
    if( n < m )
        vek = vek';
        dum = n;
        n   = m;
        m   = dum;
    end
        
    flag = 1;
    for i=1:m
        dvek = diff(vek(1:n,i));
        dmin = min(dvek);
        if( dmin < 0.0 ) % Steigung ist negativ

            flag = 0;
            return
        end
    end
end
        
