function e = cg_read_ecal_channel_RoadModelInterfacePb(d,channel_name)

  ii = str_find_f(channel_name,'Pb');
  if( ii > 0 )
    name_channel = channel_name(1:max(1,ii-1));
  else
    name_channel = channel_name;
  end
  
  e    = struct([]);

  ndata = length(d.data);
  
  % Timestamp & Current Distance
  timestamp = zeros(ndata,1);
  current_distance = zeros(ndata,1);
  for j=1:ndata
    timestamp(j) = d.data{j}.header.timestamp;
    current_distance(j) = d.data{j}.current_distance;
  end
  if( isfield(d,'timestamps') )
    time = double(d.timestamps)*1.0e-6;
  else
    time = double(timestamp)*1.0e-6;
  end
  
  e = e_data_add_value(e,[name_channel,'_timestamp'],'us','time stamp',time,timestamp,0);
  e = e_data_add_value(e,[name_channel,'_current_distance'],'m','current distance of vehicle in RM',time,current_distance,0);
  
  % Extract left and right lane marking data of own lane
  RM_ego_lane_right_marker_x       = {};
  RM_ego_lane_right_marker_y       = {};
  RM_ego_lane_right_marker_curv    = {};
  RM_ego_lane_right_marker_dist    = {};

  RM_ego_lane_left_marker_x        = {};
  RM_ego_lane_left_marker_y        = {};
  RM_ego_lane_left_marker_curv     = {};
  RM_ego_lane_left_marker_dist     = {};   
  for k = 1:ndata
    RM_current_road_id(k) = d.data{k}.current_road_id;
    RM_current_lane_id(k) = d.data{k}.current_lane_id;
    
    % go through all roads
    if isfield(d.data{k},'roads')
        for roadIter = 1:length(d.data{k}.roads)
            % go through all lanes
            if isfield(d.data{k}.roads{roadIter},'lanes')
                for laneIter = 1:length(d.data{k}.roads{roadIter}.lanes)
                    if (d.data{k}.roads{roadIter}.lanes{laneIter}.road_ids(1) ~= RM_current_road_id(k))
                        continue;
                    end

                    if (d.data{k}.roads{roadIter}.lanes{laneIter}.lane_ids(1) ~= RM_current_lane_id(k))
                        continue;
                    end

                    if (length(d.data{k}.roads{roadIter}.lane_marks) > laneIter)
                        RM_ego_lane_right_marker_x{k}       = d.data{k}.roads{roadIter}.lane_marks{laneIter}.pos_x;
                        RM_ego_lane_right_marker_y{k}       = d.data{k}.roads{roadIter}.lane_marks{laneIter}.pos_y;
                        RM_ego_lane_right_marker_curv{k}    = d.data{k}.roads{roadIter}.lane_marks{laneIter}.curv;
                        RM_ego_lane_right_marker_dist{k}    = d.data{k}.roads{roadIter}.lane_marks{laneIter}.dist;

                        RM_ego_lane_left_marker_x{k}        = d.data{k}.roads{roadIter}.lane_marks{laneIter+1}.pos_x;
                        RM_ego_lane_left_marker_y{k}        = d.data{k}.roads{roadIter}.lane_marks{laneIter+1}.pos_y;
                        RM_ego_lane_left_marker_curv{k}     = d.data{k}.roads{roadIter}.lane_marks{laneIter+1}.curv;
                        RM_ego_lane_left_marker_dist{k}     = d.data{k}.roads{roadIter}.lane_marks{laneIter+1}.dist;
                    end
                end
            else
                RM_ego_lane_right_marker_x{k}       = NaN;
                RM_ego_lane_right_marker_y{k}       = NaN;
                RM_ego_lane_right_marker_curv{k}    = NaN;
                RM_ego_lane_right_marker_dist{k}    = NaN;

                RM_ego_lane_left_marker_x{k}        = NaN;
                RM_ego_lane_left_marker_y{k}        = NaN;
                RM_ego_lane_left_marker_curv{k}     = NaN;
                RM_ego_lane_left_marker_dist{k}     = NaN;   
            end
        end
    else
                RM_ego_lane_right_marker_x{k}       = NaN;
                RM_ego_lane_right_marker_y{k}       = NaN;
                RM_ego_lane_right_marker_curv{k}    = NaN;
                RM_ego_lane_right_marker_dist{k}    = NaN;

                RM_ego_lane_left_marker_x{k}        = NaN;
                RM_ego_lane_left_marker_y{k}        = NaN;
                RM_ego_lane_left_marker_curv{k}     = NaN;
                RM_ego_lane_left_marker_dist{k}     = NaN;
    end
  end
  
    % save vectors to e structure
    e = e_data_add_value(e,[name_channel,'_ego_lane_right_marker_x']...
                                        ,'m'...
                                        ,'x location of right ego lane markers'...
                                        ,time...
                                        ,RM_ego_lane_right_marker_x...
                                        ,1);
                                    
    e = e_data_add_value(e,[name_channel,'_ego_lane_right_marker_y']...
                                        ,'m'...
                                        ,'y location of right ego lane markers'...
                                        ,time...
                                        ,RM_ego_lane_right_marker_y...
                                        ,1);
  
     e = e_data_add_value(e,[name_channel,'_ego_lane_right_marker_curv']...
                                        ,'1/m'...
                                        ,'curvature at right ego lane marker nodes'...
                                        ,time...
                                        ,RM_ego_lane_right_marker_curv...
                                        ,1); 
    
     e = e_data_add_value(e,[name_channel,'_ego_lane_right_marker_dist']...
                                        ,'m'...
                                        ,'distance along right ego lane markers'...
                                        ,time...
                                        ,RM_ego_lane_right_marker_dist...
                                        ,1); 

    e = e_data_add_value(e,[name_channel,'_ego_lane_left_marker_x']...
                                        ,'m'...
                                        ,'x location of left ego lane markers'...
                                        ,time...
                                        ,RM_ego_lane_left_marker_x...
                                        ,1);
                                    
    e = e_data_add_value(e,[name_channel,'_ego_lane_left_marker_y']...
                                        ,'m'...
                                        ,'y location of left ego lane markers'...
                                        ,time...
                                        ,RM_ego_lane_left_marker_y...
                                        ,1);
  
     e = e_data_add_value(e,[name_channel,'_ego_lane_left_marker_curv']...
                                        ,'1/m'...
                                        ,'curvature at left ego lane marker nodes'...
                                        ,time...
                                        ,RM_ego_lane_left_marker_curv...
                                        ,1); 
    
     e = e_data_add_value(e,[name_channel,'_ego_lane_left_marker_dist']...
                                        ,'m'...
                                        ,'distance along left ego lane markers'...
                                        ,time...
                                        ,RM_ego_lane_left_marker_dist...
                                        ,1); 
end
