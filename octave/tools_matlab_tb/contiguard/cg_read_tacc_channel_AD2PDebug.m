function eout = cg_read_tacc_channel_AD2PDebug(e,channel_name,use_old_names)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);
  e = e_data_rename_signal(e,[channel_name,'_header_timestamp'],[channel_name,'_timestamp']);
if( use_old_names )
  e = e_data_rename_signal(e,[channel_name,'_kappa_traj'],[channel_name,'__kappaTraj']);
  e = e_data_rename_signal(e,[channel_name,'_kappa_traj_raw'],[channel_name,'_kappaTrajRaw']);
  e = e_data_rename_signal(e,[channel_name,'_run_time'],[channel_name,'_runTime']);
  e = e_data_rename_signal(e,[channel_name,'_run_time_max_lately'],[channel_name,'_runTimeMaxLately']);
  e = e_data_rename_signal(e,[channel_name,'_x_ego'],[channel_name,'_xEgo']);
  e = e_data_rename_signal(e,[channel_name,'_x_ego_fa_cor'],[channel_name,'_xEgoFACor']);
  e = e_data_rename_signal(e,[channel_name,'_x_ego_ra_cor'],[channel_name,'_xEgoRACor']);
  e = e_data_rename_signal(e,[channel_name,'_x_traj'],[channel_name,'_xTraj']);
  e = e_data_rename_signal(e,[channel_name,'_x_traj_raw'],[channel_name,'_xTrajRaw']);
  e = e_data_rename_signal(e,[channel_name,'_y_ego'],[channel_name,'_yEgo']);
  e = e_data_rename_signal(e,[channel_name,'_y_ego_fa_cor'],[channel_name,'_yEgoFACor']);
  e = e_data_rename_signal(e,[channel_name,'_y_ego_ra_cor'],[channel_name,'_yEgoRACor']);
  e = e_data_rename_signal(e,[channel_name,'_y_traj'],[channel_name,'_yTraj']);
  e = e_data_rename_signal(e,[channel_name,'_y_traj_raw'],[channel_name,'_yTrajRaw']);
  e = e_data_rename_signal(e,[channel_name,'_index_act'],[channel_name,'_indexAct']);
  e = e_data_rename_signal(e,[channel_name,'_d_path_act'],[channel_name,'_dPathAct']);

end
% Channels zuordnen
%            AD2PDebug_kappaTraj: [1x1 struct]
%         AD2PDebug_kappaTrajRaw: [1x1 struct]
%              AD2PDebug_runTime: [1x1 struct]
%     AD2PDebug_runTimeMaxLately: [1x1 struct]
%            AD2PDebug_timestamp: [1x1 struct]
%                 AD2PDebug_xEgo: [1x1 struct]
%            AD2PDebug_xEgoFACor: [1x1 struct]
%            AD2PDebug_xEgoRACor: [1x1 struct]
%                AD2PDebug_xTraj: [1x1 struct]
%             AD2PDebug_xTrajRaw: [1x1 struct]
%                 AD2PDebug_yEgo: [1x1 struct]
%            AD2PDebug_yEgoFACor: [1x1 struct]
%            AD2PDebug_yEgoRACor: [1x1 struct]
%                AD2PDebug_yTraj: [1x1 struct]
%             AD2PDebug_yTrajRaw: [1x1 struct]
%               AD2PDebug_yawEgo: [1x1 struct]
%            AD2PDebug_yawEgoCor: [1x1 struct]
%              AD2PDebug_yawTraj: [1x1 struct]
%           AD2PDebug_yawTrajRaw: [1x1 struct]

  for i=1:n
    
    switch(c_names{i})
      case {[channel_name,'_kappaTraj'] ...
           ,[channel_name,'_kappa_traj'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '1/m';
       eout.(c_names{i}).comment  = 'kappa Trajectory';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_kappaTrajRaw'] ...
           ,[channel_name,'_kappa_traj_raw'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '1/m';
       eout.(c_names{i}).comment  = 'kappa Trajectory raw';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_runTime'] ...
           ,[channel_name,'_run_time'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'ms';
       eout.(c_names{i}).comment  = 'run time';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_runTimeMaxLately'] ...
           ,[channel_name,'_run_time_max_lately'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'ms';
       eout.(c_names{i}).comment  = 'run time last second ';
       eout.(c_names{i}).lin      = 1;
      case 'AD2PDev2PthRequest_timestamp'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment  = 'timestamp';
       eout.(c_names{i}).lin      = 0;
      case {[channel_name,'_xEgo'] ...
           ,[channel_name,'_x_ego'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'x-Position ohne Korrektur';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_yEgo'] ...
           ,[channel_name,'_y_ego'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'y-Position ohne Korrektur';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_xEgoFACor'] ...
           ,[channel_name,'_x_ego_fa_cor'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'x-Position FA mit Korrektur';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_yEgoFACor'] ...
           ,[channel_name,'_y_ego_fa_cor'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'y-Position FA mit Korrektur';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_xEgoRACor'] ...
           ,[channel_name,'_x_ego_ra_cor'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'x-Position RA mit Korrektur';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_yEgoRACor'] ...
           ,[channel_name,'_y_ego_ra_cor'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'y-Position RA mit Korrektur';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_xTraj'] ...
           ,[channel_name,'_x_traj'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'x-Position Trajektorie';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_yTraj'] ...
           ,[channel_name,'_y_traj'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'y-Position Trajektorie';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_xTrajRaw'] ...
           ,[channel_name,'_x_traj_raw'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'x-Position Trajektorie Raw';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_yTrajRaw'] ...
           ,[channel_name,'_y_traj_raw'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'y-Position Trajektorie Raw';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_yawEgo'] ...
           ,[channel_name,'_yaw_ego'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = 'yaw-Angle Ego';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_yawEgoCor'] ...
           ,[channel_name,'_yaw_ego_cor'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = 'yaw-Angle Ego Korrektur';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_yawTraj'] ...
           ,[channel_name,'_yaw_traj'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = 'yaw-Angle Trajektorie';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_yawTrajRaw'] ...
           ,[channel_name,'_yaw_traj_raw'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = 'yaw-Angle Trajektorie Raw';
       eout.(c_names{i}).lin      = 1;
      case {[channel_name,'_indexAct'] ...
           ,[channel_name,'_index_act'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'index actual';
       eout.(c_names{i}).lin      = 0;
      case {[channel_name,'_dPathAct'] ...
           ,[channel_name,'_d_path_act'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'actual portion on path';
       eout.(c_names{i}).lin      = 1;
       
    end
  end
end