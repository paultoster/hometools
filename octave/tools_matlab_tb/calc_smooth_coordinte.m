function out = calc_smooth_coordinte(q)
%
%
% in.ctype = 4;
% in.TFilt = 0.75;
% in.dalim = 100.;
% 
% out = calc_smooth_coordinte(q)
%
% Approximation des Pfades zu smooth-coordinates (integriert)
% Es wird aus den Daten der Ruck approximiert und dann bis zu den
% Posiotionen integriert
%
% q.type        = 1: Eingang time,xpath,ypath
%               = 2: Eingang xpath,ypath,vpath
% q.ctype       = 1: Teilapproximation mit Ruck Annahme Polyom (funktioniert schlecht)
%               = 2: Schrittweise Anpassung des Rucks an xpath,ypath mit
%                    Begrenzung
%               = 3: Schrittweise Anpassung des Rucks an vxpath,vypath, der
%               = 4: Schrittweise Anpassen mit gefilterter Beschleunigung
%               mit q.TFilt gefiltert wird
% q.time        [s]   Zeitvektor
% q.xpath       [m]   X-Positionsvektor
% q.ypath       [m]   Y-Positionsvektor
% q.vpath       [m/s] Geschw-Vektor
% q.iord        Potenzordnung der Approximation des Rucks
% q.nmin        minimale Anzahl der Teilapproximation
% q.nmax        maximale Anzahl der Teilapproximation
% q.dt          [s] Berechnung damit durchführen
% q.gend        Gewichtung für Vergleich Approx-Vorgabe am Endpunkt 
%               <= 1.0, Gewichtung über gesamter Bereich: (1. - q.gend)
% q.drlim       [m/s/s/s/s] Limit für Änderung Ruck pro Zeit 
% q.dalim       [m/s/s/s] Limit für Änderung Beschleuingun pro Zeit 
% q.TFilt       [s] Filterkonstante für vxpath,vypath
%
% Ausgabe
% out.tpath     [s]   Zeit Pfad
% out.xpath     [m]   x-Koordinate Pfad
% out.ypath     [m]   y-Koordinate Pfad
% out.spath     [m]   Weg-Parameter Pfad
% out.vxpath    [m/s] x-Geschw Pfad
% out.vypath    [m/s] y-Geschw Pfad
% out.vpath     [m/s] Geschw entlang Pfad
% out.axpath    [m/s/s] x-Beschl Pfad
% out.aypath    [m/s/s] y-Beschl Pfad
% out.apath     [m/s/s] Beschl entlang Pfad
% out.thetapath [rad]   Kurswinel entlang Pfad
% out.kpath     [1/m]   Krümmung entlang Pfad
% out.dkpath    [1/m/m] Krümmung entlang Pfad

  % q.type        = 1: Eingang time,xpath,ypath
  %               = 2: Eingang xpath,ypath,vpath
  if( ~isfield(q,'type') )
    error('q.type ist nicht bestimmt');
  end
  q.type = round(q.type);
  if( q.type < 1 || q.type > 2 )
    error('Fehler: q.type < 1 || q.type > 2');
  end
  % q.ctype       = 1: Teilapproximation mit Ruck Annahme Polyom (funktioniert schlecht)
  %               = 2: Schrittweise Anpassung des Rucks an xpath,ypath mit
  %                    Begrenzung
  %               = 3: Schrittweise Anpassung des Rucks an vxpath,vypath, der
  %               mit q.TFilt gefiltert wird
  %               = 4: Schrittweise Anpassen mit gefilterter Beschleunigung
  if( ~isfield(q,'ctype') )
    error('q.ctype ist nicht bestimmt');
  end
  q.ctype = round(q.ctype);
  if( q.ctype < 1 || q.ctype > 4 )
    error('Fehler: q.ctype < 1 || q.ctype > 4');
  end
  % q.time        [s]   Zeitvektor
  if( (q.type == 1) && ~isfield(q,'time') )
    error('Zeitvektor q.time ist nicht übergeben worden')
  end
  % q.xpath       [m]   X-Positionsvektor
  if( ~isfield(q,'xpath') )
    error('Vektor q.xpath ist nicht übergeben worden')
  end
  % q.ypath       [m]   Y-Positionsvektor
  if( ~isfield(q,'ypath') )
    error('Vektor q.ypath ist nicht übergeben worden')
  end
  % q.vpath       [m/s] Geschw-Vektor
  if( (q.type == 2) && ~isfield(q,'vpath') )
    error('Vektor q.vpath ist nicht übergeben worden')
  end
  if( q.type == 1 )
    q.n = min([length(q.time),length(q.xpath),length(q.ypath)]);
    if( length(q.time)  ~= q.n ), q.time  = q.time(1:q.n); end
    if( length(q.xpath) ~= q.n ), q.xpath = q.xpath(1:q.n); end
    if( length(q.ypath) ~= q.n ), q.ypath = q.ypath(1:q.n); end
  else
    q.n = min([length(q.vpath),length(q.xpath),length(q.ypath)]);
    if( length(q.vpath)  ~= q.n ), q.vpath  = q.vpath(1:q.n); end
    if( length(q.xpath) ~= q.n ), q.xpath = q.xpath(1:q.n); end
    if( length(q.ypath) ~= q.n ), q.ypath = q.ypath(1:q.n); end
  end
  [q.spath,q.dspath] = vek_2d_s_ds_alpha(q.xpath,q.ypath);
  
  % q.dt          [s] Berechnung damit durchführen
  if( ~isfield(q,'dt') )
    error('Fehlt: q.dt          [s] Berechnung damit durchführen');
  end
  if( q.ctype == 1 )
    % q.iord        Potenzordnung der Approximation des Rucks
    if( ~isfield(q,'iord') )
      error('Fehlt: q.iord        Potenzordnung der Approximation des Rucks')
    end
    q.iord = round(abs(q.iord));
    % q.nmin        minimale Anzahl der Teilapproximation
    if( ~isfield(q,'nmin') )
      error('Fehlt: q.nmin        minimale Anzahl der Teilapproximation')
    end
    q.nmin = max(q.iord,round(q.nmin));
    % q.nmax        maximale Anzahl der Teilapproximation
    if( ~isfield(q,'nmax') )
      error('Fehlt: q.nmax        maximale Anzahl der Teilapproximation')
    end
    q.nmax = min(q.n,round(q.nmax));
    % q.gend        Gewichtung für Vergleich Approx-Vorgabe am Endpunkt 
    if( ~isfield(q,'gend') )
      error('Fehlt: q.gend        Gewichtung für Vergleich Approx-Vorgabe am Endpunkt');
    end
    q.gend = min(1.0,max(0.0,q.gend));
  end  
  if( q.ctype == 2 )
    % q.drlim        [m/s/s/s/s] Limit für Änderung Ruck pro Zeit 
    if( ~isfield(q,'drlim') )
      error('Fehlt: q.drlim        [m/s/s/s/s] Limit für Änderung Ruck pro Zeit');
    end
    q.drlim = abs(q.drlim);
  end
  if( q.ctype == 3 )
    % q.drlim        [m/s/s/s/s] Limit für Änderung Ruck pro Zeit 
    if( ~isfield(q,'drlim') )
      error('Fehlt: q.drlim        [m/s/s/s/s] Limit für Änderung Ruck pro Zeit');
    end
    q.drlim = abs(q.drlim);
    % q.TFilt       [s] Filterkonstante für vxpath,vypath
    if( ~isfield(q,'TFilt') )
      error('Fehlt: q.TFilt        [s] Filterkonstante für vxpath,vypath');
    end
    q.TFilt = abs(q.TFilt);
  end
  if( q.ctype == 4 )
    % q.dalim        [m/s/s/s] Limit für Änderung Beschl pro Zeit 
    if( ~isfield(q,'dalim') )
      error('Fehlt: q.dalim        [m/s/s/s] Limit für Änderung Ruck pro Zeit');
    end
    q.dalim = abs(q.dalim);
    % q.TFilt       [s] Filterkonstante für vxpath,vypath
    if( ~isfield(q,'TFilt') )
      error('Fehlt: q.TFilt        [s] Filterkonstante für vxpath,vypath');
    end
    q.TFilt = abs(q.TFilt);
  end
  % Geschw -> Zeit umrechnen
  % und Ausgabezeitvektor bestimmen
  if( q.type == 2 )
    time  = q.spath*0.0;
    for i=2:q.n
      if( q.vpath(i) < 1.e-6 )
        dt = q.dt;
      else
        dt = q.dspath(i-1)/q.vpath(i);
      end
      time(i) = time(i-1)+dt;
    end

    q.tcalc  = [0.0:q.dt:time(q.n)]';
    q.ncalc  = length(q.tcalc);
    q.xcalc = interp1(time,q.xpath,q.tcalc,'cubic','extrap');
    q.ycalc = interp1(time,q.ypath,q.tcalc,'cubic','extrap');
  else
    
    % Zeitvektor bilden
    q.tcalc = [0.0:q.dt:q.time(q.n)]';
    q.ncalc = length(q.tcalc);
    % Pfad an Zeitvektor anpassen
    q.xcalc = interp1(q.time,q.xpath,q.tcalc,'cubic','extrap');
    q.ycalc = interp1(q.time,q.ypath,q.tcalc,'cubic','extrap');
  end
  
  % Ableitungen
  q.vxcalc = differenziere(q.tcalc,q.xcalc,1,0);
  q.vycalc = differenziere(q.tcalc,q.ycalc,1,0);
  q.axcalc = differenziere(q.tcalc,q.vxcalc,1,0);
  q.aycalc = differenziere(q.tcalc,q.vycalc,1,0);
  q.rxcalc = differenziere(q.tcalc,q.axcalc,1,0);
  q.rycalc = differenziere(q.tcalc,q.aycalc,1,0);
  
  if( q.ctype == 1 )
    % Stückweise approximation des Rucks
    q = calc_smooth_coordinte_approx1(q);
  elseif( q.ctype == 2 )
    % Schrittweise Bestimmung des Rucks
    q = calc_smooth_coordinte_approx2(q);
  elseif( q.ctype == 3 )
    % Schrittweise Bestimmung des Rucks
    q = calc_smooth_coordinte_approx3(q);
  elseif( q.ctype == 4 )
    % Schrittweise Bestimmung des Rucks
    q = calc_smooth_coordinte_approx4(q);
  end

  out.tpath     = q.tapprox;
  out.xpath     = q.xapprox;
  out.ypath     = q.yapprox;
  [out.spath,out.dspath,out.thetapath] = vek_2d_s_ds_alpha(q.xapprox,q.yapprox);
  out.vxpath    = q.vxapprox;
  out.vypath    = q.vyapprox;
  out.vpath     = sqrt(q.vxapprox.*q.vxapprox+q.vyapprox.*q.vyapprox);
  out.axpath    = q.axapprox;
  out.aypath    = q.ayapprox;
  out.apath     = sqrt(q.axapprox.*q.axapprox+q.ayapprox.*q.ayapprox);
  v             = not_zero(out.vpath);
  out.kpath     = (out.vxpath.*out.aypath-out.axpath.*out.vypath)./v./v./v;
  out.dkpath    = differenziere(out.spath,out.kpath,1,1);
  
  out.rxpath    = q.rxapprox;
  out.rypath    = q.ryapprox;
  

end
function q = calc_smooth_coordinte_approx1(q)

  flag = 1;
  q.tapprox  = q.tcalc(1);
  q.xapprox  = q.xcalc(1);
  q.yapprox  = q.ycalc(1);
  q.vxapprox = q.vxcalc(1);
  q.vyapprox = q.vycalc(1);
  q.axapprox = q.axcalc(1);
  q.ayapprox = q.aycalc(1);
  q.rxapprox = q.rxcalc(1);
  q.ryapprox = q.rycalc(1);
  q.napprox  = 1;
  while( flag )
    
    i0 = q.napprox;
    i1 = i0+q.nmin-1;
    i2 = i0+q.nmax-1;
    
    if( i2 > q.ncalc )
      i2 = q.ncalc;
    end
    if( i1 > q.ncalc )
      i1 = q.ncalc;
    end
    s.t = q.tcalc(i0:i2);
    s.x = q.xcalc(i0:i2);
    s.y = q.ycalc(i0:i2);
    s.vx = q.vxcalc(i0:i2);
    s.vy = q.vycalc(i0:i2);
    s.ax = q.axcalc(i0:i2);
    s.ay = q.aycalc(i0:i2);
    s.rx = q.rxcalc(i0:i2);
    s.ry = q.rycalc(i0:i2);
    s.nmin = i1-i0+1;
    s.nmax = i2-i0+1;
    s.iord = min(q.iord,s.nmin);   % Reduzieren, wenn nicht mehr genügend Punkte    
    s.ax0  = q.axapprox(i0); 
    s.ay0  = q.ayapprox(i0); 
    s.vx0  = q.vxapprox(i0); 
    s.vy0  = q.vyapprox(i0); 
    s.x0   = q.xapprox(i0); 
    s.y0   = q.yapprox(i0); 
    s.gend = q.gend;
    
    o = calc_smooth_coordinte_approx1_teil(s);
    
    q.tapprox  = [q.tapprox;o.t(2:o.n)];
    q.xapprox  = [q.xapprox;o.xa(2:o.n)];
    q.yapprox  = [q.yapprox;o.ya(2:o.n)];
    q.vxapprox = [q.vxapprox;o.vxa(2:o.n)];
    q.vyapprox = [q.vyapprox;o.vya(2:o.n)];
    q.axapprox = [q.axapprox;o.axa(2:o.n)];
    q.ayapprox = [q.ayapprox;o.aya(2:o.n)];
    q.rxapprox = [q.rxapprox;o.rxa(2:o.n)];
    q.ryapprox = [q.ryapprox;o.rya(2:o.n)];
    q.napprox  = q.napprox + o.n - 1;
    
    if( q.napprox >= q.ncalc )
      flag = 0;
    end
  end
end
function o = calc_smooth_coordinte_approx1_teil(s)

  % Anzahl der Teilapproximation
  n = s.nmax - s.nmin + 1;
  ff = 1e30;
  PX = [];
  PY = [];
  NN = [];
  n1 = s.nmin - 1;
  for i = 1:n
    n1 = n1+1;
    t  = s.t(1:n1) ;
    rx = s.rx(1:n1) ;
    ry = s.ry(1:n1) ;
    try
%      [px,Res] = poly_approx(t-t(1),rx-rx(1),1,1,s.iord,0);
      [px,Res] = poly_approx(t,rx,1,1,s.iord,0);
    catch
      tt = t-t(1);
      rrx = rx-rx(1);
      figure
      plot(tt,rrx)
    end
%    [py,Res] = poly_approx(t-t(1),ry-ry(1),1,1,s.iord,0);
    [py,Res] = poly_approx(t,ry,1,1,s.iord,0);
%     rxa      = poly_multiplaction(px,t-t(1),0)+rx(1);
%     rya      = poly_multiplaction(py,t-t(1),0)+ry(1);
    rxa      = poly_multiplaction(px,t,0);
    rya      = poly_multiplaction(py,t,0);
    
    axa      = integriere(t,rxa,0,s.ax0);
    aya      = integriere(t,rya,0,s.ay0);
    vxa      = integriere(t,axa,0,s.vx0);
    vya      = integriere(t,aya,0,s.vy0);
    xa       = integriere(t,vxa,0,s.x0);
    ya       = integriere(t,vya,0,s.y0);
    
    dx     = s.x(1:n1)-xa;
    dy     = s.y(1:n1)-ya;
    d      = sqrt(dx.*dx+dy.*dy);
    de     = d(n1);
    dm     = mean(d);
    
    f      = de*s.gend + dm * (1.0-s.gend);
    if( f < ff )
      ff = f;
      PX = px;
      PY = py;
      NN = n1;
    end
  end
  
  if( isempty(NN) )
    error('Es konnte keine Teiloptimum gefunden werden')
  else
    o.t        = s.t(1:NN);
%     o.rxa      = poly_multiplaction(PX,s.t(1:NN)-s.t(1),0)+s.rx(1);
%     o.rya      = poly_multiplaction(PY,s.t(1:NN)-s.t(1),0)+s.ry(1);
    o.rxa      = poly_multiplaction(PX,s.t(1:NN),0);
    o.rya      = poly_multiplaction(PY,s.t(1:NN),0);
    
    o.axa      = integriere(s.t(1:NN),o.rxa,0,s.ax0);
    o.aya      = integriere(s.t(1:NN),o.rya,0,s.ay0);
    o.vxa      = integriere(s.t(1:NN),o.axa,0,s.vx0);
    o.vya      = integriere(s.t(1:NN),o.aya,0,s.vy0);
    o.xa       = integriere(s.t(1:NN),o.vxa,0,s.x0);
    o.ya       = integriere(s.t(1:NN),o.vya,0,s.y0);
    o.n        = NN;
  end
end
function q = calc_smooth_coordinte_approx2(q)

  
  q.tapprox  = q.tcalc;
  q.xapprox  = q.tcalc*0.0;
  q.yapprox  = q.tcalc*0.0;
  q.vxapprox = q.tcalc*0.0;
  q.vyapprox = q.tcalc*0.0;
  q.axapprox = q.tcalc*0.0;
  q.ayapprox = q.tcalc*0.0;
  q.rxapprox = q.tcalc*0.0;
  q.ryapprox = q.tcalc*0.0;

  q.xapprox(1)  = q.xcalc(1);
  q.yapprox(1)  = q.ycalc(1);
  q.vxapprox(1) = q.vxcalc(1);
  q.vyapprox(1) = q.vycalc(1);
  q.axapprox(1) = q.axcalc(1);
  q.ayapprox(1) = q.aycalc(1);
  q.rxapprox(1) = q.rxcalc(1);
  q.ryapprox(1) = q.rycalc(1);
  q.napprox  = q.ncalc;
  
  
  for i = 2:q.ncalc
        
    s.dt    = q.tcalc(i)-q.tcalc(i-1);
    s.x     = q.xcalc(i);
    s.y     = q.ycalc(i);
    s.rx0   = q.rxapprox(i-1); 
    s.ry0   = q.ryapprox(i-1); 
    s.ax0   = q.axapprox(i-1); 
    s.ay0   = q.ayapprox(i-1); 
    s.vx0   = q.vxapprox(i-1); 
    s.vy0   = q.vyapprox(i-1); 
    s.x0    = q.xapprox(i-1); 
    s.y0    = q.yapprox(i-1); 
    s.drlim_p = q.drlim*s.dt;
    s.drlim_m = -q.drlim*s.dt;
    
    o = calc_smooth_coordinte_approx2_schritt(s);
    
    q.xapprox(i)   = o.xa;
    q.yapprox(i)   = o.ya;
    q.vxapprox(i)  = o.vxa;
    q.vyapprox(i)  = o.vya;
    q.axapprox(i)  = o.axa;
    q.ayapprox(i)  = o.aya;
    q.rxapprox(i)  = o.rxa;
    q.ryapprox(i)  = o.rya;
    
  end
end
function o = calc_smooth_coordinte_approx2_schritt(s)

  % x-Richtung
  dr = (((s.x-s.x0)/s.dt-s.vx0)/s.dt-s.ax0)/s.dt-s.rx0;
  
  if( dr > s.drlim_p )
    dr = s.drlim_p;
    fprintf('*');
  elseif( dr < s.drlim_m )
    dr = s.drlim_m;
    fprintf('#');
  end
  
  o.rxa = s.rx0 + dr;
  o.axa = s.ax0 + o.rxa * s.dt;
  o.vxa = s.vx0 + o.axa * s.dt;
  o.xa  = s.x0  + o.vxa * s.dt;

  % y-Richtung
  dr = (((s.y-s.y0)/s.dt-s.vy0)/s.dt-s.ay0)/s.dt-s.ry0;
  
  if( dr > s.drlim_p )
    dr = s.drlim_p;
    fprintf('+');
  elseif( dr < s.drlim_m )
    dr = s.drlim_m;
    fprintf('=');
  end
  
  o.rya = s.ry0 + dr;
  o.aya = s.ay0 + o.rya * s.dt;
  o.vya = s.vy0 + o.aya * s.dt;
  o.ya  = s.y0  + o.vya * s.dt;
end
function q = calc_smooth_coordinte_approx3(q)

%   vxfilt =  butter2_filter(q.tcalc,q.vxcalc,q.TFilt,1);
%   vyfilt =  butter2_filter(q.tcalc,q.vycalc,q.TFilt,1);
  vxfilt =  pt1_filter_zp(q.tcalc,q.vxcalc,q.TFilt);
  vyfilt =  pt1_filter_zp(q.tcalc,q.vycalc,q.TFilt);
  
  q.tapprox  = q.tcalc;
  q.xapprox  = q.tcalc*0.0;
  q.yapprox  = q.tcalc*0.0;
  q.vxapprox = q.tcalc*0.0;
  q.vyapprox = q.tcalc*0.0;
  q.axapprox = q.tcalc*0.0;
  q.ayapprox = q.tcalc*0.0;
  q.rxapprox = q.tcalc*0.0;
  q.ryapprox = q.tcalc*0.0;

  q.xapprox(1)  = q.xcalc(1);
  q.yapprox(1)  = q.ycalc(1);
  q.vxapprox(1) = vxfilt(1);
  q.vyapprox(1) = vyfilt(1);
  q.axapprox(1) = q.axcalc(1);
  q.ayapprox(1) = q.aycalc(1);
  q.rxapprox(1) = q.rxcalc(1);
  q.ryapprox(1) = q.rycalc(1);
  q.napprox  = q.ncalc;
  
  
  for i = 2:q.ncalc
        
    s.dt    = q.tcalc(i)-q.tcalc(i-1);
    s.vx    = vxfilt(i);
    s.vy    = vyfilt(i);
    s.rx0   = q.rxapprox(i-1); 
    s.ry0   = q.ryapprox(i-1); 
    s.ax0   = q.axapprox(i-1); 
    s.ay0   = q.ayapprox(i-1); 
    s.vx0   = q.vxapprox(i-1); 
    s.vy0   = q.vyapprox(i-1); 
    s.x0    = q.xapprox(i-1); 
    s.y0    = q.yapprox(i-1); 
    s.drlim_p = q.drlim*s.dt;
    s.drlim_m = -q.drlim*s.dt;
    
    o = calc_smooth_coordinte_approx3_schritt(s);
    
    q.xapprox(i)   = o.xa;
    q.yapprox(i)   = o.ya;
    q.vxapprox(i)  = o.vxa;
    q.vyapprox(i)  = o.vya;
    q.axapprox(i)  = o.axa;
    q.ayapprox(i)  = o.aya;
    q.rxapprox(i)  = o.rxa;
    q.ryapprox(i)  = o.rya;
    
  end
end
function o = calc_smooth_coordinte_approx3_schritt(s)

  % x-Richtung
  dr = ((s.vx-s.vx0)/s.dt-s.ax0)/s.dt-s.rx0;
  
  if( dr > s.drlim_p )
    dr = s.drlim_p;
    fprintf('*');
  elseif( dr < s.drlim_m )
    dr = s.drlim_m;
    fprintf('#');
  end
  
  o.rxa = s.rx0 + dr;
  o.axa = s.ax0 + o.rxa * s.dt;
  o.vxa = s.vx0 + o.axa * s.dt;
  o.xa  = s.x0  + o.vxa * s.dt;

  % y-Richtung
  dr = ((s.vy-s.vy0)/s.dt-s.ay0)/s.dt-s.ry0;
  
  if( dr > s.drlim_p )
    dr = s.drlim_p;
    fprintf('+');
  elseif( dr < s.drlim_m )
    dr = s.drlim_m;
    fprintf('=');
  end
  
  o.rya = s.ry0 + dr;
  o.aya = s.ay0 + o.rya * s.dt;
  o.vya = s.vy0 + o.aya * s.dt;
  o.ya  = s.y0  + o.vya * s.dt;
end
function q = calc_smooth_coordinte_approx4(q)

  axfilt =  butter2_filter(q.tcalc,q.axcalc,q.TFilt,1);
  % axfilt =  pt1_filter_zp(q.tcalc,q.axcalc,q.TFilt);
  vxfilt = integriere(q.tcalc,axfilt,0,q.vxcalc(1));
  xfilt  = integriere(q.tcalc,vxfilt,0,q.xcalc(1));
  
  delta  = q.xcalc(q.ncalc)-xfilt(q.ncalc);
  i = 0;  
  while( (abs(delta) > 0.1) && (i <= 10) )
    i = i + 1;
    tend = q.tcalc(q.ncalc);
    aend = 6.*delta/tend/tend;
    axfilt = axfilt + aend/tend*q.tcalc;
    vxfilt = integriere(q.tcalc,axfilt,0,q.vxcalc(1));
    xfilt  = integriere(q.tcalc,vxfilt,0,q.xcalc(1));
    delta  = q.xcalc(q.ncalc)-xfilt(q.ncalc);
  end
    
  ayfilt =  butter2_filter(q.tcalc,q.aycalc,q.TFilt,1);
  % ayfilt =  pt1_filter_zp(q.tcalc,q.aycalc,q.TFilt);
  vyfilt = integriere(q.tcalc,ayfilt,0,q.vycalc(1));
  yfilt  = integriere(q.tcalc,vyfilt,0,q.ycalc(1));
  
  delta  = q.ycalc(q.ncalc)-yfilt(q.ncalc);
  
  i = 0;  
  while( (abs(delta) > 0.1) && (i <= 10) )
    i = i + 1;
    
    tend = q.tcalc(q.ncalc);
    aend = 6.*delta/tend/tend;
    ayfilt = ayfilt + aend/tend*q.tcalc;
    vyfilt = integriere(q.tcalc,ayfilt,0,q.vycalc(1));
    yfilt  = integriere(q.tcalc,vyfilt,0,q.ycalc(1));
    delta  = q.ycalc(q.ncalc)-yfilt(q.ncalc);
  end
  
  q.tapprox  = q.tcalc;
  q.xapprox  = q.tcalc*0.0;
  q.yapprox  = q.tcalc*0.0;
  q.vxapprox = q.tcalc*0.0;
  q.vyapprox = q.tcalc*0.0;
  q.axapprox = q.tcalc*0.0;
  q.ayapprox = q.tcalc*0.0;
  q.rxapprox = q.tcalc*0.0;
  q.ryapprox = q.tcalc*0.0;

  q.xapprox(1)  = q.xcalc(1);
  q.yapprox(1)  = q.ycalc(1);
  q.vxapprox(1) = vxfilt(1);
  q.vyapprox(1) = vyfilt(1);
  q.axapprox(1) = q.axcalc(1);
  q.ayapprox(1) = q.aycalc(1);
  q.rxapprox(1) = q.rxcalc(1);
  q.ryapprox(1) = q.rycalc(1);
  q.napprox  = q.ncalc;
  
  
  for i = 2:q.ncalc
        
    s.dt    = q.tcalc(i)-q.tcalc(i-1);
    s.x     = xfilt(i);
    s.y     = yfilt(i);
    s.rx0   = q.rxapprox(i-1); 
    s.ry0   = q.ryapprox(i-1); 
    s.ax0   = q.axapprox(i-1); 
    s.ay0   = q.ayapprox(i-1); 
    s.vx0   = q.vxapprox(i-1); 
    s.vy0   = q.vyapprox(i-1); 
    s.x0    = q.xapprox(i-1); 
    s.y0    = q.yapprox(i-1); 
    s.dalim_p = q.dalim *s.dt;
    s.dalim_m = -s.dalim_p;
    
    o = calc_smooth_coordinte_approx4_schritt(s);
    
    q.xapprox(i)   = o.xa;
    q.yapprox(i)   = o.ya;
    q.vxapprox(i)  = o.vxa;
    q.vyapprox(i)  = o.vya;
    q.axapprox(i)  = o.axa;
    q.ayapprox(i)  = o.aya;
    q.rxapprox(i)  = o.rxa;
    q.ryapprox(i)  = o.rya;
    
  end
end
function o = calc_smooth_coordinte_approx4_schritt(s)

  % x-Richtung
  da = ((s.x-s.x0)/s.dt-s.vx0)/s.dt-s.ax0;
  
  if( da > s.dalim_p )
    da = s.dalim_p;
  elseif( da < s.dalim_m )
    da = s.dalim_m;
  end
  
  o.rxa = da / s.dt;
  o.axa = s.ax0 + da;
  o.vxa = s.vx0 + o.axa * s.dt;
  o.xa  = s.x0  + o.vxa * s.dt;

  % y-Richtung
  da = ((s.y-s.y0)/s.dt-s.vy0)/s.dt-s.ay0;
  
  if( da > s.dalim_p )
    da = s.dalim_p;
  elseif( da < s.dalim_m )
    da = s.dalim_m;
  end
  
  o.rya = da/s.dt;
  o.aya = s.ay0 + da;
  o.vya = s.vy0 + o.aya * s.dt;
  o.ya  = s.y0  + o.vya * s.dt;
end
