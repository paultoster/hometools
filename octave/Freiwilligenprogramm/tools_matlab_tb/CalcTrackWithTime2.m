function d = CalcTrackWithTime2(a,q)
%
% t = CalcTrackWithTime(a,q)
%
% a.time Zeitvektor
% a.x    x-Koordinaten
% a.y    y-Koordinaten
% a.vel  Geschwindigkeit
% a.acc  Beschleunigung
%
% q.T_filt = 1.0;
% q.delta_t_approx = 10.;
% q.delta_t_mean   = 2.;
% q.Gain_acc_vel   = 1;
% q.Gain_acc_s     = 0.1;
% q.delta_s        = 1.;
% q.delta_s_approx = 200.;
% q.delta_s_mean   = 10.;
% q.Gain_ds        = 0.01;
% q.Gain_s         = 0.00005;
% q.dytol          = 0.1;
% q.correct_approx = 0;
% q.plot           = 0;
%
% Ausgabe
% d.time
% d.x                 m
% d.y                 m
% d.vel               m/s
% d.acc               m/s/s
% d.theta             rad
% d.kappa             1/m
% d.dkappa            1/m/m
% d.kappap            1/m/s
  if( ~isfield(q,'T_filt') )
    q.T_filt = 1.0;
  end
  if( ~isfield(q,'delta_t_approx') )
    q.delta_t_approx = 10.;
  end
  if( ~isfield(q,'delta_t_mean') )
    q.delta_t_mean   = 2.;
  end
  if( ~isfield(q,'Gain_acc_vel') )
    q.Gain_acc_vel   = 1;
  end
  if( ~isfield(q,'Gain_acc_s') )
    q.Gain_acc_s     = 0.1;
  end
  if( ~isfield(q,'delta_s') )
    q.delta_s        = 1.;
  end
  if( ~isfield(q,'delta_s_approx') )
    q.delta_s_approx = 200.;
  end
  if( ~isfield(q,'delta_s_mean') )
    q.delta_s_mean   = 10.;
  end
  if( ~isfield(q,'Gain_ds') )
    q.Gain_ds        = 0.01;
  end
  if( ~isfield(q,'Gain_s') )
    q.Gain_s         = 0.00005;
  end
  if( ~isfield(q,'dytol') )
    q.dytol         = 0.1;
  end
  if( ~isfield(q,'correct_approx') )
    q.correct_approx = 0;
  end

  if( ~isfield(q,'plot') )
    q.plot         = 0;
  end

  if( q.correct_approx )
    sw = 11;
  else
    sw = 1;
  end
  
  a.xfilt   = butter2_filter(a.time,a.x,q.T_filt,0);
  a.yfilt   = butter2_filter(a.time,a.y,q.T_filt,0);
  a.x       =a.xfilt;
  a.y       =a.yfilt;
  a.sfilt   = vek_2d_s_ds_alpha(a.xfilt,a.yfilt,0.0);

  a.vfilt   = differenziere(a.time,a.sfilt,1,0);
  a.afilt   = differenziere(a.time,a.vfilt,1,0);


  % Approximation mit gemessener Beschleunigung
  dt      = mean(diff(a.time));
  npoints = q.delta_t_approx/dt+1;
  nderiv  = q.delta_t_mean/dt+1;
  [tApprox,aApprox,vApprox,sApprox] = ApproxZweiteAbleitung(a.time,a.acc,a.vfilt,a.sfilt ...
                                                   ,q.delta_t_approx,q.delta_t_mean ...
                                                   ,q.Gain_acc_vel,q.Gain_acc_s,sw,q.dytol);

  % Approximation Krümung und Gierwinkel
  i0 = suche_index(a.vfilt,1.,'>=','v',1e-6,1);
  i1 = suche_index(a.vfilt,0.1,'>=','r',1e-6,length(a.vfilt));

  %i0 = i0 + 1000;
  %i1 = i1 - 1000;
  [s,ds,alpha,x,y,ilist]   = vek_2d_s_ds_alpha(a.xfilt(i0:i1),a.yfilt(i0:i1),0.0,q.delta_s);

  t      = a.time(ilist+i0-1);
  dxds   = differenziere(s,x,1,0);
  d2xds2 = differenziere(s,dxds,1,0);
  d2xds2_filt   = butter2_filter(s,d2xds2,15,0);
  [sapp,d2xds2app,dxdsapp,xapp] = ApproxZweiteAbleitung(s,d2xds2_filt,dxds,x ...
                                                   ,q.delta_s_approx,q.delta_s_mean ...
                                                   ,q.Gain_ds,q.Gain_s,sw,q.dytol);

  dyds   = differenziere(s,y,1,0);
  d2yds2 = differenziere(s,dyds,1,0);
  d2yds2_filt   = butter2_filter(s,d2yds2,15.0,0);
  [sapp,d2yds2app,dydsapp,yapp] = ApproxZweiteAbleitung(s,d2yds2_filt,dyds,y ...
                                                   ,q.delta_s_approx,q.delta_s_mean ...
                                                   ,q.Gain_ds,q.Gain_s,sw,q.dytol);


  thetaapp = atan2(dydsapp,dxdsapp);
  thetaapp = Winkel_2pi_Sprung(thetaapp,'rad');
  kappaapp  = sqrt(dxdsapp.*dxdsapp+dydsapp.*dydsapp);
  kappaapp  = kappaapp .* kappaapp .* kappaapp;
  kappaapp  = (dxdsapp.*d2yds2app-d2xds2app.*dydsapp) ./not_zero(kappaapp);
  dkappaapp = differenziere(sapp,kappaapp,1,0);


  d.time    = tApprox;
  d.vel     = vApprox;
  d.acc     = aApprox;
  d.s       = interp1_linear_extrap_const(t,s,d.time);
  d.x       = interp1_linear_extrap_const(t,xapp,d.time);
  d.y       = interp1_linear_extrap_const(t,yapp,d.time);
  d.theta   = interp1_linear_extrap_const(t,thetaapp,d.time);
  d.kappa   = interp1_linear_extrap_const(t,kappaapp,d.time);
  d.dkappa  = interp1_linear_extrap_const(t,dkappaapp,d.time);
  d.kappap  = d.dkappa.*d.vel;

  if( q.plot )                                               
    ifig   = 0; 
    idina4 = 1;
    ifig = ifig+1;
    ifig = find_free_ifig(ifig);
    p_figure(ifig,idina4,num2str(ifig),1)

    subplot(3,1,1)
    plot(a.time,a.x,'k-')
    title('Filterung x-Position-Zeit')
    hold on
    plot(a.time,a.xfilt,'b-')
    hold off
    grid on
    xlabel('time [s]')
    ylabel('x [m]')
    legend('x','xfilt')
    subplot(3,1,2)
    plot(a.time,a.y,'k-')
    title('Filterung y-Position-Zeit')
    hold on
    plot(a.time,a.yfilt,'b-')
    hold off
    grid on
    xlabel('time [s]')
    ylabel('y [m]')
    legend('y','yfilt')
    subplot(3,1,3)
    plot(a.time,a.sfilt,'b-')
    title('Filterung s-Weg-Zeit')
    grid on
    xlabel('time [s]')
    ylabel('sfilt [m]')

    ifig = ifig+1;
    ifig = find_free_ifig(ifig);
    p_figure(ifig,idina4,num2str(ifig),1)

    subplot(4,1,1)
    plot(a.time,a.sfilt-sApprox,'b-')
    title('Abweichung s-Weg zur Approximation in Zeit')
    grid on
    xlabel('time [s]')
    ylabel('delta s [m]')
    subplot(4,1,2)
    plot(a.time,a.sfilt,'b-')
    hold on
    plot(tApprox,sApprox,'r-')
    hold off
    grid on
    xlabel('time [s]')
    ylabel('s [m]')
    legend('sfilt','sApprox')
    subplot(4,1,3)
    plot(a.time,a.vel*3.6,'k-')
    hold on
    plot(a.time,a.vfilt*3.6,'b-')
    plot(tApprox,vApprox*3.6,'r-')
    hold off
    grid on
    xlabel('time [s]')
    ylabel('v [km/h]')
    legend('vel','vfilt','vApprox')
    subplot(4,1,4)
    plot(a.time,a.acc,'k-')
    hold on
    plot(a.time,a.afilt,'b-')
    plot(tApprox,aApprox,'r-','LineWidth',2)
    hold off
    grid on
    xlabel('time [s]')
    ylabel('a [m/s/s]')
    legend('acc','afilt','aApprox')


    ifig = ifig+1;
    ifig = find_free_ifig(ifig);
    p_figure(ifig,idina4,num2str(ifig),1)

    subplot(4,1,1)
    plot(s,x-xapp,'b-')
    title('Abweichung x-Pos Approximation zu gefiltert in Weg')
    grid on
    xlabel('s [m]')
    ylabel('dx [m]')
    subplot(4,1,2)
    plot(s,x,'b-')
    hold on
    plot(sapp,xapp,'r-')
    hold off
    grid on
    xlabel('s [m]')
    ylabel('x [m]')
    legend('x','xapp')
    subplot(4,1,3)
    plot(s,dxds,'b-')
    hold on
    plot(sapp,dxdsapp,'r-')
    hold off
    grid on
    xlabel('s [m]')
    ylabel('dxds [m/m]')
    legend('dxds','dxdsapp')
    subplot(4,1,4)
    plot(s,d2xds2,'b-')
    hold on
    plot(sapp,d2xds2app,'r-','LineWidth',2)
    hold off
    grid on
    xlabel('s [m]')
    ylabel('d2xds2 [m/m/m]')
    legend('d2xds2','d2xds2app')

    ifig = ifig+1;
    ifig = find_free_ifig(ifig);
    p_figure(ifig,idina4,num2str(ifig),1)

    subplot(4,1,1)
    plot(s,y-yapp,'b-')
    title('Abweichung y-Pos Approximation zu gefiltert in Weg')

    grid on
    xlabel('s [m]')
    ylabel('dy [m]')
    subplot(4,1,2)
    plot(s,y,'b-')
    hold on
    plot(sapp,yapp,'r-')
    hold off
    grid on
    xlabel('s [m]')
    ylabel('y [m]')
    legend('y','yapp')
    subplot(4,1,3)
    plot(s,dyds,'b-')
    hold on
    plot(sapp,dydsapp,'r-')
    hold off
    grid on
    xlabel('s [m]')
    ylabel('dyds [m/m]')
    legend('dyds','dydsapp')
    subplot(4,1,4)
    plot(s,d2yds2,'b-')
    hold on
    plot(sapp,d2yds2app,'r-','LineWidth',2)
    hold off
    grid on
    xlabel('s [m]')
    ylabel('d2yds2 [m/m/m]')
    legend('d2yds2','d2yds2app')

    ifig = ifig+1;
    ifig = find_free_ifig(ifig);
    p_figure(ifig,idina4,num2str(ifig),1)

    subplot(3,1,1)
    plot(d.time,d.s,'m-');
    title('Ausgabe')
    hold on
    plot(d.time,d.x,'r-');
    plot(d.time,d.y,'c-');
    hold off
    grid on
    xlabel('time [s]')
    ylabel('s [m]')
    legend('s','x','y')

    subplot(3,1,2)
    plot(d.time,d.vel*3.6,'m-');
    grid on
    xlabel('time [s]')
    ylabel('vel [km/h]')

    subplot(3,1,3)
    plot(d.time,d.acc,'m-');
    grid on
    xlabel('time [s]')
    ylabel('acc [m/s/s]')


    ifig = ifig+1;
    ifig = find_free_ifig(ifig);
    p_figure(ifig,idina4,num2str(ifig),1)

    subplot(3,1,1)
    y0 = min(d.theta*180/pi)-90;
    ymin = 0.0;
    while(ymin > y0 )
      ymin = ymin - 180;
    end
    y1 = max(d.theta*180/pi)+90;
    ymax = 0.0;
    while(ymax < y1 )
      ymax = ymax + 180;
    end
    plot(d.time,d.theta*180/pi,'m-');
    title('Ausgabe')
    grid on
    xlabel('time [s]')
    ylabel('theta [deg]')
    ylim([ymin,ymax]);

    subplot(3,1,2)
    plot(d.time,d.kappa,'m-');
    grid on
    xlabel('time [s]')
    ylabel('kappa [1/m]')
    ylim([-0.1,0.1])

    subplot(3,1,3)
    plot(d.time,d.kappap,'m-');
    hold on
    plot(d.time,d.dkappa,'r-');
    hold off
    grid on
    xlabel('time [s]')
    legend('kappap [1/m/s]','dkappa [1/m/m]')

    zaf('set_silent')
    figmen
  end
end