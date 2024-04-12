function [smod,xmod,ymod,yawmod,q] = polynom_for_txy(time_in,xvec,yvec,q)
% 
% [xmod,ymod,yawmod] = polynom_for_txy(time,xvec,yvec,q)
%
% geglättete Kurve für xvec,yvec in Teilstücken
% x-und y werden separat gefittet xvec(svec) und yvec(svec)
% Dazu werden die die Punkte delta_s < dsmin rausgenommen,
% aber für die Rückgabe wieder reingenommen
% Parameter:
% q.nmin     minimale Punktzahl zum Approximieren eines Teilstücks
% q.dsgrob   delta_s für Grobabschätzung der Krümmungen und damit Einteilung der Abschnitte
% q.dsmin    minimaler Abstand zweier Punkte zum fitten
% q.plotflag soll geplottet werden
% q.fig_num  aktuelle letzte figuren-Nummer
% q.Nord     Ordnung des Polynoms
% q.s_filt   Filterlänge, für Filterung Steigung
% q.ds_out   Ausgabe in delta Weg Länge
% q.yawvec   Wenn vorhanden yawvec(1:n) wird dieser Headingwinkel benutzt
%            für Teilstücke zu erstellen
%
  xmod   = [];
  ymod   = [];
  yawmod = [];
  nvec = min(length(xvec),length(yvec));
  xvec = xvec(1:nvec);
  yvec = yvec(1:nvec);
  time = time_in(1:nvec);
  svec = vek_2d_build_s(xvec,yvec,nvec,0.0,-1.);

  if( ~check_val_in_struct(q,'nmin','num',1) )
    q.nmin = min(10,nvec);
  end
  q.nmin = min(q.nmin,nvec);
  
  if( ~check_val_in_struct(q,'dsgrob','num',1) )
    q.dsgrob = svec(nvec)/q.nmin;
  end
  
  if( ~check_val_in_struct(q,'dsmin','num',1) )
    q.dsmin = 0.001;
  end
  
  if( ~check_val_in_struct(q,'Nord','num',1) )
    q.Nord = 5;
  end
  
  if( ~check_val_in_struct(q,'s_filt','num',1) )
    q.s_filt = 10.;
  end
  
  if( ~check_val_in_struct(q,'ds_out','num',1) )
    q.ds_out = 0.1;
  end
  
  if( check_val_in_struct(q,'yawvec','num',1) )
    if( length(q.yawvec) <= nvec )
      yawvec    = q.yawvec(1:nvec);
      q.use_yaw = 1;
    else
      yawvec = [];
      q.use_yaw = 0;
    end
  else
    yawvec = [];
    q.use_yaw = 0;
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
  if( q.use_yaw )
    yawvec = yawvec(ivec);
  end
  nvec = length(svec);
  
  % Punkte bereinigen
  %==================
  [t,x,y,yaw,s,ds,n] = polynom_for_txy_build_svec(time,xvec,yvec,nvec,q.dsmin,svec,yawvec,q.use_yaw);
  
  % Teilstücke bestimmen
  if( q.use_yaw ) % Teilstücke mit Headingangle bestimmen
    [sx,sy,q] = polynom_for_txy_build_teilstuecke_mit_yaw(s,x,y,yaw,n,q);
  else    
    [sx,q] = polynom_for_txy_build_teilstuecke(s,x,n,q,'Vektor x');
    [sy,q] = polynom_for_txy_build_teilstuecke(s,y,n,q,'Vektor y');
  end  
  % Steigung an den Endpunkten der Teilstuecke bestimmen
  [sx,q] = polynom_for_txy_steigung_teilstuecke(sx,s,x,n,q,'Vektor x');
  [sy,q] = polynom_for_txy_steigung_teilstuecke(sy,s,y,n,q,'Vektor y');
  
  % Teilstück approximieren
  [sx,q] = polynom_for_txy_approx_teilstuecke(sx,s,x,n,q,'Vektor x');
  [sy,q] = polynom_for_txy_approx_teilstuecke(sy,s,y,n,q,'Vektor y');
  
  % Gesamtlänge erstellen
  [xmod,ymod,yawmod] = polynom_for_txy_gesamt(s,n,sx,sy,q);
  
  smod   = [s(1):q.ds_out:s(n)]';
  xmod   = interp1(s,xmod,smod,'linear','extrap');
  ymod   = interp1(s,ymod,smod,'linear','extrap');
  yawmod = interp1(s,yawmod,smod,'linear','extrap');
end
function [t,x,y,yaw,s,ds,n] = polynom_for_txy_build_svec(time,xvec,yvec,nvec,dsmin,svec,yawvec,use_yaw)
%
% Bilde Bahn der Punkte mindestens den Abstand dsmin hat
%
  yaw = [];
  s0 = 0.0;
  s  = s0;
  x  = xvec(1);
  y  = yvec(1);
  if( use_yaw )
    yaw = yawvec(1);
  end
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
      if( use_yaw )
        yaw = [yaw;yawvec(i)];
      end
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
function [sx,sy,q] = polynom_for_txy_build_teilstuecke_mit_yaw(s,x,y,yaw,n,q)
% Einteilung der Teilstücke Anhand Krümmungsverlauf mit yaw berechnet,
% mindestens q.nmin Punkte
% Immer dann wenn gefilterte Krümmung ein Minimum hat oder durch null geht
% sx(i).i0   Teilstück-i Startindex
% sx(i).i1   Teilstück-i Endindex
% sx(i).n    Teilstück-i Anzahl

  [yaw_filt,yawp_filt]     = filter_prolong_zerophase(s,yaw,q.s_filt,1);
  [yawp_filt2,yawpp_filt2] = filter_prolong_zerophase(s,yawp_filt,q.s_filt,1);
  [yawpp_filt3]            = filter_prolong_zerophase(s,yawpp_filt2,q.s_filt,1);
  
  n1    = round(length(yawpp_filt3)*3/4);
  delta = (max(yawpp_filt3(1:n1))-min(yawpp_filt3(1:n1)))/30.;
    
  [ss,nss]                   = suche_vec_min_max(yawpp_filt3,delta);
  
  if( q.plotflag )
    q.fig_num = q.fig_num + 1;
    p_figure(q.fig_num,2,'txy1')
    subplot(3,1,1)
    plot(s,yaw*180/pi,'k-')
    hold on
    plot(s,yaw_filt*180/pi,'r-')
    hold off
    grid on
    xlabel('s [m]')
    ylabel('yaw [deg]')
    legend('yaw','yaw_filt')
    subplot(3,1,2)
    plot(s,yawp_filt,'k-')
    hold on
    plot(s,yawp_filt2,'r-')
    hold off
    grid on
    xlabel('s [m]')
    ylabel('yawp [1/m]')
    legend('yawp_filt','yawp_filt2')
    subplot(3,1,3)
    plot(s,yawpp_filt2,'k-')
    hold on
    plot(s,yawpp_filt3,'r-')
    hold off
    grid on
    xlabel('s [m]')
    ylabel('yawpp [1/m/m]')
    legend('yawpp_filt2','yawpp_filt3')
      
    y_rng  = get(gca,'Ylim');

    for i=1:nss
      i0 = ss(i).index;
      x_rng = [s(i0),s(i0)];
      hold on
      if( ss(i).type > 0.0 )
        plot(x_rng,y_rng,'g-')
      else
        plot(x_rng,y_rng,'b-')
      end
      hold off
    end
  end
  
  % Teilstücke bilden
  i0  = 1;
  nsx = 0;
  sx  = [];
  sy  = [];
  n   = length(s);
  for i=1:nss
    
    i1    = ss(i).index;
    ni01  = i1-i0+1;
    if( ni01 > q.nmin )
      nsx = nsx+1;
      sx(nsx).i0 = i0;
      sx(nsx).i1 = i1;
      sx(nsx).n  = ni01;
      sy(nsx).i0 = i0;
      sy(nsx).i1 = i1;
      sy(nsx).n  = ni01;
      i0         = i1;
    end
  end
  % letzter Punkt
  if( n-sx(nsx).i1 < q.nmin ) % Zuwenige Punkte für neue Stützstelle
    sx(nsx).i1 = n;
    sx(nsx).n  = sx(nsx).i1-sx(nsx).i0+1;
    sy(nsx).i1 = sx(nsx).i1;
    sy(nsx).n  = sx(nsx).n;
  else
    nsx = nsx + 1;
    sx(nsx).i0 = sx(nsx-1).i1;
    sx(nsx).i1 = n;
    sx(nsx).n  = sx(nsx).i1-sx(nsx).i0+1;
    sy(nsx).i0 = sx(nsx).i0;
    sy(nsx).i1 = sx(nsx).i1;
    sy(nsx).n  = sx(nsx).n;
  end

end
function [sv,q] = polynom_for_txy_build_teilstuecke(s,v,n,q,vname)
% Einteilung der Teilstücke Anhand Krümmungsverlauf mit q.sgrob,
% mindestens q.nmin Punkte;
% Immer dann wenn GrobKrümmung ein Minimum hat
% sv(i).i0   Teilstück-i Startindex
% sv(i).i1   Teilstück-i Endindex
% sv(i).n    Teilstück-i Anzahl

  s0  = 0.0;
  ss  = s0;
  vv  = v(1);
  ii  = 1;
  nv  = 1;
  for i=2:n
    ds = s(i)-s0;
    if( (ds >= q.dsgrob) || (i == n) )
      nv  = nv + 1; 
      s0 = s0 + ds;
      ss = [ss;s0];
      vv = [vv;v(i)];
      ii = [ii;i];
    end
  end
  
  % Steigung
  [sss,ds,alpha] = vek_2d_s_ds_alpha(ss,vv,0.0);
  kappa = abs(path_calc_kappa(alpha,ds,nv,0));
 
  if( q.plotflag )
    q.fig_num = q.fig_num + 1;
    p_figure(q.fig_num,0,'txy1')

    plot(sss,kappa,'k.-')
    hold on
    plot(sss,sss*0.0+mean(kappa),'k-')
    plot(sss,sss*0.0+mean(kappa)+std(kappa),'g-')
    plot(sss,sss*0.0+mean(kappa)-std(kappa),'g-')
    hold off
    title(vname)
    grid on
    xlabel('sss')
    ylabel('kappa')
    legend('kappa','mean','+std','-std')
  end
  
  isv        = 1;
  sv(isv).i0 = 1; % der erste Punkt
  if( kappa(2) < kappa(1) )
    richtung = -1;
    kappamin = kappa(1);
    kappamax = kappa(1);
  else
    richtung = +1;
    kappamin = kappa(1);
    kappamax = kappa(1);
  end
  kappastd = std(kappa)/10;
  i    = 1;
  flag = 1;
  while( (i<=nv) && flag )
    
    if( richtung > 0 )
      if( kappa(i) < kappamax )
        richtung = -1;
        kappamin = kappa(i);
      else
        kappamax   = kappa(i);  
      end
      
    else
      if( kappa(i) > kappamin )
        % minimum erreicht
        if( kappa(i) > (kappamin + kappastd) ) 
          [sv,isv,flag,i,richtung,kappamin,kappamax] = polynom_for_txy_build_teilstuecke_min(i,ii,kappa,sv,isv,q.nmin,nv,flag,richtung,kappamin,kappamax);
        end
      else
        kappamin = kappa(i);
      end
    end
    if( flag && (i == nv) ) % Ende
      sv(isv).i1 = ii(i);
      sv(isv).n  = sv(isv).i1 - sv(isv).i0 +1;
      if( (sv(isv).n < q.nmin) && (isv > 1) )
        isv = isv - 1;
        sv(isv).i1 = ii(i);
        sv(isv).n  = sv(isv).i1 - sv(isv).i0 +1;
        sv = sv(1:isv);
      end
    end
    i = i +1;
    
  end
    
end
function   [sv,isv,flag,i,richtung,kappamin,kappamax] = polynom_for_txy_build_teilstuecke_min(i,ii,kappa,sv,isv,nmin,nv,flag,richtung,kappamin,kappamax)
  if( ii(i) - sv(isv).i0 >= nmin )
    sv(isv).i1 = ii(i);
    sv(isv).n  = sv(isv).i1 - sv(isv).i0 +1;
    if( ((i+1) == nv) && ((ii(i+1)-ii(i))<nmin) )
      sv(isv).i1 = ii(i+1);
      sv(isv).n  = sv(isv).i1 - sv(isv).i0 +1;
      flag       = 0;
    else
      isv = isv+1;
      sv(isv).i0 = sv(isv-1).i1;
    end
    richtung = +1;
    kappamax   = kappa(i);
  else
    sv(isv).n  = nmin;
    sv(isv).i1 = sv(isv).i0 + nmin -1;
    if( sv(isv).i1 >= n )
      sv(isv).i1 = n;
      sv(isv).n  = sv(isv).i1 - sv(isv).i0 +1;
      flag  = 0;
      % richtung = 0;
      % kappa0   = 0;
    else
      flag1 = 1;
      while( flag1 )
        i = i+1;
        if( i == nv ) % Ende
          sv(isv).i1 = n;
          sv(isv).n  = sv(isv).i1 - sv(isv).i0 +1;
          flag  = 0;
          flag1 = 0;
          % richtung = 0;
          % kappa0   = 0;
        elseif( sv(isv).i1 <= ii(i) ) % Nummer in sv ist kleiner der nächsten kappastelle
          isv = isv+1;
          sv(isv).i0 = sv(isv-1).i1;
          kappa0 = (ii(i)-sv(isv).i0)/(ii(i) - ii(i-1))*(kappa(i)-kappa(i-1))+kappa(i-1);
          if( kappa(i) < kappa0 )
            richtung = -1;
            kappamin = kappa0;
          else
            richtung = +1;
            kappamax = kappa0;
          end
          i      = i-1;
          flag1  = 0;
        end
      end 
    end
  end
end
function [sv,q] = polynom_for_txy_steigung_teilstuecke(sv,s,v,n,q,vname)

  [s1,v1,i0,i1] = polynom_for_txy_erweit_teilstuecke(s,v,n,n/2);
  vfilt = butter2_filter(s1,v1,q.s_filt,1);
  [vdiff_f, vdiff] = diff_pt1_zp(s1,vfilt,q.s_filt);
  vfilt = vfilt(i0:i1);
  vdiff = vdiff(i0:i1);
  vdiff_f = vdiff_f(i0:i1);
  
  nsv = length(sv);
  for i = 1:nsv;
    sv(i).ypend = vdiff_f(sv(i).i1);
    
    j0 = max(1,sv(i).i1 - q.nmin);
    j1 = min(n,sv(i).i1 - q.nmin);
    offset = sum(v(j0:j1)-vfilt(j0:j1))/(j1-j0+1);
    sv(i).yend  = vfilt(sv(i).i1)+offset;
  end
  
  if( q.plotflag )
    q.fig_num = q.fig_num + 1;
    h0 = p_figure(q.fig_num,2,'txy4');
   
    plot(s,v,'k-')
    hold on
    plot(s,vfilt,'r-')
    hold off
    grid on
    title(vname)
    legend('s-v','s-vfilt')

    q.fig_num = q.fig_num + 1;
    h0 = p_figure(q.fig_num,2,'txy5');
   
    plot(s,vdiff,'k-')
    hold on
    plot(s,vdiff_f,'r-')
    hold off
    grid on
    title(vname)
    legend('s-vdiff','s-vdiff_f')
  end

end
function [sout,vout,i0,i1] = polynom_for_txy_erweit_teilstuecke(s,v,n,ne)

  % Vorderes Stück ne spiegeln
  st1 = s(1)-(s(2:ne)-s(1));
  vt1 = v(1)-(v(2:ne)-v(1));
  nt1 = length(st1);
  % Hinteres Stück spiegeln
  st2 = s(n)-(s(n-ne+1:n-1)-s(n));
  vt2 = v(n)-(v(n-ne+1:n-1)-v(n));
  
  sout = [umsortieren(st1);s;umsortieren(st2)];
  vout = [umsortieren(vt1);v;umsortieren(vt2)];
  
  i0   = nt1 + 1;
  i1   = nt1 + n;
  
end
function [sv,q] = polynom_for_txy_approx_teilstuecke(sv,s,v,n,q,vname)
%
% Approximation der Teilstücke
% mit q.Nord

  nsv = length(sv);
 
  % erstes Teilstück (frei)
  %========================
  istart = sv(1).i0;
  iend   = sv(1).i1;
  n      = sv(1).n;
  xvec   = s(istart:iend);
  yvec   = v(istart:iend);
  b0 = [];
  b1 = [sv(1).yend,sv(1).ypend];
 
  sv(1).p   = polynom_approx_bound_xy(q.Nord,xvec,yvec,b0,b1);
  sv(1).pd  = polyder(sv(1).p);
  sv(1).pdd = polyder(sv(1).pd);
  
  
  xmod   = xvec;
  ymod   = polyval(sv(1).p,xmod);
  xend   = xmod(end);
  yend   = polyval(sv(1).p,xend);
  ypend   = polyval(sv(1).pd,xend);
  yppend   = polyval(sv(1).pdd,xend);
 
  if( q.plotflag )
    set_plot_standards
    q.fig_num = q.fig_num + 1;
    h0 = p_figure(q.fig_num,2,'txy2');
   
    plot(xvec,yvec,'k-')
    hold on
    plot(xmod,ymod,'Color',PlotStandards.Farbe{2},'LineStyle','-')
    hold off
    grid on
    title(vname)

    q.fig_num = q.fig_num + 1;
    h1 = p_figure(q.fig_num,2,'txy3');   
    plot(xmod,yvec-ymod,'Color',PlotStandards.Farbe{2},'LineStyle','-')
    ylabel('vvec-vmod')
    grid on
    title(vname)
  end
  
  for i=2:nsv
    
    b0 = [yend,ypend];
    b1 = [sv(i).yend,sv(i).ypend];
    istart = sv(i).i0;
    iend   = sv(i).i1;
    n      = sv(i).n;
    xvec   = s(istart:iend);
    yvec   = v(istart:iend);
 
    sv(i).p   = polynom_approx_bound_xy(q.Nord,xvec,yvec,b0,b1);
    sv(i).pd  = polyder(sv(i).p);
    sv(i).pdd = polyder(sv(i).pd);
  
    xmod   = xvec;
    ymod   = polyval(sv(i).p,xmod);
    xend   = xmod(end);
    yend   = polyval(sv(i).p,xend);
    ypend   = polyval(sv(i).pd,xend);
    yppend   = polyval(sv(i).pdd,xend);
    
    if( q.plotflag )
      figure(h0)
      hold on
      plot(xvec,yvec,'k-')
      plot(xmod,ymod,'Color',PlotStandards.Farbe{1+i},'LineStyle','-')
      hold off
      grid on
      
      figure(h1)
      hold on
      plot(xmod,yvec-ymod,'Color',PlotStandards.Farbe{2},'LineStyle','-')
      hold off
    end
  end
    
end
function [xmod,ymod,yawmod] = polynom_for_txy_gesamt(s,n,sx,sy,q)

 nsx = length(sx);
 nsy = length(sy);
 isx = 1;
 isy = 1;
 xmod   = zeros(n,1);
 ymod   = zeros(n,1);
 yawmod = zeros(n,1);
 
 for i=1:n
   
   if( i > sx(isx).i1 )
     isx = isx + 1;
   end
   if( i > sy(isy).i1 )
     isy = isy + 1;
   end
   
   xmod(i)   = polyval(sx(isx).p,s(i));
   ymod(i)   = polyval(sy(isy).p,s(i));
   xp        = polyval(sx(isx).pd,s(i));
   yp        = polyval(sy(isy).pd,s(i));
   yawmod(i) = atan2(yp,xp);
   
 end
end
