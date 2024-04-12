function eout = cg_read_tacc_channel_VehiclePose(e,channel_name,use_old_names)

  e = e_data_rename_signal(e,[channel_name,'_header_timestamp'],[channel_name,'_timestamp']);
%               VehiclePosePb_external_src_info: [1x1 struct]
%                VehiclePosePb_header_timestamp: [1x1 struct]
%         VehiclePosePb_header_timestamp_source: [1x1 struct]
%     VehiclePosePb_header_timestamp_sync_state: [1x1 struct]
%                   VehiclePosePb_motion_status: [1x1 struct]
%                      VehiclePosePb_pos_status: [1x1 struct]
%                             VehiclePosePb_s_m: [1x1 struct]
%             VehiclePosePb_sigma_slip_angle_ra: [1x1 struct]
%                         VehiclePosePb_sigma_x: [1x1 struct]
%                         VehiclePosePb_sigma_y: [1x1 struct]
%                 VehiclePosePb_sigma_yaw_angle: [1x1 struct]
%                   VehiclePosePb_slip_angle_ra: [1x1 struct]
%                       VehiclePosePb_track_rad: [1x1 struct]
%                         VehiclePosePb_x_cog_m: [1x1 struct]
%                             VehiclePosePb_x_m: [1x1 struct]
%                          VehiclePosePb_x_ra_m: [1x1 struct]
%                         VehiclePosePb_y_cog_m: [1x1 struct]
%                             VehiclePosePb_y_m: [1x1 struct]
%                          VehiclePosePb_y_ra_m: [1x1 struct]
%                         VehiclePosePb_yaw_rad: [1x1 struct]

if( use_old_names )
  e = e_data_rename_signal(e,[channel_name,'_x_cog_m'],[channel_name,'_xCOG_m']);
  e = e_data_rename_signal(e,[channel_name,'_y_cog_m'],[channel_name,'_yCOG_m']);
  e = e_data_rename_signal(e,[channel_name,'_x_ra_m'],[channel_name,'_xRA_m']);
  e = e_data_rename_signal(e,[channel_name,'_y_ra_m'],[channel_name,'_yRA_m']);
  e = e_data_rename_signal(e,[channel_name,'_motion_status'],[channel_name,'_motionStatus']);
  eout = [];
end 
  c_names = fieldnames(e);
  n       = length(c_names);
% Channels zuordnen
%                   VehiclePose_mVersionNo: [1x1 struct]
%                    VehiclePose_timestamp: [1x1 struct]
%                          VehiclePose_x_m: [1x1 struct]
%                          VehiclePose_y_m: [1x1 struct]
%                      VehiclePose_yaw_rad: [1x1 struct]

  for i=1:n
    
    switch(c_names{i})
      
      case {[channel_name,'_x_m'],[channel_name,'_y_m'],[channel_name,'_xCOG_m'],[channel_name,'_xRA_m'],[channel_name,'_yCOG_m'],[channel_name,'_yRA_m']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case {[channel_name,'_x_m'],[channel_name,'_y_m'],[channel_name,'_x_cog_m'],[channel_name,'_x_ra_m'],[channel_name,'_y_cog_m'],[channel_name,'_y_ra_m'],[channel_name,'_s_m']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case [channel_name,'_yaw_rad']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
%       case [channel_name,'_mVersionNo']
%        [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
%        eout.(c_names{i}).time = tin;
%        eout.(c_names{i}).vec  = vin;
%        eout.(c_names{i}).unit = '-';
%        eout.(c_names{i}).comment = '';
%        eout.(c_names{i}).lin     = 0;
      case {[channel_name,'_timestamp'],[channel_name,'_header_timestamp']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
      case {[channel_name,'_motionStatus'],[channel_name,'_motion_status']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '-';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
    end
  end
end