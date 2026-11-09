function channel_exist_name_list = cg_get_existing_ecal_channel(meas_dir,channel_name_list)
% 
% channel_exist_name_list = cg_get_existing_ecal_channel(meas_dir,channel_name_list)
%
  channel_exist_name_list = {};
  file_channels = eCAL.measurement.getChannels(meas_dir);
  
  for i=1:length(channel_name_list)
    if( ~isempty(cell_find_f(file_channels,channel_name_list{i},'f')) )
      channel_exist_name_list = cell_add(channel_exist_name_list,channel_name_list{i});
    end
  end
end