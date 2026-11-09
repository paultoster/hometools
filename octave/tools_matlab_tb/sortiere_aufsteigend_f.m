function    liste_out = sortiere_aufsteigend_f(liste)
% vec_out = sortiere_aufsteigend_f(vec)
% Sortiert Vektor
liste_out = [];
[n,m] = size(liste);
flag = 0;
if( m > n )
  flag = 1;
  liste = liste';
end
while( ~isempty(liste) )
    
    [y,index] = min(liste);
    
    ident_flag = 0;
    
    for i=1:length(liste_out)
        
        if( abs(y-liste_out(i)) < 1e-9 )
            ident_flag = 1;
        end
        
    end
    if( ~ident_flag )
        liste_out = [liste_out;y];
    end
    
    for i=1:length(index)
        
        if( index(i) == 1 )
            
            liste = liste(2:length(liste));
            
        elseif( index(i) == length(liste) )
            
            liste = liste(1:length(liste)-1);
        else
            
            liste = [liste(1:index(i)-1);liste(index(i)+1:length(liste))];
        end
        
        for j=i+1:length(index)
            index(j) = index(j)-1;
        end
    end
    if( flag )
      liste_out = liste_out';
    end
end
    