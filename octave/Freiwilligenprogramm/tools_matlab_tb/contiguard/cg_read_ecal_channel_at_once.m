function [e,pbdata] = cg_read_ecal_channel_at_once(meas_dir,channel_name_list,time_out_VehDsrdTraj,pbflag)
%
% e = cg_read_ecal_channel(ecal_file,channel_name_list,time_out_VehDsrdTraj)
%
%
%   flagNewReading = 0;
%   [Channels,Headers,nCChanHead]  = cg_read_protobuf_names;

  % Da die Signale mit diesen Namen zu lange werden max 63 Zeichen,
  % wird beim Einlesen mit hdf5_read_e(hdf5_file); noch nach den in dieser
  % Liste stehenden NAmen gesucht und geändert (kürzer !)
%   change_name_liste = {{'ParkingSpaceDescriptionCorrected','ParkingSpaceDescrCor'} ...
%                       ,{'ParkingSpaceDescription','ParkingSpaceDescr'} ...
%                       };
  pbdata = [];
  
  if( ~exist('time_out_VehDsrdTraj','var') )
    time_out_VehDsrdTraj = 0.0;
  end
  if( ~exist('pbflag','var') )
    pbflag = 0;
  end

%   ichannel =  cell_find_f(Channels,channel_name,'f');
  
%   if(  isempty(ichannel) )
%     flagNewReading = 1;
%     % error('%s_error: Der Channel <%s> ist nicht implementiert',mfilename,channel_name);
%   else
%     ichannel = ichannel(1);
%   end
  
  e = struct([]);

  
%   if( strcmp('LongReqParkingPb',channel_name) )
%     a = 0;
%   end

  channel_exist_name_list = cg_get_existing_ecal_channel(meas_dir,channel_name_list);  
  
  if( isempty(channel_exist_name_list) )
    
    warning('No channels found in measurement');
    return;
  end
  
  [n,m] = size(channel_name_list);
  if( m > n )
    channel_exist_name_list = channel_exist_name_list';
  end
  
  fprintf('-> read ECAL-measurement: %s\n',meas_dir);
  tic
  data =  eCAL.measurement.getData(meas_dir, channel_exist_name_list);
  toc
  fprintf('<- end read ECAL-measurement\n');
  
  channel_name_list = fieldnames(data);
  
  
  for i=1:length(channel_name_list)
  
    channel_name = channel_name_list{i};
    
    fprintf('-> ECAL-Channel-%s-lesen\n',channel_name);
    tic
    flag = 0;
    if( cg_exist_ecal_channel(meas_dir,channel_name) )
      flag = 1;
      % data =  eCALImportGetData(s_file.dir, {channel_name});


      if( ~isfield(data.(channel_name),'data') )
        flag = 0;
      end
    end
  
    if( flag  ) 
      
      ee = cg_read_ecal_channel_convert(data.(channel_name),channel_name);

    else
      warning('channel: <%s> was not found or corrupted',channel_name); 
    end

    if( pbflag && flag )
      ii = str_find_f(channel_name,'Pb');
      if( ii > 0 )
        name_channel_wo = channel_name(1:max(1,ii-1));
      else
        name_channel_wo = channel_name;
      end

      ename = fieldnames(ee);
      pbdata.(name_channel_wo).time       = ee.(ename{1}).time;
      pbdata.(name_channel_wo).timestamps = data.(channel_name).timestamps;
      pbdata.(name_channel_wo).data       = data.(channel_name).data;

      fprintf('read pbdata\n');
    end
    
    
    fprintf('signals: %i\n',length(fieldnames(ee)));
    fprintf('<- ECAL-Channel-%s-ende\n',channel_name);
    
    e = merge_struct_f(e,ee); 
    
    data = rmfield(data,channel_name);
    toc
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