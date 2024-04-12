function eout = cg_read_tacc_channel_VehicleDynamics(e)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);
% Channels zuordnen
%     'VehicleDynamics_a_x_mps2'
%     'VehicleDynamics_a_y_mps2'
%     'VehicleDynamics_driveDir'
%     'VehicleDynamics_mVersionNo'
%     'VehicleDynamics_selectedCar'
%     'VehicleDynamics_steeringWheelAngle_rad'
%     'VehicleDynamics_steeringWheelRate_radps'
%     'VehicleDynamics_timestamp'
%     'VehicleDynamics_v_mps'
%     'VehicleDynamics_wheelSpeedFL_mps'
%     'VehicleDynamics_wheelSpeedFR_mps'
%     'VehicleDynamics_wheelSpeedRL_mps'
%     'VehicleDynamics_wheelSpeedRR_mps'
%     'VehicleDynamics_yawRate_radps'

  for i=1:n
    
    switch(c_names{i})
      case 'VehicleDynamics_a_x_mps2'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s/s';
       eout.(c_names{i}).comment  = 'vehicle longitudinal acceleration';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_a_y_mps2'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s/s';
       eout.(c_names{i}).comment  = 'vehicle lateral acceleration';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_driveDir'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '-';
       eout.(c_names{i}).comment  = '';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_steeringWheelAngle_rad'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = 'steering wheel angle';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_steeringWheelRate_radps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad/s';
       eout.(c_names{i}).comment  = 'steering wheel angle velocity';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_v_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_wheelSpeedFL_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'wheel speed FL';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_wheelSpeedFR_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'wheel speed FR';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_wheelSpeedRL_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'wheel speed RL';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_wheelSpeedRR_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'wheel speed RR';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_yawRate_radps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad/s';
       eout.(c_names{i}).comment  = 'vehicle yaw rate';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_v_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_v_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_v_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_v_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_v_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_v_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_v_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity';
       eout.(c_names{i}).lin      = 1;
      case 'VehicleDynamics_v_mps'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = 'vehicle velocity';
       eout.(c_names{i}).lin      = 1;
    end
  end
end