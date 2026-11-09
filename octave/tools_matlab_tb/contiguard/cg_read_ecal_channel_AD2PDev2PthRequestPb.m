function e = cg_read_ecal_channel_AD2PDev2PthRequestPb(d,name_channel)

 sigliste     = {{'active'                   , 1,'enum'     ,'int'    , 1, ''} ...
                ,{'lateral_control_priority' , 1,'enum'     ,'int'    , 1, ''} ...
                ,{'lateral_control_quality'  , 1,'enum'     ,'int'    , 1, ''} ...
                ,{'yaw_angle_deviation_psi'  , 1,'rad'      ,'double' , 1, ''} ...
                ,{'lateral_deviation_y'      , 1,'m'        ,'double' , 1, ''} ...
                ,{'pilot_control_c0'         , 1,'1/m'      ,'double' , 1, ''} ...
                ,{'header_timestamp'         , 1,'us'       ,'double' , 1, ''} ...
                ,{'ramp_out_request'         , 1,'enum'     ,'int'    , 1, ''} ...
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
    e = e_data_add_value(e,[name_channel,'_timestamp'],'us','tiem stamp',time,timestamp,0);
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
          for jj=1:n
            vec(jj) = double(d.data{jj}.(cnames{i})(dindex));
          end
        else
          for jj=1:n
            vec(jj) = round(double(d.data{jj}.(cnames{i})(dindex)));
          end
        end
        [tin,vin] = elim_nicht_monoton(time,vec);
        e = e_data_add_value(e,[name_channel,'_',cnames{i}],dunit,dcom,tin,vin,dlin);
      end       
    end
  end
  
  e = e_data_rename_signal(e,[name_channel,'_header_timestamp'],[name_channel,'_timestamp']);


end