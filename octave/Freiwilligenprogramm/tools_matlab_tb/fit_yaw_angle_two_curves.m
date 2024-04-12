function   strans = fit_yaw_angle_two_curves(xmodvec,ymodvec,xbasevec,ybasevec ...
                                           , delta_yaw_max,delta_yaw_min ...
                                          , delta_yaw_tol,delta_yaw_n_max)
%
%
% strans  = fit_yaw_angle_two_curves(xmodvec,ymodvec,xbasevec,ybasevec ...
%                                  ,delta_yaw_max,delta_yaw_min ...
%                                  ,delta_yaw_tol,delta_yaw_n_max)
%
% Berechnung Offset und Drehwinkel bei Fitten (xmod,ymod) auf (xbase,ybase)
% mit fminbnd()
%
% xmodvec,ymodvec              xy-Vektor, der auf base gefittet wird
% xbasevec,ybasevec            xy-BAse-Vektor
% delta_yaw_max          [rad] Für Suchalgo maximaler Winkel (default: 10/180*pi)
% delta_yaw_min          [rad] Für Suchalgo minimaler Winkel (default: -10/180*pi)
% delta_yaw_tol          [rad] Für Suchalgo Toeranz (default: 0.001*pi/180)
% delta_yaw_n_max        enum  maximale Rechenschritte Such algo (default: 100)
%
% Ausgabe struktur strans:
%
% strans.xoffsetsub       
% strans.yoffsetsub
% strans.dyaw           [rad]
% strans.xoffsetadd
% strans.yoffsetadd
%
% Berechnung:
%
% xvec =  (xmodvec-xoffsetsub)*cos(dyaw)+(ymodvec-yoffsetsub)*sin(dyaw) + xoffsetadd
% yvec = -(xmodvec-xoffsetsub)*sin(dyaw)+(ymodvec-yoffsetsub)*cos(dyaw) + yoffsetadd
% oder
% [xvec,yvec] = vek_2d_transform_strans(xmodvec,ymodvec,strans);
% 
  xmodvec  = fit_yaw_angle_two_curves_check_size(xmodvec);
  ymodvec  = fit_yaw_angle_two_curves_check_size(ymodvec);
  xbasevec = fit_yaw_angle_two_curves_check_size(xbasevec);
  ybasevec = fit_yaw_angle_two_curves_check_size(ybasevec);
  
  if( ~exist('delta_yaw_max','var') )
    delta_yaw_max = 10/180*pi;
  end
  if( ~exist('delta_yaw_min','var') )
    delta_yaw_max = -10/180*pi;
  end
  if( ~exist('delta_yaw_tol','var') )
    delta_yaw_tol = 0.001/180*pi;
  end
  if( ~exist('delta_yaw_n_max','var') )
    delta_yaw_n_max = 100;
  end
  
  x0base       = xbasevec(1);
  y0base       = ybasevec(1);
  xbasevec     = xbasevec-x0base;
  ybasevec     = ybasevec-y0base;
  nbasevec     = min(length(xbasevec),length(ybasevec));
  sbasevec     = vek_2d_build_s(xbasevec,ybasevec,nbasevec,0.0,-1.);
  p           = poly_approx(sbasevec,xbasevec,1,0,1,0,'',0);
  dxdsbase     = p(2);
  p           = poly_approx(sbasevec,ybasevec,1,0,1,0,'',0);
  dydsbase     = p(2);
  yaw0base     = atan2(dydsbase,dxdsbase);

  x0mod       = xmodvec(1);
  y0mod       = ymodvec(1);
  xmodvec     = xmodvec-x0mod;
  ymodvec     = ymodvec-y0mod;
  nmodvec     = min(length(xmodvec),length(ymodvec));
  smodvec     = vek_2d_build_s(xmodvec,ymodvec,nmodvec,0.0,-1.);
  if( nbasevec ~= nmodvec )
    xmodvec = interp1(smodvec,xmodvec,sbasevec,'linear','extrap');
    ymodvec = interp1(smodvec,ymodvec,sbasevec,'linear','extrap');
    smodvec = sbasevec;
    nmodvec = nbasevec;
  end
  p           = poly_approx(smodvec,xmodvec,1,0,1,0,'',0);
  dxdsmod     = p(2);
  p           = poly_approx(smodvec,ymodvec,1,0,1,0,'',0);
  dydsmod     = p(2);
  yaw0mod     = atan2(dydsmod,dxdsmod);
  
  dyawStart   = yaw0base - yaw0mod;
  
  % Zuerst xmodvec,ymodvec mit yawStart
  cyaw    = cos(dyawStart);
  syaw    = sin(dyawStart);
  T       = [cyaw,-syaw;syaw,cyaw];
  x       = [xmodvec';ymodvec'];
  y       = T*x;
  xmodvec = y(1,:)';
  ymodvec = y(2,:)';
  
  ss = optimset('TolX',delta_yaw_tol,'MaxIter',delta_yaw_n_max,'Display','off');
  yaw0 = fminbnd(@(x) fit_yaw_angle_two_curves_ErrorFunc(x,xmodvec,ymodvec,xbasevec,ybasevec) ...
                ,delta_yaw_min,delta_yaw_max,ss);
              
  strans.dyaw        = (-1.)*(dyawStart+yaw0);
  strans.xoffsetsub  = x0mod;
  strans.yoffsetsub  = y0mod;
  strans.xoffsetadd  = x0base;
  strans.yoffsetadd  = y0base;
end
function e = fit_yaw_angle_two_curves_ErrorFunc(yaw,xmod,ymod,xbase,ybase)
  
  cyaw = cos(yaw);
  syaw = sin(yaw);
  T    = [cyaw,-syaw;syaw,cyaw];
  x    = [xmod';ymod'];
  y    = T*x;
  xmodM = y(1,:)';
  ymodM = y(2,:)';
  e    = mean((xbase-xmodM).^2 + (ybase-ymodM).^2);
  
end
function  vec = fit_yaw_angle_two_curves_check_size(vec)
%
% mache einen Spaltenvektor
  [n,m] = size(vec);
  if( m > n )
    vec = vec';
    m       = n;
  end
  if( m > 1 )
    vec = vec(:,1);
  end
end
  


