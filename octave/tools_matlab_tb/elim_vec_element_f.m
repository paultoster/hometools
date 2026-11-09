function a_out = elim_vec_element_f(a_in,istart,istop)
%
% a_out = elim_vec_element_f(a_in,istart);
% a_out = elim_vec_element_f(a_in,istart,istop);
%
% a_in     Vektor,Matrix oder struktur: 
%                              Es wird die Zeilen von istart:istop eliminiert, 
%                              wenn min istart-Zeilen vorhanden, wenn nicht,
%                              werden die Spalten von istart:istop eliminiert
%                              wenn min istart-Spalten, ansonsten wird
%                              nichts gemacht
% istart kann mit 1 beginnen
%
% a_out    Ergebnis

if( ~exist('istop','var') ) 
    istop = istart;
end
if( istart > istop )
    i      = istart;
    istart = istop;
    istop  = i;
end

[m,n] = size(a_in);
if( m > 1 && istart <= m) % Spaltenvektor oder Matrix
    
    if( istart <= 1 )
        
        if( istop >= m )
            a_out = [];
        else
            a_out = a_in(istop+1:m,:);
        end
    elseif( istop >= m )
        
        a_out = a_in(1:istart-1,:);
    else
        a_out = [a_in(1:istart-1,:);a_in(istop+1:m,:)];
    end
elseif( m == 1 && istart <= n) % Zeilenvektor
    
    if( istart <= 1 )
        
        if( istop >= n )
            a_out = [];
        else
            a_out = a_in(istop+1:n);
        end
    elseif( istop >= n )
        
        a_out = a_in(1:istart-1);
    else
        a_out = [a_in(1:istart-1),a_in(istop+1:n)];
    end
else
    a_out = a_in;
end
