function ss  = calc_merge_kappa_vel(sk,sv)
%
% ss      = calc_merge_kappa_vel(sk,sv)
%
%  Merge sk.s          (vektor)
%        sk.x          (vektor)
%        sk.y          (vektor)
%        sk.theta      (vektor)
%        sk.kappa      (vektor)
%  mit
%        sv.time       (vektor)
%        sv.vel        (vektor)
%
%
%  zu
%
%  ss.time
%  ss.s
%  ss.ds
%  ss.ds
%  ss.x
%  ss.y
%  ss.theta
%  ss.kappa
%  ss.vel
%  ss.acc


  s    = integriere(sv.time,sv.vel,1,0.0);
  smax  = s(end);
  skmax = sk.s(end);
  if( smax < skmax )
    deltas = skmax-smax;
    vel1   = max(0.001,sv.vel(end));
    deltat = deltas/vel1;
    dt     = mean(diff(sv.time));
    n      = ceil(deltat/dt);
    for i=1:n
      sv.time(end+1) = sv.time(end)+dt;
      sv.vel(end+1)  = vel1;
    end
  elseif( skmax < smax )
    index   = such_index(s,skmax);
    sv.time = sv.time(1:index);
    sv.vel   = sv.vel(1:index);
  end
  
  acc  = diff_pt1_zp(sv.time,sv.vel,0.1);
  vel  = integriere(sv.time,acc,1,sv.vel(1));
  s    = integriere(sv.time,vel,1,0.0);

  ss.time   = sv.time;
  ss.s      = s;
  ss.ds     = diff(ss.s);
  ss.ds     = [ss.ds;ss.ds(end)];
  ss.x      = interp1(sk.s,sk.x,s,'linear','extrap');
  ss.y      = interp1(sk.s,sk.y,s,'linear','extrap');
  ss.theta  = interp1(sk.s,sk.theta,s,'linear','extrap');
  ss.kappa  = interp1(sk.s,sk.kappa,s,'linear','extrap');
  ss.vel    = sv.vel;
  ss.acc    = diff_pt1_zp(sv.time,sv.vel,0.1);


end
  