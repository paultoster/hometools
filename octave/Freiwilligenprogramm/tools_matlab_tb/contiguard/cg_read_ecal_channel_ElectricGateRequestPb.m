function e = cg_read_ecal_channel_ElectricGateRequestPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'gate1_entrance'      , 1,'enum'   ,'int'     ,1,'0:INVALID,1:NO_REQUEST,2:TOGGLE_GATE'} ...
                 ,{'gate2_exit'          , 1,'enum'   ,'int'     ,1,'0:INVALID,1:NO_REQUEST,2:TOGGLE_GATE'} ...
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