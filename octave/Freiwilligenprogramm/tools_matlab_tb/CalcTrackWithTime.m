function t = CalcTrackWithTime(a,q)
%
% t = CalcTrackWithTime(a,q)
%
% a.time Zeitvektor
% a.x    x-Koordinaten
% a.y    y-Koordinaten
% a.vel  Geschwindigkeit
%
% q.type              string   'txy'    Bilde Trajektorie mit t,x und y
% q.T_filt            [s]      Zeitkonstante Filterung x-y
% q.delta_time_approx [s](5.9) Zeitbereich über dem eine
%                              Polynomapproximation gemacht wird
%                              (Vektor wird in Stücke zerlegt)
% q.delta_time_mean   [s](0.5) Zeitbereich über dem erste und zweite
%                              Ableitung gemittelt an den Eckpunkten 
%                              gebildet wird
% q.Nord                  (7)  Ordnung des Polynoms
%
% Ausgabe
% t.time
% t.x                 m
% t.y                 m
% t.vel               m/s
% t.acc               m/s/s
% t.theta             rad
% t.kappa             1/m
% t.dkappa            1/m/m
% t.kappap            1/m/s

  ifig = 0;
      

  if( strcmp(q.type,'txyv') )
    
    if( ~isfield(q,'T_filt') )
      q.T_filt = 2.;
    end
    if( ~isfield(q,'delta_s') )
      q.delta_s = 2.0;
    end
    if( ~isfield(q,'delta_s_approx') )
      q.delta_s_approx = 101.0;
    end
    if( ~isfield(q,'delta_s_mean') )
      q.delta_s_mean = 5.;
    end
    if( ~isfield(q,'Nord') )
      q.Nord = 9;
    end
    npoints = q.delta_s_approx/q.delta_s+1;
    nderiv  = q.delta_s_mean/q.delta_s+1;
    
    % Berechnung x und y aus Positionsbestimmung (VBox)
    xfilt   = butter2_filter(a.time,a.x,q.T_filt,0);
    yfilt   = butter2_filter(a.time,a.y,q.T_filt,0);
    % das ganze äquidistant
    [sxy,dsxy,alphaxy,xxy,yxy] = vek_2d_s_ds_alpha(xfilt,yfilt,0.0,q.delta_s);
    sxymax = max(sxy);
    
    % Weg aus Geschwndigkeit generiert
    velfilt = butter2_filter(a.time,a.vel,q.T_filt,0);
    accfilt = differenziere(a.time,velfilt,1,0);
    sfilt   = integriere(a.time,velfilt,1,0.0);
    n       = length(sfilt);
    
    ilist  = 1;
    slast  = sfilt(1);
    for i=2:n
      if( sfilt(i)-slast > eps && (sfilt(i)<=sxymax) )
        ilist   = [ilist;i]; 
        slast   = sfilt(i);
      end
    end
    seps    = sfilt(ilist);
    veps    = velfilt(ilist);
    acceps  = accfilt(ilist);
    teps    = a.time(ilist);
    
%     xdelta = xfilt(ilist);
%     ydelta = yfilt(ilist);
%     veldelta = velfilt(ilist);
    
    % alles auf den äquidistanten Weg beziehen
    sdd = [seps(2):q.delta_s:seps(length(seps))]';
    
    % x-y aus Positionsbestimmung
    xdd = interp1(sxy,xxy,sdd,'linear','extrap');
    ydd = interp1(sxy,yxy,sdd,'linear','extrap');
    % Geschwindigkeit, Beschleunigung, Zeit
    vdd   = interp1(seps,veps,sdd,'linear','extrap');
    accdd = interp1(seps,acceps,sdd,'linear','extrap');
    tdd   = interp1(seps,teps,sdd,'linear','extrap');
    
    [ss,x] = vek_double_vek(sdd,xdd);
    [ss,x,dxds,d2xds2] = polynom_approx_delta(ss,x,npoints,nderiv,3,q.Nord);
    [s,x] = vek_half_vek(ss,x);
    [s,dxds] = vek_half_vek(ss,dxds);
    [s,d2xds2] = vek_half_vek(ss,d2xds2);
    
    [ss,y] = vek_double_vek(sdd,ydd);
    [ss,y,dyds,d2yds2] = polynom_approx_delta(ss,y,npoints,nderiv,3,q.Nord);
    [s,y] = vek_half_vek(ss,y);
    [s,dyds] = vek_half_vek(ss,dyds);
    [s,d2yds2] = vek_half_vek(ss,d2yds2);
    
%      [s,x,dxds,d2xds2] = polynom_approx_delta(sdelta,xdelta,npoints,nderiv,3,q.Nord);
%      [s,y,dyds,d2yds2] = polynom_approx_delta(sdelta,ydelta,npoints,nderiv,3,q.Nord);

    % s,x,y
    vel   = interp1(sdd,vdd,s,'linear','extrap');
    acc   = interp1(sdd,accdd,s,'linear','extrap');
    time  = interp1(sdd,tdd,s,'linear','extrap');
    
    theta = atan2(dyds,dxds);
    theta = Winkel_2pi_Sprung(theta,'rad');
		kappa  = sqrt(dxds.*dxds+dyds.*dyds);
		kappa  = kappa .* kappa .* kappa;
		kappa  = (dxds.*d2yds2-d2xds2.*dyds) ./not_zero(kappa);
    dkappa = differenziere(s,kappa,1,0);
    
    % Zeitvektor
    index0 = such_index(a.time,time(1));
    index1 = such_index(a.time,time(length(time)));
    
    t.time  = a.time(index0:index1);
    t.vel   = interp1(time,vel,t.time,'linear','extrap');
    t.acc   = interp1(time,acc,t.time,'linear','extrap');
    t.s     = interp1(time,s,t.time,'linear','extrap');
    t.x     = interp1(time,x,t.time,'linear','extrap');
    t.y      = interp1(time,y,t.time,'linear','extrap');
    t.theta  = interp1(time,theta,t.time,'linear','extrap');
    t.kappa  = interp1(time,kappa,t.time,'linear','extrap');
    t.dkappa = interp1(time,dkappa,t.time,'linear','extrap');
    t.kappap = t.dkappa.*t.vel;
    
    if( 1 )
      ifig = ifig+1;
      close_figure(ifig)
      figure(ifig)
      subplot(2,1,1)
      plot(sdd,xdd,'-k')
      hold on
      plot(s,x,'-r')
      hold off
      grid on
      xlabel('sdelta [m]')
      ylabel('x [m]')
      legend('xdd','xapprox')
      subplot(2,1,2)
      plot(sdd,ydd,'-k')
      hold on
      plot(s,y,'-r')
      hold off
      grid on
      xlabel('sdd [m]')
      ylabel('y [m]')
      legend('ydd','yapprox')

      ifig = ifig+1;
      close_figure(ifig)
      figure(ifig)
      subplot(2,1,1)
      plot(s,dxds,'-r')
      grid on
      xlabel('s [m]')
      ylabel('xapprox [m]')
      subplot(2,1,2)
      plot(s,dyds,'-r')
      grid on
      xlabel('s [m]')
      ylabel('yapprox [m]')

      ifig = ifig+1;
      close_figure(ifig)
      figure(ifig)
      subplot(2,1,1)
      plot(s,d2xds2,'-r')
      grid on
      xlabel('s [m]')
      ylabel('xapprox [m]')
      subplot(2,1,2)
      plot(s,d2yds2,'-r')
      grid on
      xlabel('s [m]')
      ylabel('yapprox [m]')

      ifig = ifig+1;
      close_figure(ifig)
      figure(ifig)
      subplot(2,1,1)
      plot(s,theta*180/pi,'-r')
      grid on
      xlabel('s [m]')
      ylabel('theta [deg]')
      subplot(2,1,2)
      plot(s,kappa,'-r')
      grid on
      xlabel('s [m]')
      ylabel('kappa [1/m]')

      figmen
      
    end    
  elseif( strcmp(q.type,'txy') ) 
    if( ~isfield(q,'delta_time_approx') )
      q.delta_time_approx = 10.0;
    end
    if( ~isfield(q,'delta_time_mean') )
      q.delta_time_mean = 0.5;
    end
    if( ~isfield(q,'Nord') )
      q.Nord = 7;
    end
    dt = mean(diff(a.time));
    npoints = q.delta_time_approx/dt+1;
    nderiv  = q.delta_time_mean/dt+1;

%     if( isfield(q,'T_filt_xy') )
%       xr = butter2_filter(a.time,a.x,q.T_filt_xy,1);
%       yr = butter2_filter(a.time,a.y,q.T_filt_xy,1);
%     else
      xr = a.x;
      yr = a.y;
%     end

    [time,t.x,dxdt,d2xdt2] = polynom_approx_delta(a.time,xr,npoints,nderiv,3,q.Nord);
    [t.time,t.y,dydt,d2ydt2] = polynom_approx_delta(a.time,yr,npoints,nderiv,3,q.Nord);

    t.theta = atan2(dydt,dxdt);
    t.vel   = sqrt(dxdt.*dxdt+dydt.*dydt);
%     if( isfield(q,'T_filt_acc') && ~isempty(q.T_filt_acc) )
%       t.acc   = diff_pt1_zp(t.time,t.vel,q.T_filt_acc);
%     else
%       t.acc = differenziere(t.time,t.vel,1);
%     end

    t.acc   = d2xdt2.*cos(t.theta)+d2ydt2.*sin(t.theta);
    nenn    = not_zero(t.vel.^3);
    t.kappa = (dxdt.*d2ydt2-d2xdt2.*dydt)./nenn;
    t.kappap = differenziere(time,t.kappa,1);
    t.dkappa = t.kappap./not_zero(t.vel);

  end

  if( isfield(q,'plot') && q.plot )

    ifig = ifig + 1;
    close_figure(ifig)
    figure(ifig)
    plot(a.time,a.x,'-k')
    hold on
    plot(t.time,t.x,'-r')
    hold off
    grid on
    legend('xin','xout')
    xlabel('time [s]')
    ylabel('x [m]')

    ifig = ifig+1;
    close_figure(ifig)
    figure(ifig)
    plot(a.time,a.y,'-k')
    hold on
    plot(t.time,t.y,'-r')
    hold off
    grid on
    xlabel('time [s]')
    ylabel('y [m]')
    legend('yin','yout')

    ifig = ifig+1;
    close_figure(ifig)
    figure(ifig)
    plot(a.x,a.y,'-k')
    hold on
    plot(t.x,t.y,'-r')
    hold off
    grid on
    xlabel('x [m]')
    ylabel('y [m]')
    legend('in','out')

    if( strcmp(q.type,'txyv') )
      ifig = ifig+1;
      close_figure(ifig)
      figure(ifig)
      plot(s,dxds,'-b')
      hold on
      plot(s,dyds,'-g')
      hold off
      grid on
      xlabel('s [m]')
      ylabel('dds [m/m]')
      legend('dxds','dyds')

      ifig = ifig+1;
      close_figure(ifig)
      figure(ifig)
      plot(s,d2xds2,'-b')
      hold on
      plot(s,d2yds2,'-g')
      hold off
      grid on
      xlabel('s [m]')
      ylabel('ddds [m/m/m]')
      legend('d2xds2','d2yds2')
      
    elseif( strcmp(q.type,'txy') )
      ifig = ifig+1;
      close_figure(ifig)
      figure(ifig)
      plot(t.time,dxdt,'-b')
      hold on
      plot(t.time,dydt,'-g')
      hold off
      grid on
      xlabel('time [s]')
      ylabel('ddt [m/s]')
      legend('dxdt','dydt')

      ifig = ifig+1;
      close_figure(ifig)
      figure(ifig)
      plot(t.time,d2xdt2,'-b')
      hold on
      plot(t.time,d2ydt2,'-g')
      hold off
      grid on
      xlabel('time [s]')
      ylabel('dddt [m/s/s]')
      legend('d2xdt2','d2ydt2')
    end
    
    ifig = ifig+1;
    close_figure(ifig)
    figure(ifig)
    plot(t.time,t.vel*3.6,'-r')
    if( isfield(a,'vel') )
      hold on
      plot(a.time,a.vel*3.6,'-k')
      hold off
      legend('approx','vehicle')
    end
    grid on
    xlabel('time [s]')
    ylabel('vel [km/h]')

    ifig = ifig+1;
    close_figure(ifig)
    figure(ifig)
    plot(t.time,t.acc,'-r','LineWidth',2.0)
    if( isfield(a,'acc') )
      hold on
      plot(a.time,a.acc,'-k')
      hold off
      legend('approx','vehicle')
    end
    grid on
    xlabel('time [s]')
    ylabel('acc [m/s/S]')

    ifig = ifig+1;
    close_figure(ifig)
    figure(ifig)
    plot(t.time,t.theta*180/pi,'-r')
    grid on
    xlabel('time [s]')
    ylabel('theta [deg]')

    ifig = ifig+1;
    close_figure(ifig)
    figure(ifig)
    plot(t.time,t.kappa,'-r')
    grid on
    xlabel('time [s]')
    ylabel('kappa [1/m]')

    ifig = ifig+1;
    close_figure(ifig)
    figure(ifig)
    plot(t.time,t.dkappa,'-r')
    grid on
    xlabel('time [s]')
    ylabel('dkappa [1/m/m]')

    ifig = ifig+1;
    close_figure(ifig)
    figure(ifig)
    plot(t.time,t.kappap,'-r')
    grid on
    xlabel('time [s]')
    ylabel('kappap [1/m/s]')

    figmen
  end
end
    
  
  
