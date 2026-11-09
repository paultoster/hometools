function [delta_x,delta_y] = vek_2d_diff_freenet(xTra,yTra,alphaTra,xEgo,yEgo,freenetv)
%
% [delta_x,delta_y] = vek_2d_diff_freenet(xTra,yTra,alphaTra,xEgo,yEgo,freenetv)
%
% xTra,yTra,alphaTra      Punkt und Winkel der Trajektorie
% xEgo,yEg0               Punkte des Ego.Fzg
% freenetv                0: freenet-Koordinaten: Abweichung Ego - Tra,
%                            dy positiv wenn in Richtung alpha Ego links
%                            von Tra, dx positiv wenn in alpha Ego vor Tra
%                         1: gespiegelte-Koordinaten: Abweichung Tra - Ego,
%                            dy positiv wenn in Richtung alpha Ego rechts
%                            von Tra, dx positiv wenn in alpha Tra vor Ego

  cval = cos(alphaTra);
  sval = sin(alphaTra);

  dval  = xEgo - xTra;
  dval1 = yEgo - yTra;

  delta_x =  cval * dval + sval * dval1;
  delta_y = -sval * dval + cval * dval1;
  
  if( freenetv )
    delta_x = -delta_x;
    delta_y = -delta_y;
  end
end
