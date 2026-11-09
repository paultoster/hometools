function [xvec,yvec,svec] = vek_2d_build_path(s)
%
% [xvec,yvec]      = vek_2d_build_path(s)
% [xvec,yvec,svec] = vek_2d_build_path(s)
%  
% build path points with rules:
% 
% s.type  =   'ramp'    Rampe
%             'line'    Linie
%             'winkel'  Abknickender Winkel
%             'path'    Pfad Bildung mit Clothoiden oder Cosinus-Schwingung
%
% s.xrandom    [m]    random artiges aufaddieren in x
% s.yrandom    [m]    random artiges aufaddieren in y
%
% s.type  ==   'line'
% ===================
% s.slen       [m]    length of line
% s.ds         [m]    distance between ´points, but will be adapted
% oder
% s.dsvec      [m]    Vector with length pieces ds0,ds1,ds2,... , but will be adapted to
%                     s.slen
% s.x0         [m]    start x
% s.y0         [m]    start y
% s.yaw0       [rad]  start yaw angle
%
% s.type  ==   'ramp'
% ===================
% s.slen0      [m]    length of line befor ramp
% s.slen1      [m]    length of line after ramp
% s.slenr      [m]    length of ramp
% s.dy         [m]    step hight of ramp
% s.ds         [m]    distance between points, but will be adapted
% oder
% s.dsvec      [m]    Vector with length pieces ds0,ds1,ds2,..., but will be adapted to
%                     s.slen
% s.x0         [m]    start x
% s.y0         [m]    start y
% s.yaw0       [rad]  start yaw angle
%
% s.type  ==   'winkel'
% ===================
% s.slen0      [m]    length of line befor buckling
% s.slen1      [m]    length of line after buckling
% s.dyaw       [rad]  yaw angle of buckling
% s.ds         [m]    distance between points, but will be adapted
% oder
% s.dsvec      [m]    Vector with length pieces ds0,ds1,ds2,..., but will be adapted to
%                     s.slen
% s.x0         [m]    start x
% s.y0         [m]    start y
% s.yaw0       [rad]  start yaw angle
%
% s.type == 'path'
% ===================
%
% s.bvec       [-]    Vektor with sequences of buildimg path
%                     1) clothoid along distance s.bvec = [...,1,S,kappaend,...]    
%                        nr=1 a segemnt with length S/m will be build,
%                        with clothoid changing from kappa0 (from last 
%                        segment) to kappaend
%                     2) clothoid along angle   s.bvec[...,2,YAW,kappastart,kappaend,...]
%                        nr=2 a segemnt with over YAW-angle/rad will be build,
%                        with clothoid changing from kappa0 (from last 
%                        segment) to kappaend
%                     3) cosinus oszilation   s.bvec[...,3,L,X,A,...]
%                        nr=2 a segemnt with over X-distance/m will be build,
%                        with cosinus of Amplitude A (positive to left) and
%                        Length of one wave X
%                     
%                     s.bvec could be concatinated e.g.
%                     s.bvec = [1,10,0.0, 2,45/57.2958,0.05, 2,45/57.2958,0.0, 1,10,0.0, 3,40,10,1.0]
%                     => first: 10 m straight, second,third going around a curve of 90 deg to
%                     the left with increasing and deacresing kappa up 0.05
%                     forth 10 m straight, fivth Ostilation along 40 m with
%                     peroid length 10 m and 1.0 m Amplitude
%
% s.ds         [m]    distance between points, but will be adapted
% s.dyaw       [rad]  angle step to build clothoid with angle
% s.x0         [m]    start x
% s.y0         [m]    start y
% s.yaw0       [rad]  start yaw angle

  check_val_in_struct(s,'type','char',1,1);

  check_val_in_struct(s,'x0',  'num',1,1);
  check_val_in_struct(s,'y0',  'num',1,1);
  check_val_in_struct(s,'yaw0','num',1,1);
  
  if( ~check_val_in_struct(s,'xrandom',  'num',1,0) )
    s.xrandom = 0.0;
  end
  if( ~check_val_in_struct(s,'yrandom',  'num',1,0) )
    s.yrandom = 0.0;
  end

  if( s.type(1) == 'l' )
    check_val_in_struct(s,'slen','num',1,1);
      
    % über die Länge slen werden Punkte im konstantem Abstand ds gebildet
    if( check_val_in_struct(s,'ds',  'num',1,0) )
      
      [svec,n] = vek_2d_build_path_build_svec(s.ds,s.slen);
    % über die Länge slen werden Punkte im Abstand des Vektors dsvec gebildet
    else
      check_val_in_struct(s,'dsvec',  'num',1,1)
      [svec,n] = vek_2d_build_path_build_svec(s.dsvec,s.slen);
    end
    if( n < 2 )
      error('%s: s.slen = %f < s.ds = %f',s.slen,s.ds)
    end
    
    xvec = zeros(n,1); 
    yvec = zeros(n,1); 
    
    xvec(1) = 0.;
    yvec(1) = 0.;
    for i=2:n
      xvec(i) = svec(i);
      yvec(i) = 0.0;
    end
    
    
    
  elseif( s.type(1) == 'r' )
    
    check_val_in_struct(s,'slen0','num',1,1);
    check_val_in_struct(s,'slen1',  'num',1,1);
    check_val_in_struct(s,'slenr',  'num',1,1);
    check_val_in_struct(s,'dy',  'num',1,1);

    slen = s.slen0+s.slen1+s.slenr;
    
    % über die Länge slen werden Punkte im konstantem Abstand ds gebildet
    if( check_val_in_struct(s,'ds',  'num',1,0) )
      
      [svec,n] = vek_2d_build_path_build_svec(s.ds,slen);
    % über die Länge slen werden Punkte im Abstand des Vektors dsvec gebildet
    else
      check_val_in_struct(s,'dsvec',  'num',1,1)
      [svec,n] = vek_2d_build_path_build_svec(s.dsvec,slen);
    end
    
    if( n < 2 )
      error('%s: slen = %f < s.ds = %f',slen,s.ds)
    end
    
    if( s.slenr < eps )
      error('%s: s.slenr = %f < eps',mfilename,s.slenr);
    end
    
    yawramp = asin(s.dy/s.slenr);
    
    xvec = zeros(n,1); 
    yvec = zeros(n,1); 
    
    xvec(1) = 0.;
    yvec(1) = 0.;
    for i=2:n
      
      if( svec(i) < s.slen0 )        
        xvec(i) = svec(i);
        yvec(i) = 0.0;
      elseif( svec(i) < (s.slen0+s.slenr) )
        sramp = svec(i)- s.slen0;
        
        xvec(i) = s.slen0 + cos(yawramp) * sramp;
        yvec(i) = sin(yawramp) * sramp;
      else
        send = svec(i) - (s.slen0+s.slenr);

        xvec(i) = s.slen0 + cos(yawramp) * s.slenr + send;
        yvec(i) = sin(yawramp) * s.slenr;
        
      end
        
    end

% s.slen0      [m]    length of line befor buckling
% s.slen1      [m]    length of line after buckling
% s.dyaw       [rad]  yaw angle of buckling
% s.ds         [m]    distance between points, but will be adapted
% s.x0         [m]    start x
% s.y0         [m]    start y
% s.yaw0       [rad]  start yaw angle
  elseif( s.type(1) == 'w' )
    
    check_val_in_struct(s,'slen0','num',1,1);
    check_val_in_struct(s,'slen1',  'num',1,1);
    check_val_in_struct(s,'dyaw',  'num',1,1);

    slen = s.slen0+s.slen1;
    % über die Länge slen werden Punkte im konstantem Abstand ds gebildet
    if( check_val_in_struct(s,'ds',  'num',1,0) )
      
      [svec,n] = vek_2d_build_path_build_svec(s.ds,slen);
    % über die Länge slen werden Punkte im Abstand des Vektors dsvec gebildet
    else
      check_val_in_struct(s,'dsvec',  'num',1,1);
      [svec,n] = vek_2d_build_path_build_svec(s.dsvec,slen);
    end
    if( n < 2 )
      error('%s: slen = %f < s.ds = %f',slen,s.ds)
    end
    
    
    cyaw = cos(s.dyaw);
    syaw = sin(s.dyaw);
        
    xvec = zeros(n,1); 
    yvec = zeros(n,1); 
    
    
    xvec(1) = 0.;
    yvec(1) = 0.;
    for i=2:n
      
      if( svec(i) < s.slen0 )        
        xvec(i) = svec(i);
        yvec(i) = 0.0;
      else
        swinkel = svec(i)- s.slen0;
        
        xvec(i) = s.slen0 + cyaw * swinkel;
        yvec(i) = syaw * swinkel;
      end        
    end
% s.bvec       [-]    Vektor with sequences of buildimg path
%                     1) clothoid along distance s.bvec = [...,1,S,kappastart,kappaend,...]    
%                        nr=1 a segemnt with length S/m will be build,
%                        with clothoid changing from kappastart (from last 
%                        segment) to kappaend
%                     2) clothoid along angle   s.bvec[...,2,YAW,kappastart,kappaend,...]
%                        nr=2 a segemnt with over YAW-angle/rad will be build,
%                        with clothoid changing from kappa0 (from last 
%                        segment) to kappaend
%                     3) cosinus oszilation   s.bvec[...,3,X,A,L,...]
%                        nr=2 a segemnt with over X-distance/m will be build,
%                        with cosinus of Amplitude A (positive to left) and
%                        Length of one wave X
%                     
%                     s.bvec could be concatinated e.g.
%                     s.bvec = [1,10,0.0, 2,45/57.2958,0.05, 2,45/57.2958,0.0, 1,10,0.0, 3,40,10,1.0]
%                     => first: 10 m straight, second,third going around a curve of 90 deg to
%                     the left with increasing and deacresing kappa up 0.05
%                     forth 10 m straight, fivth Ostilation along 40 m with
%                     peroid length 10 m and 1.0 m Amplitude
%
% s.ds         [m]    distance between points, but will be adapted
% s.x0         [m]    start x
% s.y0         [m]    start y
% s.yaw0       [rad]  start yaw angle
  elseif( s.type(1) == 'p' )
    
    check_val_in_struct(s,'ds',  'num',1,1);
    check_val_in_struct(s,'dyaw',  'num',1,1);
    check_val_in_struct(s,'bvec',  'num',1,1);
    
    % read bvec
    ss  = struct([]);
    nss = 0;
    i=1;
    n = length(s.bvec);
    while(i <= n )
      type = s.bvec(i);
      if( abs(type -1) < 0.5 )
          nss = nss+1;
          ss(nss).type = 1; 
          
          if( n < i+3 )
              error('bvec is to short')
          end
          ss(nss).S          = s.bvec(i+1);
          ss(nss).kappastart = s.bvec(i+2);
          ss(nss).kappa      = s.bvec(i+3);
          
          i = i+4;
      elseif( abs(type -2) < 0.5 )
          
          nss = nss+1;
          ss(nss).type = 2; 
          
          if( n < i+3 )
              error('bvec is to short')
          end
          ss(nss).YAW        = s.bvec(i+1);
          ss(nss).kappastart = s.bvec(i+2);
          ss(nss).kappa      = s.bvec(i+3);
          
          i = i+4;
      elseif( abs(type -3) < 0.5 )
          
          nss = nss+1;
          ss(nss).type = 3; 
          
          if( n < i+3 )
              error('bvec is to short')
          end
          ss(nss).L   = s.bvec(i+1);
          ss(nss).X = s.bvec(i+2);
          ss(nss).A = s.bvec(i+3);
          
          i = i+4;
      else
          error('type not detected s-bvec(%i) = %f',i,type)
      end
    end
    % build pathes
    xvec(1) = s.x0;
    yvec(1) = s.y0;
    yawvec(1) = s.yaw0;
    svec(1) = 0.0;
    
    
    for i=1:nss
      
      if( ss(i).type == 1 )
        
        [xv,yv,yawv,sv,kappav] = vek_2d_build_clothoid_s(xvec(end),yvec(end),yawvec(end),svec(end),ss(i).kappastart ...
                                                        ,ss(i).S,ss(i).kappa,s.ds);
                                                 
        
      elseif( ss(i).type == 2 )
        
        [xv,yv,yawv,sv,kappav] = vek_2d_build_clothoid_yaw(xvec(end),yvec(end),yawvec(end),svec(end),ss(i).kappastart ...
                                                          ,ss(i).YAW,ss(i).kappa,s.ds);
                                                 
      else
        
        [xv,yv,yawv,sv,kappav] = vek_2d_build_path_osci(xvec(end),yvec(end),yawvec(end),svec(end),kappavec(end) ...
                                                       ,ss(i).L,ss(i).X,ss(i).A,s.ds);
      end
      
      xvec = [xvec; xv(2:end)];
      yvec = [yvec; yv(2:end)];
      yawvec = [yawvec; yawv(2:end)];
      svec = [svec; sv(2:end)];
      if( i == 1 )
        kappavec = kappav;
      else
        kappavec = [kappavec; kappav(2:end)];
      end
    end
    
  else
    error('%s: ramp type not known s.type = %s',mfilename,s.type);
  end

  if( s.type(1) ~= 'p' )
    [xvec,yvec] = vek_2d_drehen(xvec,yvec,s.yaw0,1);
    xvec        = xvec + s.x0;
    yvec        = yvec + s.y0;
  end
  if( (abs(s.xrandom) > eps) || (abs(s.yrandom) > eps) )
    xvec = vec_add_random(xvec,1,s.xrandom);
    yvec = vec_add_random(yvec,1,s.yrandom);
  end
  svec        = vek_2d_build_s(xvec,yvec);
  
  end

  function [svec,n] = vek_2d_build_path_build_svec(dsvec,slen)
    
    dslen = sum(dsvec);
    
    n     = round(slen/dslen*length(dsvec))+1;
    
    m     = round(slen/dslen);
    dslen_exakt = slen/m;
    
    fac         = dslen_exakt/dslen;
    
    svec  = zeros(n,1);
    isvec = 1;
    while( isvec < n )
      for j=1:length(dsvec)
        isvec = isvec+1;
        svec(isvec) = svec(isvec-1)+ dsvec(j)*fac;
      end
    end
  end
    
    