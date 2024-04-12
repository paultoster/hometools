function e = cg_read_ecal_channel_MotionControlwxWaveControl(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'statemachine_state'    , 1,'-'     ,'int'     ,0,'0: IS, 8:PR '} ...
                 };                 

  e    = struct([]);
  
  [e,time] = cg_read_ecal_channel_read_timestamp(e,d,name_channel);
  
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);

  
end