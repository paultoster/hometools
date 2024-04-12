function e = cg_read_ecal_channel_TrainedParkPathPlannerResponse(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
 
  sigliste     = {{'state'       , 1,'enum'  ,'int'    ,0,'0:idle,1:recording,2:searchpath,3:available,4:run,5:goalreached,6:pause,7:infrontpause,8:handoverpause,9:wppause,10:objectpause,11:stop,12:err'} ...
                 ,{'nmax'        , 1, 'enum' ,'int'    ,0,''} ...
                 ,{'isavailable' , 1, 'enum' ,'int'    ,0,''} ...                 
                 ,{'triggerstate'     , 1,'enum'    ,'int',0,''} ...
                 ,{'send_index'     , 1,'enum'    ,'int',0,''} ...                 
                 ,{'start_pos_state'   , 1,'enum'    ,'int',0,''} ...
                 ,{'start_pos_yaw'     , 1,'rad'  ,'double',1,''} ...
                 ,{'start_position.x'  , 1,'m'    ,'double',1,''} ...
                 ,{'start_position.y'  , 1,'m'    ,'double',1,''} ...
                 ,{'end_pos_state'     , 1,'enum'    ,'int',0,''} ...
                 ,{'end_pos_yaw'       , 1,'rad'  ,'double',1,''} ...
                 ,{'end_position.x'    , 1,'m'    ,'double',1,''} ...
                 ,{'end_position.y'    , 1,'m'    ,'double',1,''} ...
                 ,{'waypoint_next_id'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'waypoint_next_type'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'waypoint_next_id'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'waypoint_next_action'       , 1,'enum'  ,'int'    ,0,''} ...
                 ,{'waypoint_next_position.x'       , 1,'m'  ,'double'    ,1,''} ...
                 ,{'waypoint_next_position.y'       , 1,'m'  ,'double'    ,1,''} ...
                 ,{'stopping_for_dyn_object'             , 1,'enum'    ,'int',0,''} ...
                 ,{'dyn_object'           , 1,'enum'    ,'int',0,''} ...                 
                 ,{'show_dyn_object'           , 1,'enum'    ,'int',0,''} ...                 
                 };                 
%   optional  ResponseState     state               =  2  [default = TPP_IDLE];           /// response state
%   optional  int32             nmax                =  3  [default = 1];                  /// maximum number of possible pathes
%   repeated  bool              isavailable         =  5;                                 /// vector[0:nmax-1] with true/false for available pathes 
%   repeated  bool              isswitchable        =  6;                                 /// vector[0:nmax-1] with true/false for switchable pathes (possiblity to switch to 
%   repeated  TriggerState      triggerstate        =  7;
%   optional  int32             send_index          =  8  [default = -1];                 /// sended index = [0:nmax-1](-1: no send) 
%   optional  PosAvailableState     start_pos_state              =  9  [default = TP_NO_POS_AVAILABLE]; ///       Start Position state
%   optional  float                 start_pos_yaw                =  10  [default = -1.0];                /// [rad] Start Position yawAngle 
%   optional  Point2d               start_position               =  11;                                 ///       Start Position position
%   optional  PosAvailableState     end_pos_state                =  12  [default = TP_NO_POS_AVAILABLE]; ///       End Position state
%   optional  float                 end_pos_yaw                  =  13 [default = -1.0];                /// [rad] End Position yawAngle  
%   optional  Point2d               end_position                 =  14;                                 ///       End Position position
% 
%   
%   optional  uint64                waypoint_next_id             =  15  [default = 0];                   ///       id of next waypoint 0: no stop
%   optional  Point2d               waypoint_next_position       =  16;                                  ///       next waypoint position
%   optional  WaypointType          waypoint_next_type           =  17  [default = TP_WAYPOINT_UNDEF];   ///       type of next waypoint
%   optional  WaypointAction        waypoint_next_action         =  18  [default = TP_WAYPOINT_STOP];    ///       action at next stop
%   optional  WaypointStatus        waypoint_status              =  19  [default = TP_WAY_POINT_NO];     ///       waypoint status
%   
%   optional  bool                  stopping_for_dyn_object      =  20 [default = false];              ///       TP is braking for dynamic object
%   optional  DynObjectType         dyn_object                   =  21 [default = TP_DYN_OBJECT_NO];   ///       Type of object and situatjion
%   optional  bool                  show_dyn_object              =  22 [default = false];             ///       show object type

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