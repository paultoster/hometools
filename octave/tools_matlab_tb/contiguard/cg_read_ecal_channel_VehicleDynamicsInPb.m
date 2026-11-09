function e = cg_read_ecal_channel_VehicleDynamicsInPb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
%                          speed: 14.194444656372070
%                speed_displayed: 15
%                speed_per_wheel: [4x1 double]
%                       long_acc: -1.440000057220459
%                        lat_acc: -1.440000057220459
%                        yawrate: -0.108559474349022
%           steering_wheel_angle: -0.423787742853165
%     steering_wheel_angle_speed: 0
%               drv_steer_torque: 0

  %                name                       ,index,unit,type,lin,comment
%   sigliste     = {{'speed'                     ,1 ,'m/s'     ,'double',1,'vehicle velocity'} ...
%                  ,{'speed_displayed'           ,1 ,'m/s'     ,'double',1,'displayed speed'} ...
%                  ,{'speed_per_wheel_fl'        ,1 ,'m/s'     ,'double',1,'wheel speed FL'} ...
%                  ,{'speed_per_wheel_fr'        ,2 ,'m/s'     ,'double',1,'wheel speed  FR'} ...
%                  ,{'speed_per_wheel_rl'        ,3 ,'m/s'     ,'double',1,'wheel speed  RL'} ...
%                  ,{'speed_per_wheel_rr'        ,4 ,'m/s'     ,'double',1,'wheel speed  RR'} ...
%                  ,{'long_acc'                  ,1 ,'m/s/s'   ,'double',1,'longitudinal acceleration'} ...
%                  ,{'lat_acc'                   ,1 ,'m/s/s'   ,'double',1,'lateral acceleration'} ...
%                  ,{'yawrate'                   ,1 ,'rad/s'   ,'double',1,'Yawrate'} ...
%                  ,{'steering_wheel_angle'      ,1 ,'rad'     ,'double',1,'steering wheel angle'} ...
%                  ,{'steering_wheel_angle_speed',1 ,'rad/s'   ,'double',1,'steering wheel angle speed'} ...
%                  ,{'drv_steer_torque'          ,1 ,'Nm'      ,'double',1,'driver torque'} ...
%                  };
  sigliste     = {{'signals.speed'                     ,1 ,'m/s'     ,'double',1,'vehicle velocity'} ...
                 ,{'signals.speed_displayed'           ,1 ,'m/s'     ,'double',1,'displayed speed'} ...
                 ,{'signals.speed_per_wheel'           ,1 ,'m/s'     ,'double',1,'wheel speed'} ...
                 ,{'signals.long_acc'                  ,1 ,'m/s/s'   ,'double',1,'longitudinal acceleration'} ...
                 ,{'signals.lat_acc'                   ,1 ,'m/s/s'   ,'double',1,'lateral acceleration'} ...
                 ,{'signals.yawrate'                   ,1 ,'rad/s'   ,'double',1,'Yawrate'} ...
                 ,{'signals.steering_wheel_angle'      ,1 ,'rad'     ,'double',1,'steering wheel angle'} ...
                 ,{'signals.steering_wheel_angle_speed',1 ,'rad/s'   ,'double',1,'steering wheel angle speed'} ...
                 };

  e    = struct([]);
  
%   n         = length(d.data);
%   if( isfield(d.data{1},'header') )
%     timestamp = zeros(n,1);
%     for j=1:n
%       timestamp(j) = d.data{j}.header.timestamp;
%     end
%   end
%   
%   if( isfield(d,'timestamps') )
%     time = double(d.timestamps)*1.0e-6;
%   elseif( exist('timestamp','var') )
%     time = double(timestamp)*1.0e-6;
%   else
%     error('%_err: time is not available',mfilename)
%   end
%   
%   if( exist('timestamp','var') )
%     e = e_data_add_value(e,[name_channel,'_timestamp'],'us','tiem stamp',time,timestamp,0);
%   end
  
  [e,time] = cg_read_ecal_channel_read_timestamp(e,d,name_channel);
  
%   cnames = fieldnames(d.data{1}.signals);
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
%           for k=1:n
%             vec(k) = double(d.data{k}.signals.(cnames{i})(dindex));
%           end
%         else
%           for k=1:n
%             vec(k) = round(double(d.data{k}.signals.(cnames{i})(dindex)));
%           end
%         end
%         [tin,vin] = elim_nicht_monoton(time,vec);
%         e = e_data_add_value(e,[name_channel,'_signals_',cnames{i}],dunit,dcom,tin,vin,dlin);
%       end       
%     end
%   end
  
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);
  
  
  e = cg_read_ecal_channel_VehicleDynamicsInPbspeed_per_wheel(e,[name_channel,'_signals_speed_per_wheel']);
   
end
function e = cg_read_ecal_channel_VehicleDynamicsInPbspeed_per_wheel(e,channel_name)

  if( isfield(e,channel_name) )
    n = length(e.(channel_name).time);
    vec_fl = zeros(n,1);
    vec_fr = zeros(n,1);
    vec_rl = zeros(n,1);
    vec_rr = zeros(n,1);
    for i=1:n
      vec = e.(channel_name).vec{i};
      if( length(vec) >= 4 )
        vec_fl(i) = vec(1);
        vec_fr(i) = vec(2);
        vec_rl(i) = vec(3);
        vec_rr(i) = vec(4);
      else
        vec_fl(i) = -1.;
        vec_fr(i) = -1.;
        vec_rl(i) = -1.;
        vec_rr(i) = -1.;
      end        
    end

    e = e_data_add_value(e,[channel_name,'_fl'] ...
                          ,e.(channel_name).unit ...
                          ,[e.(channel_name).comment,' front left'] ...
                          ,e.(channel_name).time ...
                          ,vec_fl ...
                          ,e.(channel_name).lin);
    e = e_data_add_value(e,[channel_name,'_fr'] ...
                          ,e.(channel_name).unit ...
                          ,[e.(channel_name).comment,' front right'] ...
                          ,e.(channel_name).time ...
                          ,vec_fr ...
                          ,e.(channel_name).lin);
    e = e_data_add_value(e,[channel_name,'_rl'] ...
                          ,e.(channel_name).unit ...
                          ,[e.(channel_name).comment,' rear left'] ...
                          ,e.(channel_name).time ...
                          ,vec_rl ...
                          ,e.(channel_name).lin);
    e = e_data_add_value(e,[channel_name,'_rr'] ...
                          ,e.(channel_name).unit ...
                          ,[e.(channel_name).comment,' rear right'] ...
                          ,e.(channel_name).time ...
                          ,vec_rr ...
                          ,e.(channel_name).lin);
    e = e_data_delete_signal(e,channel_name);
  end
end