function e = cg_read_ecal_channel_GpsRawData(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'latitude'    , 1,'deg'     ,'double'     ,0,''} ...
                 ,{'longitude'   , 1,'deg'     ,'double'     ,0,''} ...     
                 ,{'heading' , 1,'deg'     ,'double'     ,0,''} ...  
                 ,{'speed'    , 1,'m/s'     ,'double'     ,0,''} ...
                 ,{'altitude'    , 1,'m'     ,'double'     ,0,''} ...
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