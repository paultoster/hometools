function e = convert_to_VehDsrdTraj1(e)

  % Trajektorie in Standard-Namen kopieren
  % VehDsrdTraj1,VehDsrdTraj2,VehDsrdTraj3 ...
  %        Name,                 index (für Simulation)
  liste = {{'PlannerVehDsrdTraj'    , 2} ...
          ,{'LCCVehDsrdTraj'        , 6} ...
          ,{'PeopleMoverVehDsrdTraj', 5} ...
          ,{'HAPSVehDsrdTraj'       , 4} ...
          ,{'TPVehDsrdTraj'         , 7} ...
          ,{'GPVehDsrdTraj'         , 8} ...
          };
  icount = 0;
  cnames = fieldnames(e);
  for i = 1:length(liste)
    ifound  = cell_find_f(cnames,liste{i}{1},'n');
    if( ~isempty(ifound) )
      icount = icount + 1;
      nameout = sprintf('VehDsrdTraj%i',icount);
      e = copy_VehDsrdTraj_estruct(e,liste{i}{1},nameout,liste{i}{2});
      fprintf('\nTrajektorie: %s => %s\n',liste{i}{1},nameout);
    end
  end
  
  if(  isfield(e,'VehDsrdTraj1_speed_v') && isfield(e,'VehDsrdTraj1_valid') ...
    && isfield(e,'VehDsrdTraj1_point_x') && isfield(e,'VehDsrdTraj1_point_y') ...
    && isfield(e,'VehiclePose_x_m') && isfield(e,'VehiclePose_y_m')  && isfield(e,'VehiclePose_yaw_rad') )  
  
    time = e.VehDsrdTraj1_speed_v.time;
    Velvec  = time *0.0;
    for i=1:length(time)
      t0    = time(i);
      index = such_index(e.VehDsrdTraj1_valid.time,t0);
      % Path is valid == 1
      if( e.VehDsrdTraj1_valid.vec(index) > 0.5 )
        index = such_index(e.VehDsrdTraj1_point_x.time,t0);
        xvec = e.VehDsrdTraj1_point_x.vec{index};
        yvec = e.VehDsrdTraj1_point_y.vec{index};
        vvec = e.VehDsrdTraj1_speed_v.vec{index};
        nvec = min(length(xvec),length(yvec));
        nvec = min(nvec,length(vvec));
        
        if( nvec > 1 )
          index = such_index(e.VehiclePose_x_m.time,t0);
          [~,~,dPath,~,iact] = vek_2d_intersection(xvec,yvec ...
                                                         ,e.VehiclePose_x_m.vec(index) ...
                                                         ,e.VehiclePose_y_m.vec(index) ...
                                                         ,e.VehiclePose_yaw_rad.vec(index) ...
                                                         ,1,1);
          Velvec(i) = vvec(iact) + (vvec(iact+1)-vvec(iact))*  dPath;                                    
        end
      end
    end
    e = e_data_add_value(e,'VehDsrdTraj1_vrequest_curr_pos' ...
                          ,e.VehDsrdTraj1_speed_v.unit ...
                          ,'V-Request at VehPose' ...
                          ,time ...
                          ,Velvec,1);
    
  end


end