function [xA,d2ydx2A,dydxA,yA] = ApproxZweiteAbleitung(x,d2ydx2G,dydxV,yV,delta_x_app,delta_x_mean,gain_dydx,gain_y,sw,dytol)
%
% [d2ydx2A,dydxA,yA] = ApproxZweiteAbleitung(x,d2ydx2G,dydxV,yV,delta_x_app,delta_x_mean,gain_dydx,gain_y)
% [d2ydx2A,dydxA,yA] = ApproxZweiteAbleitung(x,d2ydx2G,dydxV,yV,delta_x_app,delta_x_mean,gain_dydx,gain_y,sw)
% [d2ydx2A,dydxA,yA] = ApproxZweiteAbleitung(x,d2ydx2G,dydxV,yV,delta_x_app,delta_x_mean,gain_dydx,gain_y,sw,dytol)
%
% Funktion approximiert aus dem ersten Annäherung (Guess) d2ydx1G eine
% stückweise (delta_x_app) Approximation 2. Ordnung mit Übereinstimmung von
% Wert und Ableitung an den Nahtstellen (Nord = 6) und nähert den Wert über
% eine Art Beobachter mit den Verstäkungen gain_dydx für dydxV (Vergleich)
% und gain_y für yV
%
% x             nx1 Vektor         x-Vektor monoton steigend
% d2ydx1G       nx1 Vektor         einen in erster Näherung berechnete
%                                  zweite Ableitung (muss nicht glatt sein)
% dydxV         nx1 Vektor         erste Abletung zum Vergleich und
%                                  Anpassung
% dyV           nx1 Vektor         Werte zum Vergleich und
%                                  Anpassung
% delta_x_app   single             Abschnittsgröße von x für Approximation
%                                  kann maximal x(n)-x(1) sein
% delta_x_mean  single             Mittelungsgröße von x für Mittelwertbildung
%                                  an den Schnittstellen von i*delta_x_app
%                                  dx < delta_x_mean < delta_x_app/2
%                                  mit dx(i) = x(i)-x(i-1)
% sw            enum (optional)    1: Am Anfan und Ende der Messwerte wird
%                                     mit Steigung null gearbeitet
%                                  +10 zweite Methode
% dytol                            Toleranz für zweite Methode
%
  ifig = find_free_ifig(1);
  if( ~exist('sw','var') )
    sw = 0;
  end
  
  sw1 = floor(sw/10);
  sw0 = sw - sw1*10;
 
  if( ~exist('dytol','var') )
    dytol = max(1e-6,(max(yV)-min(yV))/100.);
  end
  
  % Monotonie
  if( ~is_monoton_steigend(x) )
    error('%s_error: x ist nicht monoton steigend',mfilename);
  end

  dxmean  = mean(diff(x));
  npoints = delta_x_app/dxmean+1;
  nmean   = delta_x_mean/dxmean+1;

  % Approximation
  [xA,d2ydx2app] = polynom_approx_delta(x,d2ydx2G,npoints,nmean,2,6,sw0);

  % Anpassung
  dydx0  = mean(dydxV(1:nmean)); 
  y0     = yV(1); 
  n = length(xA);

  d2ydx2A = d2ydx2app;
  dydxA   = xA*0.0;
  yA      = xA*0.0;

  delta_dydx = 0.0;
  delta_y    = 0.0;


  for i=1:n

    if( i == 1 )
      d2ydx2A(i) = d2ydx2A(i);
      dydxA(i)   = dydx0;
      yA(i)      = y0;
    else 
      d2ydx2A(i) = d2ydx2A(i) + delta_dydx + delta_y;
      dx         = xA(i)- xA(i-1);
      dydxA(i)   = dydxA(i-1) + d2ydx2A(i) * dx;
      yA(i)      = yA(i-1)    + dydxA(i)   * dx;
    end

    delta_dydx = (dydxV(i) - dydxA(i)) * gain_dydx;
    delta_y    = (yV(i)    - yA(i))    * gain_y;
  end
  
  % Nachbearbeitung
  if( sw1 == 1 )
    % Stelle suchen, wo Abweichung nicht mehr paßt
    istart = n;
    iend   = n;
    for i=2:n
      Delta = yV(i) - yA(i);
      if( abs(Delta) > dytol )
        istart = max(1,i-2);
        break;
      end
    end
    for i=n:-1:2
      Delta = yV(i) - yA(i);
      if( abs(Delta) > dytol )
        iend = i;
        break;
      end
    end
    if( istart < iend )
      
      for j=1:iend-istart
        
        XA      = zeros(j+1,1);
        for k=1:j+1
          XA(k)    = xA(istart)+(xA(iend)-xA(istart))/j*(k-1);
        end
        YA      = interp1(xA(istart:iend),yA(istart:iend),XA,'linear','extrap');
        YV      = interp1(xA(istart:iend),yV(istart:iend),XA,'linear','extrap');
        DYDXA   = interp1(xA(istart:iend),dydxA(istart:iend),XA,'linear','extrap');
        D2YDX2A = interp1(xA(istart:iend),d2ydx2A(istart:iend),XA,'linear','extrap');
        
        for k=2:j+1
          DX         = XA(k) - XA(k-1);
          DY         = YV(k) - YA(k-1);
          DYP        = DY/DX;
          DYPP       = (DYP-DYDXA(k-1))/DX;
          D2YDX2A(k) = DYPP;
          DYDXA(k)   = DYDXA(k-1) + DYPP * DX;
          YA(k)      = YA(k-1) + DYDXA(k) * DX;
        end
        
        yA(istart:iend)      = interp1(XA,YA,xA(istart:iend),'linear','extrap');
        dydxA(istart:iend)   = interp1(XA,DYDXA,xA(istart:iend),'linear','extrap');
        d2ydx2A(istart:iend) = interp1(XA,D2YDX2A,xA(istart:iend),'linear','extrap');
        
        figure(ifig)

        subplot(4,1,1)
        plot(xA,yV-yA,'g-')
        grid on
        subplot(4,1,2)
        plot(xA,yA,'r-')
        hold on
        plot(xA,yV,'k-')
        hold off
        grid on
        subplot(4,1,3)
        plot(xA,dydxA,'r-')
        hold on
        plot(xA,dydxV,'k-')
        hold off
        grid on
        subplot(4,1,4)
        plot(xA,d2ydx2A,'r-')
        hold on
        plot(xA,d2ydx2G,'k-')
        hold off
        grid on
        pause(0.1)

        delta = max(abs(yV-yA));
        if( delta < dytol )
          break;
        end
      end
    end
  end
end