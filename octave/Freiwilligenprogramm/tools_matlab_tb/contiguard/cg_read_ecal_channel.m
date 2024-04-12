function [e,pbdata] = cg_read_ecal_channel(meas_dir,channel_name,time_out_VehDsrdTraj,pbflag)
%
% e = cg_read_ecal_channel(ecal_file,channel_name,time_out_VehDsrdTraj)
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

  fprintf('-> ECAL-Channel-%s-lesen\n',channel_name);  
  
%   if( strcmp('LongReqParkingPb',channel_name) )
%     a = 0;
%   end
  flag = 0;
  if( cg_exist_ecal_channel(meas_dir,channel_name) )
    flag = 1;
    % data =  eCALImportGetData(s_file.dir, {channel_name});
    data =  eCAL.measurement.getData(meas_dir, {channel_name});
    
    if( ~isfield(data.(channel_name),'data') )
      flag = 0;
    end
  end
  
  if( flag  ) % okay and old reading
        
    e = cg_read_ecal_channel_convert(data.(channel_name),channel_name);
    
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

    ename = fieldnames(e);
    pbdata.(name_channel_wo).time       = e.(ename{1}).time;
    pbdata.(name_channel_wo).timestamps = data.(channel_name).timestamps;
    pbdata.(name_channel_wo).data       = data.(channel_name).data;
    
    fprintf('read pbdata\n');
  end
  
  fprintf('signals: %i\n',length(fieldnames(e)));
  fprintf('<- ECAL-Channel-%s-ende\n',channel_name);

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