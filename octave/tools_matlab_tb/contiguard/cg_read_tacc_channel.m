function e = cg_read_tacc_channel(taskdir,channel_name,maxvec,time_out_VehDsrdTraj,taccconv_dir,use_old_names)
%
% e = read_tacc_channel(taskdir,channel_name,maxvec,time_out_VehDsrdTraj)
%
% Reads with TaccConv.exe the named channel. TaccConv must be installed
%
% taskdir      char        full directory of tacc-measurement
% channel_name char        channel name to get
% [maxvec]       int       count of measure points from Vektor to store
%                          see TaccConv.exe
% time_out_VehDsrdTraj  s  timeout for VehDsrdTraj set in e-structure
% taccconv_dir             Verzeichnis von TaccConv
%
  if( ~exist('time_out_VehDsrdTraj','var') )
    time_out_VehDsrdTraj = -1;
  end
  
  [Channels,Headers,nCChanHead]  = cg_read_protobuf_names;     

  % Da die Signale mit diesen Namen zu lange werden max 63 Zeichen,
  % wird beim Einlesen mit hdf5_read_e(hdf5_file); noch nach den in dieser
  % Liste stehenden NAmen gesucht und geändert (kürzer !)
  change_name_liste = {{'ParkingSpaceDescriptionCorrected','ParkingSpaceDescrCor'} ...
                      ,{'ParkingSpaceDescription','ParkingSpaceDescr'} ...
                      };
  
  ichannel =  cell_find_f(Channels,channel_name,'f');
  
  if(  isempty(ichannel) )
    error('%s_error: Der Channel <%s> ist nicht implementiert',mfilename,channel_name);
  end
  ichannel = ichannel(1);
  
  if( ~exist('maxvec','var') )
    maxvec = 200;
  end
  
  % Channels = {'ESA2VehDsrdTraj' ...

  e = struct([]);
  
  % TaccConv-Verzeichnis
  %---------------------
  taccconvexe = fullfile(taccconv_dir,'TaccConv.exe');
  taccconvexe = ['"',taccconvexe,'"'];


  idx_file  = fullfile(taskdir,[channel_name,'.idx']);
  dat_file  = fullfile(taskdir,[channel_name,'.dat']);
  hdf5_file = fullfile(taskdir,[channel_name,'.hdf5']);

  if( ~strcmp(channel_name,'V2xFusionCheck_1') )
    if( (exist(idx_file,'file') ~= 2) || (exist(dat_file,'file') ~= 2) )
      warning('Der channel:%s konnte nicht im Verzeichnis <%s> gefunden werden',channel_name,taskdir);
      return
    end
  end
  
  if( exist(hdf5_file,'file') == 2 )
    delete(hdf5_file);
  end
  
  % Check taccChannels.txt
  read_tacc_channel_taccChannelstxt(taskdir,Channels{ichannel},Headers{ichannel});
  
  if( maxvec > 0 )
    command  = [taccconvexe ...
               ,' -i "',taskdir,'"' ...
               ,' -o "',hdf5_file,'"' ...
               ,' -q -hdf5 -ch ',channel_name ...
               ,' -maxvec ',num2str(maxvec)];
  else
    command  = [taccconvexe ...
               ,' -i "',taskdir,'"' ...
               ,' -o "',hdf5_file,'"' ...
               ,' -q -hdf5 -ch ',channel_name];
  end  
  % TaccConv 
  [status,result] = dos(command);
  
  if( exist(hdf5_file,'file') ) % okay
    
    e = hdf5_read_e(hdf5_file,change_name_liste);
    
    if( ichannel == 94 )
      a = 0;
    end
    
    if( ichannel == 1 )
      e = cg_read_tacc_channel_DsrdTraj(e,'ESA2VehDsrdTraj',use_old_names);
    elseif( ichannel == 2 )
      e = cg_read_tacc_channel_LaneRecognition(e);
    elseif( ichannel == 3 )
      e = cg_read_tacc_channel_VehiclePose(e,'VehiclePose',use_old_names);
    elseif( ichannel == 4 )
      e = cg_read_tacc_channel_VehicleDynamics(e);
    elseif( ichannel == 5 )
      e = cg_read_tacc_channel_RelevantObjectData(e);
    elseif( ichannel == 6 )
      e = cg_read_tacc_channel_GpsRawData(e);
    elseif( ichannel == 7 )
      e = cg_read_tacc_channel_MFCImage(e);
    elseif( ichannel == 8 )
      e = cg_read_tacc_channel_GenericObjectList(e);
    elseif( ichannel == 9 )
      e = cg_read_tacc_channel_TargetLane(e);
    elseif( (ichannel == 10) )
      e = cg_read_tacc_channel_DsrdTraj(e,'HAPSVehDsrdTraj',use_old_names);
    elseif( ichannel == 11 )
      e = cg_read_tacc_channel_DsrdTraj(e,'PRORETAVehDsrdTraj',use_old_names);
    elseif( ichannel == 12 )
      e = cg_read_tacc_channel_AD2PCurvRequest(e,Channels{ichannel});
    elseif( ichannel == 13 )
      e = cg_read_tacc_channel_ArbiDev2PthRequest(e,Channels{ichannel});
    elseif( ichannel == 14 )
      e = cg_read_tacc_channel_AD2PCurvRequest(e,Channels{ichannel});
    elseif( ichannel == 15 )
      e = cg_read_tacc_channel_AD2PRequest(e,Channels{ichannel});
    elseif( ichannel == 16 )
      e = cg_read_tacc_channel_CanMsgLatCtrl(e);
    elseif( ichannel == 17 )
      e = cg_read_tacc_channel_VehicleDynamicsIn(e,'VehicleDynamicsIn',use_old_names);
    elseif( ichannel == 18 )
      e = cg_read_tacc_channel_PowerTrainIn(e,'PowerTrainIn',use_old_names);
    elseif( ichannel == 19 )
      e = cg_read_tacc_channel_DsrdTraj(e,Channels{ichannel},use_old_names);
    elseif( ichannel == 20 )
      e = cg_read_tacc_channel_CarSwitches(e,'CarSwitchesIn',use_old_names);
    elseif( ichannel == 21 )
      e = cg_read_tacc_channel_DsrdTraj(e,'Test1VehDsrdTraj',use_old_names);
    elseif( ichannel == 22 )
      e = cg_read_tacc_channel_AD2PRequest(e,Channels{ichannel});
    elseif( ichannel == 23 )
      e = cg_read_tacc_channel_Vpu4IQF1(e);
    elseif( ichannel == 24 )
      e = cg_read_tacc_channel_GlobalPosVBox(e);
    elseif( (ichannel == 33) )
      e = cg_read_tacc_channel_DsrdTraj(e,'PlannerVehDsrdTraj',use_old_names);
    elseif( ichannel == 38 )
      e = cg_read_tacc_channel_RT4000DataIn(e);
    elseif( ichannel == 39 )
      e = cg_read_tacc_channel_PoseOffsetCorrect(e,'PoseOffsetCorrect',use_old_names);
    elseif( ichannel == 41 )
      e = cg_read_tacc_channel_DsrdTraj(e,'AD2PVehDsrdTraj',use_old_names);
    elseif( ichannel == 42 )
      e = cg_read_tacc_channel_AD2PDebug(e,'AD2PDebug',use_old_names);
    elseif( ichannel == 43 )
      e = cg_read_tacc_channel_DsrdTraj(e,'TrajectoryRequestFrenet',use_old_names);
    elseif( ichannel == 44 )
      e = cg_read_tacc_channel_DsrdTraj(e,'PeopleMoverVehDsrdTraj',use_old_names);
    elseif( ichannel == 45 )
      e = cg_read_tacc_channel_DsrdTraj(e,'PlannerVehDsrdTrajPb',use_old_names);
    elseif( ichannel == 46 )      
      e = cg_read_tacc_channel_VehicleDynamicsIn(e,'VehicleDynamicsInPb',use_old_names);
    elseif( ichannel == 47 )
      e = cg_read_tacc_channel_PowerTrainIn(e,'PowerTrainInPb',use_old_names);
    elseif( ichannel == 48 )
      e = cg_read_tacc_channel_VehiclePose(e,'VehiclePosePb',use_old_names);
    elseif( ichannel == 49 )
      e = cg_read_tacc_channel_CarSwitches(e,'CarSwitchesInPb',use_old_names);
    elseif( ichannel == 50 )
      e = cg_read_tacc_channel_AD2PDev2PthRequest(e,'AD2PDev2PthRequestPb',use_old_names);
    elseif( (ichannel == 51) )
      e = cg_read_tacc_channel_DsrdTraj(e,'AD2PVehDsrdTrajPb',use_old_names);
    elseif( ichannel == 64 )
      e = cg_read_tacc_channel_CanMsgLongCtrl(e,'CanMsgLongCtrlPb');
    elseif( ichannel == 49 )
      e = cg_read_tacc_channel_CarSwitches(e,'CarSwitchesInPb',use_old_names);
    elseif( (ichannel == 65))
      e = cg_read_tacc_channel_ExtVeloRequest(e,Channels{ichannel},use_old_names);
    elseif( ichannel == 68 )
      e = cg_read_tacc_channel_ADManeuverListMsg(e,Channels{ichannel});
    elseif( ichannel == 70 )
      e = cg_read_tacc_channel_CanMsgLatCtrl(e,Channels{ichannel});
    elseif( ichannel == 74 )
      e = cg_read_tacc_channel_DsrdTraj(e,'TPVehDsrdTrajPb',use_old_names);
    elseif( (ichannel == 79) )
      e = cg_read_tacc_channel_ArbiVRequest(e,Channels{ichannel},use_old_names);
    elseif( ichannel == 82 )
      e = cg_read_tacc_channel_DsrdTraj(e,'GPVehDsrdTrajPb',use_old_names);
    elseif( ichannel == 86 )
      e = cg_read_tacc_channel_AD2PDebug(e,'AD2PDebugPb',use_old_names);    
    elseif( ichannel == 91 )
      e = cg_read_tacc_channel_PoseOffsetCorrect(e,'PoseOffsetCorrectPb',use_old_names);
    elseif( (ichannel == 92) )
      e = cg_read_tacc_channel_DsrdTraj(e,'HAPSVehDsrdTrajPb',use_old_names);
    elseif( (ichannel == 94) )
      e = cg_read_tacc_channel_StrAngRequest(e,Channels{ichannel});
    elseif( (ichannel == 95) )
      e = cg_read_tacc_channel_AD2PDebug(e,Channels{ichannel},use_old_names);
    elseif( ichannel ==  98)
      e = cg_read_tacc_channel_AD2PDev2PthRequest(e,'DrvCtrlDev2PthRequestPb',use_old_names);
    elseif( (ichannel == 103) )
      e = cg_read_tacc_channel_ExtVeloRequest(e,Channels{ichannel},use_old_names);
    else
      e = cg_read_tacc_channel_general(e);
    end
    

    
    e = cg_read_tacc_channel_build_flagNew(e,Channels{ichannel});
    % Für Trajektorien, kürzeres Timeout setzen
    if( (ichannel == 1) || (ichannel == 10) || (ichannel == 11) || (ichannel == 19) || (ichannel == 21) || (ichannel == 33) || (ichannel == 45)  || (ichannel == 51)|| (ichannel == 52)|| (ichannel == 72) )
      e = e_data_set_time_out(e,time_out_VehDsrdTraj);
    end
    % Protobufname zu alten Namen
    ii=str_find_f(Channels{ichannel},'Pb','vs');
    if( ii > 1 )
      e = e_data_rename_signal(e,[Channels{ichannel},'*'],[Channels{ichannel}(1:ii-1),'*']);
    end
  end    
end
function read_tacc_channel_taccChannelstxt(taskdir,channel,header)
%
% Prüft, ob der Channel in taccChannel.txt beschrieben ist

  file_name = fullfile(taskdir,'taccChannels.txt');
  [okay,c_lines,nzeilen ] = read_ascii_file( file_name );
  only_header = 0;
  for i = 1:nzeilen
    
    [c_names,icount] = str_split(c_lines{i},',');
    
    if( strcmpi(c_names{1},channel) && ~strcmpi(c_names{1},'proto')) % gefunden
      
      i1 = str_find_f(c_lines{i},header,'vs');
      if( i1 > 0 )
        return;
      elseif( icount == 3 )
        only_header = 1;
        break;
       else
        error('Bearbeitung taccChannels.txt: Für channel: %s ist ein falscher Header gefunden worden (siehe %s.m, möglicherweise lasche Zuordnung Channels und Header)',channel,header,mfilename)
      end
    end
  end
  
  if( only_header )
    tt = [c_names{1},',',c_names{2},',',c_names{3},',',header];
  else
    tt = [channel,',0.0,0.0,',header];
  end
  c_lines{nzeilen+1} = tt;
  [okay] = addto_ascii_file(file_name,c_lines);
  
end
function e = cg_read_tacc_channel_build_flagNew(e,channel_name)

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
    e.(name).comment = 'NewFlag to indicate in d-struct, if channel was send';
    e.(name).lin     = 0;
    if( ~isempty(leading_time_name) )
      e.(name).leading_time_name = leading_time_name;
    end
  end  
end