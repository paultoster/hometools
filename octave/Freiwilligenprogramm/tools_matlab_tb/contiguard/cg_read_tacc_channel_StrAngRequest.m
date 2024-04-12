function eout = cg_read_tacc_channel_StrAngRequest(e,channel_name)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);
  e = e_data_rename_signal(e,[channel_name,'_header_timestamp'],[channel_name,'_timestamp']);
% Channels zuordnen
%                           DrvCtrlStrAngRequestPb_active: [1x1 struct]
%                 DrvCtrlStrAngRequestPb_header_timestamp: [1x1 struct]
%          DrvCtrlStrAngRequestPb_header_timestamp_source: [1x1 struct]
%      DrvCtrlStrAngRequestPb_header_timestamp_sync_state: [1x1 struct]
%         DrvCtrlStrAngRequestPb_lateral_control_priority: [1x1 struct]
%          DrvCtrlStrAngRequestPb_lateral_control_quality: [1x1 struct]
%     DrvCtrlStrAngRequestPb_steering_angle_request_value: [1x1 struct]

  for i=1:n
    
    switch(c_names{i})
      case [channel_name,'_active']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'active-Signal';
       eout.(c_names{i}).lin      = 0;
      case [channel_name,'_timestamp']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment  = 'timestamp';
       eout.(c_names{i}).lin      = 0;
      case [channel_name,'_lateral_control_priority']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'Priority';
       eout.(c_names{i}).lin      = 0;
      case [channel_name,'_lateral_control_quality']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'Quality';
       eout.(c_names{i}).lin      = 0;
      case [channel_name,'_steering_angle_request_value']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = 'Requested steering wheel angle';
       eout.(c_names{i}).lin      = 1;
    end
  end
end