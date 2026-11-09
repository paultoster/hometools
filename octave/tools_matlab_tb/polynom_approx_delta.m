function [x,ya,dyadx,d2yadx2] = polynom_approx_delta(x,y,npoints,nderiv,type,Nord,sw)
% 
% [xa,ya,dyadx,d2yadx2] = polynom_approx_delta(x,y,npoints,nderiv,type,Nord)
% [xa,ya,dyadx,d2yadx2] = polynom_approx_delta(x,y,npoints,nderiv,type,Nord,sw)
%
% Approximation von y(x) stückweise über npoints-Punkte. Über nderiv werden
% am Anfang und Ende die ableitungen gemittelt. Es muß sein
% length(x) >= npoints > nderiv
% type bestimmt welche Randbedingung
%
% x        vectot double     x-Vektor
% y        vectot double     y-Vektor
% npoints  single            Anzahle der Punkte für ein Stück (default length(x))
% nderiv   single            ANzahl der Punkte zur Mittelung 1. und 2. Ableitung
% type     single            Welche Randbedingung
%                            = 0  keine
%                            = 1 (default) Werte am Anfang und Ende
%                            = 2 Werte und erste Abletung
%                            = 3 Werte, erste und zweite Abletung
% Nord     single            Ordnung des Polynoms bei type = 3 Nord >= 6
% sw       enum (optional)   1: Steigung am ersten un letzten Wert null
%                               setzen
%--------------------------------------------------------------------------
% xa        vector double    monoton steigender Vektor von x
% ya        vector double    approximierter Vektor ya(xa)
% dyadx     vector double    approximierter Vektor erste Ableitung dyadx(x)
% d2yadx2   vector double    approximierter Vektor zweite Ableitung d2yadx2(x)
%-----------------------------------------------------------------------------
  if( ~exist('sw','var') )
    sw = 0;
  end

  if( ~exist('Nord','var') )
    Nord = 7;
  end
  [n,m] = size(x);
  if( m > n )
    x = x';
    trans_x = 1;
  else
    trans_x = 0;
  end
  [n,m] = size(y);
  if( m > n )
    y = y';
    trans_y = 1;
  else
    trans_y = 0;
  end
  
  n = min(length(x),length(y));
  [x,y] = elim_nicht_monoton(x(1:n),y(1:n));
  n = length(x);
  
  ya      = zeros(n,1);
  dyadx   = zeros(n,1);
  d2yadx2 = zeros(n,1);
  
  if( ~exist('npoints','var') )
    npoints = n;
  end


  if( npoints > n )
    npoints = n;
  end
  if( ~exist('nderiv','var') )
    nderiv = min(10,(npoints/2-1));
  end

  nderiv2 = round(nderiv/2);
  nderiv  = nderiv2*2;

  if( nderiv > npoints/2 )
    error('%s_error: nderiv > npoints/2',mfilename);
  end
  if( ~exist('type','var') )
    type = 1;
  end
  type = round(type);
  if( type < 0 )
    type = 0;
  elseif( type > 3 )
    type = 2;
  end

  i  = 0;
  ii = 1;
  while ii < n
    i  =i+1;
    s(i).i0 = floor(ii);

    ii = ii + npoints -1;
    if( ii+nderiv2 >= n )
      ii = n;
    end
    s(i).i1 = floor(ii);
    s(i).n  = s(i).i1 - s(i).i0 + 1;
  end
  m = length(s);

  % Ableitungen bilden
  for i=1:m
    s(i).y0 = [];
    s(i).y1 = [];
    s(i).dy0 = [];
    s(i).dy1 = [];
    s(i).ddy0 = [];
    s(i).ddy1 = [];

    if( type >= 1 )
      s(i).y0 = y(s(i).i0);
      s(i).y1 = y(s(i).i1);
    end

    if( type >= 2 )
      if( i == 1 )
        i0 = 1;
        i1 = nderiv2;
      else
        i0 = s(i).i0-nderiv2;
        i1 = s(i).i0+nderiv2;
      end
      if( (sw == 1) && (i == 1) ) % Ableitungen null
        s(i).dy0 = 0.0;
      else
        s(i).dy0 =  polynom_approx_delta_dy(x(i0:i1),y(i0:i1));
      end
      if( type == 3 )
        if( (sw == 1) && (i == 1) ) % Ableitungen null
          s(i).ddy0 = 0.0;
        else
          s(i).ddy0 =  polynom_approx_delta_ddy(x(i0:i1),y(i0:i1));
        end
      end
      if( i == m )
        i0 = s(i).i1-nderiv2;
        i1 = s(i).i1;
      else
        i0 = s(i).i1-nderiv2;
        i1 = s(i).i1+nderiv2;
      end
      if( (sw == 1) && (i == m) ) % Ableitungen null
        s(i).dy1 = 0.0;
      else
        s(i).dy1 =  polynom_approx_delta_dy(x(i0:i1),y(i0:i1));
      end
      if( type == 3 )
        if( (sw == 1) && (i == m) ) % Ableitungen null
          s(i).ddy1 = 0.0;
        else
          s(i).ddy1 =  polynom_approx_delta_ddy(x(i0:i1),y(i0:i1));
        end
      end
    end
    if( type == 0 )
      s(i).p = polynom_approx_bound_xy(Nord,x(s(i).i0:s(i).i1),y(s(i).i0:s(i).i1),[],[]);
    elseif( type == 1 )
      s(i).p = polynom_approx_bound_xy(Nord,x(s(i).i0:s(i).i1),y(s(i).i0:s(i).i1),[s(i).y0],[s(i).y1]);
    elseif( type == 2 )
      s(i).p = polynom_approx_bound_xy(Nord,x(s(i).i0:s(i).i1),y(s(i).i0:s(i).i1),[s(i).y0,s(i).dy0],[s(i).y1,s(i).dy1]);
    elseif( type == 3 )
      s(i).p = polynom_approx_bound_xy(Nord,x(s(i).i0:s(i).i1),y(s(i).i0:s(i).i1),[s(i).y0,s(i).dy0,s(i).ddy0],[s(i).y1,s(i).dy1,s(i).ddy1]);      
    end
    s(i).pd  = polyder(s(i).p);
    s(i).pdd = polyder(s(i).pd);
    
    i0 = s(i).i0;
    if( i == m )
      i1 = max(i0,s(i).i1);
    else
      i1 = max(i0,s(i).i1-1);
    end
    ya(i0:i1)      = polyval(s(i).p,x(i0:i1));
    dyadx(i0:i1)   = polyval(s(i).pd,x(i0:i1));
    d2yadx2(i0:i1) = polyval(s(i).pdd,x(i0:i1));
    
  end  
  if( trans_x )
    x = x';
  end
  if( trans_y )
    ya      = ya';
    dyadx   = dyadx';
    d2yadx2 = d2yadx2';    
  end
end
function dy =  polynom_approx_delta_dy(x,y)

  dy = mean(diff(y)./diff(x));
  
end
function ddy =  polynom_approx_delta_ddy(x,y)

  dy  = diff(y)./diff(x);
  dy  = [dy(1);dy];
  ddy = mean(diff(dy)./diff(x));

end

