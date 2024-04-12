function e = cg_read_ecal_channel_LongReqADPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'acc_request_active'    , 1,'enum'    ,'int'        ,0,'0: request not active; 1: request active'} ...
                 ,{'acceleration'          , 1,'m/s/s'  ,'double'     ,1,'Requested acceleration'} ...
                 ,{'gradient'              , 1,'m/s/s/s','double'     ,1,'Requested gradient to reach requested acceleration'} ...
                 ,{'park'                  , 1,'enum'    ,'int'        ,0,'0: Release park brake and driving brake,1: Hold car with applied driving brake as long as request is sent frequently,2: Hold car as long as "release" command is sent (preferably with parking brake),'} ...
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