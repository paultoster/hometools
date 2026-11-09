function kappa  = path_calc_kappa_radius_estimation(x,y,n,nfit)
%
% kappa  = path_calc_kappa_radius_estimation(x,y,n,nfit)
%
%

  kappa = zeros(n,1);
  nfit = round(nfit);
  if( nfit > n )
    warning('nfit=%i ist größer n=%i kappa(i) = 0',nfit,n);
    return
  end
  if( is_even_value(nfit) )
    dnm = nfit/2;
    dnp = dnm;
  else
    dnm = (nfit-1)/2;
    dnp = dnm;
  end
    
  for i=1:n
    
    
    i0       = max(1,i-dnm);
    i1       = min(n,i+dnp);
    if( i0 == 1 )
      i1 = min(n,i0+dnm+dnp);
    elseif( i1 == n )
      i0 = max(1,i1-dnm-dnp);
    end
%     p_figure(1,2,'Kreis',1);
%     hold on,plot(x(i0:i1),y(i0:i1)),grid on
%     hold off
    [x0,y0,r] = estimate_radius_from_xy(x(i0:i1),y(i0:i1));
%     xkreis = zeros(100,1);
%     ykreis = zeros(100,1);
%     dphi   = 2*pi/100;
%     for i=1:100
%       xkreis(i) = x0+r*cos(dphi*(i-1));
%       ykreis(i) = y0+r*sin(dphi*(i-1));
%     end
%     hold on
%     plot(xkreis,ykreis,'r-',x0,y0,'+')
%     hold off
    if( r > eps ) 
      kappa(i) = 1/not_zero(r);
    else
      kappa(i) = 0.;
    end
    
%     vek0 = [x(i0)-x0,y(i0)-y0,0.0];
%     vek1 = [x(i1)-x0,y(i1)-y0,0.0];
%     vek2 = cross(vek0,vek1);
%     if( vek2(3) < 0.0 )
%       kappa(i) = kappa(i) * (-1.);
%     end
    if( mean(diff(Winkel_2pi_Sprung(atan2(diff(y(i0:i1)),diff(x(i0:i1))),'rad'))) < 0 )
      kappa(i) = kappa(i) * (-1.);
    else
      aa = 0;
    end
  end

end
