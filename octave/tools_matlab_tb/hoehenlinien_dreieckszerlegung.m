function [tri,x,y,z] = hoehenlinien_dreieckszerlegung(S,plot_flag)
%
% [tri,x,y,z] = hoehenlinien_dreieckszerlegung(S)
% 
% S(i).x        x-Vektor der iten-Hoehenlinie
% S(i).y        y-Vektor der iten-Hoehenlinie
% S(i).z        Hoehenwert oder -vektor der iten-Hoehenlinie

% n-Netze berechnen
tri = [];
x = [];
y = [];
z = [];
sec0 = [];
sec1 = [];

n = length(S);

for i=1:n
    
    x = [x;S(i).x];
    y = [y;S(i).y];
    if( length(S(i).z) == 1 )
        z = [z;S(i).z+S(i).x*0.0];
    else
        z = [z;S(i).z];
    end
    
    if( i == 1 )
        sec0 = [sec0;1];
        sec1 = [sec1;length(S(i).x)];
    else
        sec0 = [sec0;sec1(i-1)+1];
        sec1 = [sec1;sec1(i-1)+length(S(i).x)];
    end
end
for i=1:n-1
     tri0 = contour_netz_erstellen_f(sec0(i),x(sec0(i):sec1(i)),y(sec0(i):sec1(i)), ...
                                    sec0(i+1),x(sec0(i+1):sec1(i+1)),y(sec0(i+1):sec1(i+1)), ...
                                    plot_flag);
    
    
    tri = [tri;tri0];
end

% Prüfen, ob letze Höhenlinie geschlossen ist und mehr als ein Punkt ist
delta = sqrt( (x(sec1(n))-x(sec0(n)))^2 + (y(sec1(n))-y(sec0(n)))^2 );
if( delta < 1e-16 &&  sec0(n) ~= sec1(n) ) % geschlossener Kreis
    
    % Mittelpunkz suchen
    xmit = 0.0;
    ymit = 0.0;
    for i=sec0(n):sec1(n)
        
        xmit = xmit + x(i);
        ymit = ymit + y(i);
    end
    
    xmit = xmit/(sec1(n)-sec0(n)+1);
    ymit = ymit/(sec1(n)-sec0(n)+1);
    
    x = [x;xmit];
    y = [y;ymit];
    z = [z;S(n).z(1)];
     
    tri0 = contour_netz_erstellen_f(sec0(n),x(sec0(n):sec1(n)),y(sec0(n):sec1(n)), ...
                                    sec1(n)+1,x(sec1(n)+1:sec1(n)+1),y(sec1(n)+1:sec1(n)+1), ...
                                    plot_flag);
    
    
    tri = [tri;tri0];
end   
    
    
% % Prüfen ob entlang einer inneren Höhenlinie immer zwei DReieck für jede
% % Strecke zu finden ist?
% 
% for i=2:n-1
%     
%     index = [s_c(i).offset+1:1:s_c(i+1).offset]';
%     for j=2:length(index)-1
% 
%         ifound = seg_find_with(index(j-1),index(j),tri);
%         if( (ifound == 1) )
%             if( i == 5 & j == 26 )
%                 fprintf('i=%i, j=%i \n,',i,j);
%             end
%             [index1,index2] = find_opennet_with(index(j),tri);
%             tri = [tri;[index1,index(j),index2]];
%             if( index1 == 0 | index2 == 0)
%                 fprintf('i=%i, j=%i index1=%i, index(j)=%i, index2=%i\n,',i,j,index1,index(j),index2);
%             end
%         end
%     end
% end
%fprintf('min(tri) = %i \n',min([min(tri(:,1));min(tri(:,2));min(tri(:,3))]));
