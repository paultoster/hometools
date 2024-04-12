function e = cg_read_ecal_channel2(meas_dir,channel_name,time_out_VehDsrdTraj,UnitLinDatei)
%
% e = cg_read_ecal_channel2(ecal_file,channel_name,time_out_VehDsrdTraj)
%
%

  % Da die Signale mit diesen Namen zu lange werden max 63 Zeichen,
  % wird beim Einlesen mit hdf5_read_e(hdf5_file); noch nach den in dieser
  % Liste stehenden NAmen gesucht und geändert (kürzer !)
%   change_name_liste = {{'ParkingSpaceDescriptionCorrected','ParkingSpaceDescrCor'} ...
%                       ,{'ParkingSpaceDescription','ParkingSpaceDescr'} ...
%                       };
  
  e = struct([]);
  
  file_channels = eCAL.measurement.getChannels(meas_dir);
  ich =  cell_find_f(file_channels,channel_name,'f');
    
  if( ~isempty(ich) )
    
    % data =  eCALImportGetData(s_file.dir, {channel_name});
    data =  eCAL.measurement.getData(meas_dir, {channel_name});
    
    [e,basesigname] = cg_read_ecal_get_vector_struct(data.(channel_name),channel_name,UnitLinDatei);
    
    % Nachbearbeitung
    e = cg_read_ecal_channel_build_flagNew(e,basesigname);
    switch(channel_name)
      case {'PlannerVehDsrdTrajPb','AD2PVehDsrdTrajPb','HAPSVehDsrdTrajPb','GPVehDsrdTrajPb','TPVehDsrdTrajPb','VisuVehDsrdTrajPb'} 
        e = e_data_set_time_out(e,time_out_VehDsrdTraj);
    end
  else
    warning('channel: <%s> was not found',channel_name);
  end
  
end

function e = cg_read_ecal_channel_build_flagNew(e,channel_name)

  if( ~isempty(e) )
    c_names = fieldnames(e);
    n       = length(c_names);
    if( isfield(e.(c_names{1}),'leading_time_name') && ~isempty(e.(c_names{1}).leading_time_name) )
      leading_time_name = e.(c_names{1}).leading_time_name;
    else
      leading_time_name = '';
    end

  else 
    c_names = {};
    n       = 0;
  end
  if( n > 0 )
    name = [channel_name,'_flag_new'];
    e.(name).time = double(e.(c_names{1}).time);
    e.(name).vec  = e.(name).time * 0.0 + 1.;
    e.(name).unit = 'enum';
    e.(name).comment = 'new_flag to indicate in d-struct, if channel was send';
    e.(name).lin     = 0;
    if( ~isempty(leading_time_name) )
      e.(name).leading_time_name = leading_time_name;
    end
  end  
end