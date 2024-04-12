function a_out = elim_zeile(a_in,izeile)
%
% a_out = elim_zeile(a_in,izeile);
%
% Eliminiert Zeile aus Matrix, Vektor
% a = [0,1,2,3,4,5,6];
% b = elim_zeile_spalte_f(a,1,3);
% a = a';
% c = elim_zeile_spalte_f(a,3);

[m,n] = size(a_in);
% Zeilen eliminieren
if( izeile >= 1 && izeile <= m )
    
    if( izeile == 1 )
        a_in = a_in(2:m,:);
    elseif( izeile == m )
        if( m == 1 )
            a_in = [];
        else
            a_in = a_in(1:m-1,:);
        end
    else
        a_in = [a_in(1:izeile-1,:);a_in(izeile+1:m,:)];
    end
end

a_out = a_in;

