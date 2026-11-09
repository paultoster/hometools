function e = cg_read_ecal_channel_RpEcuADCntrlStatusPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'hands_off_detect'      , 1,'num'   ,'int'     ,0,''} ...
                 ,{'hands_torque'          , 1,'Nm'    ,'double'     ,1,''} ...
                 ,{'lat_cntrl_status'      , 1,'enum'  ,'int'     ,0,'0:CNTRL_STAT_UNAVAILABLE,1:CNTRL_STAT_AVAILABLE_INACTIVE,2:CNTRL_STAT_ACTIVE'} ...
                 ,{'long_cntrl_status'     , 1,'enum'  ,'int'     ,0,'0:CNTRL_STAT_UNAVAILABLE,1:CNTRL_STAT_AVAILABLE_INACTIVE,2:CNTRL_STAT_ACTIVE'} ...
                 ,{'tor_ramp_state'        , 1,'enum'  ,'int'     ,0,'0:RAMP_OUT_FINISHED,1:RAMP_IN_IN_PROGRESS,2:RAMP_IN_FINISHED,3:RAMP_OUT_IN_PROGRESS'} ...
                 ,{'lat_int_status'        , 1,'enum'  ,'int'     ,0,'0:INT_STAT_UNAVAILABLE,1:INT_STAT_AVAILABLE,2:INT_STAT_ERROR,3:INT_STAT_SNA'} ...
                 ,{'long_int_status'       , 1,'enum'  ,'int'     ,0,'0:INT_STAT_UNAVAILABLE,1:INT_STAT_AVAILABLE,2:INT_STAT_ERROR,3:INT_STAT_SNA'} ...
                 ,{'maneuvering_finished'  , 1,'enum'  ,'int'     ,0,'0:MF_FALSE,1:MF_TRUE,2:MF_SNA'} ...
                 };                 


  e    = struct([]);
  
  
  
  [e,time] = cg_read_ecal_channel_read_timestamp(e,d,name_channel);
  
   
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);

%   for i=1:length(sigliste)
%     ee = cg_read_ecal_channel_signal(sigliste{i},d.data,time,name_channel);
%     e  = merge_struct_f(e,ee);
%   end
  
  e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);
  
end