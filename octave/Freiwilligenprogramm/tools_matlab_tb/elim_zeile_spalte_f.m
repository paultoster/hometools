function a_out = elim_zeile_spalte_f(a_in,izeile,ispalte)
%
% a_out = elim_zeile_spalte_f(a_in,izeile,ispalte);
%
% Eliminiert Zeile oder Spalte aus Matrix, Vektor
% a = [0,1,2,3,4,5,6];
% b = elim_zeile_spalte_f(a,1,3);
% a = a';
% c = elim_zeile_spalte_f(a,3);

if( ~exist('ispalte','var') )
    
    ispalte = 1;
end

[m,n] = size(a_in);
elim_flag = 0;
% Zeilen eliminieren
if( izeile >= 1 && izeile <= m )
    
    elim_flag = 1;
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

if( ispalte >= 1 && ispalte <= n )
    
    elim_flag = 1;
    if( ispalte == 1 )
        a_in = a_in(:,2:n);
    elseif( ispalte == n )
        if( n == 1 )
            a_in = [];
        else
            a_in = a_in(:,1:n-1);
        end
    else
        a_in = [a_in(:,1:ispalte-1),a_in(:,ispalte+1:n)];
    end
end

if( ~elim_flag )
    fprintf('elim_zeile_spalte_f_warning: Vorsicht keine Zeile oder Spalte gelöscht\n')
    fprintf(' izeile = %i   zu löschende zeile\n',izeile); 
    fprintf(' ispalte = %i   zu löschende spalte\n',ispalte); 
    fprintf(' m = %i   Zeilenlänge input\n',m); 
    fprintf(' n = %i   Spaltenlänge input\n',n);
    a_out = [];
else
    a_out = a_in;
end
