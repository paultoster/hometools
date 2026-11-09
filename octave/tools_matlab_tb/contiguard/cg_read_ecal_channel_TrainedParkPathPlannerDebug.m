function e = cg_read_ecal_channel_TrainedParkPathPlannerResponse(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'process_time_ms'       , 1,'ms'  ,'double'    ,0,''} ...
                 ,{'loop_time_ms'          , 1,'ms' ,'double'    ,0,''} ...
                 ,{'xPathRecordRAvec'      , 1,'m'    ,'double',1,''} ...
                 ,{'yPathRecordRAvec'      , 1,'m'    ,'double',1,''} ...
                 ,{'xPathCorrrectRAvec'      , 1,'m'    ,'double',1,''} ...
                 ,{'yPathCorrrectRAvec'      , 1,'m'    ,'double',1,''} ...
                 ,{'xDevErrAct'              , 1,'m'    ,'double',1,''} ...
                 ,{'yDevErrAct'              , 1,'m'    ,'double',1,''} ...
                 ,{'yawDevErrAct'            , 1,'rad'    ,'double',1,''} ...
                 ,{'xDevErrLast'              , 1,'m'    ,'double',1,''} ...
                 ,{'yDevErrLast'              , 1,'m'    ,'double',1,''} ...
                 ,{'yawDevErrLast'            , 1,'rad'    ,'double',1,''} ...
                 };                 
                 
%   optional  pb.Header        header                  =  1;           /// common message header
%   optional  uint32           process_time_ms         =  2;           /// process time in [ms]
%   optional  uint32           loop_time_ms            =  3;           /// loop time in [ms]
%   repeated  double           xPathRecordRAvec        =  4;           /// [m]  xpoints of original path
%   repeated  double           yPathRecordRAvec        =  5;           /// [m]  ypoints of original path
%   repeated  double           xPathCorrrectRAvec      =  6;           /// [m]  xpoints of corrected path
%   repeated  double           yPathCorrrectRAvec      =  7;           /// [m]  ypoints of corrected path
%   optional  double           xDevErrAct              = 8;            /// [m]  x deviation Error actual
%   optional  double           yDevErrAct              = 9;            /// [m]  y deviation Error actual
%   optional  double           yawDevErrAct            = 10;          /// [rad]  yaw deviation Error actual
%   optional  double           xDevErrLast              = 11;            /// [m]  x deviation Error last
%   optional  double           yDevErrLast              = 12;            /// [m]  y deviation Error last
%   optional  double           yawDevErrLast            = 13;          /// [rad]  yaw deviation Error last

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
  
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);

%   for i=1:length(sigliste)
%     ee = cg_read_ecal_channel_signal(sigliste{i},d.data,time,name_channel);
%     e  = merge_struct_f(e,ee);
%   end
  
  e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);
  
end