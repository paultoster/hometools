function e = cg_read_ecal_channel_VehicleDynamicsPb(d)

  name_channel = 'VehicleDynamics';
%                        header.timestamp
%                         v_mps: 8.638889312744141
%                      a_x_mps2: 0.800000011920929
%                      a_y_mps2: -0.079999998211861
%                yaw_rate_radps: -0.015882495790720
%            wheel_speed_rl_mps: 8.620426177978516
%            wheel_speed_rr_mps: 8.604037284851074
%            wheel_speed_fl_mps: 8.685979843139648
%            wheel_speed_fr_mps: 8.636815071105957
%      steering_wheel_angle_rad: -0.073303826153278
%     steering_wheel_rate_radps: 0
%                  selected_car: 11
%                     drive_dir: 1
  sigliste     = {{'v_mps'                     ,1 ,'m/s'     ,'double',1,''} ...
                 ,{'a_x_mps2'                  ,1 ,'m/s/s'   ,'double',1,''} ...
                 ,{'a_y_mps2'                  ,1 ,'m/s/S'   ,'double',1,''} ...
                 ,{'yaw_rate_radps'            ,1 ,'rad/s'   ,'double',1,''} ...
                 ,{'wheel_speed_fl_mps'        ,1 ,'m/s'     ,'double',1,''} ...
                 ,{'wheel_speed_fr_mps'        ,1 ,'m/s'     ,'double',1,''} ...
                 ,{'wheel_speed_rl_mps'        ,1 ,'m/s'     ,'double',1,''} ...
                 ,{'wheel_speed_rr_mps'        ,1 ,'m/s'     ,'double',1,''} ...
                 ,{'steering_wheel_angle_rad'  ,1 ,'rad'     ,'double',1,''} ...
                 ,{'steering_wheel_rate_radps' ,1 ,'rad/s'   ,'double',1,''} ...
                 ,{'selected_car'              ,1 ,'enum'    ,'int'   ,0,''} ...
                 ,{'drive_dir'                 ,1 ,'enum'    ,'int'   ,0,''} ...
                 };
                 
  e    = struct([]);
  
  n    = length(d.data);
  time = zeros(n,1);
  for j=1:n
    time(j) = double(d.data{j}.header.timestamp)*1.0e-6;
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
          for k=1:n
            vec(k) = double(d.data{k}.(cnames{i})(dindex));
          end
        else
          for k=1:n
            vec(k) = round(double(d.data{k}.(cnames{i})(dindex)));
          end
        end
        [tin,vin] = elim_nicht_monoton(time,vec);
        e = e_data_add_value(e,[name_channel,'_',cnames{i}],dunit,dcom,tin,vin,dlin);
      end       
    end
  end

end