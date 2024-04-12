function k = contour_tsearch(x,y,tri,xi,yi)
%
% k = contour_tsearch(x,y,tri,xi,yi)
%
% Sucht zu den Punkten x,y das passende Dreieck tri(k,1)-tri(k,2)-tri(k,3)
% In dem der Punkt (xi,yi) zu finden ist, wenn nich vorhanden, dann ist ist 
% k = NaN isnan(k)
% 

k = NaN;

for i=1:length(tri)
    
    found = contour_tsearch_triangle(x(tri(i,1)),y(tri(i,1)) ...
                                ,x(tri(i,2)),y(tri(i,2)) ...
                                ,x(tri(i,3)),y(tri(i,3)) ...
                                ,xi,yi);
                            
    if( found )
        k = i;
        return
    end
end

function found = contour_tsearch_triangle(x1,y1,x2,y2,x3,y3,xi,yi)

found = 0;

tol = 1e-6;

%Abstand 1-2,2-3,3-1
r12 = sqrt((y2-y1)^2+(x2-x1)^2);
r23 = sqrt((y3-y2)^2+(x3-x2)^2);
r31 = sqrt((y1-y3)^2+(x1-x3)^2);

% Punkt
if( r12 <= tol && r23 <= tol ) 
    
    r = sqrt((y2-yi)^2+(x2-xi)^2);
    if( r <= tol )
        found = 1;
    end

% Linie 1-3
elseif( r12 <= tol && r31 > tol )
    
    [m,b,flag] = contour_tsearch_triangle_koef(x3,y3,x1,y1,tol);

    if( (flag && abs(m*xi+b - yi) <= tol) || (~flag && abs(xi-x1) <= tol ) )
        
        found = 1;
    end
% Linie 1-2
elseif( r23 <= tol && r12 > tol )
    
    [m,b,flag] = contour_tsearch_triangle_koef(x1,y1,x2,y2,tol);

    if( (flag && abs(m*xi+b - yi) <= tol) || (~flag && abs(xi-x2) <= tol ) )
        
        found = 1;
    end
% Linie 3-1
elseif( r31 <= tol && r23 > tol )
    
    [m,b] = contour_tsearch_triangle_koef(x2,y2,x3,y3,tol);

    if( (flag && abs(m*xi+b - yi) <= tol) || (~flag && abs(xi-x3) <= tol ) )
        
        found = 1;
    end
% Fläche
else

    % Schwerpunkt
    xs = (x1+x2+x3)/3;
    ys = (y1+y2+y3)/3;
    % Geraden
    [m(1),b(1),flag(1)] = contour_tsearch_triangle_koef(x1,y1,x2,y2,tol);
    x(1)                = x1;
    [m(2),b(2),flag(2)] = contour_tsearch_triangle_koef(x2,y2,x3,y3,tol);
    x(2)                = x2;
    [m(3),b(3),flag(3)] = contour_tsearch_triangle_koef(x3,y3,x1,y1,tol);
    x(3)                = x3;

    % Vorzeichen 1: größer 0: kleiner
    for i = 1:3
        if( flag(i) )
            if( ys > m(i)*xs+b(i) )
                v(i) = 1;
            else
                v(i) = 0;
            end
        else
            if( xs > x(i) )
                v(i) = 1;
            else
                v(i) = 0;
            end
        end
    end

    % Auswerten Geradenungleichung aller drei Geraden
    i0 = 0;
    found = 1;
    for i = 1:3
        if( flag(i) )
            if( (v(i) && yi > m(i)*xi+b(i)) || (~v(i) && yi <= m(i)*xi+b(i)) )
                i0 = i0 + 1;
            end
        else
            if( (v(i) && xi > x(i)) || (~v(i) && xi <= x(i)) )
                i0 = i0 + 1;
            end
        end
        if( i0 < i )
            found = 0;
            break;
        end
    end
end

function [m,b,flag] = contour_tsearch_triangle_koef(x1,y1,x2,y2,tol)

if( abs(x2-x1) <= tol )
    flag = 0;
    m    = 0;
    b    = 0;
else
    flag = 1;
    m = (y2-y1)/(x2-x1);
    b = y1-m*x1;
end