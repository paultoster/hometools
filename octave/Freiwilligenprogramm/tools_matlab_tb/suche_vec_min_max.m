function [s,ns] = suche_vec_min_max(y,delta_y_hyst)
%
% s = suche_vec_min_max(x,y,delta_y_min)
%
% Sucht Index mit Min und MAx mit Hysterese delta_y_hyst
% x               x-Vektor
% y               y-Vektor
% delta_y_hyst    Hysterese die mindestens zwischen min und max liegen muss
%                 (default: (ymax-ymin)/25
%
% s(i).index      der gefundene Index
% s(i).type       Typ: -1: Minumum
%                      +1: Maximum
% ns              Anzahl der min/max gefunden
%
  ns = 0;
  s  = [];
  n  = length(y);
  
  if( ~exist('delta_y_hyst','var') )
    delta_y_hyst = (max(y)-min(y))/25;
  end
  delta_y_hyst = abs(delta_y_hyst);
  
  y0 = y(1);
  steig = 0;
  for i=1:n
    
    if( steig > 1.5 )
      if( y(i) < y0-delta_y_hyst )
        ns          = ns + 1;
        s(ns).index = i0;
        s(ns).type  = +1;
        steig       = -1;
        y0          = y(i);
      elseif( y(i) > y0 )
        steig = +1;
        y0    = y(i);
      end
    elseif( steig > 0.5 )
      if( y(i) < y0 )
        i0 = i;
        steig = 2;
      else
        y0 = y(i);
      end
    elseif( steig < -1.5 )
      if( y(i) > y0+delta_y_hyst )
        ns          = ns + 1;
        s(ns).index = i0;
        s(ns).type  = -1;
        steig       = +1;
        y0          = y(i);
      elseif( y(i) < y0 )
        steig = -1;
        y0    = y(i);
      end
    elseif( steig < -0.5 )
      if( y(i) > y0 )
        i0 = i;
        steig = -2;
      else
        y0 = y(i);
      end
    else
      if( y(i) > y0+delta_y_hyst )
        steig = 1;
        y0    = y(i);
      elseif( y(i) < y0-delta_y_hyst )
        steig = -1;
        y0    = y(i);
      end
    end
  end
end
  