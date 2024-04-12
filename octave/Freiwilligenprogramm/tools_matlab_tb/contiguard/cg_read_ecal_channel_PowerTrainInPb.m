function e = cg_read_ecal_channel_PowerTrainInPb(d)

  name_channel = 'PowerTrainIn';
  sigliste     = {{'signals.engine_speed'      , 1,'U/min'  ,'double'    , 1, 'Motordrehzahl'} ...
                 ,{'signals.engine_torque'     , 1,'Nm'     ,'double'    , 1, 'Motormoment'} ...
                 ,{'signals.fuel_consumption'  , 1,'l/h'    ,'double'    , 1, ''} ...
                 ,{'signals.gas_pedal_pos'     , 1,'%'      ,'double'    , 1, ''} ...
                 ,{'signals.gas_pedal_pos_grad', 1,'%/s'    ,'double'    , 1, ''} ...
                 ,{'signals.gear'              , 1,'enum'   ,'int'       , 1, '0:N,1:R,2:P,3:D,4:D1,5:D2,6:D3,7:D4'} ...                
                 };
                
%   e    = struct([]);
%   
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
  
  e    = struct([]);
  
  [e,time] = cg_read_ecal_channel_read_timestamp(e,d,name_channel);

% %  time = double(d.timestamps)*1.0e-6;
%   
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
%           for jj=1:n
%             vec(jj) = double(d.data{jj}.signals.(cnames{i})(dindex));
%           end
%         else
%           for jj=1:n
%             vec(jj) = round(double(d.data{jj}.signals.(cnames{i})(dindex)));
%           end
%         end
%         [tin,vin] = elim_nicht_monoton(time,vec);
%         e = e_data_add_value(e,[name_channel,'_signals_',cnames{i}],dunit,dcom,tin,vin,dlin);
%       end       
%     end
%   end
%   
  e = cg_read_ecal_channel_read_signals(e,name_channel,time,d,sigliste);

end