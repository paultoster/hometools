% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function    liste_out = sortiere_abfallend_f(liste)
liste_out = [];
while( length(liste) > 0 )
    
    [y,index] = max(liste);
    
    ident_flag = 0;
    
    for i=1:length(liste_out)
        
        if( abs(y-liste_out(i)) < 1e-9 )
            ident_flag = 1;
        end
        
    end
    if( ~ident_flag )
        liste_out = [liste_out,y];
    end
    
    for i=1:length(index)
        
        if( index(i) == 1 )
            
            liste = liste(2:length(liste));
            
        elseif( index(i) == length(liste) )
            
            liste = liste(1:length(liste)-1);
        else
            
            liste = [liste(1:index(i)-1),liste(index(i)+1:length(liste))];
        end
        
        for j=i+1:length(index)
            index(j) = index(j)-1;
        end
    end
end
    