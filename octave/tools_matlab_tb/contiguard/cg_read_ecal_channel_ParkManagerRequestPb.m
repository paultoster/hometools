function e = cg_read_ecal_channel_ParkManagerRequestPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'tpl_req_state'       , 1,'enum'  ,'int'    ,0,'0:TPL_IDLE,1:TPL_RECORD,2:TPL_SEND_PATH'} ...
                 ,{'use_index'           , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'tpp_req_state'       , 1,'enum'  ,'int'    ,0,'0:TPP_IDLE,1:TPP_RUN,2:TPP_PAUSE,3:TPP_HANDOVER_PAUSE,4:TPP_INFRONT_PAUSE,5:TPP_WAYPOINT_PAUSE,6:TPP_RECORD,7:TPP_SEARCH_PATH'} ...
                 ,{'tpp_stop_dist'       , 1,'m'     ,'double' ,1,''} ...
                 ,{'tpp_use_park_point'  , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'tpp_park_pos_yaw'    , 1,'rda'     ,'double' ,1,''} ...
                 ,{'waypoint_req_id'     , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'waypoint_req_action' , 1,'enum'  ,'int'    ,0,'0:TP_WAYPOINT_STOP,1:TP_WAYPOINT_PASS,2:TP_WAYPOINT_NO_DECISION'} ...  
                 ,{'tpp_park_position.x' , 1,'m'     ,'double' ,1,''} ...
                 ,{'tpp_park_position.y' , 1,'m'     ,'double' ,1,''} ...
                 ,{'active_mode'         , 1,'enum'  ,'int'    ,0,'0:NOT_ACTIVE_MODE,1:TRAINED_PARKING_MODE,2:VALET_PARKING_MODE'} ...  
                 ,{'is_in_parking_hold'  , 1,'enum'  ,'int'    ,0,''} ...  
                 ,{'slam_task'           , 1,'enum'  ,'int'    ,0,'0:SLAM_TASK_UNDEFINED,1:SLAM_TASK_RADAR,2:SLAM_TASK_CAMERA,3:SLAM_TASK_FUSED,4:SLAM_TASK_FUSED_2MAPS'} ...  
                 ,{'slam_req_state'      , 1,'enum'  ,'int'    ,0,'0:SLAM_IDLE,1:SLAM_RECORD,2:SLAM_SEARCH_PATH,3:SLAM_RUN'} ...  
                 ,{'veh_ready_for_start' , 1,'enum'  ,'int'    ,0,''} ...  
                 };
                 
%                  header: [1x1 struct]
%                     x_m: 9.138123145081461e+02
%                     y_m: -5.508884514697104e+02
%                  x_ra_m: 9.116008999764259e+02
%                  y_ra_m: -5.493185502725337e+02
%                 x_cog_m: 9.128240274829083e+02
%                 y_cog_m: -5.501868584568128e+02
%                 yaw_rad: -0.617344822108180
%           slip_angle_ra: 7.923510775588877e-04
%                 sigma_x: 0
%                 sigma_y: 0
%     sigma_slip_angle_ra: 1
%         sigma_yaw_angle: 0
%               track_rad: 0
%           motion_status: 1

  e    = struct([]);
  
  
  
  ndata = length(d.data);
   
  timestamp = zeros(ndata,1);
  for j=1:ndata
    timestamp(j) = d.data{j}.header.timestamp;
  end
  if( isfield(d,'timestamps') )
    time = double(d.timestamps)*1.0e-6;
  else
    time = double(timestamp)*1.0e-6;
  end
  
  e = e_data_add_value(e,[name_channel,'_timestamp'],'us','time stamp',time,timestamp,0);
  
  
  for i=1:length(sigliste)
    ee = cg_read_ecal_channel_signal(sigliste{i},d.data,time,name_channel);
    e  = merge_struct_f(e,ee);
  end
  
  e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);
  
end