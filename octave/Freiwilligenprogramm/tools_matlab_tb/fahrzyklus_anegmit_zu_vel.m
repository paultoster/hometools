function [velvec,accvec]=fahrzyklus_anegmit_zu_vel(vel,acc, delta_vel)
%
% [velvec,accvec]=anegmit_zu_vel(time,vel,acc)
% aus Geschwindigkeits-Verzögerungsprofil wird gemitteltes
% Profile berechnet
%
% vel           Vektor(n) mit Geschwindigkeitspunkten des Profils
% acc           Vektor(n) mit Beschleunigungspunkten des Profils
% delta_vel     Wertebereich für die Klasseneinteilung geschwindigkeit
%
% velvec        Vektor(m) mit Geschwindigkeit
% accvec        Vektor(m) mit Verzögerungen

n = length(vel);
v0 = 0.1/3.6;

m = ceil(max(vel)/delta_vel);

velvec = zeros(m,1);
accvec = zeros(m,1);
kvec   = zeros(m,1);
for i=1:n
    
    if( acc(i) < 0.0 && vel(i) > v0 )
        
        j = ceil(vel(i)/delta_vel);
        
        accvec(j) = accvec(j) + acc(i);
        kvec(j)   = kvec(j) + 1;
        
    end
end

for j=1:m
    
    velvec(j) = delta_vel*(j-0.5);
    
    if( kvec(j) > 0.5 )
        
        accvec(j) = accvec(j)/kvec(j);
    end
end

for j=1:m
    
    if( kvec(j) < 0.5 )
        
        if( j == 1 )
            
            for k=j+1:m
                
                if( kvec(k) > 0.5 )
                    for k1 = j+1:k
                        accvec(k1) = accvek(k);
                        kvec(k1)   = 1;
                    end
                    break
                end
            end
            
        elseif( letzter_wert_erreicht(kvec,j) )
            
            for k=j:m
                accvec(k) = accvek(j-1);
                kvec(k)   = 1;
            end
        else
            for k0 = j-1:1
                if( kvec(k0) > 0.5 )
                    break
                end
            end
            for k1 = j+1:m
                if( kvec(k0) > 0.5 )
                    break
                end
            end
            delta = accvec(k1)-accvec(k0);
            for k = k0+1:k1-1
                
                accvek(k) = accvek(k0)+delta*(k-k0)/(k1-k0);
                kvec(k)   = 1;
            end
        end
    end
end
%=====================================================
function flag_letzt = letzter_wert_erreicht(kvec,j0)
     
flag_letzt = 1;
for j = j0:length(kvec)
    
    if( kvec(j) > 0.5 )
        
        flag_letzt = 0;
        break
    end
end
        
        
        
        
        
        
        