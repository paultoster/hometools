function e = cg_read_ecal_channel_VehiclePosePb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
  sigliste     = {{'x_m'            , 1,'m'     ,'double',1,''} ...
                 ,{'y_m'            , 1,'m'     ,'double',1,''} ...
                 ,{'x_ra_m'         , 1,'m'     ,'double',1,''} ...
                 ,{'y_ra_m'         , 1,'m'     ,'double',1,''} ...
                 ,{'x_cog_m'        , 1,'m'     ,'double',1,''} ...
                 ,{'y_cog_m'        , 1,'m'     ,'double',1,''} ...
                 ,{'yaw_rad'        , 1,'rad'   ,'double',1,''} ...
                 ,{'slip_angle_ra'  , 1,'rad'   ,'double',1,''} ...
                 ,{'motion_status'  , 1,'enum'  ,'int'   ,0,'0:EMS_standstill,1:EMS_forwards,2:EMS_backwards,3:EMS_invalid'} ...
                 ,{'odoResetCounter', 1,'enum'  ,'int'   ,0,''} ...                 
                 ,{'yawAngleCorrection', 1,'deg'  ,'double'   ,0,''} ...                 
                 ,{'correct_cc'     , 1,'enum'  ,'int'   ,0,''} ...                 
                 ,{'dx_correct_m'   , 1,'m'     ,'double',1,''} ...
                 ,{'dy_correct_m'   , 1,'m'     ,'double',1,''} ...
                 ,{'dyaw_correct_rad', 1,'rad'     ,'double',1,''} ...
                 ,{'pos_status'      , 1,'enum'     ,'int',0,''} ...               
                 ,{'s_m'             , 1,'m'     ,'double',1,''} ...
                 };
                 
%                  header: [1x1 struct]
%                     x_m: 9.138123145081461e+02
%                     y_m: -5.508884514697104e+02
%                  x_ra_m: 9.116008999764259e+02
%                  y_ra_m: -5.493185502725337e+02
%                 x_cog_m: 9.128240274829083e+02
%                 y_cog_m: -5.501868584568128e+02
%                 yaw_rad: -0.617344822108180
%           slip_angle_ra: 7.923510775588877e-04
%                 sigma_x: 0
%                 sigma_y: 0
%     sigma_slip_angle_ra: 1
%         sigma_yaw_angle: 0
%               track_rad: 0
%           motion_status: 1

  e    = struct([]);
  
%   n    = length(d.data);
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
%  time = double(d.timestamps)*1.0e-6;
  
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
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);
end