function d = trajektorie_calc(q)
%
% d = trajektorie_calc(q)
% 
% Geschwindiigkeit wird differenziert und gefiltert mit TFilt und
% zero-phase. Danach zweimal intergriert -> vel -> s
%
% q.type   = 'time';                Zeitbasierend errechnen
% q.time   = [0.0:0.01:30]';        [s]
% 
% q.t_vel  = [0.0, 10.0, 30.0]';    [s]
% q.vel    = [0.0, 13.5, 13.5]';    [m/s]
% 
% q.t_kappa = [0.0, 10.0, 15.00, 20.00, 25.0 30.0]';  [s]
% q.kappa   = [0.0,  0.0,  0.01,  0.01,  0.0, 0.0]';  [1/m]
%
% default Wert0
% q.x0,q.y0,q,theta0 = 0.0 
% q.TFilt            = 0.1 s
%
% Ausgabe:
% d.time          [s]
% d.x;            [m]
% d.y;            [m]
% d.vel;          [m/s]
% d.acc;          [m/s/s]
% d.theta         [rad]
% d.kappa         [1/m]
% d.dkappa        [1/m/m]
% d.kappap        [1/m/s]

%===============================================================================
%===============================================================================
  if( q.type(1) == 't' )


    if( ~isfield(q,'TFilt') )
      q.TFilt = 0.1;
    end
    if( ~isfield(q,'x0') )
      q.x0 = 0.0;
    end
    if( ~isfield(q,'y0') )
      q.y0 = 0.0;
    end
    if( ~isfield(q,'theta0') )
      q.theta0 = 0.0;
    end
    if( ~isfield(q,'delta_t_kappa') )
      q.delta_t_kappa = 0.0;
    end
    d.time = q.time;
    vel  = interp1_linear_extrap_const(q.t_vel,q.vel,d.time);
    d.acc  = diff_pt1_zp(d.time,vel,q.TFilt);
    d.vel  = integriere(d.time,d.acc,1,vel(1));
    d.s    = integriere(d.time,d.vel,1,0.0);

    kappa    = interp1_linear_extrap_const(q.t_kappa,q.kappa,d.time);
    d.kappap = diff_pt1_zp(d.time,kappa,q.TFilt);
    d.kappa  = integriere(d.time,d.kappap,1,kappa(1));
    d.theta  = integriere(d.time,d.kappa .* d.vel,1,q.theta0);

    d.x  = integriere(d.time,cos(d.theta) .* d.vel,1,q.x0);
    d.y  = integriere(d.time,sin(d.theta) .* d.vel,1,q.y0);
    
    [s,alpha,kappa,d.dkappa] = path_calc_aplha_kappa(d.x,d.y);

    if( q.delta_t_kappa > 0.0 )
      di   = -floor(q.delta_t_kappa/not_zero(mean(diff(d.time))));
      d.kappa = shiftsignal(d.kappa,di);
      d.kappap = shiftsignal(d.kappap,di);
      d.dkappa = shiftsignal(d.dkappa,di);
    end
  
  elseif( q.type(1) == 'm' )
    
    if( ~isfield(q,'TFilt') )
      q.TFilt = 0.1;
    end
    if( ~isfield(q,'x0') )
      q.x0 = 0.0;
    end
    if( ~isfield(q,'y0') )
      q.y0 = 0.0;
    end
    if( ~isfield(q,'theta0') )
      q.theta0 = 0.0;
    end
    if( ~isfield(q,'a0') )
      q.a0 = 0.01;
    end
    if( ~isfield(q,'delta_t_kappa') )
      q.delta_t_kappa = 0.0;
    end
    d.time = q.time;
    vel    = interp1_linear_extrap_const(q.t_vel,q.vel,d.time);
    d.acc  = diff_pt1_zp(d.time,vel,q.TFilt);
    d.vel  = integriere(d.time,d.acc,1,vel(1));
    d.s    = integriere(d.time,d.vel,1,0.0);
    
    kappa    = interp1_linear_extrap_const(q.s_kappa,q.kappa,d.s);
    d.kappap = diff_pt1_zp(d.time,kappa,q.TFilt);
    d.kappa  = integriere(d.time,d.kappap,1,kappa(1));
    d.theta  = integriere(d.time,d.kappa .* d.vel,1,q.theta0);
    

    d.x  = integriere(d.time,cos(d.theta) .* d.vel,1,q.x0);
    d.y  = integriere(d.time,sin(d.theta) .* d.vel,1,q.y0);

    [s,alpha,kappa,d.dkappa] = path_calc_aplha_kappa(d.x,d.y);
    
%     figure
%     plot(d.time,d.kappa,'k-')

    if( q.delta_t_kappa > 0.0 )
      di   = -floor(q.delta_t_kappa/not_zero(mean(diff(d.time))));
      d.kappa = shiftsignal(d.kappa,di);
      d.kappap = shiftsignal(d.kappap,di);
      d.dkappa = shiftsignal(d.dkappa,di);
    end
%     hold on
%     plot(d.time,d.kappa,'r-')
%     hold off
  else
    d = struct([]);
  end
end

