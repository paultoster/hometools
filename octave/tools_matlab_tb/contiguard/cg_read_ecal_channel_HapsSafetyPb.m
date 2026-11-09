function e = cg_read_ecal_channel_HapsSafetyPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'haps_active'              , 1,'enum' ,'int'       ,0,''} ...
                 ,{'tp_start_pos_state'     , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'tp_start_position.x'         , 1,'m'     ,'double' ,0,''} ...
                 ,{'tp_start_position.y'         , 1,'m'     ,'double' ,0,''} ...
                 ,{'tp_start_pos_yaw'       , 1,'rad'   ,'double' ,0,''} ...
                 ,{'tp_end_pos_state'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'tp_end_position.x'           , 1,'m'     ,'double' ,0,''} ...
                 ,{'tp_end_position.y'           , 1,'m'     ,'double' ,0,''} ...
                 ,{'tp_end_pos_yaw'         , 1,'rad'   ,'double' ,0,''} ...
                 };
                 
%                    id_rel_obj: 0
%               process_time_ms: 0
%                  loop_time_ms: 21
%             ss_sample_point_s: 0
%         ss_long_start_state_e: 0
%             ss_sample_point_t: 0
%         ss_long_start_state_t: 0
%      dsrd_traj_out_flag_avail: 0
%        dsrd_traj_out_x_ra_act: -43.424131284303478
%        dsrd_traj_out_y_ra_act: 3.699258938299343
%        dsrd_traj_out_s_ra_act: 0
%     dsrd_traj_out_vel_ref_act: 0
%              way_point_status: 0
%      way_point_act_req_action: 2
%     way_point_act_is_relevant: 0
%           way_point_act_x_pos: -1
%           way_point_act_y_pos: -1
%            way_point_act_type: 0
%              way_point_act_id: 0
%        way_point_act_s_pos_ra: 0
%       way_point_act_s_stop_ra: 0
%      way_point_act_s_start_ra: 0
%      way_point_act_index_stop: 0

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