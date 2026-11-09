function eout = cg_read_tacc_channel_CanMsgLongCtrl(e,channel_name)

  e = e_data_rename_signal(e,[channel_name,'_header_timestamp'],[channel_name,'_timestamp']);
%                           CanMsgLongCtrlPb_a_req: [1x1 struct]
%                      CanMsgLongCtrlPb_a_req_type: [1x1 struct]
%                   CanMsgLongCtrlPb_brk_press_req: [1x1 struct]
%             CanMsgLongCtrlPb_brk_press_req_activ: [1x1 struct]
%                CanMsgLongCtrlPb_delay_since_meas: [1x1 struct]
%                CanMsgLongCtrlPb_distance_to_stop: [1x1 struct]
%          CanMsgLongCtrlPb_distance_to_stop_valid: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_x1: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_x2: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_x3: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_x4: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_x5: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_y1: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_y2: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_y3: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_y4: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_curve_y5: [1x1 struct]
%                 CanMsgLongCtrlPb_gas_pdl_dem_pos: [1x1 struct]
%                CanMsgLongCtrlPb_gas_pdl_req_mode: [1x1 struct]
%                        CanMsgLongCtrlPb_gear_req: [1x1 struct]
%                CanMsgLongCtrlPb_header_timestamp: [1x1 struct]
%         CanMsgLongCtrlPb_header_timestamp_source: [1x1 struct]
%     CanMsgLongCtrlPb_header_timestamp_sync_state: [1x1 struct]
%               CanMsgLongCtrlPb_max_acc_set_speed: [1x1 struct]
%                        CanMsgLongCtrlPb_park_req: [1x1 struct]
%                  CanMsgLongCtrlPb_switch_acc_off: [1x1 struct]
%                   CanMsgLongCtrlPb_switch_acc_on: [1x1 struct]
%                           CanMsgLongCtrlPb_v_req: [1x1 struct]
%                      CanMsgLongCtrlPb_v_req_type: [1x1 struct]
  c_names = fieldnames(e);
  n       = length(c_names);
% Channels zuordnen
%                   VehiclePose_mVersionNo: [1x1 struct]
%                    VehiclePose_timestamp: [1x1 struct]
%                          VehiclePose_x_m: [1x1 struct]
%                          VehiclePose_y_m: [1x1 struct]
%                      VehiclePose_yaw_rad: [1x1 struct]

  for i=1:n
    
    switch(c_names{i})
      
      case {[channel_name,'_a_req']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s/s';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case {[channel_name,'_max_acc_set_speed'],[channel_name,'_v_req']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'km/h';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case {[channel_name,'_distance_to_stop'],[channel_name,'_y_m'],[channel_name,'_x_cog_m'],[channel_name,'_x_ra_m'],[channel_name,'_y_cog_m'],[channel_name,'_y_ra_m'],[channel_name,'_s_m']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case [channel_name,'_brk_press_req']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'bar';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case [channel_name,'_delay_since_meas']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 's';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
      case {[channel_name,'_timestamp'],[channel_name,'_header_timestamp']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
      case {[channel_name,'_a_req_type'] ...
           ,[channel_name,'_v_req_type'] ...
           ,[channel_name,'_brk_press_req_activ'] ...
           ,[channel_name,'_distance_to_stop_valid'] ...
           ,[channel_name,'_gear_req'] ...  
           ,[channel_name,'_park_req'] ...  
           ,[channel_name,'_switch_acc_off'] ...  
           ,[channel_name,'_switch_acc_on'] ...             
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = '-';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
    end
  end
end