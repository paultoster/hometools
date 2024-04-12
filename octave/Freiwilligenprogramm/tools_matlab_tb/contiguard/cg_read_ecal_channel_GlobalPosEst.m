function e = cg_read_ecal_channel_GlobalPosEst(d,name_channel)

  
  sigliste     = {{'mTimestamp'       , 1,'µs'   ,'double'     , 1, 'global timestamp epoch'} ...    
                 ,{'mode'             , 1,'enum' ,'int'        , 0, 'mode: 0:UNDEF, 1:GPS_ONLY, 2:VEHICLE_MODEL, 3:DGPS 4:RTK_FLOAT, 5:RTK_INT'} ...    
                 ,{'mLat'             , 1,'deg'   ,'double'    , 1, ''} ...
                 ,{'mLon'             , 1,'deg'   ,'double'    , 1, ''} ...
                 ,{'mCourse'          , 1,'deg'   ,'double'    , 1, ''} ...    
                 ,{'mCourseValid'     , 1,'num'   ,'int'       , 0, 'valid/invalid'} ...    
                 ,{'mX'               , 1,'m'  ,'double'       , 1, ''} ...
                 ,{'mY'               , 1,'m'  ,'double'       , 1, ''} ...
                 ,{'mVelocity'        , 1,'m/s'  ,'double'     , 1, ''} ...
                 ,{'mYawrate'         , 1,'rad/s' ,'double'    , 1, ''} ...    
                 ,{'mAccLong'         , 1,'m/s/s'  ,'double'   , 1, ''} ...
                 ,{'mAltitudeOld'     , 1,'m/s/s'  ,'double'   , 1, ''} ...
                 ,{'altitude'         , 1,'m'  ,'double'       , 1, ''} ...
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
%     e = e_data_add_value(e,[name_channel,'_timestamp'],'us','time stamp',time,timestamp,0);
%   end

  [e,time] = cg_read_ecal_channel_read_timestamp(e,d,name_channel);
  

  
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);
  
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
%           for j=1:n
%             vec(j) = double(d.data{j}.(cnames{i})(dindex));
%           end
%         else
%           for j=1:n
%             vec(j) = round(double(d.data{j}.(cnames{i})(dindex)));
%           end
%         end
%         [tin,vin] = elim_nicht_monoton(time,vec);
%         e = e_data_add_value(e,[name_channel,'_',cnames{i}],dunit,dcom,tin,vin,dlin);
%       end       
%     end
%   end
  
  e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);


end