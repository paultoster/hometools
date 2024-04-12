function eout = cg_read_tacc_channel_ExtVeloRequest(e,channel_name,use_old_names)

%                    DrvCtrlVRequestPb_acc_gradient: [1x1 struct]
%                    DrvCtrlVRequestPb_acceleration: [1x1 struct]
%           DrvCtrlVRequestPb_always_send_accel_req: [1x1 struct]
%                   DrvCtrlVRequestPb_control_state: [1x1 struct]
%                            DrvCtrlVRequestPb_gear: [1x1 struct]
%                DrvCtrlVRequestPb_header_timestamp: [1x1 struct]
%         DrvCtrlVRequestPb_header_timestamp_source: [1x1 struct]
%     DrvCtrlVRequestPb_header_timestamp_sync_state: [1x1 struct]
%                      DrvCtrlVRequestPb_next_accel: [1x1 struct]
%                DrvCtrlVRequestPb_next_accel_valid: [1x1 struct]
%                       DrvCtrlVRequestPb_next_velo: [1x1 struct]
%                 DrvCtrlVRequestPb_next_velo_valid: [1x1 struct]
%                            DrvCtrlVRequestPb_park: [1x1 struct]
%                  DrvCtrlVRequestPb_request_active: [1x1 struct]
%                 DrvCtrlVRequestPb_resm_aftr_intrv: [1x1 struct]
%                 DrvCtrlVRequestPb_stndstll_mngmnt: [1x1 struct]
%                  DrvCtrlVRequestPb_switch_acc_off: [1x1 struct]
%                   DrvCtrlVRequestPb_switch_acc_on: [1x1 struct]
%                        DrvCtrlVRequestPb_velocity: [1x1 struct]
%                DrvCtrlVRequestPb_distance_to_stop: [1x1 struct]
%          DrvCtrlVRequestPb_distance_to_stop_valid: [1x1 struct]
  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);
  
  for i=1:n
    
    switch(c_names{i})
      case {[channel_name,'_distance_to_stop']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 1;       
      case {[channel_name,'_acc_gradient']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'm/s/s/s';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 1;       
      case {[channel_name,'_acceleration'],[channel_name,'_next_accel']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'm/s/s';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 1; 
      case {[channel_name,'_velocity'],[channel_name,'_next_velo'],[channel_name,'_velocity_ahead']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 1; 
       
      case {[channel_name,'_control_state'] ...
           ,[channel_name,'_always_send_accel_req'] ...
           ,[channel_name,'_gear'] ...
           ,[channel_name,'_timestamp_source'] ...
           ,[channel_name,'_header_timestamp_sync_state'] ...
           ,[channel_name,'_next_accel_valid'] ...
           ,[channel_name,'_next_velo_valid'] ...           
           ,[channel_name,'_park'] ...
           ,[channel_name,'_request_active'] ...           
           ,[channel_name,'_resm_aftr_intrv'] ...           
           ,[channel_name,'_stndstll_mngmnt'] ...           
           ,[channel_name,'_switch_acc_off'] ...           
           ,[channel_name,'_switch_acc_on'] ...
           ,[channel_name,'_distance_to_stop_valid'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 0;
      case {[channel_name,'_timestamp'],[channel_name,'_header_timestamp']}
       t_name = [channel_name,'_timestamp'];
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(t_name).time = double(tin);
       eout.(t_name).vec  = double(vin);
       eout.(t_name).unit = 'us';
       eout.(t_name).comment = '';
       eout.(t_name).lin     = 1;     
      otherwise       
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = '';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
    end
  end
end