function eout = cg_read_tacc_channel_ArbiVRequest(e,channel_name,use_old_names)

%                      ArbiVRequestPb_app_number: [1x1 struct]
%                     ArbiVRequestPb_application: [1x1 struct]
%                        ArbiVRequestPb_gear_req: [1x1 struct]
%                ArbiVRequestPb_header_timestamp: [1x1 struct]
%         ArbiVRequestPb_header_timestamp_source: [1x1 struct]
%     ArbiVRequestPb_header_timestamp_sync_state: [1x1 struct]
%                        ArbiVRequestPb_park_req: [1x1 struct]
%                 ArbiVRequestPb_resm_aftr_intrv: [1x1 struct]
%                  ArbiVRequestPb_switch_acc_off: [1x1 struct]
%                   ArbiVRequestPb_switch_acc_on: [1x1 struct]
%                        ArbiVRequestPb_velocity: [1x1 struct]
  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);

  for i=1:n
    
    switch(c_names{i})
      case {[channel_name,'_app_number'] ...
           ,[channel_name,'_application'] ...
           ,[channel_name,'_gear_req'] ...
           ,[channel_name,'_header_timestamp_source'] ...
           ,[channel_name,'_timestamp_sync_state'] ...
           ,[channel_name,'_park_req'] ...
           ,[channel_name,'_resm_aftr_intrv'] ...
           ,[channel_name,'_switch_acc_off'] ...
           ,[channel_name,'_switch_acc_on'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = '-';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 0;
     case {[channel_name,'_signals_timestamp'],[channel_name,'_header_timestamp']}
       t_name = [channel_name,'_timestamp'];
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(t_name).time = double(tin);
       eout.(t_name).vec  = double(vin);
       eout.(t_name).unit = 'us';
       eout.(t_name).comment  = 'timestamp';
       eout.(t_name).lin      = 1;
     case [channel_name,'_velocity']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = 'm/s';
       eout.(c_names{i}).comment  = str_change_f(c_names{i},'_',' ');
       eout.(c_names{i}).lin      = 1;
       
    end
  end
end