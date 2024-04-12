function e = cg_read_ecal_channel_LatCtrlStatPb(d)

  name_channel = 'CarSwitchesIn';
  sigliste     = {{'signals_car_id'           , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals_cruise_control'   , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals_doors'            , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals_gear_lever'       , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals_hands_off'        , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals_lamps'            , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals_odometer_total'   , 1,'m'        ,'double' , 1, ''} ...
                 ,{'signals_park_brake_state' , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals_temperature_ext'  , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals_wiper_front'      , 1,'enum'     ,'int'    , 1, ''} ...
                 ,{'signals_wiper_rear'       , 1,'enum'     ,'int'    , 1, ''} ...
                 };
                
  e    = struct([]);
  
  n         = length(d.data);
  timestamp = zeros(n,1);
  for j=1:n
    timestamp(j) = d.data{j}.header.timestamp;
  end
  time = double(timestamp)*1.0e-6;
  
  e = e_data_add_value(e,[name_channel,'_timestamp'],'us','tiem stamp',time,timestamp,0);
  
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