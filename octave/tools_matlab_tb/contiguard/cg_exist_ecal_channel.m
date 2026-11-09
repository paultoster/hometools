function flag = cg_exist_ecal_channel(meas_dir,channel_name)
% 
% flag = cg_exist_ecal_channel(meas_dir,channel_name)
%
  flag = 0;
  file_channels = eCAL.measurement.getChannels(meas_dir);
  if( ~isempty(cell_find_f(file_channels,channel_name,'f')) )
    flag = 1;
  end
end