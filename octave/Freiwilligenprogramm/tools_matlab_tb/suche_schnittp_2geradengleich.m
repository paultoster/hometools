function [okay,xa,ya] = suche_schnittp_2geradengleich(x0,y0,calpha0,salpha0,x1,y1,calpha1,salpha1)
%
%         x = x0 + r0 * calpha0
%         y = y0 + r0 * salpha0
%         x = x1 + r1 * calpha1
%         y = y1 + r1 * salpha1
%
%                - ca1 (y0 - y1) - sa1 x1 + sa1 x0
%         [[r0 = ---------------------------------, 
%                        ca1 sa0 - ca0 sa1
%                - ca0 (y0 - y1) - sa0 x1 + sa0 x0
%           r1 = ---------------------------------]]
%                        ca1 sa0 - ca0 sa1

  okay = 0;
  x    = 0.;
  y    = 0.;
  
  nen  = calpha1*salpha0-calpha0*salpha1;
  
  if( abs(nen) > eps )
    okay = 1;
    r0 = (salpha1*(x0-x1) - calpha1*(y0-y1))/nen;
    % r1 = (salpha0*(x0-x1) - calpha0*(y0-y1))/nen;
    
    xa = x0 + r0 * calpha0;
    ya = y0 + r0 * salpha0;
    
  end
 
  
end
