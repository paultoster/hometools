function [d,u,c] = cg_mod_d_data(d,u,c)
%
% [d,u,c] = iqf_mod_data(d,u,c);
%
% d       Datenstruktur äquidistant fängt mit Zeitvektor (Spaltenvektor) an
%         z.B. d.time = [0;0.01;0.02; ... ]
%              d.F    = [1;1.05;1.10; ... ]
%              ...
% u       Unitstruktur mit Unitnamen
%         u.time = 's'
%         u.F    = 'N'
%         ...
% c       Struktur mit Beschreibungen
%         z.B. c.time = 'Zeitvektor' ...
%
%cg_base_variables

n = length(d.time);
  
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
