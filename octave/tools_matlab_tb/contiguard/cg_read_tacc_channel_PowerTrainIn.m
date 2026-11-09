function eout = cg_read_tacc_channel_PowerTrainIn(e,channel_name,use_old_names)
  e = e_data_rename_signal(e,[channel_name,'_header_timestamp'],[channel_name,'_timestamp']);
if( use_old_names )
  e = e_data_rename_signal(e,[channel_name,'_errs_engine_speed'],[channel_name,'_err_engineSpeed']);
  e = e_data_rename_signal(e,[channel_name,'_errs_engine_torque'],[channel_name,'_err_engineTorque']);
  e = e_data_rename_signal(e,[channel_name,'_signals_engine_speed'],[channel_name,'_signals_engineSpeed']);
  e = e_data_rename_signal(e,[channel_name,'_signals_gas_pedal_pos'],[channel_name,'_signals_gasPedalPos']);
  e = e_data_rename_signal(e,[channel_name,'_signals_gas_pedal_pos_grad'],[channel_name,'_signals_gasPedalPosGrad']);
end

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);
% Channels zuordnen
%         PowerTrainIn_err_engineSpeed: [1x1 struct]
%         PowerTrainIn_err_engineTorque: [1x1 struct]
%         PowerTrainIn_err_fuelConsumption: [1x1 struct]
%         PowerTrainIn_err_gasPedalPos: [1x1 struct]
%         PowerTrainIn_err_gasPedalPosGrad: [1x1 struct]
%         PowerTrainIn_err_gear: [1x1 struct]
%         PowerTrainIn_err_reserved: [1x1 struct]
%         PowerTrainIn_general: [1x1 struct]
%         PowerTrainIn_signals_engineSpeed: [1x1 struct]
%         PowerTrainIn_signals_engineTorque: [1x1 struct]
%         PowerTrainIn_signals_fuelConsumption: [1x1 struct]
%         PowerTrainIn_signals_gasPedalPos: [1x1 struct]
%         PowerTrainIn_signals_gasPedalPosGrad: [1x1 struct]
%         PowerTrainIn_signals_gear: [1x1 struct]
%         PowerTrainIn_signals_timestamp: [1x1 struct]

  for i=1:n
    
    switch(c_names{i})
      case {[channel_name,'_signals_engineSpeed'],[channel_name,'_signals_engine_speed']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'U/min';
       eout.(c_names{i}).comment  = 'Motordrehzahl';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_engineTorque'],[channel_name,'_signals_engine_torque']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'Nm';
       eout.(c_names{i}).comment  = 'Motormoment';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_fuelConsumption'],[channel_name,'_signals_fuel_consumption']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'l/h';
       eout.(c_names{i}).comment  = 'Verbrauch';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_gasPedalPos'],[channel_name,'_signals_gas_pedal_pos']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '%';
       eout.(c_names{i}).comment  = 'Gaspedal';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_signals_gasPedalPosGrad'],[channel_name,'_signals_gas_pedal_pos_grad']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '%/s';
       eout.(c_names{i}).comment  = 'Gaspedaländerung';
       eout.(c_names{i}).lin      = 1;
      case [channel_name,'_signals_gear']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'Gang';
       eout.(c_names{i}).lin      = 0;
      case [channel_name,'_signals_timestamp']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment  = 'timestamp';
       eout.(c_names{i}).lin      = 1;
       
    end
  end
end