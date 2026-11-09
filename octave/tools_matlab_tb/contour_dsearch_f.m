%version 1 TBert/TZS/3052 20050107
function zi = contour_dsearch_f(tri,xs,ys,x,y,z,xi,yi)

% Der Punkt liegt ausserhalb des Netzes:

% [i1,dsmin1] = contour_finde_naechsten_punkt(xi,yi,x,y,1); % nächster Punkt
% [i2,dsmin2] = contour_finde_naechsten_punkt(xi,yi,x,y,2); % zweitnächster Punkt
% 
% k = contour_dsearch_tri2(tri,i1,i2);
[k,dsmin1] = contour_finde_naechsten_punkt(xi,yi,xs,ys,1); % nächster Punkt
% kein Dreieck gefuden
if( isnan(k) )

    dx = x(i2)-x(i1);
    dy = y(i2)-y(i1);
    l  = sqrt(dx^2+dy^2);

    dx1 = x(i1)-xi;
    dy1 = y(i1)-yi;

    % dx2 = x(i2)-xi;
    % dy2 = y(i2)-yi;

    a1 = dx*dx1+dy*dy1;
    if( a1 < 0 ) % liegt vor Punkt 1
        a1 = 1;
        a2 = 0;
    elseif( a1 > l ) % liegt hinter Punkt 2
        a1 = 0;
        a2 = 1;
    elseif( l < 1e-8 )
        a1 = 1;
        a2 = 0;
    else
        a1 = a1/l;
        a2 = 1.0 - a1;
    end

    zi = a1*z(i1)+a2*z(i2);
% extrapoliere Dreicek    
else

    x1 = x(tri(k,1));
    x2 = x(tri(k,2));
    x3 = x(tri(k,3));
    y1 = y(tri(k,1));
    y2 = y(tri(k,2));
    y3 = y(tri(k,3));
    z1 = z(tri(k,1));
    z2 = z(tri(k,2));
    z3 = z(tri(k,3));            


    nenner = (x3-x2)*y1+(x1-x3)*y2+(x2-x1)*y3;

    if( abs(nenner) < eps )
        alpha = (z1+z2+z3)/3;
        beta = 0.;
        gamma = 0.;
    else
        alpha = ((x2*y3-x3*y2)*z1 + (x3*y1-x1*y3)*z2 + (x1*y2-x2*y1)*z3) / nenner;
        beta  = ((z2-z1)*y3 + (z1-z3)*y2 + (z3-z2)*y1) / nenner;
        gamma = ((z1-z2)*x3 + (z3-z1)*x2 + (z2-z3)*x1) / nenner;
    end

    zi = alpha+beta*xi+gamma*yi;
end

function itri = contour_dsearch_tri2(tri,i1,i2)

itri = NaN;
for i=1:length(tri)
    
    if( i1 == tri(i,1) || i1 == tri(i,2) || i1 == tri(i,3) )
        
        if( i2 == tri(i,1) || i2 == tri(i,2) || i2 == tri(i,3) )
            
            itri = i;
            return
        end
    end
end

% if( isnan(isearch) ) % Der Punkt liegt ausserhalb des Netzes:
% del_min =1e30;
%     isearch = 1;
% 
%     [m,n]=size(tri);
% 
% 
%              h1=figure;
%              plot(x,y,'o'), hold on
%              triplot(tri,x,y)
%              plot(xi,yi,'r+')
%     for i=1:m
%     
%         xs = ( x(tri(i,1))+x(tri(i,2))+x(tri(i,3)) )/3.;    
%         ys = ( y(tri(i,1))+y(tri(i,2))+y(tri(i,3)) )/3.;
%     
%         
%         del_xy = sqrt((xs-xi)^2 + (ys-yi)^2);
%     
%         plot([xs],[ys],'go')
%         text(xs,ys,[' ' num2str(del_xy)],'era','back');
% 
%         if( del_xy < del_min )
%             del_min = del_xy;
%             isearch = i;
%         end
%     end
%              triplot(tri(isearch,:),x,y,'red')             
%              close(h1)
% 
% end

