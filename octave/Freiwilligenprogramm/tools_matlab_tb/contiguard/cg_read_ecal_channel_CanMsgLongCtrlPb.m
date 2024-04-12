function e = cg_read_ecal_channel_CanMsgLongCtrlPb(d,name_channel)

  
  sigliste     = {{'a_req'            , 1,'m/s/s','double'    , 1, ''} ...
                 ,{'max_acc_set_speed', 1,'km/h' ,'double'    , 1, ''} ...    
                 ,{'distance_to_stop' , 1,'m'    ,'double'    , 1, ''} ...    
                 ,{'brk_press_req'    , 1,'bar'  ,'double'    , 1, ''} ...
                 ,{'v_req'            , 1,'km/h'  ,'double'    , 1, ''} ...                 
                 ,{'a_req_type'            , 1,'enum' ,'int'       , 0, 'Acceleration request type; 0: OFF, 1: deceleration ramp out, 2: deceleration request, 3: acceleration request, 4:friction limit'} ...    
                 ,{'v_req_type'            , 1,'enum' ,'int'       , 0, 'Velocity request type; 0: OFF, 1: ACC setspeed request (tacho speed), 2: trajectory speed including v_req_ahead (tacho speed)'} ...    
                 ,{'brk_press_req_activ'   , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'distance_to_stop_valid', 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'gear_req'              , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'park_req'              , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'switch_acc_off'        , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'switch_acc_on'         , 1,'enum' ,'int'       , 0, ''} ...  
                 ,{'gas_pdl_dem_pos'       , 1,'-'    ,'double'    , 1, ''} ... 
                 ,{'v_req_ahead'           , 1,'km/h'    ,'double'    , 1, ''} ... 
                 };
                
  e    = struct([]);
  
  n         = length(d.data);
  if( isfield(d.data{1},'header') )
    timestamp = zeros(n,1);
    for j=1:n
      timestamp(j) = d.data{j}.header.timestamp;
    end
  end
  
  if( isfield(d,'timestamps') )
    time = double(d.timestamps)*1.0e-6;
  elseif( exist('timestamp','var') )
    time = double(timestamp)*1.0e-6;
  else
    error('%_err: time is not available',mfilename)
  end
  
  if( exist('timestamp','var') )
    e = e_data_add_value(e,[name_channel,'_timestamp'],'us','time stamp',time,timestamp,0);
  end

  
%  time = double(d.timestamps)*1.0e-6;
  for i=1:length(sigliste)
    ee = cg_read_ecal_channel_signal(sigliste{i},d.data,time,name_channel);
    e  = merge_struct_f(e,ee);
  end
  
  e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);


end