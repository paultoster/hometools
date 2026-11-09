function eout = cg_read_tacc_channel_AD2PDev2PthRequest(e,channel_name,use_old_names)

%                                 AD2PDev2PthRequest_active: [1x1 struct]
%                   AD2PDev2PthRequest_header_timestamp: [1x1 struct]
%           AD2PDev2PthRequest_lateral_control_priority: [1x1 struct]
%            AD2PDev2PthRequest_lateral_control_quality: [1x1 struct]
%                AD2PDev2PthRequest_lateral_deviation_y: [1x1 struct]
%                   AD2PDev2PthRequest_pilot_control_c0: [1x1 struct]
%                   AD2PDev2PthRequest_ramp_out_request: [1x1 struct]
%            AD2PDev2PthRequest_yaw_angle_deviation_psi: [1x1 struct]
%                            AD2PDev2PthRequest_flagNew: [1x1 struct]
  e = e_data_rename_signal(e,[channel_name,'_header_timestamp'],[channel_name,'_timestamp']);
if( use_old_names )
  e = e_data_rename_signal(e,[channel_name,'_lateral_control_priority'],[channel_name,'_lateralControlPriority']);
  e = e_data_rename_signal(e,[channel_name,'_lateral_control_quality'],[channel_name,'_lateralControlQuality']);
  e = e_data_rename_signal(e,[channel_name,'_yaw_angle_deviation_psi'],[channel_name,'_yawAngleDeviationPsi']);
  e = e_data_rename_signal(e,[channel_name,'_lateral_deviation_y'],[channel_name,'_lateralDeviationY']);
  e = e_data_rename_signal(e,[channel_name,'_pilot_control_c0'],[channel_name,'_pilotControlC0']);
end
  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);
% Channels zuordnen
%     'CarSwitchesIn_err_blinker'
%     'CarSwitchesIn_err_carId'
%     'CarSwitchesIn_err_cruiseControl'
%     'CarSwitchesIn_err_cruiseDriverSpeed'
%     'CarSwitchesIn_err_doors'
%     'CarSwitchesIn_err_gearLever'
%     'CarSwitchesIn_err_handsOff'
%     'CarSwitchesIn_err_lamps'
%     'CarSwitchesIn_err_odometerTotal'
%     'CarSwitchesIn_err_parkBrakeState'
%     'CarSwitchesIn_err_temperatureExt'
%     'CarSwitchesIn_err_wiperFront'
%     'CarSwitchesIn_err_wiperRear'
%     'CarSwitchesIn_general'
%     'CarSwitchesIn_signals_blinker'
%     'CarSwitchesIn_signals_carId'
%     'CarSwitchesIn_signals_cruiseControl'
%     'CarSwitchesIn_signals_cruiseDriverSpeed'
%     'CarSwitchesIn_signals_doors'
%     'CarSwitchesIn_signals_gearLever'
%     'CarSwitchesIn_signals_handsOff'
%     'CarSwitchesIn_signals_lamps'
%     'CarSwitchesIn_signals_odometerTotal'
%     'CarSwitchesIn_signals_parkBrakeState'
%     'CarSwitchesIn_signals_temperatureExt'
%     'CarSwitchesIn_signals_timestamp'
%     'CarSwitchesIn_signals_wiperFront'
%     'CarSwitchesIn_signals_wiperRear'

  for i=1:n
    
    switch(c_names{i})
      case {[channel_name,'_active'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '-';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 0;
      case {[channel_name,'_lateralControlPriority'] ...
           ,[channel_name,'_lateral_control_priority'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 0;
      case {[channel_name,'_lateralControlQuality'] ...
           ,[channel_name,'_lateral_control_quality'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 0;
      case {[channel_name,'_yawAngleDeviationPsi'] ...
           ,[channel_name,'_yaw_angle_deviation_psi'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 1;       
      case {[channel_name,'_lateralDeviationY'] ...
           ,[channel_name,'_lateral_deviation_y'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 1;       
      case {[channel_name,'_pilotControlC0'] ...
           ,[channel_name,'_pilot_control_c0'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '1/m';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 1;       
     case {[channel_name,'_timestamp'] ...
          ,[channel_name,'_header_timestamp'] ...
          }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment  = 'timestamp';
       eout.(c_names{i}).lin      = 1;
     case {[channel_name,'_ramp_out_request'] ...
          }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'ramp out req';
       eout.(c_names{i}).lin      = 1;
     otherwise
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '';
       eout.(c_names{i}).comment  = 'timestamp';
       eout.(c_names{i}).lin      = 0;
        
    end
  end
end