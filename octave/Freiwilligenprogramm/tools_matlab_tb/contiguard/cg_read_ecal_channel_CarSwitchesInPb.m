function e = cg_read_ecal_channel_CarSwitchesInPb(d)

  name_channel = 'CarSwitchesIn';
  sigliste     = {{'signals.car_id'           , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.cruise_control'   , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.doors'            , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.gear_lever'       , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.hands_off'        , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.lamps'            , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.odometer_total'   , 1,'m'        ,'double' , 1, ''} ...
                 ,{'signals.park_brake_state' , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.temperature_ext'  , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.wiper_front'      , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.wiper_rear'       , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals.status_steering_actuator'       , 1,'enum'     ,'int'    , 0, ''} ...    
                 ,{'signals.status_standstill_management'   , 1,'enum'     ,'int'    , 0, '0: unknown,1:released,2:tempor_hold,3:permanent_hold'} ...                     
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
%   cnames = fieldnames(d.data{1});
%   
%   for i=1:length(cnames)
%     for j=1:length(sigliste)
%       dname  = sigliste{j}{1};
%       dindex = sigliste{j}{2};
%       dunit  = sigliste{j}{3};
%       dtype  = sigliste{j}{4};
%       dlin   = sigliste{j}{5};
%       dcom   = sigliste{j}{6};
%       
%       if( strcmpi(cnames{i},dname) )
%         vec = zeros(n,1);
%         if( strcmpi(dtype,'double') )
%           for jj=1:n
%             vec(jj) = double(d.data{jj}.(cnames{i})(dindex));
%           end
%         else
%           for jj=1:n
%             vec(jj) = round(double(d.data{jj}.(cnames{i})(dindex)));
%           end
%         end
%         [tin,vin] = elim_nicht_monoton(time,vec);
%         e = e_data_add_value(e,[name_channel,'_',cnames{i}],dunit,dcom,tin,vin,dlin);
%       end       
%     end
%   end
  
  e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);


end