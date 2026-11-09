function e = cg_mod_e_data(e)
%
% [d,u] = iqf_mod_data(d);
%
iqf_base_variables
n = length(d.time);

% Umgehungslösung bei Interactive Ausgabe
if( isfield(d,'Velocity_Kmh') && ~isfield(d,'vVeh') )
  
  d.vVeh = d.Velocity_Kmh /3.6;
  u.vVeh = 'm/s';
end
  


% if( isfield(d,'VehYawRate_Raw') && isfield(d,'VehYawRateOffset') )
%   d.VehYawRate = d.VehYawRate_Raw - d.VehYawRateOffset;
%   u.VehYawRate = u.VehYawRate_Raw;
%   c.VehYawRate = c.VehYawRate_Raw;
% 
%   d.yawpVeh   = (d.VehYawRate_Raw - d.VehYawRateOffset)*pi/180.;
%   u.yawpVeh   = 'rad/s';
%   c.yawpVeh   = 'Fahrzeuggierrate';
% end

if( isfield(d,'yawpVeh') )
  
   [d.yawppVeh ydiff] = diff_pt1_zp(d.time,d.yawpVeh,0.05);

   switch(u.yawpVeh)
     case 'rad/s'
       u.yawppVeh = 'rad/s/s';
     case 'deg/s'
       u.yawppVeh = 'deg/s/s';
     otherwise
       error('yawppVeh, falsche Einheit')
   end
end
       
  
%==========================================================================
% BMW  
%==========================================================================
if( isfield(d,'ABS_Vref_low') && isfield(d,'ABS_Vref_high'))
    
  d.VelRefEbs = d.ABS_Vref_low+256*d.ABS_Vref_high;
  u.VelRefEbs = 'km/h';
  c.VelRefEbs = c.ABS_Vref_low;
end

%==========================================================================
% Passatlenkung
%==========================================================================
if( isfield(d,'PT_LH3_BLW') )

    d.SwaEps =  d.PT_LH3_BLW * pi/180;
    u.SwaEps = 'rad';
    c.SwaEps =  c.PT_LH3_BLW;
    
    [ydiff_f, ydiff] = diff_pt1_zp(d.time,d.SwaEps,0.05);
    d.DSwaEps          = ydiff;
    d.DSwaFiltEps      = ydiff_f;
    u.DSwaEps          = 'rad/s';
    u.DSwaFiltEps      = 'rad/s';
    c.DSwaEps          = '';
    c.DSwaFiltEps      = '';
    
end
if( isfield(d,'PT_LH2_ALT_Requested_motor_torque') )
    d.MReqEps  = d.PT_LH2_ALT_Requested_motor_torque;
    u.MReqEps  = 'Nm';
    c.MReqEps  = c.PT_LH2_ALT_Requested_motor_torque;
end
if( isfield(d,'PT_LH2_ALT_Motor_torque') )
    d.MActEps  = d.PT_LH2_ALT_Motor_torque;
    u.MActEps  = 'Nm';
    c.MActEps  = c.PT_LH2_ALT_Motor_torque;
end
if( isfield(d,'PT_LH3_LM') )
    d.MSensEps  = d.PT_LH3_LM;
    u.MSensEps  = 'Nm';
    c.MSensEps  = c.PT_LH3_LM;
end
    
if( isfield(d,'PT_LW1_LRW') )
    d.SwaLw1 = d.PT_LW1_LRW * pi/180;
    u.SwaLw1 = 'rad';
    c.SwaLw1 = c.PT_LW1_LRW;
end
    
if( isfield(d,'PT_LW1_Lenk_Gesch') )
    d.DSwaLw1 = d.PT_LW1_Lenk_Gesch* pi/180;
    u.DSwaLw1 = 'rad/s';
    c.DSwaLw1 = c.PT_LW1_Lenk_Gesch;
  
end
%==========================================================================
% Neue Mittenfühjrungsdaten auf alte Signale mappen 
%==========================================================================
  if( isfield(d,'ExtSteerReq_Dev2Pth_active') )
        
    d.SALaLoIqfm_c0                   = d.ExtSteerReq_Dev2Pth_c0;
    d.SALaLoIqfm_dy                   = d.ExtSteerReq_Dev2Pth_y;  
    d.SALaLoIqfm_available            = d.ExtSteerReq_Dev2Pth_active;
    d.SALaLoIqfm_psi                  = d.ExtSteerReq_Dev2Pth_psi;

    u.SALaLoIqfm_c0                   = u.ExtSteerReq_Dev2Pth_c0;
    u.SALaLoIqfm_dy                   = u.ExtSteerReq_Dev2Pth_y;  
   q u.SALaLoIqfm_available            = u.ExtSteerReq_Dev2Pth_active;
    u.SALaLoIqfm_psi                  = u.ExtSteerReq_Dev2Pth_psi;
  end
%==========================================================================
% zweite Spur Carmaker 
%==========================================================================
if( isfield(d,'SALaLoIqf1_availableL') && ~isfield(d,'SALaLoIqf2_availableL') )
  
  d.SALaLoIqf2_availableL  = d.SALaLoIqf1_availableL*0.0;
  d.SALaLoIqf2_TypeLeft    = d.SALaLoIqf1_TypeLeft;
  d.SALaLoIqf2_dyL         = d.SALaLoIqf1_dyL;
    
end    
if( isfield(d,'SALaLoIqf1_availableR') && ~isfield(d,'SALaLoIqf2_availableR') )
  
  d.SALaLoIqf2_availableR  = d.SALaLoIqf1_availableR*0.0;
  d.SALaLoIqf2_TypeRight   = d.SALaLoIqf1_TypeRight;
  d.SALaLoIqf2_dyR         = d.SALaLoIqf1_dyR;
end    
    
%==========================================================================
% Position über Carmaker über Bodysensor
%==========================================================================
if(  isfield(d,'xVehVA') && isfield(d,'yVehVA') && isfield(d,'yawVeh') && isfield(d,'SALaLoIqfm_available') ...
  && isfield(d,'SALaLoIqfm_dy') && isfield(d,'SALaLoIqf1_dyL') && isfield(d,'SALaLoIqf1_dyR') )
  
  sVeh = 1.8;
  sVeh2 = sVeh/2;
  
  d.spv_x_veh_0  = d.xVehVA;
  d.spv_y_veh_0  = d.yVehVA;
  d.spv_x_veh_l  = d.xVehVA;
  d.spv_y_veh_l  = d.yVehVA;
  d.spv_x_veh_r  = d.xVehVA;
  d.spv_y_veh_r  = d.yVehVA;
  d.spv_x_spur_0  = d.xVehVA;
  d.spv_y_spur_0  = d.yVehVA;
  d.spv_x_spur_l  = d.xVehVA;
  d.spv_y_spur_l  = d.yVehVA;
  d.spv_x_spur_r  = d.xVehVA;
  d.spv_y_spur_r  = d.yVehVA;
  d.spv_x_spur_l_i  = d.xVehVA;
  d.spv_y_spur_l_i  = d.yVehVA;
  d.spv_x_spur_r_i  = d.xVehVA;
  d.spv_y_spur_r_i  = d.yVehVA;
  
  for i=1:n
    
    if( d.SALaLoIqfm_available(i) )
    
      cyaw = cos(d.yawVeh(i));
      syaw = sin(d.yawVeh(i));
    
      d.spv_x_veh_l(i)  = d.xVehVA(i)-syaw*sVeh2;
      d.spv_y_veh_l(i)  = d.yVehVA(i)+cyaw*sVeh2;
      d.spv_x_veh_r(i)  = d.xVehVA(i)+syaw*sVeh2;
      d.spv_y_veh_r(i)  = d.yVehVA(i)-cyaw*sVeh2;
      d.spv_x_spur_0(i) = d.xVehVA(i)-syaw*d.SALaLoIqfm_dy(i);
      d.spv_y_spur_0(i) = d.yVehVA(i)+cyaw*d.SALaLoIqfm_dy(i);
      d.spv_x_spur_l(i) = d.xVehVA(i)-syaw*d.SALaLoIqf1_dyL(i);
      d.spv_y_spur_l(i) = d.yVehVA(i)+cyaw*d.SALaLoIqf1_dyL(i);
      d.spv_x_spur_r(i) = d.xVehVA(i)-syaw*d.SALaLoIqf1_dyR(i);
      d.spv_y_spur_r(i) = d.yVehVA(i)+cyaw*d.SALaLoIqf1_dyR(i);
      d.spv_x_spur_l_i(i) = d.xVehVA(i)-syaw*d.SALaLoIqf1_dyL(i);
      d.spv_y_spur_l_i(i) = d.yVehVA(i)+cyaw*d.SALaLoIqf1_dyL(i);
      d.spv_x_spur_r_i(i) = d.xVehVA(i)-syaw*d.SALaLoIqf1_dyR(i);
      d.spv_y_spur_r_i(i) = d.yVehVA(i)+cyaw*d.SALaLoIqf1_dyR(i);
    end
  end
  
  
  u.spv_x_veh_0     = u.xVehVA;
  u.spv_y_veh_0     = u.yVehVA;
  u.spv_x_veh_l     = u.xVehVA;
  u.spv_y_veh_l     = u.yVehVA;
  u.spv_x_veh_r     = u.xVehVA;
  u.spv_y_veh_r     = u.yVehVA;
  u.spv_x_spur_0    = u.xVehVA;
  u.spv_y_spur_0    = u.yVehVA;
  u.spv_x_spur_l    = u.xVehVA;
  u.spv_y_spur_l    = u.yVehVA;
  u.spv_x_spur_r    = u.xVehVA;
  u.spv_y_spur_r    = u.yVehVA;
  u.spv_x_spur_l_i  = u.xVehVA;
  u.spv_y_spur_l_i  = u.yVehVA;
  u.spv_x_spur_r_i  = u.xVehVA;
  u.spv_y_spur_r_i  = u.yVehVA;

  c.spv_x_veh_0     = 'Fahrzeugmitte VA x';
  c.spv_y_veh_0     = 'Fahrzeugmitte VA y';
  c.spv_x_veh_l     = 'Fahrzeug linke Begrenzung VA x';
  c.spv_y_veh_l     = 'Fahrzeug linke Begrenzung VA y';
  c.spv_x_veh_r     = 'Fahrzeug rechte Begrenzung VA x';
  c.spv_y_veh_r     = 'Fahrzeug rechte Begrenzung VA y';
  c.spv_x_spur_0    = 'Spur Mitte x';
  c.spv_y_spur_0    = 'Spur Mitte y';
  c.spv_x_spur_l    = 'Spur Begrenzung links x';
  c.spv_y_spur_l    = 'Spur Begrenzung links y';
  c.spv_x_spur_r    = 'Spur Begrenzung rechts x';
  c.spv_y_spur_r    = 'Spur Begrenzung rechts y';
  c.spv_x_spur_l_i  = 'Spur Regelzone links x';
  c.spv_y_spur_l_i  = 'Spur Regelzone links y';
  c.spv_x_spur_r_i  = 'Spur Regelzone rechts x';
  c.spv_y_spur_r_i  = 'Spur Regelzone rechts y';

end  
%==========================================================================
% EPS-Lenkwinkel nur Passat
%==========================================================================
if( (q.fzg_type == IQF_FZG_TYPE_PASSAT_CC) || (q.fzg_type == IQF_FZG_TYPE_PASSAT) )
  if( isfield(d,'deltaStWhlCarMaker') && ~isfield(d,'PT_LH3_BLW') )
    d.PT_LH3_BLW = d.deltaStWhlCarMaker;
    u.PT_LH3_BLW = u.deltaStWhlCarMaker;
  end

  % Eps-Winkel nicht vorhanden
  %---------------------------
  if( isfield(d,'deltaStWhl') && ~isfield(d,'PT_LH3_BLW') )
    d.PT_LH3_BLW = pt1_filter_zp(d.time,d.deltaStWhl,0.03);
    u.PT_LH3_BLW = u.deltaStWhl;
    warning('d.PT_LH3_BLW wurde aus d.deltaStWhl gebilde. Möglicherweise kein CAN2 gemessen')
  end
  
end
%==========================================================================
% EPS-Lenkwinkel nur Passat
%==========================================================================
if( (q.fzg_type == IQF_FZG_TYPE_BMW545_2222) )
  % Eps-Winkel nicht vorhanden
  %---------------------------
  if( isfield(d,'deltaStWhl') && ~isfield(d,'deltaStWhlBmw') )
    d.deltaStWhlBmw = pt1_filter_zp(d.time,d.deltaStWhl,0.03);
    u.deltaStWhlBmw = u.deltaStWhl;
    warning('d.deltaStWhlBmw wurde aus d.deltaStWhl gebilde. Möglicherweise kein CAN2 gemessen')
  end
end


%==========================================================================
% Position  Carmaker über ArbiDef2Path
%==========================================================================
if(  isfield(d,'XSPath') && isfield(d,'YSPath')  )
  
  % Wenn in CarMaker nicht richtig initialisiert 
  if(  ((d.XSPath(1) == 0.0) && (d.XSPath(3) ~= 0.0)) ...
    || ((d.YSPath(1) == 0.0) && (d.YSPath(3) ~= 0.0)) )
    
    d.XSPath(1)     = d.XSPath(3);
    d.YSPath(1)     = d.YSPath(3);
    d.alphaSPath(1) = d.alphaSPath(3); 
    d.XSPath(2)     = d.XSPath(3);
    d.YSPath(2)     = d.YSPath(3);
    d.alphaSPath(2) = d.alphaSPath(3); 
  end
  d.SSPath = d.time*0.0;
  for i=2:n
    dx = d.XSPath(i)-d.XSPath(i-1);
    dy = d.YSPath(i)-d.YSPath(i-1);
    d.SSPath(i) = d.SSPath(i-1)+sqrt(dx*dx+dy*dy);
  end
  u.SSPath = u.XSPath;
  c.SSPath = 'Weg entlang des Pfads aus den Schnittpunkten';
end
if(  isfield(d,'XPosEgoFA') && isfield(d,'YPosEgoFA')  )
  
  % Wenn in CarMaker nicht richtig initialisiert 
  if(  ((d.XPosEgoFA(1) == 0.0) && (d.XPosEgoFA(3) ~= 0.0)) ...
    || ((d.YPosEgoFA(1) == 0.0) && (d.YPosEgoFA(3) ~= 0.0)) )
    
    d.XPosEgoFA(1) = d.XPosEgoFA(3);
    d.YPosEgoFA(1) = d.YPosEgoFA(3);
    d.YawPosEgo(1) = d.YawPosEgo(3);
    d.XPosEgoFA(2) = d.XPosEgoFA(3);
    d.YPosEgoFA(2) = d.YPosEgoFA(3);
    d.YawPosEgo(2) = d.YawPosEgo(3);
  end
end
  % Heading nach Sprüngen untersuchen
  if( isfield(e,'Heading') )
%     figure(99)
%     plot(e.('Heading').time,e.('Heading').vec,'k-')    
    e.('Heading') = modify_Heading(e.('Heading'));
  end

%==========================================================================
% GPS-DAten in Koordinatne wandeln
%==========================================================================
if( isfield(d,'Longitude') && isfield(d,'Latitude') && isfield(d,'Heading') )
  
  % Messpunkte korrigieren
  %-----------------------

  % Heading bei Stillstand halten
  %------------------------------
  i0 = 1;
  for i=2:length(d.Heading)
    if( d.vVeh(i) < 0.555 )
      d.Heading(i) = d.Heading(i0); 
    else
      i0 = i;
    end
  end
  
  heading_old = d.Heading(1);
  shift_flag  = 0;

  a.Longitude  = d.Longitude;
  b.Longitude  = 100/60/180*pi;
  a.Latitude   = d.Latitude;
  b.Latitude   = 100/60/180*pi;
  a.Heading    = d.Heading;
  b.Heading    = 10000;        % auf utopischen Wert lassen
                               % damit nicht gesucht, aber trotzdem
                               % mitgefiltert wird

  if( ~isfield(q,'VBox_filter_flag') )
    q.VBox_filter_flag = 0;
  end
  if( q.VBox_filter_flag > -0.5 )

    n = max(get_fig_numbers);
    if( isempty(n) )
      n = 1;
    else
      n = n+1;
    end

    if( q.VBox_filter_flag > 1.5 )
      figure(n);
      subplot(3,1,1)
      plot(d.Longitude)
      title('Longitude')
      subplot(3,1,2)
      plot(d.Latitude)
      title('Latitude')
      subplot(3,1,3)
      plot(d.Heading)
      title('Heading')

      plot_bottom(q.act_full_mess_name);
    end
  
    if( q.VBox_filter_flag )
      flag = q.VBox_filter_flag;
      flagplot = 0;
    else
      s_frage.frage = 'Soll VBox-Daten gefiltert werden';
      [flag] = o_abfragen_jn_f(s_frage);
      flagplot = 1;
    end
    if( flag )

      [a,found_flag] = peak_filterA(a,b);
      
      if( (q.VBox_filter_flag > 1.5) || flagplot )
        figure(n);
        subplot(3,1,1)
        hold on
        plot(a.Longitude,'r-')
        hold off
        ylabel(u.Longitude)
        subplot(3,1,2)
        hold on
        plot(a.Latitude,'r-')
        hold off
        ylabel(u.Latitude)
        subplot(3,1,3)
        hold on
        plot(a.Heading,'r-')
        hold off
        ylabel(u.Heading)
      end
      d.Longitude  = a.Longitude;
      d.Latitude   = a.Latitude;
      d.Heading    = a.Heading;

    end
  end
  % Messpunkt Fahrzeug
  %-------------------
  [x,y,phi] = LongLatToPos( d.Latitude, u.Latitude, d.Longitude, u.Longitude , d.Heading , u.Heading );
  n         = length(x);
  
  d.xGPS        = x;
  d.yGPS        = y;
  d.yawVeh      = phi;
  u.xGPS     = 'm';
  u.yGPS     = 'm';
  u.yawVeh   = 'rad';

  if( ~isfield(q,'VBox_make_mode_flag') )
    q.VBox_make_mode_flag = 0;
  end
  if( q.VBox_make_mode_flag )

    [xmod,ymod,yawmod] = mod_gps_data(d.time,x,y,0.1);
    % Koordinaten für Vorderachse Mitte
    %----------------------------------
    xva = zeros(size(x));
    yva = zeros(size(y));
    xha = zeros(size(x));
    yha = zeros(size(y));
    for i=1:n
      cyaw = cos(yawmod(i));
      syaw = sin(yawmod(i));
      xva(i) = xmod(i) +  IQF_GPS_POS_DX_MES_TO_VA*cyaw - IQF_GPS_POS_DY_MES_TO_VA*syaw;
      yva(i) = ymod(i) +  IQF_GPS_POS_DX_MES_TO_VA*syaw + IQF_GPS_POS_DY_MES_TO_VA*cyaw;
      xha(i) = xmod(i) +  IQF_GPS_POS_DX_MES_TO_HA*cyaw - IQF_GPS_POS_DY_MES_TO_HA*syaw;
      yha(i) = ymod(i) +  IQF_GPS_POS_DX_MES_TO_HA*syaw + IQF_GPS_POS_DY_MES_TO_HA*cyaw;
    end
    [sva,alphava,c0va] = path_calc_aplha_kappa(xva,yva,30,0.1);
    [sha,alphaha,c0ha] = path_calc_aplha_kappa(xha,yha,30,0.1);

    d.xGPSmod     = xmod;
    d.yGPSmod     = ymod;
    d.yawVehmod   = yawmod;
    d.xVehVA      = xva;
    d.yVehVA   = yva;
    d.sVehVA   = sva;
    d.alphaVehVA  = alphava;
    d.c0VehVA  = c0va;
    d.xVehHA   = xha;
    d.yVehHA   = yha;
    d.sVehHA   = sha;
    d.alphaVehHA  = alphaha;
    d.c0VehHA  = c0ha;
    u.xGPSmod     = 'm';
    u.yGPSmod     = 'm';
    u.yawVehmod   = 'rad';
    u.xVehVA   = 'm';
    u.yVehVA   = 'm';
    u.sVehVA   = 'm';
    u.alphaVehVA   = 'rad';
    u.c0VehVA   = '1/m';
    u.xVehHA   = 'm';
    u.yVehHA   = 'm';
    u.sVehHA   = 'm';
    u.alphaVehHA   = 'rad';
    u.c0VehHA   = '1/m';
    c.xGPS     = 'x-Position GPS Messpunkt';
    c.yGPS     = 'y-Position GPS Messpunkt';
    c.yawVeh   = 'Gierwinkel GPS';
    c.xGPSmod     = 'modifizierte x-Position GPS Messpunkt';
    c.yGPSmod     = 'modifizierte y-Position GPS Messpunkt';
    c.yawVehmod   = 'modifizierter Gierwinkel GPS';
    c.xVehVA   = 'x-Position GPS Vorderachse';
    c.yVehVA   = 'y-Position GPS Vorderachse';
    c.sVehVA   = 'zurückgelegter Weg GPS Vorderachse';
    c.alphaVehVA   = 'Winkel entlang dem Weg GPS Vorderachse';
    c.c0VehVA   = 'Kruemmung entlag dem Weg GPS Vorderachse';
    c.xVehHA   = 'x-Position GPS Hinterachse';
    c.yVehHA   = 'y-Position GPS Hinterachse';
    c.sVehVA   = 'zurückgelegter Weg GPS Hinterachse';
    c.alphaVehVA   = 'Winkel entlang dem Weg GPS Hinterachse';
    c.c0VehVA   = 'Kruemmung entlag dem Weg GPS Hinterachse';
  end
end

% Corrsys-Daten auf Schwerpunkt rechnen
if( isfield(d,'beta0') && isfield(d,'vquer0') && isfield(d,'vlaengs0') )

  beta_offset = -0.007387083452815;

  d.beta0     = d.beta0 - beta_offset;
  d.Beta0     = d.beta0*180/pi;
  u.Beta0     = '°';

  d.Vlaengs0  = d.vlaengs0 * 3.6;
  u.Vlaengs0  = 'km/h';

  d.vquer0    = tan(d.beta0) .* d.vlaengs0;
  d.Vquer0    = d.vquer0*3.6;
  u.Vquer0    = 'km/h';

  y0S         = 0.0045; % Abstand in y aus Mitte pos nach rechts
  x0S         = 2.749;  % Abstadn in x Schwerpunkt zu Sensor 

  d.vlaengsS  = d.vlaengs0-d.yawpVeh*y0S;
  d.vquerS    = d.vquer0+d.yawpVeh*x0S;
  d.betaS     = atan2(d.vquerS,d.vlaengsS);
  u.betaS     = 'rad';
  u.vlaengsS  = 'm/s';
  u.vquerS    = 'm/s';

  d.VlaengsS  = d.vlaengsS*3.6;
  d.VquerS    = d.vquerS*3.6;
  d.BetaS     = d.betaS*180/pi;
  u.BetaS     = 'deg';
  u.VlaengsS  = 'km/h';
  u.VquerS    = 'km/h';

%     figure(4)
%     subplot(4,1,1)
%     plot(d.beta0/pi*180,'k-')
%     subplot(4,1,2)
%     plot(d.vlaengs0*3.6,'k-')
%     subplot(4,1,3)
%     plot(d.vquer0*3.6,'k-')
%     subplot(4,1,4)
%     plot(d.yaw_rate/pi*180,'k-')
% 
%     subplot(4,1,1)
%     hold on
%     plot(d.betaS*180/pi,'b-')
%     hold off
%     subplot(4,1,2)
%     hold on
%     plot(d.vlaengsS*3.6,'b-')
%     hold off
%     subplot(4,1,3)
%     hold on
%     plot(d.vquerS*3.6,'b-')
%     hold off
%     
end


if( isfield(d,'PT_LW1_LRW') && ~isfield(d,'PT_LW1_Lenk_Gesch') )
  
  d.deltapStWhLw1 = differenziere(d.time,d.PT_LW1_LRW,2);
  u.PT_LW1_Lenk_Gesch = [u.PT_LW1_LRW,'/s'];
end
if( isfield(d,'PT_LH3_BLW') )
  
  d.deltapStWhlEps = differenziere(d.time,d.PT_LH3_BLW,2);
  u.deltapStWhlEps = [u.PT_LH3_BLW,'/s'];
end
if( isfield(d,'deltaStWhlBmw') && ~isfield(d,'deltapStWhlBmw') )
  
  d.deltapStWhlBmw = differenziere(d.time,d.deltaStWhlBmw,2);
  u.deltapStWhlBmw = [u.deltaStWhlBmw,'/s'];
end

% if( isfield(d,'Mode_Steering_Assistance') && isfield(d,'IQF1_RefAng'))
%   for i=1:length(d.time)
%     if( (d.IQF1_LkasIntvMaxStrength(i) < 0.01) || (d.Mode_Steering_Assistance(i) < 0.01))
%       d.IQF1_RefAng(i) = 0.0;
%     end
%   end
% end

% alte Schnittstelle umsetzen auf neue
%-------------------------------------
if( isfield(d,'IQF2_IntervType') )  
  
  d.IQF1_RefActivity = d.IQF2_IntervType;
  u.IQF1_RefActivity = u.IQF2_IntervType;
  d = rmfield(d,'IQF2_IntervType');
  u = rmfield(u,'IQF2_IntervType');
  
  if(  isfield(d,'IQF1_LdwActvStatus') )
    d.IQF1_LdwStatus = d.IQF1_LdwActvStatus;
    u.IQF1_LdwStatus = u.IQF1_LdwActvStatus;
    d = rmfield(d,'IQF1_LdwActvStatus');
    u = rmfield(u,'IQF1_LdwActvStatus');    
  end
  if(  isfield(d,'IQF1_LdwActvIntens') )
    d.IQF1_LdwIntens = d.IQF1_LdwActvIntens;
    u.IQF1_LdwIntens = u.IQF1_LdwActvIntens;
    d = rmfield(d,'IQF1_LdwActvIntens');
    u = rmfield(u,'IQF1_LdwActvIntens');    
  end
  
  if( isfield(d,'IQF1_LkasActive') && isfield(d,'IQF1_IntvActvStatus') )
    d.IQF1_Status = zeros(size(d.time));
    u.IQF1_Status = '-';
      
    for i = 1:n
      if( d.IQF1_LkasActive(i) > 0 )
        d.IQF1_Status(i) = bitor(d.IQF1_Status(i),1);
      end
      if( d.IQF1_IntvActvStatus(i) == 1 ) % IntvLeft
        d.IQF1_Status(i) = bitor(d.IQF1_Status(i),2);
      elseif( d.IQF1_IntvActvStatus(i) == 2 ) % IntvLeft+virtwall
        d.IQF1_Status(i) = bitor(d.IQF1_Status(i),2+8);
      elseif( d.IQF1_IntvActvStatus(i) == 3 ) % IntvRight
        d.IQF1_Status(i) = bitor(d.IQF1_Status(i),4);
      elseif( d.IQF1_IntvActvStatus(i) == 4 ) % IntvLeft+virtwall
        d.IQF1_Status(i) = bitor(d.IQF1_Status(i),4+8);
      end
    end
    d = rmfield(d,'IQF1_LkasActive');
    u = rmfield(u,'IQF1_LkasActive');
    d = rmfield(d,'IQF1_IntvActvStatus');
    u = rmfield(u,'IQF1_IntvActvStatus');
  end
  
  if( ~isfield(d,'IQF1_RefPriority') )
    d.IQF1_RefPriority = d.time*0+4;
    u.IQF1_RefPriority = '-';
  end
  if( ~isfield(d,'IQF1_RefQuality') )
    d.IQF1_RefQuality = d.time*0+1;
    u.IQF1_RefQuality = '-';
  end
  if( ~isfield(d,'IQF2_Failure') )
    d.IQF2_Failure = d.time*0;
    u.IQF2_Failure = '-';
  end
  if( isfield(d,'IQF1_Curvature') )
    d.IQF2_Curvature = d.IQF1_Curvature;
    u.IQF2_Curvature = u.IQF1_Curvature;
    d = rmfield(d,'IQF1_Curvature');
    u = rmfield(u,'IQF1_Curvature');
  else
    d.IQF1_Curvature = d.time*0.0;
    u.IQF1_Curvature = '1/m';
  end
  if( isfield(d,'IQF2_IntervTorque') )
    d.IQF1_RefTorque = d.IQF2_IntervTorque;
    u.IQF1_RefTorque = u.IQF2_IntervTorque;
    d = rmfield(d,'IQF2_IntervTorque');
    u = rmfield(u,'IQF2_IntervTorque'); 
  else
    d.IQF1_RefTorque = d.time*0.0;
    u.IQF1_RefTorque = 'Nm';
  end
  tname = 'IQF1_LkasIntvMaxStrength'; 
  if( isfield(d,tname) )
    d.([tname,'_old']) = d.(tname);
    u.([tname,'_old']) = u.(tname);
    d = rmfield(d,tname);
    u = rmfield(u,tname); 
  end  
  tname = 'IQF1_LkasIntvDynFac'; 
  if( isfield(d,tname) )
    d.([tname,'_old']) = d.(tname);
    u.([tname,'_old']) = u.(tname);
    d = rmfield(d,tname);
    u = rmfield(u,tname); 
  end  
  tname = 'IQF2_GradLim'; 
  if( isfield(d,tname) )
    d.([tname,'_old']) = d.(tname);
    u.([tname,'_old']) = u.(tname);
    d = rmfield(d,tname);
    u = rmfield(u,tname); 
  end  
    
  
end

if( isfield(d,'IPAS_Debug_Int') )
  
  d.deltaStWhlDebug = d.IPAS_Debug_Int*0.1*pi/180.;
  u.deltaStWhlDebug = 'rad';

end
%     % Endwerte setzen wenn Botschaft am Ende nicht gemessen wurde 
%     for i0 = nt:-1:1      
%       if( d.time(i0) <= tmax )
%         for j=nt:-1:i0+1
%           d.(name)(j) = d.(name)(i0);
%         end
%         break;
%       end
%     end
%   end
  if( isfield(e,'ExtSteerReq_C0C1_c0') )
    [d.('ExtSteerReq_C0C1_c0'),d.('ExtSteerReq_C0C1_c1'),d.('ExtSteerReq_C0C1_active'),d.('ExtSteerReq_C0C1_priority')] = build_c0_exact(d,e,u);
  end

end
function h = modify_Heading(h)
%
% Behandlung von Heading bei 2*pi -Sprünge
%
  n = length(h.time);
  % Einheit
  if( ~isempty(h.unit) )
    unit_in  = h.unit;
  else
    unit_in  = 'Degrees';
  end
  [fac,offset,errtext] = get_unit_convert_fac_offset(unit_in,'rad');    
  if( ~isempty(errtext) )
    error('Fehler bei unit-convert in Signal <%s> \n%s','Heading',errtext)
  end
    
  vec = h.vec * fac + offset;
  %[ydiff_f, ydiff] = diff_pt1_zp(h.time,vec,0.1);
  
  pdelta0 = 2*pi*0.8;
  pdelta1 = 2*pi*1.2;
  mdelta0 = -2*pi*0.8;
  mdelta1 = -2*pi*1.2;
  add     = 0.0;
  vec1 = vec*0.0;
  for i=2:n
    
    val0  = vec(i-1) ; %+ ydiff_f(i-1) * (h.time(i)-h.time(i-1));
    vdiff = vec(i) - val0;
    
    if( (vdiff > pdelta0) && (vdiff < pdelta1) )
      add = add - pi*2.0;
    elseif( (vdiff < mdelta0) && (vdiff > mdelta1) )
      add = add + pi*2.0;
    end
    
    vec1(i) = vec(i)+add;
  end
  
%   figure(100)
%   plot(vec*180/pi,'k-')
%   hold on
%   plot(vec1*180/pi,'r-')
%   hold off 
%   grid on
  
  
  h.vec = (vec1-offset)/fac;
      
end
function [c0,c1,act,prio] = build_c0_exact(d,e,u)

  ne  = length(e.('ExtSteerReq_C0C1_c0').time);
  
  if( isfield(d,'vVeh') )
    [fac,offset] = get_unit_convert_fac_offset(u.('vVeh'),'m/s');
    vvec = d.vVeh * fac;
  elseif( isfield(d,'VehSpd') )
    [fac,offset] = get_unit_convert_fac_offset(u.('VehSpd'),'m/s');
    vvec = d.VehSpd * fac;
  end
  
  n   = length(d.time);
  dt  = mean(diff(d.time));
  c0  = d.time*0.0;
  c1  = d.time*0.0;
  act  = d.time*0.0;
  prio = d.time*0.0;
  
  i = 1;
  while( d.time(i) <= e.('ExtSteerReq_C0C1_c0').time(1) )
    c0(i) = 0.0;
    c1(i) = 0.0;
    act(i) = 0.0;
    prio(i) = 0.0;
    i     = i+1;
  end
  
  for j = 1:ne-1      


      while( d.time(i) < e.('ExtSteerReq_C0C1_c0').time(j+1) )
        c0(i) = e.('ExtSteerReq_C0C1_c0').vec(j) ...
              + e.('ExtSteerReq_C0C1_c1').vec(j)*vvec(i)*floor((d.time(i) - e.('ExtSteerReq_C0C1_c0').time(j))/dt)*dt;
        c1(i) = e.('ExtSteerReq_C0C1_c1').vec(j);
        act(i)  = e.('ExtSteerReq_C0C1_active').vec(j);
        prio(i) = e.('ExtSteerReq_C0C1_priority').vec(j);

        i     = i+1;
        if( i > n )
          break;
        end
      end


  end
  while( i <= n )
    c0(i) = e.('ExtSteerReq_C0C1_c0').vec(ne);
    c1(i) = e.('ExtSteerReq_C0C1_c1').vec(ne);
    act(i)  = e.('ExtSteerReq_C0C1_active').vec(ne);
    prio(i) = e.('ExtSteerReq_C0C1_priority').vec(ne);
    i     = i+1;
  end
end

