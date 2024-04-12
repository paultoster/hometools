function e = cg_read_ecal_channel_ParkScenarioResponseTrainedPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'response'            , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'error'               , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'start_pos_state'     , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'start_position.x'         , 1,'m'     ,'double' ,0,''} ...
                 ,{'start_position.y'         , 1,'m'     ,'double' ,0,''} ...
                 ,{'start_pos_yaw'       , 1,'rad'   ,'double' ,0,''} ...
                 ,{'end_pos_state'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'end_position.x'           , 1,'m'     ,'double' ,0,''} ...
                 ,{'end_position.y'           , 1,'m'     ,'double' ,0,''} ...
                 ,{'end_pos_yaw'         , 1,'rad'   ,'double' ,0,''} ...
                 ,{'traj_loaded_index'   , 1,'enum'  ,'int'    ,0,''} ...   
                 ,{'resume_state'   , 1,'enum'  ,'int'    ,0,''} ... 
                 ,{'waypoint_next_id'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'waypoint_next_type'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'waypoint_next_id'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'waypoint_next_action'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'waypoint_next_position.x'       , 1,'m'  ,'double'    ,1,''} ...
                 ,{'waypoint_next_position.y'       , 1,'m'  ,'double'    ,1,''} ...
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