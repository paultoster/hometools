function   [a,b] = schnittpunkt_2geraden_f(P1,e1,P2,e2);
%
% Lösung für Schnittpunkt zweier Geraden dreidimesional
%
% 1. Gerade Punkt P1 Richtungsvektor e1
% 2. Gerade Punkt P2 Richtungsvektor e2
%
% P = P1 + e1 * a = P2 + e2 * b
%
% a,b sind Skalare
%
[n,m]=size(e1);
if(m>n)
    e1=e1';
end
[n,m]=size(e2);
if(m>n)
    e2=e2';
end
[n,m]=size(P1);
if(m>n)
    P1=P1';
end
[n,m]=size(P2);
if(m>n)
    P2=P2';
end

A = [e1'
     e2'
     (P1-P2)'];
 
 if( abs(det(A)) > 1e-6 )
     
     fprintf('P = P1       + e1    * a'); 
     fprintf('P1 = [%12.8g;%12.8g;%12.8g,]',P1(1),P1(2),P1(3)); 
     fprintf('e1 = [%12.8g;%12.8g;%12.8g,]',e1(1),e1(2),e1(3)); 
     fprintf(' '); 
     fprintf('P = P2       + e2    * b'); 
     fprintf('P2 = [%12.8g;%12.8g;%12.8g,]',P2(1),P2(2),P2(3)); 
     fprintf('e2 = [%12.8g;%12.8g;%12.8g,]',e2(1),e2(2),e2(3)); 
     
     error(' Die Geraden mit P1+e1*a und P2+e2*b haben keinen Schnittpunkt');
 end
found_flag = 0;
for i=1:3
    for j=1:3
        if( i ~= j )
            w1 = e1(i)*e2(j)-e1(j)*e2(i);
            
            if( abs(w1) > 1e-8 & ~found_flag )
                
                b = ( e1(j)*(P2(i)-P1(i)) - e1(i)*(P2(j)-P1(j)) ) / w1;
                found_flag = 1;
                break
            end
        end
    end
end

if( ~found_flag )
     fprintf('P = P1       + e1    * a'); 
     fprintf('P1 = [%12.8g;%12.8g;%12.8g,]',P1(1),P1(2),P1(3)); 
     fprintf('e1 = [%12.8g;%12.8g;%12.8g,]',e1(1),e1(2),e1(3)); 
     fprintf(' '); 
     fprintf('P = P2       + e2    * b'); 
     fprintf('P2 = [%12.8g;%12.8g;%12.8g,]',P2(1),P2(2),P2(3)); 
     fprintf('e2 = [%12.8g;%12.8g;%12.8g,]',e2(1),e2(2),e2(3)); 
     
    error('Es konnte keine Lösung gefunden werden !!!!!')
end

found_flag = 0;
for i=1:3
    if( abs(e1(i)) > 1e-8 )
        found_flag = 1;
        a = ( P2(i)-P1(i)+e2(i)*b)  / e1(i);
    end
end

if( ~found_flag )
     fprintf('P = P1       + e1    * a'); 
     fprintf('P1 = [%12.8g;%12.8g;%12.8g,]',P1(1),P1(2),P1(3)); 
     fprintf('e1 = [%12.8g;%12.8g;%12.8g,]',e1(1),e1(2),e1(3)); 
     fprintf(' '); 
     fprintf('P = P2       + e2    * b'); 
     fprintf('P2 = [%12.8g;%12.8g;%12.8g,]',P2(1),P2(2),P2(3)); 
     fprintf('e2 = [%12.8g;%12.8g;%12.8g,]',e2(1),e2(2),e2(3)); 
     
    error('Es konnte keine Lösung gefunden werden !!!!!')
end

