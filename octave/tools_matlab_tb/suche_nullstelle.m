function xnull = suche_nullstelle(x,y,tol,x0,noraster)
%
% xnull = suche_nullstelle(x,y,tol,x0,noraster)
% ---------------------------------------------------
% | xnull = suche_nullstelle(x,y)
% | xnull = suche_nullstelle(x,y,tol)
% | xnull = suche_nullstelle(x,y,tol,x0)
% | xnull = suche_nullstelle(x,y,tol,x0,noraster)
% | 
% | Sucht Nullstelle von y=f(x) mit Sekantenverfahren
% | (x muß monoton steigend sein)
% | mit der Tolreanz tol   (default=0.1)
% | und dem Anfangswert x0 (default=x(1))
% | noraster = 0  keine Rasterung (default=1)
% | noraster = 1  Rasterung (default=1)
% ---------------------------------------------------
% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% 17.01.01 TBert 1. Version aus Matrixx
% 30.05.06 TBert 1.1 is_monoton_steigend korrigiert
Version = 1.1;
xnull = [];
if nargin == 0
   fprintf('---------------------------------------------------\n')
   fprintf('| (Version %5.3f)\n',Version)
   fprintf('| xnull = suche_nullstelle(x,y)\n')
   fprintf('| xnull = suche_nullstelle(x,y,tol)\n')
   fprintf('| xnull = suche_nullstelle(x,y,tol,x0)\n')
   fprintf('| xnull = suche_nullstelle(x,y,tol,x0,noraster)\n')
   fprintf('| \n')   
   fprintf('| Sucht Nullstelle von y=f(x) mit Sekantenverfahren\n')
   fprintf('| (x muß monoton steigend sein)\n')
   fprintf('| mit der Tolreanz tol   (default=0.1)\n')
   fprintf('| und dem Anfangswert x0 (default=x(1))\n')
   fprintf('| noraster = 0  keine Rasterung (default=1)\n')
   fprintf('| noraster = 1  Rasterung (default=1)\n')
   fprintf('---------------------------------------------------\n')
   return    
elseif nargin == 1
   fprintf('---------------------------------------------------\n')
   fprintf('| xnull = suche_nullstelle(x,y)\n')
   fprintf('| xnull = suche_nullstelle(x,y,tol)\n')
   fprintf('| xnull = suche_nullstelle(x,y,tol,x0)\n')
   fprintf('| xnull = suche_nullstelle(x,y,tol,x0,noraster)\n')
   fprintf('| Zu wenige Argumente\n')
   error('---------------------------------------------------\n')
elseif nargin == 2
   tol = 0.001;
   x0  = x(1);
   noraster = 1;
elseif nargin == 3
   x0  = x(1);
   noraster = 1;
else
   noraster = 1;
end

if ~is_monoton_steigend(x)
   error('x ist nicht monoton steigend')
end


maxschleifen = 100;
Toleranz = max(abs(tol),1e-20);
nxdim = length(x);

dxRaster = x(nxdim)-x(1);

if( min(y)*max(y) >Toleranz )
    fprintf('Keine Nullstelle im Wertebereich vorhanden\n')
    return
end

for j=1:1000,
   
   x0        = max(x0,x(1));
   y0        = interp1(x,y,x0,'linear');
   if( noraster == 1 )
       x1 = x(nxdim);
       y1 = interp1(x,y,x1,'linear');
       xmin = x(1);
       xmax = x(nxdim);
   else
    dxRaster  = dxRaster/10;
    FoundFlag = 0;	
    EndFlag   = 0;
   
    while EndFlag == 0,
      
      x1 = x0 + dxRaster;
      if x1 >= x(nxdim),
         x1 = x(nxdim);
         EndFlag = 1;
      end
      y1 = interp1(x,y,x1,'linear');
      
      if y0*y1 < 0.0,
         FoundFlag = 1;
         xmin = x0;
         xmax = x1;
         EndFlag = 1;
      else
         x0 = x1;
         y0 = y1;
      end
      
    end
   
    if FoundFlag == 0,
      fprintf('Keine Nullstelle im Wertebereich durch Raster gefunden\n')
      fprintf('eventuell Stuetzstellenzahl erhöhen\n')
      return
    end
   end
   FounfFlag = 0;
   i = 0;
   while i < maxschleifen,
      i  = i+1;
      dy = y1-y0;
      dx = x1-x0;
      if abs(dy) <= Toleranz | abs(dx) <= 1e-20,
         FoundFlag = 1;
         i = maxschleifen;
      else         
         x2 = x1 - y1/dy*dx;
         if x2 < xmin,
            x2 = xmin;
         elseif x2 > xmax,
            x2 = xmax;
         end
         y2 = interp1(x,y,x2,'linear');
         
         x0 = x1;
         y0 = y1;
         x1 = x2;
         y1 = y2;
      end
   end
   
   if FoundFlag == 1 & abs(y1) <= Toleranz,
      xnull = x1;
      return
   end
   
   x0 = xmin;
end

% Sekantenverfahren hat nicht gefunden also suchen
for i=2:length(y)
    
    if( y(i-1)*y(i) <= 0 )

        if( abs(y(i)-y(i-1)) < 1e-20 )
            xnull = x(i-1);
        else
            xnull = (y(i)*x(i-1)-y(i-1)*x(i))/(y(i)-y(i-1));
        end
        return
    end
end
      