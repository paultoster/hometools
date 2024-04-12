function [data,okay,mess_dir] = convert_ecal_meas(save_flag,mess_path,channel_list)
%
% [data,okay] = convert_ecal_meas;
% [data,okay] = convert_ecal_meas(save_flag);
% [data,okay] = convert_ecal_meas(save_flag,mess_path);
% [data,okay] = convert_ecal_meas(save_flag,mess_path,channel_list);
% [data,okay] = convert_ecal_meas(save_flag,'',channel_list);
%
% save_flag    0: don't save, 1: save in measspath
% mess_path    path with measurement
% channel_list cell array with channel-List
% data         measurement-structure if more measurements => last
%              measurement
% okay         =1 if okay
% mess_dir     last mesurement path

  okay = 1;

  if( ~exist('save_flag','var') )
    save_flag = 0;
  end
  if( ~exist('mess_path','var') )
    mess_path = '';
  else
    if( ~exist(mess_path,'dir') )
      mess_path = '';
    end
  end
  
  if( ~exist('channel_list','var') )
    channel_list = {};
  elseif(  ~iscell(channel_list) )
    error('channel_list is not cell_array');
  end
 
  
  if( qlast_exist(1) )
    start_dir      = qlast_get(1);
  else
    start_dir      = pwd;
  end
  
  
  % Path auswählen
  %---------------
  if( isempty(mess_path) )
    s_frage.comment   = 'Pfad mit den ecal-Messungen auswählen';
    s_frage.start_dir = start_dir;
    [okay,c_dirname] = o_abfragen_dir_f(s_frage);
    if( ~okay )
      fprintf('ecal-Messungen konnte nicht geladen werden !!!!\n');
      return
    end
    mess_path = c_dirname{1};
  end
  
  
  
  [ecaldirs] = get_ecal_files(mess_path);
  
  for i=1:length(ecaldirs)
    
    if( isempty(channel_list) )
    
      channels  = eCAL.measurement.getChannels(ecaldirs{i});
    else
      channels = channel_list;
    end
     
     qlast_set(1,ecaldirs{i});
     mess_dir  = ecaldirs{i};
     mess_name = get_last_name_from_dir(ecaldirs{i});
     meas_dir  = ecaldirs{i};
        
     data      = eCAL.measurement.getData(meas_dir, channels);
  
     if( save_flag )
      save_file = fullfile(ecaldirs{i},[mess_name,'_ecal.mat']);
    
      save(save_file,'data','-v6');
     end
          
  end
end