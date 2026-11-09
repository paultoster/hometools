function   name_new = tacc_cosn(name_old)
%
% name_new = tacc_cosn(name_old)
%
% tacc convert old signael names
%
  name_new = str_replace_name_if_found(name_old,'*_minLateralWidth','*_min_lateral_width');
  
  
%     e = e_data_rename_signal(e,[channel_name,'_min_lateral_width'],[channel_name,'_minLateralWidth']);
%     e = e_data_rename_signal(e,[channel_name,'_change_counter'],[channel_name,'_changeCounter']);
%     e = e_data_rename_signal(e,[channel_name,'_curr_pos_idx'],[channel_name,'_currPosIdx']);
%     e = e_data_rename_signal(e,[channel_name,'_lateral_control_quality'],[channel_name,'_lateralControlQuality']);
%     e = e_data_rename_signal(e,[channel_name,'_lateral_control_priority'],[channel_name,'_lateralControlPriority']);
%     e = e_data_rename_signal(e,[channel_name,'_world_coord'],[channel_name,'_worldCoord']);
%     e = e_data_rename_signal(e,[channel_name,'_point_*'],[channel_name,'_pointFrnt_*']);
%     e = e_data_rename_signal(e,[channel_name,'_p_rear_*'],[channel_name,'_pointRear_*']);   
