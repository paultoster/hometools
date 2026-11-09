function eout = cg_read_tacc_channel_CarSwitches(e,channel_name,use_old_names)
  e = e_data_rename_signal(e,[channel_name,'_header_timestamp'],[channel_name,'_timestamp']);
if( use_old_names )
  e = e_data_rename_signal(e,[channel_name,'_signals_car_id'],[channel_name,'_signals_carId']);
  e = e_data_rename_signal(e,[channel_name,'_signals_cruise_control'],[channel_name,'_signals_cruiseControl']);
  e = e_data_rename_signal(e,[channel_name,'_signals_gear_lever'],[channel_name,'_signals_gearLever']);
  e = e_data_rename_signal(e,[channel_name,'_signals_hands_off'],[channel_name,'_signals_handsOff']);
  e = e_data_rename_signal(e,[channel_name,'_signals_odometer_total'],[channel_name,'_signals_odometerTotal']);
  e = e_data_rename_signal(e,[channel_name,'_signals_park_brake_state'],[channel_name,'_signals_parkBrakeState']);
  e = e_data_rename_signal(e,[channel_name,'_signals_car_id'],[channel_name,'_signals_carId']);
  e = e_data_rename_signal(e,[channel_name,'_signals_temperature_ext'],[channel_name,'_signals_temperatureExt']);
  e = e_data_rename_signal(e,[channel_name,'_signals_wiper_front'],[channel_name,'_signals_wiperFront']);
  e = e_data_rename_signal(e,[channel_name,'_signals_wiper_rear'],[channel_name,'_signals_wiperRear']);
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
      case {[channel_name,'_signals_blinker'] ...
           ,[channel_name,'_signals_carId'] ...
           ,[channel_name,'_signals_cruiseControl'] ...
           ,[channel_name,'_signals_doors'] ...
           ,[channel_name,'_signals_gearLever'] ...
           ,[channel_name,'_signals_handsOff'] ...
           ,[channel_name,'_signals_lamps'] ...
           ,[channel_name,'_signals_odometerTotal'] ...
           ,[channel_name,'_signals_parkBrakeState'] ...
           ,[channel_name,'_signals_temperatureExt'] ...
           ,[channel_name,'_signals_wiperFront'] ...
           ,[channel_name,'_signals_wiperRear'] ...
           ,[channel_name,'_signals_car_id'] ...
           ,[channel_name,'_signals_cruise_control'] ...
           ,[channel_name,'_signals_doors'] ...
           ,[channel_name,'_signals_gear_lever'] ...
           ,[channel_name,'_signals_hands_off'] ...
           ,[channel_name,'_signals_lamps'] ...
           ,[channel_name,'_signals_odometer_total'] ...
           ,[channel_name,'_signals_park_brake_state'] ...
           ,[channel_name,'_signals_temperature_ext'] ...
           ,[channel_name,'_signals_wiper_front'] ...
           ,[channel_name,'_signals_wiper_rear'] ...
           ,[channel_name,'_signals_status_steering_actuator'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 1;
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