function [zi,found_flag] = contour_berechne_z_aus_tri(x,y,z,tri,xi,yi,xs,ys)
%
% [zi,found_flag] = contour_berechne_z_aus_tri(x,y,z,tri,xi,yi)
% [zi,found_flag] = contour_berechne_z_aus_tri(x,y,z,tri,xi,yi,xs,ys)
%
% Berechnet zu xi,yi den Hoehenpunkt zi aus tri-Matrix mit Netz x,y und z
% wenn vorhanden im Netz, dann found_flag = 1 ansonsten = 0
% wenn found_flag = 0 und Schwerpunktvektoren xs,ys sind auch vorhanden,
% dann wird daraus der nächste Punkt berechnet ansonsten ist zi = NaN
%

k = contour_tsearch(x,y,tri,xi,yi);

if( isnan(k) )
    if( exist('xs','var') && exist('ys','var') )
        zi = contour_dsearch_f(tri,xs,ys,x,y,z,xi,yi);
    else
        zi = NaN;
    end
    found_flag = 0;
else
    found_flag = 1;
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
        beta  = 0.;
        gamma = 0.;
    else
        alpha = ((x2*y3-x3*y2)*z1 + (x3*y1-x1*y3)*z2 + (x1*y2-x2*y1)*z3) / nenner;
        beta  = ((z2-z1)*y3 + (z1-z3)*y2 + (z3-z2)*y1) / nenner;
        gamma = ((z1-z2)*x3 + (z3-z1)*x2 + (z2-z3)*x1) / nenner;
    end

    zi = alpha+beta*xi+gamma*yi;
end