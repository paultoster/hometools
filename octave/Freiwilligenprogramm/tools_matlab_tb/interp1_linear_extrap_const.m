function y = interp1_linear_extrap_const(xdata,ydata,x)
%
% y = interp1_linear_extrap_const(xdata,ydata,x)
%
% lineare Interpolation mit dem letzten wert konst halten ausserhalb den
% Grenzen von xdata

  n      = min(length(xdata),length(ydata));
  % interp1 ohne extrap wird bei linear NaN ausserhalb den grenzen
  %---------------------------------------------------------------
  y = interp1(xdata,ydata,x,'linear');

  if( sum(isnan(y)) > 0 )
    
    m = length(y);
    for i=1:m
      if( isnan(y(i)) )
        if(     x(i) <= xdata(1) ), y(i)=ydata(1);
        elseif( x(i) >= xdata(n) ), y(i)=ydata(n);
        else                        y(i)=0.0;
        end
      end
    end
  end

end