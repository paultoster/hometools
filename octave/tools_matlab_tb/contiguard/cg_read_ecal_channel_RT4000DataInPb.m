function e = cg_read_ecal_channel_RT4000DataInPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
  
  sigliste     = {{'lat'              , 1,'deg'   ,'double'    , 1, ''} ...
                 ,{'lon'              , 1,'deg'   ,'double'    , 1, ''} ...
                 ,{'yaw_rate'         , 1,'deg/s' ,'double'    , 1, ''} ...    
                 ,{'roll_rate'        , 1,'deg/s'  ,'double'    , 1, ''} ...    
                 ,{'pitch_rate'       , 1,'deg/s'  ,'double'    , 1, ''} ...
                 ,{'yaw_angle'        , 1,'deg','double'    , 1, ''} ...    
                 ,{'roll_angle'       , 1,'deg'  ,'double'    , 1, ''} ...    
                 ,{'pitch_angle'      , 1,'deg','double'    , 1, ''} ...    
                 ,{'yaw_acc'          , 1,'deg/s/s' ,'double'       , 0, ''} ...    
                 ,{'roll_acc'         , 1,'deg/s/s' ,'double'       , 0, ''} ...    
                 ,{'pitch_acc'        , 1,'deg/s/s' ,'double'       , 0, ''} ...    
                 ,{'side_slip_angle'  , 1,'deg' ,'double'       , 0, ''} ...    
                 ,{'track_angle'      , 1,'deg' ,'double'    , 1, ''} ...    
                 ,{'curvature'        , 1,'1/m'  ,'double'    , 1, ''} ...    
                 ,{'acc_long'       , 1,'m/s/s'  ,'double'    , 1, ''} ...
                 ,{'acc_lat'       , 1,'m/s/s'  ,'double'    , 1, ''} ...
                 ,{'acc_up'       , 1,'m/s/s'  ,'double'    , 1, ''} ...
                 ,{'local_vel_x'       , 1,'m/s'  ,'double'    , 1, ''} ...
                 ,{'local_vel_y'       , 1,'m/s'  ,'double'    , 1, ''} ...
                 ,{'local_angle_yaw'       , 1,'deg'  ,'double'    , 1, ''} ...
                 ,{'local_angle_track'       , 1,'deg'  ,'double'    , 1, ''} ...
                 ,{'local_x'       , 1,'m'  ,'double'    , 1, ''} ...
                 ,{'local_y'       , 1,'m'  ,'double'    , 1, ''} ...
                 ,{'gps_status' , 1,'enum' ,'int'       , 0, ''} ...    
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
  
  cnames = fieldnames(d.data{1});
  
  for i=1:length(cnames)
    for j=1:length(sigliste)
      dname  = sigliste{j}{1};
      dindex = sigliste{j}{2};
      dunit  = sigliste{j}{3};
      dtype  = sigliste{j}{4};
      dlin   = sigliste{j}{5};
      dcom   = sigliste{j}{6};
      
      if( strcmpi(cnames{i},dname) )
        vec = zeros(n,1);
        if( strcmpi(dtype,'double') )
          for j=1:n
            vec(j) = double(d.data{j}.(cnames{i})(dindex));
          end
        else
          for j=1:n
            vec(j) = round(double(d.data{j}.(cnames{i})(dindex)));
          end
        end
        [tin,vin] = elim_nicht_monoton(time,vec);
        e = e_data_add_value(e,[name_channel,'_',cnames{i}],dunit,dcom,tin,vin,dlin);
      end       
    end
  end
  
  e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);


end