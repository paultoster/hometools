function e = cg_read_ecal_channel_convert(data,channel_name)

%       ii = str_find_f(channel_name,'Pb');
%       if( ii > 0 )
%         channel_name_out = channel_name(1:max(1,ii-1));
%       else
%         channel_name_out = channel_name;
%       end
      
      switch(channel_name)
        case 'ParkTrackPb'
          e = cg_read_ecal_channel_ParkTrackPb(data,channel_name);
        case 'GenericObjectListPb'
          e = cg_read_ecal_channel_GenericObjectListPb(data,channel_name);
        case {'ValetParkingHandoverZonePb','ParkingHandoverZoneTrainedPb'}
          e = cg_read_ecal_channel_ValetParkingHandoverZonePb(data,channel_name);
        case 'CanMsgLatCtrlPb'
          e = cg_read_ecal_channel_CanMsgLatCtrlPb(data,'CanMsgLatCtrl');
          % e = cg_read_ecal_channel_build_flagNew(e,'CanMsgLatCtrl');
        case 'DrvCtrlStrAngRequestPb'
          e = cg_read_ecal_channel_DrvCtrlStrAngRequestPb(data,'DrvCtrlStrAngRequest');
          % e = cg_read_ecal_channel_build_flagNew(e,'DrvCtrlStrAngRequest');
        case 'CanMsgLongCtrlPb'
          e = cg_read_ecal_channel_CanMsgLongCtrlPb(data,'CanMsgLongCtrl');
          % e = cg_read_ecal_channel_build_flagNew(e,'CanMsgLongCtrl');
        case 'ArbiVRequestPb'
          e = cg_read_ecal_channel_ArbiVRequestPb(data);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'HAPSVRequestPb'
          e = cg_read_ecal_channel_HAPSVRequestPb(data,'HAPSVRequestPb');
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case 'DrvCtrlVRequestPb'
          e = cg_read_ecal_channel_ExtVeloRequestPb(data,'DrvCtrlVRequest');
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'AD2PDev2PthRequestPb' 
          e = cg_read_ecal_channel_AD2PDev2PthRequestPb(data,'AD2PDev2PthRequest');
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'DrvCtrlDev2PthRequestPb' 
          e = cg_read_ecal_channel_AD2PDev2PthRequestPb(data,'DrvCtrlDev2PthRequest');
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'DrvCtrlDebugPb' 
          e = cg_read_ecal_channel_DrvCtrlDebugPb(data,'DrvCtrlDebug');
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'CarSwitchesInPb'
          e = cg_read_ecal_channel_CarSwitchesInPb(data);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'LatCtrlStatPb'        
          e = cg_read_ecal_channel_Default(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'MFCImageRightPb' 
          e = cg_read_ecal_channel_MFCImageRightPb(data);        
        case {'PlannerVehDsrdTrajPb','AD2PVehDsrdTrajPb','HAPSVehDsrdTrajPb','GPVehDsrdTrajPb','TPVehDsrdTrajPb','VisuVehDsrdTrajPb','PeopleMoverVehDsrdTrajPb','VisuMCPathPb'} 
          e = cg_read_ecal_channel_PlannerVehDsrdTrajPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
          e = e_data_set_time_out(e,time_out_VehDsrdTraj);
        case 'PowerTrainInPb'
          e = cg_read_ecal_channel_PowerTrainInPb(data);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case {'VehicleDynamicsInPb','VehicleDynamicsPb','VehicleDynamicsInOemSensorsPb'}
          e = cg_read_ecal_channel_VehicleDynamicsInPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
  %       case 'VehicleDynamicsPb'
  %         e = cg_read_ecal_channel_VehicleDynamicsPb(data);
  %         e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case {'VehiclePosePb','VehiclePoseCorrectedPb','PoseOffsetCorrectPb','EstVehPosePb','VehiclePoseALF','VehiclePoseX','VehiclePoseDGPS'}
          e = cg_read_ecal_channel_VehiclePosePb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'MotionCntrlPlannerRequestPb'
          e = cg_read_ecal_channel_MotionCntrlPlannerRequestPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'MotionCntrlPlannerResponsePb'
          e = cg_read_ecal_channel_MotionCntrlPlannerResponsePb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'TrainParkDebug'
          e = cg_read_ecal_channel_TrainParkDebug(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'ParkTrainedResponsePb'
          e = cg_read_ecal_channel_ParkTrainedResponsePb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'LaneMarkersPb'
          e = cg_read_ecal_channel_LaneMarkersPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case {'RoadModelInterfacePb','RoadModelInterface_SensorBased','RoadModelInterface_MapBased'}
          e = cg_read_ecal_channel_RoadModelInterfacePb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'MapMatchedPos'
          e = cg_read_ecal_channel_MapMatchedPos(data,channel_name);
        case 'MapMostProbablePath'
          e = cg_read_ecal_channel_MapMostProbablePath(data,channel_name);
        case 'LaneModelBaseClothoid'
          e = cg_read_ecal_channel_LaneModelBaseClothoid(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case {'ParkScenarioRequestPb','ParkScenarioRequestFromHAPSPb'}
          e = cg_read_ecal_channel_ParkScenarioRequestPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'ParkScenarioResponseTrainedPb'       
          e = cg_read_ecal_channel_ParkScenarioResponseTrainedPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'ParkScenarioResponseStandardPb'
          e = cg_read_ecal_channel_ParkScenarioResponseStandardPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'TrainParkManagerRequestPb'       
          e = cg_read_ecal_channel_ParkManagerRequestPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'TrainParkManagDebugPb'       
          e = cg_read_ecal_channel_ParkManagDebug(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'TrainParkLearnResponsePb'
          e = cg_read_ecal_channel_TrainParkLearnResponsePb(data,channel_name);
        case 'TrainParkLearnDebugPb'
          e = cg_read_ecal_channel_TrainParkLearnDebugPb(data,channel_name);
        case 'TrainParkLearnPathPb'
          e = cg_read_ecal_channel_TrainParkPathPb(data,channel_name);
        case 'TrainParkPlannerResponsePb'       
          e = cg_read_ecal_channel_ParkPlannerResponsePb(data,channel_name);
        case 'TrainParkPlannerDebugPb'       
          e = cg_read_ecal_channel_ParkPlannerDebugPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case {'TrainParkPathPlannerResponsePb','ValetParkPathPlannerResponsePb'}
          e = cg_read_ecal_channel_TrainedParkPathPlannerResponse(data,channel_name);
        case 'TrainedParkPathPlannerDebugPb'
          e = cg_read_ecal_channel_TrainedParkPathPlannerDebug(data,channel_name);
        case 'ValetParkPathPlannerDebugPb'
          e = cg_read_ecal_channel_ValetParkPathPlannerDebug(data,channel_name);
        case 'HapsSafetyPb'       
          e = cg_read_ecal_channel_HapsSafetyPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case 'RT4000DataInPb'       
          e = cg_read_ecal_channel_RT4000DataInPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'GlobalPosRT4000'       
          e = cg_read_ecal_channel_GlobalPosEst(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'CanCtrlRequestPb'
          e = cg_read_ecal_channel_CanCtrlRequestPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'MotionReqDebugPb'
          e = cg_read_ecal_channel_MotionReqDebugPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case {'RpEcuADCntrlStatusPb','MotionReqADCntrlStatusPb'}
          e = cg_read_ecal_channel_RpEcuADCntrlStatusPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case {'TrajectoryRequestPb','HAPSTrajectoryRequestPb','TPTrajectoryRequestPb','VPTrajectoryRequestPb','PlannerTrajectoryRequestPb'} 
          e = cg_read_ecal_channel_TrajectoryRequestPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
          % e = e_data_set_time_out(e,time_out_VehDsrdTraj);        
        case 'ElectricGateRequestPb'
          e = cg_read_ecal_channel_ElectricGateRequestPb(data,channel_name);    
        case {'TrafficLightListPb','TrafficLightListRMI_Anaylsis','TrafficLightListPb__Analysis'}
          e = cg_read_ecal_channel_TrafficLightListPb(data,channel_name);    
        case 'V2xTlaStateSimple'
          e = cg_read_ecal_channel_C2xTlaStateSimplePb(data,channel_name);    
        case 'CameraArrowListPb'
          e = cg_read_ecal_channel_CamArrowList(data,channel_name);    
        case 'LongReqADPb'
          e = cg_read_ecal_channel_LongReqADPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case 'LongReqParkingPb'
          e = cg_read_ecal_channel_LongReqParkingPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'WheelTicksPb'
          e = cg_read_ecal_channel_WheelTicksInPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'CanSurveillancePb'
          e = cg_read_ecal_channel_CanSurveillancePb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'Version_newRPECU'
          e = cg_read_ecal_channel_Version_newRPECU(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'ExtADMotionRequestPb'
          e = cg_read_ecal_channel_VExtSimulinkADMotionRequest(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case 'ExtCarMakerDMCInterfacePb'
          e = cg_read_ecal_channel_VExtCarMakerDMCInterface(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
        case {'MotionCntrlFriction','MotionCntrlFrictionPb','DetectFrictionPb','SetFrictionPb'}
          e = cg_read_ecal_channel_MotionCntrlFriction(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case 'ManeuverList'
          e = cg_read_ecal_channel_ManeuverList(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case 'GpsRawData'
          e = cg_read_ecal_channel_GpsRawData(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case 'BrakeInPb'
          e = cg_read_ecal_channel_BrakeInPb(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case 'wxWave_state_control_motion_control'
          e = cg_read_ecal_channel_MotionControlwxWaveControl(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        case 'ALF_Debug'
          e = cg_read_ecal_channel_ALF_Debug(data,channel_name);
          % e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);        
        otherwise
          e = cg_read_ecal_channel_Default(data,channel_name);   
          % if( ~isempty(e) )
          %   e = cg_read_ecal_channel_build_flagNew(e,channel_name_out);
          % end
      end
end