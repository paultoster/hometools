function y = interp1_linear_extrap_timeout(xdata,ydata,x,dxout)
%
% y = interp1_linear_extrap_const(xdata,ydata,x,dxout)
%
% lineare Interpolation mit dem letzten wert konst halten ausserhalb den
% Grenzen von xdata
% dxout (bei Zeit timeout) wird geschaut, ob innerhalb dyout ein neuer wert
% kommt

  n      = min(length(xdata),length(ydata));
   
  y = x * 0.0;
  m     = length(y);
  index = 1;
  for i = 1:m
    xact = x(i);
    if( xact < xdata(1) )
      dx = xdata(1)-x(1);
      if( dx < dxout )
        y(i) = ydata(1);
      else
        y(i) = 0.0;
      end
    elseif( xact >= xdata(n) )
      dx = x(m) - xdata(n);
      if( dx < dxout )
        y(i) = ydata(n);
      else
        y(i) = 0.0;
      end
    else
      while( xact > xdata(index+1) )
        index = index + 1;
      end
      if( xact == xdata(index) )
        y(i) = ydata(index);
      else
        dx = xdata(index+1)-xdata(index);
        if( dx < dxout )
          y(i) = ydata(index) ...
               +  (ydata(index+1)-ydata(index)) ...
                 / not_zero(xdata(index+1)-xdata(index)) ...
                 *(xact-xdata(index));
        else
          y(i) = 0.0;
        end
      end
    end
  end
end