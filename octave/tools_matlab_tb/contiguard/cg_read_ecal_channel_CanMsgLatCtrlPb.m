function e = cg_read_ecal_channel_CanMsgLatCtrlPb(d,name_channel)

  
  sigliste     = {{'torque_value'     , 1,'Nm'   ,'double'    , 1, ''} ...
                 ,{'angle_value'      , 1,'rad'  ,'double'    , 1, ''} ...
                 ,{'dev_2_pth_y'      , 1,'m'    ,'double'    , 1, ''} ...    
                 ,{'dev_2_pth_psi'    , 1,'rad'  ,'double'    , 1, ''} ...    
                 ,{'dev_2_pth_c0'     , 1,'1/m'  ,'double'    , 1, ''} ...
                 ,{'yaw_rate_value'   , 1,'rad/s','double'    , 1, ''} ...    
                 ,{'c0c1_c0'          , 1,'1/m'  ,'double'    , 1, ''} ...    
                 ,{'c0c1_c1'          , 1,'1/m/m','double'    , 1, ''} ...    
                 ,{'angle_active'     , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'angle_prio'       , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'angle_quality'    , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'c0c1_active'      , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'c0c1_changed'     , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'c0c1_prio'        , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'c0c1_quality'     , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'dev_2_pth_active' , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'dev_2_pth_prio'   , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'dev_2_pth_quality', 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'torque_active'    , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'torque_prio'      , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'torque_ramp_out'  , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'yaw_rate_active'  , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'yaw_rate_prio'    , 1,'enum' ,'int'       , 0, ''} ...    
                 ,{'yaw_rate_quality' , 1,'enum' ,'int'       , 0, ''} ...    
                 };
                
  e    = struct([]);
  
  n         = length(d.data);
  if( isfield(d.data{1},'header') )
    if( isfield(d.data{1}.header,'timestamp') )
      timestamp = zeros(n,1);
      for j=1:n
        timestamp(j) = d.data{j}.header.timestamp;
      end
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