function e = cg_read_ecal_channel_MotionReqDebugPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'run_time_ms'           , 1,'ms'   ,'double'     ,1,''} ...
                 ,{'loop_time_ms'          , 1,'ms'   ,'double'     ,1,''} ...
                 ,{'x_ego'                 , 1,'m'    ,'double'     ,1,''} ...
                 ,{'y_ego'                 , 1,'m'    ,'double'     ,1,''} ...
                 ,{'yaw_ego'               , 1,'rad'  ,'double'     ,1,''} ...
                 ,{'x_traj_is'             , 1,'m'    ,'double'     ,1,''} ...
                 ,{'y_traj_is'             , 1,'m'    ,'double'     ,1,''} ...
                 ,{'theta_traj_is'         , 1,'rad'  ,'double'     ,1,''} ...
                 ,{'x_traj'                , 1,'m'    ,'double'     ,1,''} ...
                 ,{'y_traj'                , 1,'m'    ,'double'     ,1,''} ...
                 ,{'theta_traj'            , 1,'rad'  ,'double'     ,1,''} ...
                 ,{'kappa_traj_is'         , 1,'1/m'  ,'double'     ,1,''} ...
                 ,{'kappa_traj'            , 1,'1/m'  ,'double'     ,1,''} ...
                 ,{'vel_traj_is'           , 1,'m/s'  ,'double'     ,1,''} ...
                 ,{'vel_traj'              , 1,'m/s'  ,'double'     ,1,''} ...
                 ,{'acc_traj_is'           , 1,'m/s/s'  ,'double'     ,1,''} ...
                 ,{'acc_traj'              , 1,'m/s/s'  ,'double'     ,1,''} ...
                 ,{'dy_raw'                , 1,'m'    ,'double'     ,1,''} ...
                 ,{'dpsi_raw'              , 1,'rad'    ,'double'     ,1,''} ...
                 ,{'index_act'             , 1,'num'  ,'int'     ,0,''} ...
                 ,{'d_path_act'            , 1,'-'    ,'double'     ,1,''} ...
                 ,{'index_pre_long'        , 1,'num'  ,'int'     ,0,''} ...
                 ,{'d_path_pre_long'       , 1,'-'    ,'double'     ,1,''} ...
                 ,{'index_pre_lat'         , 1,'num'  ,'int'     ,0,''} ...
                 ,{'d_path_pre_lat'        , 1,'-'    ,'double'     ,1,''} ...
                 ,{'n_input'               , 1,'num'  ,'int'     ,0,''} ...
                 ,{'n_calc'                , 1,'num'  ,'int'     ,0,''} ...
                 ,{'n_add_start'           , 1,'num'  ,'int'     ,0,''} ...
                 ,{'n_add_end'             , 1,'num'  ,'int'     ,0,''} ...
                 ,{'drive_state'           , 1,'enum' ,'int'     ,0,'UNDEF = 0,HOLD_NTRL = 1,HOLD_SETGEAR_FORW = 2,HOLD_FORW = 3,HOLD_SETGEAR_BACK = 4,HOLD_BACK = 5,DRIV_FORW = 6,DRIV_NTRL = 7,DRIV_BACK = 8,HOLD_FINL = 9,ERRORHNDL = 10'} ...
                 ,{'d2p_calc_type'         , 1,'enum'   ,'int'     ,0,'UNKNOWN = 0,TRAJECTORY = 1,PATH = 2,'} ...
                 ,{'d2p_run_state'         , 1,'enum'   ,'int'     ,0,'IDLE = 0,FIRST = 1,RUN = 2,MOD = 3,WAIT_FOR_MOD = 4,STOP = 5'} ...
                 ,{'x_vec'                 , 1,'m'      ,'double'     ,1,''} ...
                 ,{'y_vec'                 , 1,'m'      ,'double'     ,1,''} ...
                 ,{'theta_vec'             , 1,'rad'    ,'double'     ,1,''} ...
                 ,{'kappa_vec'             , 1,'1/m'      ,'double'     ,1,''} ...
                 ,{'vel_vec'               , 1,'m/s'      ,'double'     ,1,''} ...
                 ,{'acc_vec'               , 1,'m/s/s'    ,'double'     ,1,''} ...
                 ,{'timestamp_vec'         , 1,'�s'       ,'double'     ,1,''} ...
                 ,{'angle_pupu'            , 1,'rad'      ,'double'     ,1,''} ...
                 ,{'x_pupu'                , 1,'m'        ,'double'     ,1,''} ...
                 ,{'y_pupu'                , 1,'m'        ,'double'     ,1,''} ...
                 ,{'error_no'              , 1,'num'      ,'int'     ,0,''} ...
                 ,{'warning_no'            , 1,'num'      ,'int'     ,0,''} ...
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