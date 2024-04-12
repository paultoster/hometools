function [tmod,smod,xmod,ymod,yawmod,q] = approx_for_txy(time_in,xvec,yvec,q)
% 
% [xmod,ymod,yawmod] = approx_for_txy(time,xvec,yvec,q)
%
% geglättete Kurve für xvec,yvec in Teilstückenmit spline
% x-und y werden separat gefittet xvec(svec) und yvec(svec)
% Dazu werden die die Punkte delta_s < dsmin rausgenommen,
% aber für die Rückgabe wieder reingenommen
% Parameter:
% q.approx   1: bspline
% q.dsmin    minimaler Abstand zweier Punkte zum fitten
% q.ds_out   Ausgabe in delta Weg Länge
% q.plotflag soll geplottet werden
% q.fig_num  aktuelle letzte figuren-Nummer
% q.calc_yaw yaw aus x und y berechnen (mit  q.s_filt) (default: 0)
% q.s_filt   Filterlänge, für Filterung Steigung
%
  xmod   = [];
  ymod   = [];
  yawmod = [];
  nvec = min(length(xvec),length(yvec));
  xvec = xvec(1:nvec);
  yvec = yvec(1:nvec);
  time = time_in(1:nvec);
  svec = vek_2d_build_s(xvec,yvec,nvec,0.0,-1.);
  
  if( ~check_val_in_struct(q,'approx','num',1) )
    q.approx = 1;
  end

    
  if( ~check_val_in_struct(q,'dsmin','num',1) )
    q.dsmin = 0.001;
  end
    
  if( ~check_val_in_struct(q,'s_filt','num',1) )
    q.s_filt = 10.;
  end
  
  if( ~check_val_in_struct(q,'ds_out','num',1) )
    q.ds_out = 0.1;
  end
  
  if( ~check_val_in_struct(q,'calc_yaw','num',1) )
    q.calc_yaw = 0;
  end
    
  if( ~check_val_in_struct(q,'plotflag','num',1) )
    q.plotflag = 0;
  end
  
  if( q.plotflag )
    if( ~check_val_in_struct(q,'fig_num','num',1) )
      q.fig_num = get_max_figure_num;
    end
  end    
  
  [svec,xvec,yvec,ivec] = vek_2d_build_s(xvec,yvec,nvec,0.0,q.dsmin);
  time = time(ivec);
  nvec = length(svec);
  
  % Punkte bereinigen
  %==================
  
  [t,x,y,s,ds,n] = approx_for_txy_build_svec(time,xvec,yvec,nvec,q.dsmin,svec);
  
  smod   = [s(1):q.ds_out:s(n)]';
  
  % Filtern
  if( q.approx == 1 )
    %bspline
    [xmod,ymod,yawmod,q] = approx_for_txy_bspline(s,x,y,smod,q);
  end
  
  % yaw angle
  if( q.calc_yaw )
    [yawmod,q] = approx_for_txy_yaw(smod,xmod,ymod,q);
  end
  
  tmod       = interp1(svec,time,smod,'linear','extrap');
  
end
function [t,x,y,s,ds,n] = approx_for_txy_build_svec(time,xvec,yvec,nvec,dsmin,svec)
%
% Bilde Bahn der Punkte mindestens den Abstand dsmin hat
%
  s0 = 0.0;
  s  = s0;
  x  = xvec(1);
  y  = yvec(1);
  t  = time(1);
  n  = 1;
  smax = svec(nvec);
  for i=2:nvec
    dx = xvec(i)-xvec(n);
    dy = yvec(i)-yvec(n);
    ds = sqrt((dx)^2+(dy)^2);
    if( ds >= dsmin )
      n  = n + 1; 
      s0 = s0 + ds;
%        if( s0 >= 1.408937159796255e+02 )
%          a=0;
%        end
      s  = [s;s0];
      x  = [x;xvec(i)];
      y  = [y;yvec(i)];
      t  = [t;time(i)];
    end
  end
  ds = [diff(s);0.0];
%   figure
%   plot(svec,xvec,'k-')
%   hold on
%   plot(s,x,'r-')
%   hold off
%   grid on
%   a=0;
end
function [xmod,ymod,yawmod,q] = approx_for_txy_bspline(s,x,y,smod,q)

  if( q.approx == 0 )
    xmod = interp1(s,x,smod,'linear','extrap');
    ymod = interp1(s,y,smod,'linear','extrap');
    xpmod = diff_prolong(xmod);
    ypmod = diff_prolong(ymod);
    yawmod = atan2(ypmod,xpmod);
  elseif( q.approx == 1 )
    xmod   = approx_bspline(s,x,smod,0);
    ymod   = approx_bspline(s,y,smod,0);
    xpmod  = approx_bspline(s,x,smod,1);
    ypmod  = approx_bspline(s,y,smod,1);
    yawmod = atan2(ypmod,xpmod);
  elseif( q.approx == 2 )
    xmod   = approx_pchip(s,x,smod,0);
    ymod   = approx_pchip(s,y,smod,0);
    xpmod  = approx_pchip(s,x,smod,1);
    ypmod  = approx_pchip(s,y,smod,1);
    yawmod = atan2(ypmod,xpmod);
  else
    xmod   = approx_spline(s,x,smod,0);
    ymod   = approx_spline(s,y,smod,0);
    xpmod  = approx_spline(s,x,smod,1);
    ypmod  = approx_spline(s,y,smod,1);
    yawmod = atan2(ypmod,xpmod);
  end
end
function [yawmod,q] = approx_for_txy_yaw(smod,xmod,ymod,q)

 
 [xmod_filt,xpmod_filt]     = filter_prolong_zerophase(smod,xmod,q.s_filt,1);
 
 
 [ymod_filt,ypmod_filt]     = filter_prolong_zerophase(smod,ymod,q.s_filt,1);
 
 
 yawmod = atan2(ypmod_filt,xpmod_filt);
 
end
  