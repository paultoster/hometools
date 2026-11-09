function xnull = suche_alle_nullstellen(x,y,tol,dxraster)
%
% xnull = suche_alle_nullstelle(x,y,tol,dxraster)
% ---------------------------------------------------
% | Sucht alle Nullstelle von y=f(x) im Raster von dxraster
% | mit Sekantenverfahren (x muﬂ monoton steigend sein)
% | mit der Tolreanz tol un legt Vektor xnull an   
% ---------------------------------------------------

if ~is_monoton_steigend(x)
   error('x ist nicht monoton steigend')
end

maxschleifen = 100;
Toleranz = max(abs(tol),1e-20);
nxdim = length(x);

xnull = [];
i0 = 1;
x0 = x(i0);
y0 = y(i0);
while( abs(y0) < Toleranz )
    xnull = [xnull;x0];
    i0 = i0+1;
    x0 = x(i0);
    y0 = y(i0);
end
if( y0 > 0.0 )
    vorz0 = 1;
else
    vorz0 = 0;
end
while(1)

   if( x0 >= x(nxdim) )
       break;
   end
   x1 = min(x0 + dxraster,x(nxdim));
   for i = i0:nxdim
       if( x(i) >= x1 )
           i1 = i;
           x1 = x(i);
           break;
       end
   end
   y1 = y(i1);
   while( abs(y1) < Toleranz && i1 > i0+1)
        i1 = i1-1;
        x1 = x(i1);
        y1 = y(i1);
    end
   if( y1 > 0.0 )
        vorz1 = 1;
   else
        vorz1 = 0;
   end
   if( vorz0 ~= vorz1 && i0 ~= i1) % Nullstelle
       
       xv    = x(i0:i1);
       yv    = y(i0:i1);
       if( y1 ~= y0 )
            ystart = (y1*x0-y0*x1)/(y1-y0);
       else
           ystart = (x0+x1)/2;
       end
       xneu  = suche_nullstelle(xv,yv,Toleranz,ystart,1);
       xnull = [xnull;xneu];
   end
   i0    = i1;
   x0    = x1;
   y0    = y1;
   vorz0 = vorz1;
end
      