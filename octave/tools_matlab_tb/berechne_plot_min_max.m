function [ymin,ymax] = berechne_plot_min_max(y_vec,delta_y)
%
% [ymin,ymax] = berechne_plot_min_max(y_vec,delta_y)
%
% Berechnet für Plotfunktion ymin und ymax in delta_y Schrittweite,
% so daß y_vec im Bereich [ymin ... ymax] liegt

y0 = min(y_vec);
y1 = max(y_vec);
dy = abs(delta_y);

if( dy > 0.000001 )
    if( y0 >= 0 )
        n0 = floor(y0/dy);
    else
        n0 = floor(y0/dy);
    end
    if( y1 >= 0 )
        n1 = ceil(y1/dy);
    else
        n1 = ceil(y1/dy);
    end

    if( n0 == n1 )
      n0 = n0-1;
      n1 = n1+1;
    end
    ymin = n0*dy;  
    ymax = n1*dy;
else
    ymin = 0;
    ymax = 0;
end
