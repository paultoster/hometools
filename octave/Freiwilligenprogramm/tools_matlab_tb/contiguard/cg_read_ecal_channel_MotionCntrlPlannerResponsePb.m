function e = cg_read_ecal_channel_MotionCntrlPlannerResponsePb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
  %               name,          index, unit, type, lin, com
  sigliste     = {{'response'  , 1,'enum'  ,'int'   ,0,'0:idle,1:norecord,2:search,3:avail,4:prepare,5:run,6:pause,7:recstart,8:recrun,9:recend,10:goal,11:recabort,12:err,13:savefrict,14:manualfrict,15:runsavestop'} ...
                 ,{'error'  , 1,'enum'  ,'int'   ,0,'o:no,1:vehpose,2:nofrict'} ...
                 ,{'start_pos_state'  , 1,'enum'  ,'int'   ,0,''} ...
                 ,{'start_position.x'  , 1,'m'  ,'double'   ,1,''} ...
                 ,{'start_position.y'  , 1,'m'  ,'double'   ,1,''} ...
                 ,{'start_pos_yaw'  , 1,'rad'  ,'double'   ,1,''} ...
                 ,{'end_pos_state'  , 1,'enum'  ,'int'   ,0,''} ...
                 ,{'end_position.x'  , 1,'m'  ,'double'   ,1,''} ...
                 ,{'end_position.y'  , 1,'m'  ,'double'   ,1,''} ...
                 ,{'end_pos_yaw'  , 1,'rad'  ,'double'   ,1,''} ...
                 ,{'traj_slot_vector'  , 1,'enum'  ,'int'   ,0,''} ...
                 ,{'traj_loaded_index'  , 1,'enum'  ,'int'   ,0,''} ...                
                 ,{'resume_state'       , 1,'enum'  ,'int'   ,0,'0:TPL_NO_RESUME,1:TPL_RESUME_IN_TRAJ_DIR,2:TPL_RESUME_AG_TRAJ_DIR'} ...                
                 ,{'mpc_enabled'  , 1,'enum'  ,'int'   ,0,''} ...                
                 };
                 
  e    = struct([]);
  
  [e,time] = cg_read_ecal_channel_read_timestamp(e,d,name_channel);
  
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);
end