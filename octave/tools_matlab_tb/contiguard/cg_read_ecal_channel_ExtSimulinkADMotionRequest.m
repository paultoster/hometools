function e = cg_read_ecal_channel_ExtSimulinkADMotionRequest(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'use_simulink_channel'    , 1,'-'     ,'int'     ,0,''} ...
                 ,{'lat_out_la_kmc_status'   , 1,'-'     ,'int'        ,0,''} ...     
                 ,{'lat_out_la_dmc_activate'   , 1,'-'     ,'int'     ,0,''} ...     
                 ,{'lat_out_front_axle_wheel_angle_request' , 1,'rad'     ,'double'     ,0,''} ...     
                 ,{'lat_out_rear_axle_wheel_angle_request'  , 1,'rad'     ,'double'     ,0,''} ...     
                 ,{'long_out_lo_kmc_status'                 , 1,'-'     ,'int'        ,0,''} ...     
                 ,{'long_out_cruising_lo_dmc_activate'      , 1,'-'     ,'int'     ,0,''} ...     
                 ,{'long_out_parking_lo_dmc_activate'      , 1,'-'     ,'int'     ,0,''} ...     
                 ,{'long_out_accel_req'                    , 1,'m/s/s'     ,'double'     ,0,''} ...     
                 ,{'long_out_velocity_req'                 , 1,'m/s'     ,'double'     ,0,''} ...     
                 ,{'long_out_distance_to_stop'             , 1,'m'     ,'double'     ,0,''} ...     
                 ,{'long_out_epb_req'                      , 1,'-'     ,'int'        ,0,''} ...     
                 ,{'long_out_hold_req'                     , 1,'-'     ,'int'        ,0,''} ...     
                 ,{'long_out_emergency_hold_req'           , 1,'-'     ,'int'        ,0,''} ...     
                 ,{'long_out_gear_lever_req'               , 1,'-'     ,'int'        ,0,'0:Manual, 1:D, 2:R, 3:N, 4:P '} ...     
                 ,{'long_out_gear_switch_req'              , 1,'-'     ,'int'        ,0,''} ...     
                 };                 

  e    = struct([]);
  
  [e,time] = cg_read_ecal_channel_read_timestamp(e,d,name_channel);
  
%   ndata = length(d.data);
%    
%   timestamp = zeros(ndata,1);
%   for j=1:ndata
%     timestamp(j) = d.data{j}.header.timestamp;
%   end
%   if( isfield(d,'timestamps') )
%     time = double(d.timestamps)*1.0e-6;
%   else
%     time = double(timestamp)*1.0e-6;
%   end
%   
%   e = e_data_add_value(e,[name_channel,'_timestamp'],'us','time stamp',time,timestamp,0);
  
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);

%   for i=1:length(sigliste)
%     ee = cg_read_ecal_channel_signal(sigliste{i},d.data,time,name_channel);
%     e  = merge_struct_f(e,ee);
%   end
  
% e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);
  
end