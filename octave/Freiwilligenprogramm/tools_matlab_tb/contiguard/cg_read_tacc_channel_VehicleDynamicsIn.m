function eout = cg_read_tacc_channel_VehicleDynamicsIn(e,channel_name,use_old_names)
if( use_old_names )
  e = e_data_rename_signal(e,[channel_name,'_signals_steering_wheel_angle'],[channel_name,'_signals_steeringWheelAngle']);
  e = e_data_rename_signal(e,[channel_name,'_signals_lat_acc'],[channel_name,'_signals_latAcc']);
  e = e_data_rename_signal(e,[channel_name,'_signals_long_acc'],[channel_name,'_signals_longAcc']);
  e = e_data_rename_signal(e,[channel_name,'_signals_steering_wheel_angle_speed'],[channel_name,'_signals_steeringWheelAngleSpeed']);
  e = e_data_rename_signal(e,[channel_name,'_signals_speed_per_wheel0'],[channel_name,'_signals_speedPerWheel0']);
  e = e_data_rename_signal(e,[channel_name,'_signals_speed_per_wheel1'],[channel_name,'_signals_speedPerWheel1']);
  e = e_data_rename_signal(e,[channel_name,'_signals_speed_per_wheel2'],[channel_name,'_signals_speedPerWheel2']);
  e = e_data_rename_signal(e,[channel_name,'_signals_speed_per_wheel3'],[channel_name,'_signals_speedPerWheel3']);
end 


  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);
% Channels zuordnen
%     'VehicleDynamicsIn_err_drvSteerTorque'
%     'VehicleDynamicsIn_err_latAcc'
%     'VehicleDynamicsIn_err_longAcc'
%     'VehicleDynamicsIn_err_reserved0'
%     'VehicleDynamicsIn_err_reserved1'
%     'VehicleDynamicsIn_err_reserved2'
%     'VehicleDynamicsIn_err_speed'
%     'VehicleDynamicsIn_err_speedDisplayed'
%     'VehicleDynamicsIn_err_speedPerWheel0'
%     'VehicleDynamicsIn_err_speedPerWheel1'
%     'VehicleDynamicsIn_err_speedPerWheel2'
%     'VehicleDynamicsIn_err_speedPerWheel3'
%     'VehicleDynamicsIn_err_steeringWheelAngle'
%     'VehicleDynamicsIn_err_steeringWheelAngleSpeed'
%     'VehicleDynamicsIn_err_yawrate'
%     'VehicleDynamicsIn_general'
%     'VehicleDynamicsIn_signals_drvSteerTorque'
%     'VehicleDynamicsIn_signals_latAcc'
%     'VehicleDynamicsIn_signals_longAcc'
%     'VehicleDynamicsIn_signals_speed'
%     'VehicleDynamicsIn_signals_speedDisplayed'
%     'VehicleDynamicsIn_signals_speedPerWheel0'
%     'VehicleDynamicsIn_signals_speedPerWheel1'
%     'VehicleDynamicsIn_signals_speedPerWheel2'
%     'VehicleDynamicsIn_signals_speedPerWheel3'
%     'VehicleDynamicsIn_signals_steeringWheelAngle'
%     'VehicleDynamicsIn_signals_steeringWheelAngleSpeed'
%     'VehicleDynamicsIn_signals_timestamp'
%     'VehicleDynamicsIn_signals_yawrate'

  for i=1:n
    
    switch(c_names{i})
      case {[channel_name,'_signals_longAcc'],[channel_name,'_signals_long_acc']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s/s';
       eout.(c_names{i}).comment  = 'vehicle longitudinal acceleration';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_latAcc'],[channel_name,'_signals_lat_acc']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s/s';
       eout.(c_names{i}).comment  = 'vehicle lateral acceleration';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_steeringWheelAngle'],[channel_name,'_signals_steering_wheel_angle']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = 'steering wheel angle';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_steeringWheelAngleSpeed'],[channel_name,'_signals_steering_wheel_angle_speed']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad/s';
       eout.(c_names{i}).comment  = 'steering wheel angle velocity';
       eout.(c_names{i}).lin      = 1;
      case [channel_name,'_signals_speed']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity (rueckwaerts negativ)';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_speedPerWheel0'],[channel_name,'_signals_speed_per_wheel0']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'wheel speed FL';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_speedPerWheel1'],[channel_name,'_signals_speed_per_wheel1']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'wheel speed FR';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_speedPerWheel2'],[channel_name,'_signals_speed_per_wheel2']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'wheel speed RL';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_speedPerWheel3'],[channel_name,'_signals_speed_per_wheel3']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'wheel speed RR';
       eout.(c_names{i}).lin      = 1;
      case [channel_name,'_signals_yawrate']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad/s';
       eout.(c_names{i}).comment  = 'vehicle yaw rate';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_drvSteerTorque'],[channel_name,'_signals_drv_steer_torque']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'Nm';
       eout.(c_names{i}).comment  = 'driver steer wheel torque';
       eout.(c_names{i}).lin      = 1;
       
    end
  end
end