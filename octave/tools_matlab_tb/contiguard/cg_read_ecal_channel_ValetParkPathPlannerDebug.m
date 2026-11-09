function e = cg_read_ecal_channel_ValetParkPathPlannerDebug(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'process_time_ms'       , 1,'ms'  ,'double'    ,0,''} ...
                 ,{'loop_time_ms'          , 1,'ms' ,'double'    ,0,''} ...
                 ,{'flag_map_new'          , 1,'-'  ,'integer'    ,0,''} ...
                 ,{'xmap_vec'              , 1,'m'  ,'double'    ,0,'xpoints of a corse'} ...
                 ,{'ymap_vec'              , 1,'m'  ,'double'    ,0,'ypoints of a corse'} ...
                 ,{'smap_vec'              , 1,'m'  ,'double'    ,0,'spoints of a corse'} ...
                 ,{'yawmap_vec'            , 1,'rad'  ,'double'    ,0,'yaw angle of a corse'} ...
                 ,{'xmap_l_vec'              , 1,'m'  ,'double'    ,0,'xpoints of a corse left'} ...
                 ,{'ymap_l_vec'              , 1,'m'  ,'double'    ,0,'ypoints of a corse left'} ...
                 ,{'xmap_r_vec'              , 1,'m'  ,'double'    ,0,'xpoints of a corse right'} ...
                 ,{'ymap_r_vec'              , 1,'m'  ,'double'    ,0,'ypoints of a corse right'} ...
                 ,{'flag_path_new'          , 1,'-'  ,'integer'    ,0,''} ...
                 ,{'xpath_vec'             , 1,'m'  ,'double'    ,0,'xpoints of a path'} ...
                 ,{'ypath_vec'             , 1,'m'  ,'double'    ,0,'ypoints of a path'} ...
                 ,{'yyawpath_vec'          , 1,'rad'  ,'double'    ,0,'yaw angle of a path'} ...
                 ,{'xspline_vec'             , 1,'m'  ,'double'    ,0,'xpoints of a spline'} ...
                 ,{'yspline_vec'             , 1,'m'  ,'double'    ,0,'ypoints of a spline'} ...
                 ,{'change_counter'        , 1,'-'  ,'integer'    ,0,''} ...
                 ,{'change_type'           , 1,'enum' ,'integer'    ,0,'0:NO,1:NEW_FIRST,2:NEW_NEW_ROAD,3:MOD_MINDIST,4:MOD_END_SPLINE,5:MOD_END_SPLINE_CURVE,6:MOD_NEW_NO_CONTROL,7:MOD_NEW_START_TO_FAR_AWAY'} ...
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