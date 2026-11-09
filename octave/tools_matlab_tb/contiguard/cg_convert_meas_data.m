function [ookay,dd,uu,hh,ee,meas_dir] = cg_convert_meas_data(q)
%
% [okay,d,u,h,e] = cg_convert_meas_data(q)
%
% Liest Canlyser-Daten (*.asc) und Tacc-Messungen
%
% q.read_type      = 1  Verzeichnisse müssen ausgewählt werden
%                       q.start_dir angeben, um
%                       Daten-Verzeichnis auszuwählen
%                       (tacc-Messordner oder Ordner mit
%                       CAN-ascii-Dateien)
%                       (q.start_dir angeben)
%                  = 2  CAN-ascii-Dateien auswählen
%                       (q.start_dir angeben)
%                  = 3  übergeordnetes Verzeichnis zu Einlesen 
%                       angeben q.read_meas_path angeben
%                       (q.read_meas_path angeben)
%                  = 4  Liste mit einzulesenden Messverzeichnissen 
%                       q.read_list = {'dir1',dir2'}oder
%                       explizite Canalyser-Ascii Dateien in
%                       q.read_list = {'datei1.asc','datei2.asc'}
%                       angeben
%                  = 5  Verzeichnis auswählen, mit dem
%                       Namen des  Verzeichnisses wird die
%                       Messung gespeichert
%                       
%
% q.start_dir        (q.read_type = 1,2) Start-Dir zum Suchen 
% q.read_meas_path   (q.read_type = 3) Verzeichnis unter dem alle 
%                                      Messungen gewandelt werden
% q.read_list        (q.read_type = 4) Liste mit Dateien (Canalyser-ascii)
%                                      oder Verzeichnissen
%                    Tacc-Messungen
% q.delta_t          time step to build d.time (default 0.01)
% q.zero_time        0/1 zero time in vector d.time (default 1)
% q.tstart           start time, if to cut measurement q.tstart < 0 has no influence
%                    (default -1.) Kann durch find_limit_by_plot überschrieben werden 
% q.tend             end time, if to cut measurement q.tend < 0 has no influence
%                    (default -1.) Kann durch find_limit_by_plot überschrieben werden
% q.timeout          timeout if no signal is set in timeout, signal in
%                    d-strucure will be set to zero
% q.timeout_destraj  spezieller timeout für DesvehTraj
%
% q.delta_t0         In d-Struktur wird delta_t0 zu Beginn abgeschnitten
% q.delta_t1         In d-Struktur wird delta_t1 am Ende abgeschnitten
%
% q.CANread          0/1 CAN-log files verarbeiten (canlog*.asc bzw. beliebige Namen)
%
% q.CANuse           % Liste z.B. [1,2] mit möglichen Vorgaben:
%                    1: SCG.CAN_TYPE_CONTIGUARD_VPU
%                    2: SCG.CAN_TYPE_FZG_BMW545
%                    3: SCG.CAN_TYPE_FZG_PASSAT
%                    4: SCG.CAN_TYPE_HAF_BMW3_MDJ6385
%                    5: SCG.CAN_TYPE_VBOX3iSL
%                    6: SCG.CAN_TYPE_HAF_BMW3_MDJ6385_TESTCAN
%
% q.CANstruct        Zusätzliche Signalliste mit dbc-File 
%                    q.CANstruct(i).dbcFile     dbc-File mit vollständigem Pfad
%                    q.CANstruct(i).channel     channel in Messung(1,2,3,...=
%                    q.CANstruct(i).mFile       m-File um Signalliste zu generieren mit
%                           Ssig(i).name_in      = 'signal name';
%                           Ssig(i).unit_in      = 'dbc unit';              (default '')
%                           Ssig(i).lin_in       = 0/1;                     (default 0)
%                           Ssig(i).name_sign_in = 'signal name for sign';  (default '')
%                           Ssig(i).name_out     = 'output signal name';    (default name_in)
%                           Ssig(i).unit_out     = 'output unit';           (default 'unit_in')
%                           Ssig(i).comment      = 'description';           (default '')
% 
%                           name_in      is name from dbc, could also be used with two and mor names
%                                        in cell array {'nameold','namenew'}, if their was an change
%                                        in dbc, use for old measurements
%                           unit_in      will used if no unit is in dbc for that input signal
%                           lin_in       =0/1 linearise if to interpolate to a commen time base
%                           name_sign_in if in dbc-File is a particular signal for sign (how VW
%                                        uses) exist
%                           name_out     output name in Matlab
%                           unit_out     output unit
%                           comment      description
%
%                    q.CANstruct(i).messFile       Name des Messfiles (Ist
%                                                  nur relevant,wenn tacc-Message mit mehreren
%                                                  CAN-Messfiles mit Standard-Namen gewandelt werden soll
% q.CANFileNameTACC     char-value bei TACC-Messungen nur diesen CAN-File-NAmen nehmen z.B. {'canlog'}
% q.CANFileNameExclude  cell-array mit auszuschliessende CAN-Filenamen z.B. {'canlog_pc2'}  
%
% q.TACCread         0/1 Tacc-Daten mit TacConv lesen aus Verzeichnis TaskData
%
% q.TaccChannels      cell-array mit Channelnamen z.B. {'VehicleDynamics','ESA2VehDsrdTraj'};
%                     Mögliche Channels:
%   CChanHead = {{'ESA2VehDsrdTraj','CMsgVehicleDesiredTraj'} ...            % 1
%               ,{'LaneRecognition','CMsgLaneRecognition'}    ...            % 2
%               ,{'VehiclePose''CMsgVehiclePose'}             ...            % 3
%               ,{'VehicleDynamics','CMsgVehicleDynamics'}    ...            % 4
%               ,{'RelevantObjectData','CMsgRelevantObjectData'} ...         % 5
%               ,{'GpsRawData','CGps2NetFrameMsg'}       ...                 % 6
%               ,{'MFCImage','CMsgCameraImage'}        ...                   % 7
%               ,{'GenericObjectList','CMsgGenericEnvObjectList'} ...        % 8
%               ,{'TargetLane','CMsgTargetLane'}         ...                 % 9
%               ,{'HAPSVehDsrdTraj','CMsgVehicleDesiredTraj'} ...            % 10
%               ,{'PRORETAVehDsrdTraj','CMsgVehicleDesiredTraj'} ...         % 11
%               ,{'ArbiCurvRequest','CMsgExtCurvRequest'}     ...            % 12
%               ,{'ArbiDev2PthRequest','CMsgArbiDev2PthRequest'} ...         % 13
%               ,{'AD2PCurvRequest','CMsgExtCurvRequest'}     ...            % 14
%               ,{'AD2PRequest','CMsgExtDev2PthRequest'}  ...                % 15
%               ,{'CanMsgLatCtrl','CCanMsgLatCtrl'}         ...              % 16
%               ,{'VehicleDynamicsIn','TVehicleDyn'}            ...          % 17
%               ,{'PowerTrainIn','TPowerTrain'}            ...               % 18
%               ,{'LCCVehDsrdTraj','CMsgVehicleDesiredTraj'} ...             % 19
%               ,{'CarSwitchesIn','TCarSwitches'}          ...               % 20
%               ,{'Test1VehDsrdTraj','CMsgVehicleDesiredTraj'} ...           % 21
%               ,{'AD2PDev2PthRequest','CMsgExtDev2PthRequest'}  ...         % 22 
%               ,{'Vpu4IQF1','CMsgVpu4IQF1'}           ...                   % 23
%               ,{'GlobalPosVBox','CGlobalPosEstMsg'}       ...              % 24
%               ,{'PowerTrain','CMsgPowertrain'}         ...                 % 25
%               ,{'VehicleBehavior','CMsgBehaviorPlanner'}    ...            % 26
%               ,{'EHorizon','CMsgEHorizon'}           ...                   % 27
%               ,{'ParkingSpaceDescription','CMsgParkingSpaceDescription'} ...    % 28
%               ,{'ParkingSpaceDescriptionCorrected','CMsgParkingSpaceDescription'} ... % 29
%               ,{'VehiclePoseCorrected','CMsgVehiclePose'}  ...             % 30
%               ,{'VehiclePoseCorrected_replay','CMsgVehiclePose'}  ...      % 31
%               ,{'PlannerVRequest','CMsgExtVeloRequest'} ...                % 32
%               ,{'PlannerVehDsrdTraj','CMsgVehicleDesiredTraj' } ...        % 33
%               ,{'ArbiARequest','CMsgArbiARequest'} ...                     % 34
%               ,{'ArbiVRequest','CMsgArbiVRequest'} ...                     % 35
%               ,{'ArbiBrkPressRequest','CMsgArbiBrkPressRequest'} ...       % 36
%               ,{'GlobalPosRT4000','CGlobalPosEstMsg'} ...                  % 37
%               ,{'RT4000DataIn','CRT4000DataMsg'} ...                       % 38
%               ,{'PoseOffsetCorrect','CMsgPoseOffsetCorrect'} ...           % 39 
%               ,{'V2xFusionCheck_1','CV2xFusionCheckMsg'} ...               % 40
%               ,{'AD2PVehDsrdTraj','CMsgVehicleDesiredTraj'} ...            % 41
%               ,{'AD2PDebug','CArbiDev2PthDebugMsg'} ...                    % 42
%               ,{'TrajectoryRequestFrenet','CMsgVehicleDesiredTraj'} ...    % 43
%               ,{'PeopleMoverVehDsrdTraj','CMsgVehicleDesiredTraj'} ...     % 44
%               ,{'PlannerVehDsrdTrajPb','pb.ExtRequests.VehicleDesiredTraj'} ... % 45
%               ,{'VehicleDynamicsInPb','pb.SensorNearData.VehicleDynamics'} ...  % 46
%               ,{'PowerTrainInPb','pb.SensorNearData.PowerTrain'} ...       % 47
%               ,{'VehiclePosePb','pb.VehicleMovement.VehiclePose' } ...     % 48
%               ,{'CarSwitchesInPb','pb.SensorNearData.CarSwitches'} ...      % 49
%               ,{'AD2PDev2PthRequestPb','pb.ExtRequests.ExtDev2PthRequest' } ...             % 50
%               ,{'AD2PVehDsrdTrajPb','pb.ExtRequests.VehicleDesiredTraj'} ...                % 51
%               ,{'PeopleMoverVehDsrdTrajPb','pb.ExtRequests.VehicleDesiredTraj'} ...         % 52
%               ,{'GlobalPosRT4000Pb','pb.GlobalPosEst'}  ...                % 53
%               ,{'ADDrivingStrategyPb','pb.Applications.AD.ADDrivingStrategy'} ...           % 54
%               ,{'ADDSARequestPb''pb.ExtRequests.ExtAccelRequest' } ...     % 55
%               ,{'ADDSVRequestPb','pb.ExtRequests.ExtVeloRequest'} ...      % 56
%               ,{'ADModeManager','CMsgADModeManager'} ...                   % 57
%               ,{'ADModeMangerPb',''}                 ...                   % 58
%               ,{'ArbiARequest','pb.Arbitration.ArbiARequest'} ...          % 59
%               ,{'ArbiDrvCtrlRequest','CMsgArbiDriveCtrlRequest'} ...       % 60
%               ,{'ArbiDrvCtrlRequestPb','pb.Arbitration.ArbiDriveCtrlRequest'} ...           % 61
%               ,{'ArbiLngDebugOutputPb','pb.Arbitration.ArbLngDebug'...     % 62
%               ,{'BrakeInPb','pb.SensorNearData.Brake'} ...                 % 63
%               ,{'CanMsgLongCtrl','pb.Arbitration.CanLongCtrl'} ...         % 64
%               ,{'DrvCtrlVRequestPb','pb.ExtRequests.ExtVeloRequest'} ...   % 65
%               ,{'LatCtrlStat','' } ...                                     % 66
%               ,{'LatCtrlStatPb','pb.Arbitration.LatCtrlStat' } ...         % 66
%               ,{'ManeuverList','pb.Applications.AD.ADManeuverListMsg'} ... % 67
%               ,{'SpeedLimitPb','pb.Embedded.SpeedLimit'} ...               % 68
%               };
%
% q.TaccConvDir   directory der Tacc-Conv-exe und dll, wenn nicht
%                 gesetzt, dann wird über DOS-Variable gesetzt taccconv_dos_get
%
% q.TaccUseOldNames   0/1 use old Tac-Channel-Names
%
% q.ECALread         0/1 ecal-Daten zuerst nur protobuf-Channels einlesen
%                    mit eCALImportGetChannels.mexw32 und eCALImportGetData.mexw32
%                    = 2  ecal-read mit neuer Methode, es wird der gesamte
%                    Channel eingelesen und aus einer Datei wird versucht
%                    unit und lin Info zu bekommen
%                    q.ECALUnitLinDatei kann Datei angegeben werden
%                    Datei gefüllt mitz
%                    signalname, unit, lin=1/0
%
% q.ECALChannels      cell-array mit Channelnamen z.B. {'VehicleDynamicsInPb','VehiclePose'};
%                     Mögliche Channels:
%
%   Channels = {'VehicleDynamicsInPb'
%              ,'VehicleDynamicsPb'
%              ,'VehiclePathPb'
%              ,'VehiclePosePb'
%              ,'WheelTicksInPb'
%              };
%
% q.ECALUnitLinDatei    für q.ECALread = 2 wird diese Datei benutzt um Unit
%                       zu bekommen (default ist gesetzt)
% q.ECALStructOutput    =1/0 die von ecal eingelesene Datenstruktur wie im 
%                       hdf-File mit ausgeben
% q.find_limit_by_plot  =1/0 Soll die Messung im d-daten-Struktur per Plot
%                       begrenzt werden (aus e-Daten wird geplotet)
% q.find_limit_sig_name = {'name1','name2',...}
%                       Signalnamenliste für Begrenzung
%
% q.add_estrut = e                    additional e-Structur values to add
%                                     to Measurement, e-struct:
%                                     e.signame.time    Zeitvektor
%                                     e.signame.vec     Vektor oder cellaray
%                                                       mit Vektor zu jedem Zeitpunkt
%                                     e.signame.lin     Linear/constant bei
%                                                       Interpolation
%                                     e.signame.unit    Einheit
%                                     e.signame.comment Kommentar

% q.mod_eDataFkt     string oder cellarray mit eigenem Fuktionsaufruf z.B.
%                    'd:\auswert\mod_my_edata' oder {'d:\auswert\mod_my_edata',...}
%                    Aufruf e = mod_my_edata(e);
%                    Es können neue Daten hinzugefügt werden oder auch
%                    bestehende bearbeitet
%                    e.('signame').time    zeitvektor
%                    e.('signame').vec     Wertevektor
%                    e.('signame').unit    Einheit
%                    e.('signame').comment Kommentar
%                    e.('signame').lin     1 linear interpolieren
%                                         0 konstant interpolieren
% q.mod_dDataCG      0/1 (default 1) 
%                    modify Data mit der fest vorgegebenen Funktion
%                    d = cg_mod_data(d)
% q.mod_dDataFkt     string oder cellarray mit eigenem Fuktionsaufruf z.B.
%                    'd:\auswert\mod_my_ddata' oder {'d:\auswert\mod_my_ddata',...}
%                    Aufruf [d,u,c] = mod_my_ddata(d,u,c);
%                    Es können neue Daten hinzugefügt werden oder auch
%                    bestehende bearbeitet
%                    d.('signame')    Wertevektor (erster ist immer time)
%                    u.('signame')    Einheit
%                    c.('signame')    Kommentar
% [q.save_type]      'no'       keine duh-Format Speicherung
%                    'mat_duh'  duh-Format Matlab (default)
%                    'mat_dspa' dspace-Format Matlab
%                    'dia'      dia-Format
%                    'dia_asc'  dia-ascii-Format
%
% q.wand_Tx_in_Rx  = 1   wandelt Tx-Signale in Rx-Signale (ist aber nicht
%                        weiter notwendig)
%
% q.calc_offset_tacc_can  = 1 merged can mit tacc (oder ecal) mit Fahrzeuggeschw, insbesondere wenn 
%                             unterschiedliche Längen vorhanden sind
% q.calc_offset_tacc_can  = 2 merged can mit tacc (oder ecal) mit Lenkradwinkel, insbesondere wenn 
%                             unterschiedliche Längen vorhanden sind
% q.calc_offset_tacc_can  = 3 merged can mit tacc (oder ecal) mit
%                             vorgegebenem Signal q.calc_offset_tacc_signal
%                             und q.calc_offset_can_signal
%                             
% q.calc_offset_tacc_signal   Signalname zum vergleichen aus tacc (ecal)
% q.calc_offset_can_signal    Signalname zum vergleichen aus can
%
% q.trigger_measure          = 1;     % Messung wird auf einen Wert getriggert und geändert
% q.trigger_signal_name      = 'TStWhlSens';    % z.B. d.TStWhlSens wird verwendet
% q.trigger_vorschrift       = '>>';   % siehe suche_index()
% 	                                   % '>='          Wenn Signal größer gleich wird(default)
%                                      % '>','<','<='  größer/kleiner/kleiner gleich
%                                      % '=='          gleich innerhalb der Toleranz
%                                      % '==='         nächster Index, es wird der Index mit einem Rest bestimmt z.B index=10.3)
%                                      % '===='        (Index mit dem nächsten Wert)
%                                      % '>>'          vektor wird von kleiner zu größer als Wert
%                                      % '<<'          vektor wird größer zu kleiner als Wert
%
% q.trigger_schwelle         = 2.0;       % Schwelle
% q.trigger_vorlauf_zeit     = 0.5;       % Vorlaufzeit zum abschneiden
%
%
% q.cut_measurement_by_time            0/1             Soll die Messung in
%                                                      zeitlich in mehrere Messungen aufgeteilt werden
% q.cut_measurement_time                num  [s]       Zeit, in die
%                                                      aufgeteilt werden
%                                                      soll. Wird aber nur
%                                                      für d-DatenStruktur
%                                                      gemacht
% q.wand_new                          0
%                                     1                nur neue ecal/tacc-Channel-Daten einlsen
%                                     2                nur Messung wandeln, wenn kein name_e.mat File besteht
%                                     
%      
% q.write_signal_description          0/1              schreibt description
%                                                      in excel
% Ausgabe:
%
% Die letzte gewandelte Datei wird zurückgegeben
%
% d       Datenstruktur äquidistant fängt mit Zeitvektor (Spaltenvektor) an
%         z.B. d.time = [0;0.01;0.02; ... ]
%              d.F    = [1;1.05;1.10; ... ]
%              ...
% u       Unitstruktur mit Unitnamen
%         u.time = 's'
%         u.F    = 'N'
%         ...
% h       Header-Cellarray mit Kommentaren
%         h{1}  hat die Beschreibung aus description.txt, wenn vorhanden
%         h{2}  Struktur c mit beschreibungen, wenn vorgegeben
%               z.B. c.time = 'Zeitvektor' ...
%

  
  okay = 1;
     
  d    = [];
  u    = [];
  e    = [];
  h    = {};
  meas_dir = '';
 
  %########################################################################
  % proof input of structure q
  %########################################################################
  %----------
  %----------
  % read_type
  %----------
  if( ~isfield(q,'read_type') )
    q.read_type = 1;
  end
  if( q.read_type < 0 ),q.read_type = 1;end
  if( q.read_type > 6 ),q.read_type = 6;end
  
  %-------------------------------------
  % read_type == 1 (Abfrage),q.start_dir,q.read_meath_path,q.read_list
  %-------------------------------------
  if( (q.read_type == 1) || (q.read_type == 2) )
    if( ~isfield(q,'start_dir') )
      q.start_dir = pwd;
    else
      if( ~exist(q.start_dir,'dir') )
        q.start_dir = 'D:\:';
      end
    end
  %--------------------------------------------
  % read_type == 3 (Messpfad),q.read_meath_path
  %--------------------------------------------
  elseif( q.read_type == 3 )
    
    if( ~isfield(q,'read_meas_path') )
      error('cg_convert_meas_data: read_meas_path muss angegeben sein (q.read_type = 3)')
    elseif( ~exist(q.read_meas_path,'dir') )
      error('cg_convert_meas_data: Verzeichnis <%s> falsch',q.read_meas_path)
    end
  %--------------------------------------------
  % read_type == 4 (Liste),q.read_list
  %--------------------------------------------
  elseif( q.read_type == 4 )
    
    if( ~isfield(q,'read_list') )
      error('cg_convert_meas_data: read_list muss angegeben sein (q.read_type = 4)')
    elseif( ~iscell(q.read_list) )
      error('cg_convert_meas_data: read_list muss ein cell array sein (q.read_type = 4)')
    else
      for i=1:length(q.read_list)
        if( ~exist(q.read_list{i},'file') && ~exist(q.read_list{i},'dir') )
          error('cg_convert_meas_data: Verzeichnis/File q.read_list{%i}=''%s'' nicht gefunden',q.read_list{i})
        end
      end
    end
  end
  
  %-----------------------------------------------------
  % time
  %-----------------------------------------------------
  % q.delta_t          time step to build d.time
  if( ~isfield(q,'delta_t') )
    q.delta_t = 0.01;
  end
  % q.zero_time        0/1 zero time in vector d.time 
  if( ~isfield(q,'zero_time') )
    q.zero_time = 1;
  end
  % q.tstart           start time, if to cut measurement q.tstart < 0 has no influence
  %                    (default -1.)
  if( ~isfield(q,'tstart') )
    q.tstart = -1;
  end
  % q.tend             end time, if to cut measurement q.tend < 0 has no influence
  %                    (default -1.)
  if( ~isfield(q,'tend') )
    q.tend = -1;
  end
% q.timeout          timeout if no signal is set in timeout, signal in
%                    d-strucure will be set to zero
  if( ~isfield(q,'timeout') )
    q.timeout = -1;
  end 
  if( ~isfield(q,'timeout_destraj') )
    q.timeout_destraj = 0.01;
  end 
% q.delta_t0         In d-Struktur wird delta_t0 zu Beginn abgeschnitten
% q.delta_t1         In d-Struktur wird delta_t1 am Ende abgeschnitten
  if( ~isfield(q,'delta_t0') )
    q.delta_t0 = -1;
  end
  if( ~isfield(q,'delta_t1') )
    q.delta_t1 = -1;
  end

  %-----------------------------------------------------
  % CAN-Messung
  %-----------------------------------------------------
  if( ~isfield(q,'CANread') )
    q.CANread = 0;
  end
  
  if( q.CANread )
    
    if( ~isfield(q,'CANstruct') )
      q.CANstruct = [];
    end
    if( ~isfield(q,'CANuse') )
      q.CANuse = [];
    end
   
    s  = [];
    ns = 0;
    
    for i=1:length(q.CANuse)
      
      ii = q.CANuse(i);
      if( ii > length(SCG.CANSTRUCT) )
        error('q.CANuse(%i) = %i ist ein zugroßer Wert',i,ii);
      end
      ns = ns + 1;
      s(ns).channel = SCG.CANSTRUCT(ii).channel;
      s(ns).dbcFile = SCG.CANSTRUCT(ii).dbcFile;
      s(ns).mFile   = SCG.CANSTRUCT(ii).mFile;
      if( isfield(SCG.CANSTRUCT,'Ssig') && ~isempty(SCG.CANSTRUCT(ii).Ssig) )
        s(ns).Ssig = SCG.CANSTRUCT(ii).Ssig;
      else
        s(ns).Ssig = [];
      end
    end
    %
    % eigene CAN-Signalliste bearbeiten
    if( ~isempty(q.CANstruct) )
      if( ~isfield(q.CANstruct,'dbcFile') )
        error('In q.CANstruct fehlt q.CANstruct(i).dbcFile ; Das dbc-File');
      elseif( ~isfield(q.CANstruct,'channel') )
        error('In q.CANstruct fehlt q.CANstruct(i).channel ; Der Kanal (1,2,..)');
%       elseif(~isfield(q.CANstruct,'Ssig') )
%         error('In q.CANstruct fehlt q.CANstruct(i).Ssig ; Struktur mit gesuchten Signalen');
      end
      
      for i=1:length(q.CANstruct)
        ns = ns + 1;
        s(ns).dbcFile = q.CANstruct(i).dbcFile;
        s(ns).channel = q.CANstruct(i).channel;
        s(ns).mFile   = q.CANstruct(i).mFile;
        if( check_val_in_struct(q.CANstruct(i),'messFile','char',1) )
          s(ns).messFile   = q.CANstruct(i).messFile;
        else
          s(ns).messFile   = '';
        end
      end
    end 
    % reste CANstruct
    q.CANstruct  = s;
    q.n_CANstruct = ns;
  else
    q.n_CANstruct = 0;
  end

  if( ~isfield(q,'wand_Tx_in_Rx') )
    q.wand_Tx_in_Rx = 0;
  end
  
  if( ~check_val_in_struct(q,'CANFileNameExclude','cell') )
    q.CANFileNameExclude = {};
  end
  if( ~check_val_in_struct(q,'CANFileNameTACC','char') )
    q.CANFileNameTACC = '';
  else
    s_file = str_get_pfe_f(q.CANFileNameTACC);
    q.CANFileNameTACC = s_file.name;
  end
  % Proof Names
  for i= 1:length(q.CANFileNameExclude)
    
    s_file = str_get_pfe_f(q.CANFileNameExclude{i});
    q.CANFileNameExclude{i} = s_file.name;
  end
  %-----------------------------------------------------
  % TACC-Messung
  %-----------------------------------------------------
  if( ~isfield(q,'TACCread') )
    q.TACCread = 0;
  end
  if( ~isfield(q,'TaccChannels') )
    q.TaccChannels = {};                     %    channel-Namen
  else      
    q.TaccChannels = cell_reduce_double_elements(q.TaccChannels);
  end

  
  if( q.TACCread )
    if( ~isfield(q,'TaccConvDir') )
      q.TaccConvDir = taccconv_dos_get;
    end
    
    if( ~isfield(q,'TaccUseOldNames') )
      q.TaccUseOldNames = 1;
    end

    if( ~exist(q.TaccConvDir,'dir') )
      echo('%s: Das TaccConv-Verzeichnis q.TaccConvDir=''%s'' konnte nicht gefunden werden',q.TaccConvDir);
    else
      fprintf('q.TaccConvDir = ''%s''\n',q.TaccConvDir);
    end
  end
  
  if( ~check_val_in_struct(q,'calc_offset_tacc_can','num',1) )
    q.calc_offset_tacc_can = 0;
  end
  
  if( q.calc_offset_tacc_can == 3 )
    if( ~check_val_in_struct(q,'calc_offset_tacc_signal','char') )
      q.calc_offset_tacc_signal = 'VehicleDynamicsIn_signals_speed';
    end
    if( ~check_val_in_struct(q,'calc_offset_can_signal','char') )
      q.calc_offset_can_signal = 'PrivCAN_VehSpd';
    end
  end    

  %-----------------------------------------------------
  % ECAL-Messung
  %-----------------------------------------------------
  if( ~isfield(q,'ECALread') )
    q.ECALread = 0;
  end
  if( ~isfield(q,'ECALChannels') )
    q.ECALChannels = {};                     %    channel-Namen
  else
    q.ECALChannels = cell_reduce_double_elements(q.ECALChannels);
  end
  
  if( ~isfield(q,'ECALUnitLinDatei') )
    q.ECALUnitLinDatei = 'cg_e_struct_units_lin.dat';
  end
  
  if( ~isfield(q,'ECALStructOutput') )
    q.ECALStructOutput = 0;                     %    channel-Namen
  end
  
  
  if( ~isfield(q,'ECALReadChannelsAtOnce') )
    q.ECALReadChannelsAtOnce = 0;               %    Read ecal channels at once
  end
  
  
  if( q.ECALread )   
    q.TACCread = 0;
  end
  
  %-----------------------------------------------------
  % data-Modifikation
  %-----------------------------------------------------

  % find limits in e-data
  %----------------------
  if( ~isfield(q,'find_limit_by_plot') )
    q.find_limit_by_plot = 0;
  end
  if( q.find_limit_by_plot )
    if( ~isfield(q,'find_limit_sig_name') )
      q.find_limit_sig_name = {};
    end
  end
  
  % add e-data
  %------------
  if( ~isfield(q,'add_estruct') )
    q.add_estruct = [];
  else
    [okay,q.add_estruct] = e_data_check(q.add_estruct);
    if( ~okay )
      error('Error_%s: q.add_estruct is not correct', mfilename );
    end
  end
  
  

  % modify e-data
  %--------------
  if( ~isfield(q,'mod_eDataFkt') )
    q.mod_eDataFkt = '';
  end
  
  if( ischar(q.mod_eDataFkt) )    
    q.mod_eDataFkt = {q.mod_eDataFkt};
  elseif( ~iscell(q.mod_eDataFkt) )
    error('q.mod_eDataFkt muss char oder cellarray sein')
  end
  
  
  q.eFkt   = [];
  q.n_eFkt = 0;
  for i = 1:length(q.mod_eDataFkt)
    if( ~isempty(q.mod_eDataFkt{i}) ) 
      s = str_get_pfe_f(q.mod_eDataFkt{i});
      q.n_eFkt = q.n_eFkt + 1;
      q.eFkt(q.n_eFkt).name = s.name;
      q.eFkt(q.n_eFkt).dir  = s.dir;
            
      if( ~exist(q.eFkt(q.n_eFkt).dir,'dir') )
        error('Das Verzeichnis <%s> aus q.mod_eDataFkt{%i} exisistiert nicht !', ...
        q.eFkt(q.n_eFkt).dir,q.n_eFkt);
      end
    end
  end
     
  % standard modify d-data
  %--------------
  if( ~isfield(q,'mod_dDataCG') )
    q.mod_dDataCG = 1;
  end
  
  % modify d-data
  %--------------
  if( ~isfield(q,'mod_dDataFkt') )
    q.mod_dDataFkt = '';
  end
  
  if( ischar(q.mod_dDataFkt) )    
    q.mod_dDataFkt = {q.mod_dDataFkt};
  elseif( ~iscell(q.mod_dDataFkt) )
    error('q.mod_dDataFkt muss char oder cellarray sein')
  end
  
  q.dFkt   = [];
  q.n_dFkt = 0;
  for i = 1:length(q.mod_dDataFkt)
    if( ~isempty(q.mod_dDataFkt{i}) ) 
      s = str_get_pfe_f(q.mod_dDataFkt{i});
      q.n_dFkt = q.n_dFkt + 1;
      q.dFkt(q.n_dFkt).name = s.name;
      q.dFkt(q.n_dFkt).dir  = s.dir;
      
      if( ~exist(q.dFkt(q.n_dFkt).dir,'dir') )
        error('Das Verzeichnis <%s> aus q.mod_dDataFkt{%i} exisistiert nicht !', ...
          q.dFkt(q.n_dFkt).dir,q.n_dFkt);
      end
    end
  end
  
  
  % modify d-data
  %--------------
  if( ~isfield(q,'save_type') )
    q.save_type = 'mat_duh';
  end
  
  if(  ~strcmp(q.save_type,'mat_duh') ...
    && ~strcmp(q.save_type,'mat_dspa') ...
    && ~strcmp(q.save_type,'dia') ...
    && ~strcmp(q.save_type,'dia_asc') ...
    && ~strcmp(q.save_type,'no') ...
    )
    error('DAtenformat <%s> zum Speichern nicht gültig !',q.save_type);
  end
  
  % trigger measurement
  %--------------------
% q.trigger_measure          = 1;     % Messung wird auf einen Wert getriggert und geändert
% q.trigger_signal_name      = 'TStWhlSens';    % z.B. d.TStWhlSens wird verwendet
% q.trigger_vorschrift       = '>>';   % siehe suche_index()
% 	                                   % '>='          Wenn Signal größer gleich wird(default)
%                                      % '>','<','<='  größer/kleiner/kleiner gleich
%                                      % '=='          gleich innerhalb der Toleranz
%                                      % '==='         nächster Index, es wird der Index mit einem Rest bestimmt z.B index=10.3)
%                                      % '===='        (Index mit dem nächsten Wert)
%                                      % '>>'          vektor wird von kleiner zu größer als Wert
%                                      % '<<'          vektor wird größer zu kleiner als Wert
%
% q.trigger_schwelle         = 2.0;       % Schwelle
% q.trigger_vorlauf_zeit     = 0.5;       % Vorlaufzeit zum abschneiden
%
%
  if( ~check_val_in_struct(q,'trigger_measure','num',1) )
    q.trigger_measure = 0;
  end
  if( q.trigger_measure )
    if( ~check_val_in_struct(q,'trigger_signal_name','char',1) )
      error('Weil q.trigger_measure gesetzt, muss q.trigger_signal_name mit einem Signalnamen gesetzt sein !')
    end
    if( ~check_val_in_struct(q,'trigger_schwelle','num',1) )
      error('Weil q.trigger_measure gesetzt, muss q.trigger_schwelle mit einem Schwellwert gesetzt sein !')
    end
    if( ~check_val_in_struct(q,'trigger_vorschrift','char',1) )
      error('Weil q.trigger_measure gesetzt, muss q.trigger_vorschrift mit ''=='',''>='',''>'',''<'',''<='', ... (siehe help suche_index) gesetzt sein !')
    end
    if( ~check_val_in_struct(q,'trigger_vorlauf_zeit','num',1) )
      error('Weil q.trigger_measure gesetzt, muss q.trigger_vorlauf_zeit mit einer Vorlaufzeit gesetzt sein !')
    end
  end

% q.cut_measurement_by_time            0/1             Soll die Messung in
%                                                      zeitlich in mehrere Messungen aufgeteilt werden
% q.cut_measurement_time                num  [s]       Zeit, in die
%                                                      aufgeteilt werden
%                                                      soll. Wird aber nur
%                                                      für d-DatenStruktur
%                                                      gemacht
  if( ~check_val_in_struct(q,'cut_measurement_by_time','num',1) )
    q.cut_measurement_by_time = 0;
  end
  if( q.cut_measurement_by_time )
    if( ~check_val_in_struct(q,'cut_measurement_time','num',1) )
      q.cut_measurement_time = 500;
    end
  end
  
  % Wandle nur neue
  %----------------
  if( ~check_val_in_struct(q,'wand_new','num',1) )
    q.wand_new = 0;
  end

  % Beschreibung
  %----------------
  if( ~check_val_in_struct(q,'write_signal_description','num',1) )
    q.write_signal_description = 0;
  end
  
  %########################################################################
  %########################################################################
  %########################################################################
  % read input
  %########################################################################
  %########################################################################
  %########################################################################
  %########################################################################
  %-----------------------------------------------------
  % Liste mit einzulesenden can- und tacc-Messungen
  %-----------------------------------------------------
  fliste   = cg_get_can_asc_filenames(q);
  n_fliste = length(fliste);
  
  %-----------------------------------------------------
  % Liste durchlaufen
  %-----------------------------------------------------
   for i_fliste = 1:n_fliste

    d    = [];
    u    = [];    
    h    = {};
    if( isempty(q.add_estruct) )
      e    = [];
    else
      e = q.add_estruct;
    end
    
    f    = fliste(i_fliste);
    meas_dir = f.meas_dir;
    fprintf('===========================================================================\n');
    fprintf('i_fliste = %i\n',i_fliste);
    fprintf('name     = %s\n',f.name);
    fprintf('meas_dir = %s\n',meas_dir);
    fprintf('===========================================================================\n');
    
    filename_e = fullfile(f.meas_dir,[f.name,'_e.mat']);
    if( q.ECALStructOutput )
      filename_pb = fullfile(f.meas_dir,[f.name,'_ecal.mat']);
    end
    add_name_wand = '';
    q.existing_channel_names = {};
    if( q.wand_new == 1 )
      if( exist(filename_e,'file') )
       [okay,q.e1,ff1] = e_data_read_mat(filename_e);
       if( okay )
         q.existing_channel_names = cg_convert_meas_data_get_channel_names(q.e1);
       end
      end
    elseif( q.wand_new == 2 )
      if( exist(filename_e,'file') )
        continue
      end
    end
               
      % description-file auslesen
      %--------------------------
      S = cg_convert_meas_data_get_descrip(f);

      % help string
      %------------
      h{length(h)+1} = [S.measurement,'/',S.date,'/',S.comment];

      % CAN measurement
      %----------------
      if( q.CANread )
        if( q.wand_Tx_in_Rx )
          cg_convert_meas_data_CAN_TxRx(f);
        end
        if( ~isempty(f.can_file) && exist(fullfile(f.meas_dir,f.can_file),'file') )
          ee = cg_convert_meas_data_CAN(f,q,S);
          e  = merge_struct_f(e,ee);
        end
      end
      % TACC-data
      %----------
      if( q.TACCread )
        ee = cg_convert_meas_data_TACC(f,q);
      % ECAL-data
      %----------
      elseif( q.ECALread == 1 )
        [ee,pb] = cg_convert_meas_data_ECAL(f,q);
        %
        % Zeit nullen
        %
        if( ~isempty(ee) )
          [~,tstartmin,~] = e_data_get_tstart(ee);
          [ee] = e_data_subtract_timeoffset(ee,tstartmin);
          if( ~isempty(pb) )
            [pb] = pb_data_subtract_timeoffset(pb,tstartmin);
          end
        end
      elseif( q.ECALread == 2 )
        ee = cg_convert_meas_data_ECAL2(f,q);
        %
        % Zeit nullen
        %
        if( ~isempty(ee) )
          [~,tstartmin,~] = e_data_get_tstart(ee);
          ee = e_data_subtract_timeoffset(ee,tstartmin);
        end
        
      end
      
      if( q.TACCread || q.ECALread )
        if( q.CANread ...
          && (q.calc_offset_tacc_can == 1) ...
          && isfield(ee,'VehicleDynamicsIn_signals_speed') ...
          && isfield(e,'PrivCAN_VehSpd') ...
          )
  %         figure(199)
  %         plot(ee.VehicleDynamicsIn_signals_speed.time,ee.VehicleDynamicsIn_signals_speed.vec*3.6,'b-')
  %         hold on
  %         plot(e.VehSpd.time,e.VehSpd.vec,'k-')
  %         hold off
          e = cg_merge_tac_can(ee,e,'VehicleDynamicsIn_signals_speed','PrivCAN_VehSpd');

  %         figure(200)
  %         plot(e.VehicleDynamicsIn_signals_speed.time,e.VehicleDynamicsIn_signals_speed.vec*3.6,'b-')
  %         hold on
  %         plot(e.VehSpd.time,e.VehSpd.vec,'k-')
  %         hold off
        elseif(  q.CANread ...
              && (q.calc_offset_tacc_can == 2) ...
              && isfield(ee,'VehicleDynamicsIn_signals_steering_wheel_angle') ...
              && (isfield(e,'PTCAN_LH3_BLW') || isfield(e,'PrivCAN_StW_Angl')) ...
              )
  %         figure(199)
  %         plot(ee.VehicleDynamicsIn_signals_steeringWheelAngle.time,ee.VehicleDynamicsIn_signals_steeringWheelAngle.vec,'b-')
  %         hold on
  %         plot(e.PTCAN_LH3_BLW.time,e.PTCAN_LH3_BLW.vec,'k-')
  %         hold off
          if( isfield(e,'PTCAN_LH3_BLW') )
            e = cg_merge_tac_can(ee,e,'VehicleDynamicsIn_signals_steering_wheel_angle','PTCAN_LH3_BLW');
          else
            e = cg_merge_tac_can(ee,e,'VehicleDynamicsIn_signals_steering_wheel_angle','PrivCAN_StW_Angl');
          end
  %         figure(200)
  %         plot(e.VehicleDynamicsIn_signals_steeringWheelAngle.time,e.VehicleDynamicsIn_signals_steeringWheelAngle.vec,'b-')
  %         hold on
  %         plot(e.PTCAN_LH3_BLW.time,e.PTCAN_LH3_BLW.vec,'k-')
  %         hold off
        elseif(  q.CANread ...
              && (q.calc_offset_tacc_can == 3) ...
              && isfield(ee,q.calc_offset_tacc_signal) ...
              && (isfield(e,q.calc_offset_can_signal) ) ...
              )
  %         figure(199)
  %         plot(ee.VehicleDynamicsIn_signals_steeringWheelAngle.time,ee.VehicleDynamicsIn_signals_steeringWheelAngle.vec,'b-')
  %         hold on
  %         plot(e.PTCAN_LH3_BLW.time,e.PTCAN_LH3_BLW.vec,'k-')
  %         hold off
          e = cg_merge_tac_can(ee,e,q.calc_offset_tacc_signal,q.calc_offset_can_signal);
  %         figure(200)
  %         plot(e.VehicleDynamicsIn_signals_steeringWheelAngle.time,e.VehicleDynamicsIn_signals_steeringWheelAngle.vec,'b-')
  %         hold on
  %         plot(e.PTCAN_LH3_BLW.time,e.PTCAN_LH3_BLW.vec,'k-')
  %         hold off
        else
          e  = merge_struct_f(e,ee);
        end
      end      


      % find limits in e-data
      %-------------------------------
      if( q.find_limit_by_plot )
        q = cg_convert_find_limit_eData(e,q);
      end

      % modify e-data by own functions
      %-------------------------------
      if( ~isempty(e) )
        e = cg_convert_meas_data_eFkt(e,q);
      end

      if( isempty(e) )
        warning('Aus der Messung <%s> sind keine Daten eingelsen worden!\n<%s>' ...
               ,f.name,f.meas_dir);
      else

        % e-Struktur beschneiden
        %-----------------------
        [e,fflag] = e_data_reduce_time(e,q.tstart,q.tend,q.zero_time);
        if( fflag )
          fprintf('===========================================================================\n');
          fprintf('e_data-struct reduced to \n tstart = %f [s]\n tend = %f [s]\n zeroflag = %f \n' ...
                 ,q.tstart,q.tend,q.zero_time);
          fprintf('===========================================================================\n');
        end
        
        % e-Struktur speichern
        %---------------------
        eval(['save ''',filename_e,''' e']);
        fprintf('e-struct-Datei: <%s>\n',filename_e);
        
        % pb-Struktur speichern
        %---------------------
        if( q.ECALStructOutput )
          eval(['save ''',filename_pb,''' pb']);
          fprintf('pb-struct-Datei: <%s>\n',filename_pb);
        end
        
        % beschreibung
        if( q.write_signal_description )
          filename_excel = fullfile(f.meas_dir,[f.name,'.xlsx']);
          if( exist(filename_excel,'file') )
            delete(filename_excel)
          end
          e_data_print_signal_names_excel(e,filename_excel);
          fprintf('excel-Datei: <%s>\n',filename_excel);
        end

        % e -> d bringen
        %---------------
        if( struct_isempty(e) )
          warning('e-structure is empty')
        elseif( ~strcmp(q.save_type,'no') )
          [d,u,c]   = d_data_read_e(e,q.delta_t,q.zero_time,q.tstart,q.tend,q.timeout);

          if( q.delta_t0 >= 0. || q.delta_t0 >= 0. )
            if(q.delta_t0>eps),fprintf('delta_t0 = %f, wird zu Beginn abgeschnitten\n',q.delta_t0);end
            if(q.delta_t1>eps),fprintf('delta_t1 = %f, wird am Ende abgeschnitten\n',q.delta_t1);end
            d = struct_reduce_vecs_to_delta_t(d,q.delta_t0,q.delta_t1,'time',q.zero_time);
          end

          % modify d,u,c-data standard
          %---------------------------
          if( q.mod_dDataCG )
            [d,u,c] = cg_mod_d_data(d,u,c);
          end

          % modify d,u,c-data by own functions
          %------------------------------------
          [d,u,c] = cg_convert_meas_data_dFkt(d,u,c,q);


          % Messung auf ein Signal triggern
          %--------------------------------
          if( q.trigger_measure )
              d = d_data_trigger(d,q.trigger_signal_name,q.trigger_schwelle ...
                                ,q.trigger_vorschrift,q.trigger_vorlauf_zeit);
          end


          % Kommentar in Header einfügen
          %-----------------------------
          h{length(h)+1} = c;

          switch(q.save_type)
            case 'mat_dspa'
              filename    = fullfile(f.meas_dir,[f.name,add_name_wand,'.mat']);
              okay = d_data_save(filename,d,u,h,'dspa');
              fprintf('Mat-Ausgabe-Datei dspa-Format: <%s>\n========================================================================================================\n',filename);
            case 'mat_duh'
              filename    = fullfile(f.meas_dir,[f.name,add_name_wand,'.mat']);
              okay = d_data_save(filename,d,u,h,'duh');
              fprintf('Mat-Ausgabe-Datei duh-Format: <%s>\n========================================================================================================\n',filename);
            case 'dia'
              filename    = fullfile(f.meas_dir,[f.name,add_name_wand,'.dat']);
              okay = d_data_save(filename,d,u,h,'dia');
              fprintf('Mat-Ausgabe-Datei dia-Format: <%s>\n========================================================================================================\n',filename);
            case 'dia_asc'
              filename    = fullfile(f.meas_dir,[f.name,add_name_wand,'.dat']);
              okay = d_data_save(filename,d,u,h,'dia_asc');
              fprintf('Mat-Ausgabe-Datei diadem-Format: <%s>\n========================================================================================================\n',filename);
            case 'no'
              fprintf('keine speicherung\n');
            otherwise
              warning('Kein gültiges Format für <%s>\n========================================================================================================\n' ...
                      ,q.save_type);
          end

          if( q.cut_measurement_by_time )

            [slices,nslices] = vektor_cut_in_slices(d.time,q.cut_measurement_time,'u');
            % CAN-Datei zerlegen        
            if( (nslices>1) && ~isempty(f.can_file) )
              ascii_file = fullfile(f.meas_dir,f.can_file);
              if( exist(ascii_file,'file') )
                b = mexReadCANBytes(ascii_file);
                b.time = b.time - (b.time(1)-slices(1).xstart);
                b.n    = length(b.time);
              end
            end

            if( nslices > 1 )
              okay = 1;
              for i=1:nslices
               if( ~strcmp(q.save_type,'no') )

                 filenameout  = [f.name,'_',num2str(round(slices(i).xstart)),'_',num2str(round(slices(i).xend))];
                 filenameout  = fullfile(f.meas_dir,[filenameout,'_e.mat']);
                 okay = e_data_reduce_file_by_time(slices(i).xstart,slices(i).xend,0,filename_e,filenameout);
                 if( okay )
                  fprintf('e-struct-Datei: <%s>\n',filenameout);
                 else
                   error('e_data_reduce_file_by_time(slices(%i).xstart=%f,slices(%i).xend=%f,0,''%s'',''%s''); ging nicht' ...
                        ,i,slices(i).xstart,slices(i).xend,filename_e,filenameout);
                 end
               end
               if( ~okay )
                 break;
               end

               % d-Struktur
               filenameout = [f.name,'_',num2str(round(slices(i).xstart)),'_',num2str(round(slices(i).xend))];
               filenameout = fullfile(f.meas_dir,[filenameout,'.mat']);
               okay = d_data_reduce_file_by_time(slices(i).xstart,slices(i).xend,0,filename,q.save_type,filenameout);
               if( ~okay )
                 break;
               end

               % ascii-Datei
               if( (nslices>1) && ~isempty(f.can_file) )
                 if( exist(ascii_file,'file') )
                   filenameout  = [f.name,'_',num2str(round(slices(i).xstart)),'_',num2str(round(slices(i).xend))];
                   filenameout  = fullfile(f.meas_dir,[filenameout,'.asc']);
                   i0 = min(b.n,max(1,suche_index(b.time,slices(i).xstart,'====','v')));
                   i1 = min(b.n,max(1,suche_index(b.time,slices(i).xend,'====','v')));
        %            b1.time    = b.time(i0:i1);
        %            b1.id      = b.id(i0:i1);
        %            b1.channel = b.channel(i0:i1);
        %            b1.len     = b.len(i0:i1);
        %            b1.byte0   = b.byte0(i0:i1);
        %            b1.byte1   = b.byte1(i0:i1);
        %            b1.byte2   = b.byte2(i0:i1);
        %            b1.byte3   = b.byte3(i0:i1);
        %            b1.byte4   = b.byte4(i0:i1);
        %            b1.byte5   = b.byte5(i0:i1);
        %            b1.byte6   = b.byte6(i0:i1);
        %            b1.byte7   = b.byte7(i0:i1);
        %            b1.receive = b.receive(i0:i1);
                   tic
                   mexBDataSaveAscii(b,filenameout,i0,i1);
                   toc           
                   fprintf('ascii-Datei: <%s>\n',filenameout);
                 end
               end
              end
            end
          end

        end           


      end % end is not empty
  end % end for
  
  fprintf('===========================================================================\n');
  fprintf('Ende ----------------------------------------------------------------------\n');
  fprintf('===========================================================================\n');
  % Ausgabe
  if( nargout >= 1 ), ookay = okay;     end
  if( nargout >= 2 ), dd    = d;     end
  if( nargout >= 3 ), uu    = u;     end
  if( nargout >= 4 ), hh    = h;     end
  if( nargout >= 5 ), ee    = e;     end
  if( nargout >= 6 ), md    = meas_dir;     end  
end
%=====================================================================================================
%=====================================================================================================
%=====================================================================================================
%=====================================================================================================
%=====================================================================================================
%=====================================================================================================
%=====================================================================================================
function S = cg_convert_meas_data_get_descrip(f)
% description-file auslesen
%    
    if( f.description )
      descript_file = fullfile(f.meas_dir,'description.txt');
      S = cg_prepare_measurement_description(descript_file);
      if( isempty(S.date) && ~isempty(f.can_file) )
        a = dir(fullfile(f.meas_dir,f.can_file));
        v = datevec(a(1).date);
        S.date = [num2str(v(3)),'.',num2str(v(2)),'.',num2str(v(1))];
      end
    elseif( ~isempty(f.can_file) )
      a = dir(fullfile(f.meas_dir,f.can_file));
      a(1).date = str_change_f(a(1).date,'Mrz','Mar');
      v = datevec(a(1).date);
      S.measurement = f.name;
      S.date        = [num2str(v(3)),'.',num2str(v(2)),'.',num2str(v(1))];
      S.comment     = 'no description-file';
    else
      a = dir(fullfile(f.meas_dir));
      a(1).date = str_change_f(a(1).date,'Mrz','Mar');
      v = datevec(a(1).date);
      S.measurement = f.name;
      S.date        = [num2str(v(3)),'.',num2str(v(2)),'.',num2str(v(1))];
      S.comment     = 'no description-file';
    end
end

function e = cg_convert_meas_data_CAN(f,q,S)
% f(i).name        = 'measxyz'          Name
% f(i).meas_dir    = 'd:\abc\measxyz'   Verzeichnis
% f(i).can_file    = 'calogXXX.asc'     can-asc-file
% f(i).tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
% f(i).description = 0/1                ist description-file vorhanden
% q.CANstruct        Zusätzliche Signalliste mit dbc-File 
%                    q.CANstruct(i).dbcFile     dbc-File mit vollständigem Pfad
%                    q.CANstruct(i).channel     channel in Messung(1,2,3,...=
%                    q.CANstruct(i).mFile       m-file um Ssig zu erzeugen
%                    q.CANstruct(i).Ssig        Signalliste mit
  e    = [];

  for i=1:q.n_CANstruct
    

    % DBC-File mit Datum richtig zuordnen
    channel = q.CANstruct(i).channel;
    if( datum_str_to_int(S.date) < 20101026 ) % channel were changed

      if( channel == 1 )
        channel = 2; 
      elseif( channel == 2 )
        channel = 1; 
      end
    end
%       if( datum_str_to_int(S.date) < 20101101 )
%         q.dbcfile0 = q.dbcfile0_rev14573;
%       end
%       if( datum_str_to_int(S.date) < 20111121 )
%         q.dbcfile0 = q.dbcfile0_rev22917;
%       end
%       if( datum_str_to_int(S.date) < 20120730 )
%         q.dbcfile0 = q.dbcfile0_rev27932;
%       end

    % Ssig erzeugen
    if( ~isfield(q.CANstruct(i),'Ssig') || isempty(q.CANstruct(i).Ssig) )
      s_file = str_get_pfe_f(q.CANstruct(i).mFile);
      if( ~isempty(s_file.dir) )
        org_dir = pwd;
        cd(s_file.dir);
      else
        org_dir = '';
      end
      if( ~exist([s_file.name,'.m'],'file') )
        error('M-File: %s konnte nicht gefunden werden',q.CANstruct(i).mFile);
      else
        fprintf('M-File: <%s>\n',[s_file.dir,s_file.name,'.m']);
      end
      try
        q.CANstruct(i).Ssig = eval(s_file.name);
        if( ~isempty(org_dir) ),cd(org_dir),end
      catch exception
        if( ~isempty(org_dir) ),cd(org_dir),end
        throw(exception)
      end
    end
    
    % Wenn TACC-Messung und Vorgabe Name CAN-Log
    if( ~isempty(q.CANstruct(i).messFile) )
      s_file = str_get_pfe_f(q.CANstruct(i).messFile);
      if( ~isempty(s_file.ext) )
        t_ext = s_file.ext;
      else
        t_ext = 'asc';
      end
      mess_extra_file = fullfile(f.meas_dir,s_file.dir,[s_file.name,'.',t_ext]); 
    else
      mess_extra_file = '';
    end
    if( ~isempty(mess_extra_file)  )
      mess_full_file = mess_extra_file;
    else
      mess_full_file = fullfile(f.meas_dir,f.can_file);
    end
    if( exist(mess_full_file,'file') )
     try 
      [okay,ee] = can_asc_read_and_filter(mess_full_file ...
                                  ,q.CANstruct(i).dbcFile ...
                                  ,channel ...
                                  ,q.CANstruct(i).Ssig);
     catch
       error('Problems in can_asc_read_and_filter');
     end
      if( ~okay )
        error('Problems in can_asc_read_and_filter');
      end
      fprintf('signals: %i\n',length(fieldnames(ee)));                                
      e  = merge_struct_f(e,ee);
    else
      warning('Datei: <%s> \n does not exist',mess_full_file);
    end
  end
  
end
function e = cg_convert_meas_data_TACC(f,q)
% f.name        = 'measxyz'          Name
% f.meas_dir    = 'd:\abc\measxyz'   Verzeichnis
% f.can_file    = 'calogXXX.asc'     can-asc-file
% f.tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
% f.description = 0/1                ist description-file vorhanden
  
  e    = [];
  
  if( ~f.tacc )
    warning('Messpfad <%s> ist kein TaskData-Verzeichnis vorhanden',f.meas_dir);
    return;
  end
  
  taskdir = fullfile(f.meas_dir,'TaskData');
  
  %
  % Channel-Signale einlesen
  %
  for i=1:length(q.TaccChannels)
    channelname = q.TaccChannels{i};
    
    ii=str_find_f(channelname,'Pb','vs');
    if( ii > 1 )
      searchname = channelname(1:ii-1);
    else
      searchname = channelname;
    end

    ifound        = cell_find_f(q.existing_channel_names,searchname,'f');
    
    if( ~isempty(ifound) )
      fprintf('<-> TACC-Channel-%s-übernehmen\n',channelname);
      e1 = e_data_get_signals_with_name(q.e1,searchname);
    else
      fprintf('-> TACC-Channel-%s-lesen\n',channelname);
      e1 = cg_read_tacc_channel(taskdir,channelname,200,q.timeout_destraj,q.TaccConvDir,q.TaccUseOldNames);    
      fprintf('signals: %i\n',length(fieldnames(e1)));
      fprintf('<- TACC-Channel-%s-lesen\n',channelname);
    end
    if( ~isempty(e1) )
      e = merge_struct_f(e,e1);
    end
  end
end
function [e,pb] = cg_convert_meas_data_ECAL(f,q)
% f.name         = 'measxyz'                         Name
% f.meas_dir     = 'd:\abc\measxyz'                  Verzeichnis
% f.ecal         = 0/1                               ist TaskData-Verzeichnis vorhanden
% f.ecal_files   = {'d:\abc\measxyz\ecal.ecal.hdf5'} ist ecal-Verzeichnis vorhanden
%
% q.ECALChannels      celll array with all ecal-channels to read
% q.ECALStructOutput  0/1 read ecal struct pb

  if( ~check_val_in_struct(q,'timeout_destraj','num',1) )
    q.timeout_destraj = 0.0;
  end
  if( ~check_val_in_struct(q,'ECALStructOutput','num',1) )
    q.ECALStructOutput = 0;
  end
  if( ~check_val_in_struct(q,'ECALChannels','cell',1) )
    error('q.ECALChannels is not set');
  end
  
  
  
  
  if( q.ECALReadChannelsAtOnce )
    [e,pb] = cg_read_ecal_channel_at_once(f.meas_dir,q.ECALChannels,q.timeout_destraj,q.ECALStructOutput);
  else
    pb   = [];
    e    = [];
    for i=1:length(q.ECALChannels)
      channelname = q.ECALChannels{i};

      [e1,pb1] = cg_read_ecal_channel(f.meas_dir,channelname,q.timeout_destraj,q.ECALStructOutput); 

      if( ~isempty(e1) )
        e = merge_struct_f(e,e1);
      end
      if( ~isempty(pb1) )
        pb = merge_struct_f(pb,pb1);
      end
    end
  end  
end
function e = cg_convert_meas_data_ECAL2(f,q)
% f.name         = 'measxyz'                         Name
% f.meas_dir     = 'd:\abc\measxyz'                  Verzeichnis
% f.ecal         = 0/1                               ist TaskData-Verzeichnis vorhanden
% f.ecal_files   = {'d:\abc\measxyz\ecal.ecal.hdf5'} ist ecal-Verzeichnis vorhanden
  
  e    = [];
  for i=1:length(q.ECALChannels)
    channelname = q.ECALChannels{i};
    fprintf('-> ECAL-Channel-%s-lesen\n',channelname);
     e1 = cg_read_ecal_channel2(f.meas_dir,channelname,q.timeout_destraj,q.ECALUnitLinDatei);
     fprintf('signals: %i\n',length(fieldnames(e1)));
    fprintf('<- ECAL-Channel-%s-lesen\n',channelname);
    
    if( ~isempty(e1) )
      e = merge_struct_f(e,e1);
    end
  end
  
end
function e = cg_convert_meas_data_eFkt(e,q)
%
% Modifyfunction e = name(e);
%
  for i=1:q.n_eFkt

    dir_org = pwd;
    if( ~isempty(q.eFkt(i).dir) )
      if( ~exist(q.eFkt(i).dir,'dir') )
        error('Das Verzeichnis <%s> aus q.mod_eDataFkt{%i} exisistiert nicht !', ...
          q.eFkt(i).dir,i);
      else
        cd(q.eFkt(i).dir);
      end
    end
    try
      eval(['e=',q.eFkt(i).name,'(e);']);
      fprintf('eDAtaFkt: %s\n',['e=',q.eFkt(i).name,'(e);']);
    catch exception
     cd(dir_org);
     throw(exception)
    end
    cd(dir_org);
  end
end
function [d,u,c] = cg_convert_meas_data_dFkt(d,u,c,q)
%
% Modifyfunction [d,u,c] = name(d,u,c);
%
  for i=1:q.n_dFkt

    dir_org = pwd;
    if( ~isempty(q.dFkt(i).dir) )
      if( ~exist(q.dFkt(i).dir,'dir') )
        error('Das Verzeichnis <%s> aus q.mod_dDataFkt{%i} exisistiert nicht !', ...
          q.dFkt(i).dir,i);
      else
        cd(q.dFkt(i).dir);
      end
    end
    try
      eval(['[d,u,c]=',q.dFkt(i).name,'(d,u,c);']);
      fprintf('dDAtaFkt: %s\n',['[d,u,c]=',q.dFkt(i).name,'(d,u,c);']);
    catch exception
     cd(dir_org);
     throw(exception)
    end
    cd(dir_org);
  end
end
function q = cg_convert_find_limit_eData(e,q)

  % Liste der vorgeschlagenen Signale überprüfen
  %---------------------------------------------
  [found,time0,time1] = e_data_find_x_limit_by_plot(e,{'PTCAN_LH3_LM','PTCAN_LH3_BLW','PTCAN_BR5_Bremsdruck'});
  
  if( found )
    s.tstart = time0;
    s.tend   = time1;
  end

end
function cg_convert_meas_data_CAN_TxRx(f)

  filename = fullfile(f.meas_dir,f.can_file);
  [ okay,c,nzeilen ] = read_ascii_file(filename );
  
  if( okay )
    c = cell_change(c,'Tx','Rx');
    
    okay = write_ascii_file(filename,c);
  end
end
function e = cg_merge_tac_can(etacc,ecan,signal_tacc,signal_can)

  [fac,offset,errtext] = get_unit_convert_fac_offset(etacc.(signal_tacc).unit,ecan.(signal_can).unit);
  if( ~isempty(errtext) )
    error(errtext);
  end

  ntacc = length(etacc.(signal_tacc).time);
  ncan  = length(ecan.(signal_can).time);
  
  veccan   = abs(ecan.(signal_can).vec);
  timecan  = ecan.(signal_can).time;
  dtcan    = mean(diff(timecan));
  
  vectacc   = abs(etacc.(signal_tacc).vec)*fac+offset;
  timetacc  = etacc.(signal_tacc).time;
  dttacc    = mean(diff(timetacc));
  if( dtcan-dttacc > 0.0001 )
    timenew = [timecan(1):dttacc:timecan(length(timecan))];
    veccan = interp1(timecan,veccan,timenew,'linear','extrap');
    ntcan   = length(timenew);
    timecan = timenew;
    
  elseif( dttacc-dtcan > 0.0001 )
    
    timenew = [timetacc(1):dtcan:timetacc(length(timetacc))];
    vectacc = interp1(timetacc,vectacc,timenew,'linear','extrap');
    ntacc   = length(timenew);
    timetacc = timenew;
  end
  
%   figure(300)
%   plot(vectacc,'b-')
%   hold on
%   plot(veccan,'k-')
%   hold off

  if( ncan >= ntacc )
    
   ioffset = vec_find_di_offset(veccan,vectacc);
   
   if( ioffset > 0 )
    delta_t = timecan(ioffset) - timetacc(1);
   
   
     if( delta_t > 0 )    
       ecan = e_data_signal_shift_time(ecan,{},delta_t,1);
     else
       etacc = e_data_signal_shift_time(etacc,{},-delta_t,1);
     end
   end   
  else
   ioffset = vec_find_di_offset(vectacc,veccan);
   
   if( ioffset > 0 )
     delta_t = timetacc(ioffset) - timecan(1);

     if( delta_t > 0 )    
      etacc = e_data_signal_shift_time(etacc,{},delta_t,1);
     else
      ecan = e_data_signal_shift_time(ecan,{},-delta_t,1);
     end
   end
  end
%   veccan   = abs(ecan.(signal_can).vec);
%   timecan  = ecan.(signal_can).time;
%   dtcan    = mean(diff(timecan));
%   vectacc   = abs(etacc.(signal_tacc).vec)*fac+offset;
%   timetacc  = etacc.(signal_tacc).time;
%   dttacc    = mean(diff(timetacc));
%   figure(310)
%   plot(vectacc,'b-')
%   hold on
%   plot(veccan,'k-')
%   hold off
  
  e  = merge_struct_f(ecan,etacc);
end
function existing_channel_names = cg_convert_meas_data_get_channel_names(e1)
  existing_channel_names = {};
  field_names = fieldnames(e1);
  for i=1:length(field_names)
    [c_names,icount] = str_split(field_names{i},'_');
    existing_channel_names = cell_add_if_new(existing_channel_names,c_names{1});
  end  
end
