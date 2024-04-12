# Generated with SMOP  0.41-beta
from libsmop import *
# cg_convert_meas_data.m

    
@function
def cg_convert_meas_data(q=None,*args,**kwargs):
    varargin = cg_convert_meas_data.varargin
    nargin = cg_convert_meas_data.nargin

    
    # [okay,d,u,h,e] = cg_convert_meas_data(q)
    
    # Liest Canlyser-Daten (*.asc) und Tacc-Messungen
    
    # q.read_type      = 1  Verzeichnisse müssen ausgewählt werden
    #                       q.start_dir angeben, um
    #                       Daten-Verzeichnis auszuwählen
    #                       (tacc-Messordner oder Ordner mit
    #                       CAN-ascii-Dateien)
    #                       (q.start_dir angeben)
    #                  = 2  CAN-ascii-Dateien auswählen
    #                       (q.start_dir angeben)
    #                  = 3  übergeordnetes Verzeichnis zu Einlesen 
    #                       angeben q.read_meas_path angeben
    #                       (q.read_meas_path angeben)
    #                  = 4  Liste mit einzulesenden Messverzeichnissen 
    #                       q.read_list = {'dir1',dir2'}oder
    #                       explizite Canalyser-Ascii Dateien in
    #                       q.read_list = {'datei1.asc','datei2.asc'}
    #                       angeben
    #                  = 5  Verzeichnis auswählen, mit dem
    #                       Namen des  Verzeichnisses wird die
    #                       Messung gespeichert
    #
    
    # q.start_dir        (q.read_type = 1,2) Start-Dir zum Suchen 
    # q.read_meas_path   (q.read_type = 3) Verzeichnis unter dem alle 
    #                                      Messungen gewandelt werden
    # q.read_list        (q.read_type = 4) Liste mit Dateien (Canalyser-ascii)
    #                                      oder Verzeichnissen
    #                    Tacc-Messungen
    # q.delta_t          time step to build d.time (default 0.01)
    # q.zero_time        0/1 zero time in vector d.time (default 1)
    # q.tstart           start time, if to cut measurement q.tstart < 0 has no influence
    #                    (default -1.) Kann durch find_limit_by_plot überschrieben werden 
    # q.tend             end time, if to cut measurement q.tend < 0 has no influence
    #                    (default -1.) Kann durch find_limit_by_plot überschrieben werden
    # q.timeout          timeout if no signal is set in timeout, signal in
    #                    d-strucure will be set to zero
    # q.timeout_destraj  spezieller timeout für DesvehTraj
    #
    # q.delta_t0         In d-Struktur wird delta_t0 zu Beginn abgeschnitten
    # q.delta_t1         In d-Struktur wird delta_t1 am Ende abgeschnitten
    #
    # q.CANread          0/1 CAN-log files verarbeiten (canlog*.asc bzw. beliebige Namen)
    #    
    # q.CANuse           # Liste z.B. [1,2] mit möglichen Vorgaben:
    #                    1: SCG.CAN_TYPE_CONTIGUARD_VPU
    #                    2: SCG.CAN_TYPE_FZG_BMW545
    #                    3: SCG.CAN_TYPE_FZG_PASSAT
    #                    4: SCG.CAN_TYPE_HAF_BMW3_MDJ6385
    #                    5: SCG.CAN_TYPE_VBOX3iSL
    #                    6: SCG.CAN_TYPE_HAF_BMW3_MDJ6385_TESTCAN
    #
    # q.CANstruct        Zusätzliche Signalliste mit dbc-File 
    #                    q.CANstruct(i).dbcFile     dbc-File mit vollständigem Pfad
    #                    q.CANstruct(i).channel     channel in Messung(1,2,3,...=
    #                    q.CANstruct(i).mFile       m-File um Signalliste zu generieren mit
    #                           Ssig(i).name_in      = 'signal name';
    #                           Ssig(i).unit_in      = 'dbc unit';              (default '')
    #                           Ssig(i).lin_in       = 0/1;                     (default 0)
    #                           Ssig(i).name_sign_in = 'signal name for sign';  (default '')
    #                           Ssig(i).name_out     = 'output signal name';    (default name_in)
    #                           Ssig(i).unit_out     = 'output unit';           (default 'unit_in')
    #                           Ssig(i).comment      = 'description';           (default '')
    # 
    #                           name_in      is name from dbc, could also be used with two and mor names
    #                                        in cell array {'nameold','namenew'}, if their was an change
    #                                        in dbc, use for old measurements
    #                           unit_in      will used if no unit is in dbc for that input signal
    #                           lin_in       =0/1 linearise if to interpolate to a commen time base
    #                           name_sign_in if in dbc-File is a particular signal for sign (how VW
    #                                        uses) exist
    #                           name_out     output name in Matlab
    #                           unit_out     output unit
    #                           comment      description
    #    
    #                    q.CANstruct(i).messFile       Name des Messfiles (Ist
    #                                                  nur relevant,wenn tacc-Message mit mehreren
    #                                                  CAN-Messfiles mit Standard-Namen gewandelt werden soll
    # q.CANFileNameTACC     char-value bei TACC-Messungen nur diesen CAN-File-NAmen nehmen z.B. {'canlog'}
    # q.CANFileNameExclude  cell-array mit auszuschliessende CAN-Filenamen z.B. {'canlog_pc2'}
    #    
    # q.TACCread         0/1 Tacc-Daten mit TacConv lesen aus Verzeichnis TaskData
    #
    # q.TaccChannels      cell-array mit Channelnamen z.B. {'VehicleDynamics','ESA2VehDsrdTraj'};
    #                     Mögliche Channels:
    #   CChanHead = {{'ESA2VehDsrdTraj','CMsgVehicleDesiredTraj'} ...            # 1
    #               ,{'LaneRecognition','CMsgLaneRecognition'}    ...            # 2
    #               ,{'VehiclePose''CMsgVehiclePose'}             ...            # 3
    #               ,{'VehicleDynamics','CMsgVehicleDynamics'}    ...            # 4
    #               ,{'RelevantObjectData','CMsgRelevantObjectData'} ...         # 5
    #               ,{'GpsRawData','CGps2NetFrameMsg'}       ...                 # 6
    #               ,{'MFCImage','CMsgCameraImage'}        ...                   # 7
    #               ,{'GenericObjectList','CMsgGenericEnvObjectList'} ...        # 8
    #               ,{'TargetLane','CMsgTargetLane'}         ...                 # 9
    #               ,{'HAPSVehDsrdTraj','CMsgVehicleDesiredTraj'} ...            # 10
    #               ,{'PRORETAVehDsrdTraj','CMsgVehicleDesiredTraj'} ...         # 11
    #               ,{'ArbiCurvRequest','CMsgExtCurvRequest'}     ...            # 12
    #               ,{'ArbiDev2PthRequest','CMsgArbiDev2PthRequest'} ...         # 13
    #               ,{'AD2PCurvRequest','CMsgExtCurvRequest'}     ...            # 14
    #               ,{'AD2PRequest','CMsgExtDev2PthRequest'}  ...                # 15
    #               ,{'CanMsgLatCtrl','CCanMsgLatCtrl'}         ...              # 16
    #               ,{'VehicleDynamicsIn','TVehicleDyn'}            ...          # 17
    #               ,{'PowerTrainIn','TPowerTrain'}            ...               # 18
    #               ,{'LCCVehDsrdTraj','CMsgVehicleDesiredTraj'} ...             # 19
    #               ,{'CarSwitchesIn','TCarSwitches'}          ...               # 20
    #               ,{'Test1VehDsrdTraj','CMsgVehicleDesiredTraj'} ...           # 21
    #               ,{'AD2PDev2PthRequest','CMsgExtDev2PthRequest'}  ...         # 22 
    #               ,{'Vpu4IQF1','CMsgVpu4IQF1'}           ...                   # 23
    #               ,{'GlobalPosVBox','CGlobalPosEstMsg'}       ...              # 24
    #               ,{'PowerTrain','CMsgPowertrain'}         ...                 # 25
    #               ,{'VehicleBehavior','CMsgBehaviorPlanner'}    ...            # 26
    #               ,{'EHorizon','CMsgEHorizon'}           ...                   # 27
    #               ,{'ParkingSpaceDescription','CMsgParkingSpaceDescription'} ...    # 28
    #               ,{'ParkingSpaceDescriptionCorrected','CMsgParkingSpaceDescription'} ... # 29
    #               ,{'VehiclePoseCorrected','CMsgVehiclePose'}  ...             # 30
    #               ,{'VehiclePoseCorrected_replay','CMsgVehiclePose'}  ...      # 31
    #               ,{'PlannerVRequest','CMsgExtVeloRequest'} ...                # 32
    #               ,{'PlannerVehDsrdTraj','CMsgVehicleDesiredTraj' } ...        # 33
    #               ,{'ArbiARequest','CMsgArbiARequest'} ...                     # 34
    #               ,{'ArbiVRequest','CMsgArbiVRequest'} ...                     # 35
    #               ,{'ArbiBrkPressRequest','CMsgArbiBrkPressRequest'} ...       # 36
    #               ,{'GlobalPosRT4000','CGlobalPosEstMsg'} ...                  # 37
    #               ,{'RT4000DataIn','CRT4000DataMsg'} ...                       # 38
    #               ,{'PoseOffsetCorrect','CMsgPoseOffsetCorrect'} ...           # 39 
    #               ,{'V2xFusionCheck_1','CV2xFusionCheckMsg'} ...               # 40
    #               ,{'AD2PVehDsrdTraj','CMsgVehicleDesiredTraj'} ...            # 41
    #               ,{'AD2PDebug','CArbiDev2PthDebugMsg'} ...                    # 42
    #               ,{'TrajectoryRequestFrenet','CMsgVehicleDesiredTraj'} ...    # 43
    #               ,{'PeopleMoverVehDsrdTraj','CMsgVehicleDesiredTraj'} ...     # 44
    #               ,{'PlannerVehDsrdTrajPb','pb.ExtRequests.VehicleDesiredTraj'} ... # 45
    #               ,{'VehicleDynamicsInPb','pb.SensorNearData.VehicleDynamics'} ...  # 46
    #               ,{'PowerTrainInPb','pb.SensorNearData.PowerTrain'} ...       # 47
    #               ,{'VehiclePosePb','pb.VehicleMovement.VehiclePose' } ...     # 48
    #               ,{'CarSwitchesInPb','pb.SensorNearData.CarSwitches'} ...      # 49
    #               ,{'AD2PDev2PthRequestPb','pb.ExtRequests.ExtDev2PthRequest' } ...             # 50
    #               ,{'AD2PVehDsrdTrajPb','pb.ExtRequests.VehicleDesiredTraj'} ...                # 51
    #               ,{'PeopleMoverVehDsrdTrajPb','pb.ExtRequests.VehicleDesiredTraj'} ...         # 52
    #               ,{'GlobalPosRT4000Pb','pb.GlobalPosEst'}  ...                # 53
    #               ,{'ADDrivingStrategyPb','pb.Applications.AD.ADDrivingStrategy'} ...           # 54
    #               ,{'ADDSARequestPb''pb.ExtRequests.ExtAccelRequest' } ...     # 55
    #               ,{'ADDSVRequestPb','pb.ExtRequests.ExtVeloRequest'} ...      # 56
    #               ,{'ADModeManager','CMsgADModeManager'} ...                   # 57
    #               ,{'ADModeMangerPb',''}                 ...                   # 58
    #               ,{'ArbiARequest','pb.Arbitration.ArbiARequest'} ...          # 59
    #               ,{'ArbiDrvCtrlRequest','CMsgArbiDriveCtrlRequest'} ...       # 60
    #               ,{'ArbiDrvCtrlRequestPb','pb.Arbitration.ArbiDriveCtrlRequest'} ...           # 61
    #               ,{'ArbiLngDebugOutputPb','pb.Arbitration.ArbLngDebug'...     # 62
    #               ,{'BrakeInPb','pb.SensorNearData.Brake'} ...                 # 63
    #               ,{'CanMsgLongCtrl','pb.Arbitration.CanLongCtrl'} ...         # 64
    #               ,{'DrvCtrlVRequestPb','pb.ExtRequests.ExtVeloRequest'} ...   # 65
    #               ,{'LatCtrlStat','' } ...                                     # 66
    #               ,{'LatCtrlStatPb','pb.Arbitration.LatCtrlStat' } ...         # 66
    #               ,{'ManeuverList','pb.Applications.AD.ADManeuverListMsg'} ... # 67
    #               ,{'SpeedLimitPb','pb.Embedded.SpeedLimit'} ...               # 68
    #               };
    #    
    # q.TaccConvDir   directory der Tacc-Conv-exe und dll, wenn nicht
    #                 gesetzt, dann wird über DOS-Variable gesetzt taccconv_dos_get
    #
    # q.TaccUseOldNames   0/1 use old Tac-Channel-Names
    #
    # q.ECALread         0/1 ecal-Daten zuerst nur protobuf-Channels einlesen
    #                    mit eCALImportGetChannels.mexw32 und eCALImportGetData.mexw32
    #                    = 2  ecal-read mit neuer Methode, es wird der gesamte
    #                    Channel eingelesen und aus einer Datei wird versucht
    #                    unit und lin Info zu bekommen
    #                    q.ECALUnitLinDatei kann Datei angegeben werden
    #                    Datei gefüllt mitz
    #                    signalname, unit, lin=1/0
    
    # q.ECALChannels      cell-array mit Channelnamen z.B. {'VehicleDynamicsInPb','VehiclePose'};
#                     Mögliche Channels:
    
    #   Channels = {'VehicleDynamicsInPb'
#              ,'VehicleDynamicsPb'
#              ,'VehiclePathPb'
#              ,'VehiclePosePb'
#              ,'WheelTicksInPb'
#              };
    
    # q.ECALUnitLinDatei    für q.ECALread = 2 wird diese Datei benutzt um Unit
#                       zu bekommen (default ist gesetzt)
# q.ECALStructOutput    =1/0 die von ecal eingelesene Datenstruktur mit
#                       ausgeben
# q.find_limit_by_plot  =1/0 Soll die Messung im d-daten-Struktur per Plot
#                       begrenzt werden (aus e-Daten wird geplotet)
# q.find_limit_sig_name = {'name1','name2',...}
#                       Signalnamenliste für Begrenzung
    
    # q.add_estrut = e                    additional e-Structur values to add
#                                     to Measurement, e-struct:
#                                     e.signame.time    Zeitvektor
#                                     e.signame.vec     Vektor oder cellaray
#                                                       mit Vektor zu jedem Zeitpunkt
#                                     e.signame.lin     Linear/constant bei
#                                                       Interpolation
#                                     e.signame.unit    Einheit
#                                     e.signame.comment Kommentar
    
    # q.mod_eDataFkt     string oder cellarray mit eigenem Fuktionsaufruf z.B.
#                    'd:\auswert\mod_my_edata' oder {'d:\auswert\mod_my_edata',...}
#                    Aufruf e = mod_my_edata(e);
#                    Es können neue Daten hinzugefügt werden oder auch
#                    bestehende bearbeitet
#                    e.('signame').time    zeitvektor
#                    e.('signame').vec     Wertevektor
#                    e.('signame').unit    Einheit
#                    e.('signame').comment Kommentar
#                    e.('signame').lin     1 linear interpolieren
#                                         0 konstant interpolieren
# q.mod_dDataCG      0/1 (default 1) 
#                    modify Data mit der fest vorgegebenen Funktion
#                    d = cg_mod_data(d)
# q.mod_dDataFkt     string oder cellarray mit eigenem Fuktionsaufruf z.B.
#                    'd:\auswert\mod_my_ddata' oder {'d:\auswert\mod_my_ddata',...}
#                    Aufruf [d,u,c] = mod_my_ddata(d,u,c);
#                    Es können neue Daten hinzugefügt werden oder auch
#                    bestehende bearbeitet
#                    d.('signame')    Wertevektor (erster ist immer time)
#                    u.('signame')    Einheit
#                    c.('signame')    Kommentar
# [q.save_type]      'no'       keine duh-Format Speicherung
#                    'mat_duh'  duh-Format Matlab (default)
#                    'mat_dspa' dspace-Format Matlab
#                    'dia'      dia-Format
#                    'dia_asc'  dia-ascii-Format
    
    # q.wand_Tx_in_Rx  = 1   wandelt Tx-Signale in Rx-Signale (ist aber nicht
#                        weiter notwendig)
    
    # q.calc_offset_tacc_can  = 1 merged can mit tacc (oder ecal) mit Fahrzeuggeschw, insbesondere wenn 
#                             unterschiedliche Längen vorhanden sind
# q.calc_offset_tacc_can  = 2 merged can mit tacc (oder ecal) mit Lenkradwinkel, insbesondere wenn 
#                             unterschiedliche Längen vorhanden sind
# q.calc_offset_tacc_can  = 3 merged can mit tacc (oder ecal) mit
#                             vorgegebenem Signal q.calc_offset_tacc_signal
#                             und q.calc_offset_can_signal
#                             
# q.calc_offset_tacc_signal   Signalname zum vergleichen aus tacc (ecal)
# q.calc_offset_can_signal    Signalname zum vergleichen aus can
    
    # q.trigger_measure          = 1;     # Messung wird auf einen Wert getriggert und geändert
# q.trigger_signal_name      = 'TStWhlSens';    # z.B. d.TStWhlSens wird verwendet
# q.trigger_vorschrift       = '>>';   # siehe suche_index()
# 	                                   # '>='          Wenn Signal größer gleich wird(default)
#                                      # '>','<','<='  größer/kleiner/kleiner gleich
#                                      # '=='          gleich innerhalb der Toleranz
#                                      # '==='         nächster Index, es wird der Index mit einem Rest bestimmt z.B index=10.3)
#                                      # '===='        (Index mit dem nächsten Wert)
#                                      # '>>'          vektor wird von kleiner zu größer als Wert
#                                      # '<<'          vektor wird größer zu kleiner als Wert
    
    # q.trigger_schwelle         = 2.0;       # Schwelle
# q.trigger_vorlauf_zeit     = 0.5;       # Vorlaufzeit zum abschneiden
    
    
    # q.cut_measurement_by_time            0/1             Soll die Messung in
#                                                      zeitlich in mehrere Messungen aufgeteilt werden
# q.cut_measurement_time                num  [s]       Zeit, in die
#                                                      aufgeteilt werden
#                                                      soll. Wird aber nur
#                                                      für d-DatenStruktur
#                                                      gemacht
# q.wand_new                          0/1              nur neue tacc-Channel-Daten einlsen
#      
# q.write_signal_description          0/1              schreibt description
#                                                      in excel
# Ausgabe:
    
    # Die letzte gewandelte Datei wird zurückgegeben
    
    # d       Datenstruktur äquidistant fängt mit Zeitvektor (Spaltenvektor) an
#         z.B. d.time = [0;0.01;0.02; ... ]
#              d.F    = [1;1.05;1.10; ... ]
#              ...
# u       Unitstruktur mit Unitnamen
#         u.time = 's'
#         u.F    = 'N'
#         ...
# h       Header-Cellarray mit Kommentaren
#         h{1}  hat die Beschreibung aus description.txt, wenn vorhanden
#         h{2}  Struktur c mit beschreibungen, wenn vorgegeben
#               z.B. c.time = 'Zeitvektor' ...
    
    
    okay=1
# cg_convert_meas_data.m:291
    d=[]
# cg_convert_meas_data.m:293
    u=[]
# cg_convert_meas_data.m:294
    e=[]
# cg_convert_meas_data.m:295
    h=cellarray([])
# cg_convert_meas_data.m:296
    meas_dir=''
# cg_convert_meas_data.m:297
    
    # proof input of structure q
  #########################################################################
  #----------
  #----------
  # read_type
  #----------
    if (logical_not(isfield(q,'read_type'))):
        q.read_type = copy(1)
# cg_convert_meas_data.m:307
    
    if (q.read_type < 0):
        q.read_type = copy(1)
# cg_convert_meas_data.m:309
    
    if (q.read_type > 6):
        q.read_type = copy(6)
# cg_convert_meas_data.m:310
    
    
    #-------------------------------------
  # read_type == 1 (Abfrage),q.start_dir,q.read_meath_path,q.read_list
  #-------------------------------------
    if ((q.read_type == 1) or (q.read_type == 2)):
        if (logical_not(isfield(q,'start_dir'))):
            q.start_dir = copy(pwd)
# cg_convert_meas_data.m:317
        else:
            if (logical_not(exist(q.start_dir,'dir'))):
                q.start_dir = copy('D:\:')
# cg_convert_meas_data.m:320
        #--------------------------------------------
  # read_type == 3 (Messpfad),q.read_meath_path
  #--------------------------------------------
    else:
        if (q.read_type == 3):
            if (logical_not(isfield(q,'read_meas_path'))):
                error('cg_convert_meas_data: read_meas_path muss angegeben sein (q.read_type = 3)')
            else:
                if (logical_not(exist(q.read_meas_path,'dir'))):
                    error('cg_convert_meas_data: Verzeichnis <%s> falsch',q.read_meas_path)
  #--------------------------------------------
  # read_type == 4 (Liste),q.read_list
  #--------------------------------------------
        else:
            if (q.read_type == 4):
                if (logical_not(isfield(q,'read_list'))):
                    error('cg_convert_meas_data: read_list muss angegeben sein (q.read_type = 4)')
                else:
                    if (logical_not(iscell(q.read_list))):
                        error('cg_convert_meas_data: read_list muss ein cell array sein (q.read_type = 4)')
                    else:
                        for i in arange(1,length(q.read_list)).reshape(-1):
                            if (logical_not(exist(q.read_list[i],'file')) and logical_not(exist(q.read_list[i],'dir'))):
                                error('cg_convert_meas_data: Verzeichnis/File q.read_list{%i}='%s' nicht gefunden',q.read_list[i])
    
    
  #-----------------------------------------------------
  # time
  #-----------------------------------------------------
  # q.delta_t          time step to build d.time
    if (logical_not(isfield(q,'delta_t'))):
        q.delta_t = copy(0.01)
# cg_convert_meas_data.m:356
    
    # q.zero_time        0/1 zero time in vector d.time
    if (logical_not(isfield(q,'zero_time'))):
        q.zero_time = copy(1)
# cg_convert_meas_data.m:360
    
    # q.tstart           start time, if to cut measurement q.tstart < 0 has no influence
  #                    (default -1.)
    if (logical_not(isfield(q,'tstart'))):
        q.tstart = copy(- 1)
# cg_convert_meas_data.m:365
    
    # q.tend             end time, if to cut measurement q.tend < 0 has no influence
  #                    (default -1.)
    if (logical_not(isfield(q,'tend'))):
        q.tend = copy(- 1)
# cg_convert_meas_data.m:370
    
    # q.timeout          timeout if no signal is set in timeout, signal in
#                    d-strucure will be set to zero
    if (logical_not(isfield(q,'timeout'))):
        q.timeout = copy(- 1)
# cg_convert_meas_data.m:375
    
    if (logical_not(isfield(q,'timeout_destraj'))):
        q.timeout_destraj = copy(0.01)
# cg_convert_meas_data.m:378
    
    # q.delta_t0         In d-Struktur wird delta_t0 zu Beginn abgeschnitten
# q.delta_t1         In d-Struktur wird delta_t1 am Ende abgeschnitten
    if (logical_not(isfield(q,'delta_t0'))):
        q.delta_t0 = copy(- 1)
# cg_convert_meas_data.m:383
    
    if (logical_not(isfield(q,'delta_t1'))):
        q.delta_t1 = copy(- 1)
# cg_convert_meas_data.m:386
    
    #-----------------------------------------------------
  # CAN-Messung
  #-----------------------------------------------------
    if (logical_not(isfield(q,'CANread'))):
        q.CANread = copy(0)
# cg_convert_meas_data.m:393
    
    
    if (q.CANread):
        if (logical_not(isfield(q,'CANstruct'))):
            q.CANstruct = copy([])
# cg_convert_meas_data.m:399
        if (logical_not(isfield(q,'CANuse'))):
            q.CANuse = copy([])
# cg_convert_meas_data.m:402
        s=[]
# cg_convert_meas_data.m:405
        ns=0
# cg_convert_meas_data.m:406
        for i in arange(1,length(q.CANuse)).reshape(-1):
            ii=q.CANuse(i)
# cg_convert_meas_data.m:410
            if (ii > length(SCG.CANSTRUCT)):
                error('q.CANuse(%i) = %i ist ein zugroßer Wert',i,ii)
            ns=ns + 1
# cg_convert_meas_data.m:414
            s(ns).channel = copy(SCG.CANSTRUCT(ii).channel)
# cg_convert_meas_data.m:415
            s(ns).dbcFile = copy(SCG.CANSTRUCT(ii).dbcFile)
# cg_convert_meas_data.m:416
            s(ns).mFile = copy(SCG.CANSTRUCT(ii).mFile)
# cg_convert_meas_data.m:417
            if (isfield(SCG.CANSTRUCT,'Ssig') and logical_not(isempty(SCG.CANSTRUCT(ii).Ssig))):
                s(ns).Ssig = copy(SCG.CANSTRUCT(ii).Ssig)
# cg_convert_meas_data.m:419
            else:
                s(ns).Ssig = copy([])
# cg_convert_meas_data.m:421
        # eigene CAN-Signalliste bearbeiten
        if (logical_not(isempty(q.CANstruct))):
            if (logical_not(isfield(q.CANstruct,'dbcFile'))):
                error('In q.CANstruct fehlt q.CANstruct(i).dbcFile ; Das dbc-File')
            else:
                if (logical_not(isfield(q.CANstruct,'channel'))):
                    error('In q.CANstruct fehlt q.CANstruct(i).channel ; Der Kanal (1,2,..)')
                    #       elseif(~isfield(q.CANstruct,'Ssig') )
#         error('In q.CANstruct fehlt q.CANstruct(i).Ssig ; Struktur mit gesuchten Signalen');
            for i in arange(1,length(q.CANstruct)).reshape(-1):
                ns=ns + 1
# cg_convert_meas_data.m:436
                s(ns).dbcFile = copy(q.CANstruct(i).dbcFile)
# cg_convert_meas_data.m:437
                s(ns).channel = copy(q.CANstruct(i).channel)
# cg_convert_meas_data.m:438
                s(ns).mFile = copy(q.CANstruct(i).mFile)
# cg_convert_meas_data.m:439
                if (check_val_in_struct(q.CANstruct(i),'messFile','char',1)):
                    s(ns).messFile = copy(q.CANstruct(i).messFile)
# cg_convert_meas_data.m:441
                else:
                    s(ns).messFile = copy('')
# cg_convert_meas_data.m:443
        # reste CANstruct
        q.CANstruct = copy(s)
# cg_convert_meas_data.m:448
        q.n_CANstruct = copy(ns)
# cg_convert_meas_data.m:449
    else:
        q.n_CANstruct = copy(0)
# cg_convert_meas_data.m:451
    
    if (logical_not(isfield(q,'wand_Tx_in_Rx'))):
        q.wand_Tx_in_Rx = copy(0)
# cg_convert_meas_data.m:455
    
    
    if (logical_not(check_val_in_struct(q,'CANFileNameExclude','cell'))):
        q.CANFileNameExclude = copy(cellarray([]))
# cg_convert_meas_data.m:459
    
    if (logical_not(check_val_in_struct(q,'CANFileNameTACC','char'))):
        q.CANFileNameTACC = copy('')
# cg_convert_meas_data.m:462
    else:
        s_file=str_get_pfe_f(q.CANFileNameTACC)
# cg_convert_meas_data.m:464
        q.CANFileNameTACC = copy(s_file.name)
# cg_convert_meas_data.m:465
    
    # Proof Names
    for i in arange(1,length(q.CANFileNameExclude)).reshape(-1):
        s_file=str_get_pfe_f(q.CANFileNameExclude[i])
# cg_convert_meas_data.m:470
        q.CANFileNameExclude[i]=s_file.name
# cg_convert_meas_data.m:471
    
    #-----------------------------------------------------
  # TACC-Messung
  #-----------------------------------------------------
    if (logical_not(isfield(q,'TACCread'))):
        q.TACCread = copy(0)
# cg_convert_meas_data.m:477
    
    if (logical_not(isfield(q,'TaccChannels'))):
        q.TaccChannels = copy(cellarray([]))
# cg_convert_meas_data.m:480
    else:
        q.TaccChannels = copy(cell_reduce_double_elements(q.TaccChannels))
# cg_convert_meas_data.m:482
    
    
    if (q.TACCread):
        if (logical_not(isfield(q,'TaccConvDir'))):
            q.TaccConvDir = copy(taccconv_dos_get)
# cg_convert_meas_data.m:488
        if (logical_not(isfield(q,'TaccUseOldNames'))):
            q.TaccUseOldNames = copy(1)
# cg_convert_meas_data.m:492
        if (logical_not(exist(q.TaccConvDir,'dir'))):
            echo('%s: Das TaccConv-Verzeichnis q.TaccConvDir='%s' konnte nicht gefunden werden',q.TaccConvDir)
        else:
            fprintf('q.TaccConvDir = '%s'\n',q.TaccConvDir)
    
    
    if (logical_not(check_val_in_struct(q,'calc_offset_tacc_can','num',1))):
        q.calc_offset_tacc_can = copy(0)
# cg_convert_meas_data.m:503
    
    
    if (q.calc_offset_tacc_can == 3):
        if (logical_not(check_val_in_struct(q,'calc_offset_tacc_signal','char'))):
            q.calc_offset_tacc_signal = copy('VehicleDynamicsIn_signals_speed')
# cg_convert_meas_data.m:508
        if (logical_not(check_val_in_struct(q,'calc_offset_can_signal','char'))):
            q.calc_offset_can_signal = copy('PrivCAN_VehSpd')
# cg_convert_meas_data.m:511
    
    #-----------------------------------------------------
  # ECAL-Messung
  #-----------------------------------------------------
    if (logical_not(isfield(q,'ECALread'))):
        q.ECALread = copy(0)
# cg_convert_meas_data.m:519
    
    if (logical_not(isfield(q,'ECALChannels'))):
        q.ECALChannels = copy(cellarray([]))
# cg_convert_meas_data.m:522
    else:
        q.ECALChannels = copy(cell_reduce_double_elements(q.ECALChannels))
# cg_convert_meas_data.m:524
    
    
    if (logical_not(isfield(q,'ECALUnitLinDatei'))):
        q.ECALUnitLinDatei = copy('cg_e_struct_units_lin.dat')
# cg_convert_meas_data.m:528
    
    
    if (logical_not(isfield(q,'ECALStructOutput'))):
        q.ECALStructOutput = copy(0)
# cg_convert_meas_data.m:532
    
    
    
    if (q.ECALread):
        q.TACCread = copy(0)
# cg_convert_meas_data.m:537
    
    
    #-----------------------------------------------------
  # data-Modifikation
  #-----------------------------------------------------
    
    # find limits in e-data
  #----------------------
    if (logical_not(isfield(q,'find_limit_by_plot'))):
        q.find_limit_by_plot = copy(0)
# cg_convert_meas_data.m:547
    
    if (q.find_limit_by_plot):
        if (logical_not(isfield(q,'find_limit_sig_name'))):
            q.find_limit_sig_name = copy(cellarray([]))
# cg_convert_meas_data.m:551
    
    
    # add e-data
  #------------
    if (logical_not(isfield(q,'add_estruct'))):
        q.add_estruct = copy([])
# cg_convert_meas_data.m:558
    else:
        okay,q.add_estruct=e_data_check(q.add_estruct,nargout=2)
# cg_convert_meas_data.m:560
        if (logical_not(okay)):
            error('Error_%s: q.add_estruct is not correct',mfilename)
    
    
    
    # modify e-data
  #--------------
    if (logical_not(isfield(q,'mod_eDataFkt'))):
        q.mod_eDataFkt = copy('')
# cg_convert_meas_data.m:571
    
    
    if (ischar(q.mod_eDataFkt)):
        q.mod_eDataFkt = copy(cellarray([q.mod_eDataFkt]))
# cg_convert_meas_data.m:575
    else:
        if (logical_not(iscell(q.mod_eDataFkt))):
            error('q.mod_eDataFkt muss char oder cellarray sein')
    
    
    q.eFkt = copy([])
# cg_convert_meas_data.m:580
    q.n_eFkt = copy(0)
# cg_convert_meas_data.m:581
    for i in arange(1,length(q.mod_eDataFkt)).reshape(-1):
        if (logical_not(isempty(q.mod_eDataFkt[i]))):
            s=str_get_pfe_f(q.mod_eDataFkt[i])
# cg_convert_meas_data.m:584
            q.n_eFkt = copy(q.n_eFkt + 1)
# cg_convert_meas_data.m:585
            q.eFkt(q.n_eFkt).name = copy(s.name)
# cg_convert_meas_data.m:586
            q.eFkt(q.n_eFkt).dir = copy(s.dir)
# cg_convert_meas_data.m:587
    
    
    # standard modify d-data
  #--------------
    if (logical_not(isfield(q,'mod_dDataCG'))):
        q.mod_dDataCG = copy(1)
# cg_convert_meas_data.m:594
    
    
    # modify d-data
  #--------------
    if (logical_not(isfield(q,'mod_dDataFkt'))):
        q.mod_dDataFkt = copy('')
# cg_convert_meas_data.m:600
    
    
    if (ischar(q.mod_dDataFkt)):
        q.mod_dDataFkt = copy(cellarray([q.mod_dDataFkt]))
# cg_convert_meas_data.m:604
    else:
        if (logical_not(iscell(q.mod_dDataFkt))):
            error('q.mod_dDataFkt muss char oder cellarray sein')
    
    
    q.dFkt = copy([])
# cg_convert_meas_data.m:609
    q.n_dFkt = copy(0)
# cg_convert_meas_data.m:610
    for i in arange(1,length(q.mod_dDataFkt)).reshape(-1):
        if (logical_not(isempty(q.mod_dDataFkt[i]))):
            s=str_get_pfe_f(q.mod_dDataFkt[i])
# cg_convert_meas_data.m:613
            q.n_dFkt = copy(q.n_dFkt + 1)
# cg_convert_meas_data.m:614
            q.dFkt(q.n_dFkt).name = copy(s.name)
# cg_convert_meas_data.m:615
            q.dFkt(q.n_dFkt).dir = copy(s.dir)
# cg_convert_meas_data.m:616
    
    
    
    # modify d-data
  #--------------
    if (logical_not(isfield(q,'save_type'))):
        q.save_type = copy('mat_duh')
# cg_convert_meas_data.m:624
    
    
    if (logical_not(strcmp(q.save_type,'mat_duh')) and logical_not(strcmp(q.save_type,'mat_dspa')) and logical_not(strcmp(q.save_type,'dia')) and logical_not(strcmp(q.save_type,'dia_asc')) and logical_not(strcmp(q.save_type,'no'))):
        error('DAtenformat <%s> zum Speichern nicht gültig !',q.save_type)
    
    
    # trigger measurement
  #--------------------
# q.trigger_measure          = 1;     # Messung wird auf einen Wert getriggert und geändert
# q.trigger_signal_name      = 'TStWhlSens';    # z.B. d.TStWhlSens wird verwendet
# q.trigger_vorschrift       = '>>';   # siehe suche_index()
# 	                                   # '>='          Wenn Signal größer gleich wird(default)
#                                      # '>','<','<='  größer/kleiner/kleiner gleich
#                                      # '=='          gleich innerhalb der Toleranz
#                                      # '==='         nächster Index, es wird der Index mit einem Rest bestimmt z.B index=10.3)
#                                      # '===='        (Index mit dem nächsten Wert)
#                                      # '>>'          vektor wird von kleiner zu größer als Wert
#                                      # '<<'          vektor wird größer zu kleiner als Wert
    
    # q.trigger_schwelle         = 2.0;       # Schwelle
# q.trigger_vorlauf_zeit     = 0.5;       # Vorlaufzeit zum abschneiden
    
    
    if (logical_not(check_val_in_struct(q,'trigger_measure','num',1))):
        q.trigger_measure = copy(0)
# cg_convert_meas_data.m:654
    
    if (q.trigger_measure):
        if (logical_not(check_val_in_struct(q,'trigger_signal_name','char',1))):
            error('Weil q.trigger_measure gesetzt, muss q.trigger_signal_name mit einem Signalnamen gesetzt sein !')
        if (logical_not(check_val_in_struct(q,'trigger_schwelle','num',1))):
            error('Weil q.trigger_measure gesetzt, muss q.trigger_schwelle mit einem Schwellwert gesetzt sein !')
        if (logical_not(check_val_in_struct(q,'trigger_vorschrift','char',1))):
            error('Weil q.trigger_measure gesetzt, muss q.trigger_vorschrift mit '==','>=','>','<','<=', ... (siehe help suche_index) gesetzt sein !')
        if (logical_not(check_val_in_struct(q,'trigger_vorlauf_zeit','num',1))):
            error('Weil q.trigger_measure gesetzt, muss q.trigger_vorlauf_zeit mit einer Vorlaufzeit gesetzt sein !')
    
    # q.cut_measurement_by_time            0/1             Soll die Messung in
#                                                      zeitlich in mehrere Messungen aufgeteilt werden
# q.cut_measurement_time                num  [s]       Zeit, in die
#                                                      aufgeteilt werden
#                                                      soll. Wird aber nur
#                                                      für d-DatenStruktur
#                                                      gemacht
    if (logical_not(check_val_in_struct(q,'cut_measurement_by_time','num',1))):
        q.cut_measurement_by_time = copy(0)
# cg_convert_meas_data.m:679
    
    if (q.cut_measurement_by_time):
        if (logical_not(check_val_in_struct(q,'cut_measurement_time','num',1))):
            q.cut_measurement_time = copy(500)
# cg_convert_meas_data.m:683
    
    
    # Wandle nur neue
  #----------------
    if (logical_not(check_val_in_struct(q,'wand_new','num',1))):
        q.wand_new = copy(0)
# cg_convert_meas_data.m:690
    
    # Beschreibung
  #----------------
    if (logical_not(check_val_in_struct(q,'write_signal_description','num',1))):
        q.write_signal_description = copy(0)
# cg_convert_meas_data.m:696
    
    
    #########################################################################
  #########################################################################
  #########################################################################
  # read input
  #########################################################################
  #########################################################################
  #########################################################################
  #########################################################################
  #-----------------------------------------------------
  # Liste mit einzulesenden can- und tacc-Messungen
  #-----------------------------------------------------
    fliste=cg_get_can_asc_filenames(q)
# cg_convert_meas_data.m:710
    n_fliste=length(fliste)
# cg_convert_meas_data.m:711
    
    # Liste durchlaufen
  #-----------------------------------------------------
    for i_fliste in arange(1,n_fliste).reshape(-1):
        d=[]
# cg_convert_meas_data.m:718
        u=[]
# cg_convert_meas_data.m:719
        h=cellarray([])
# cg_convert_meas_data.m:720
        if (isempty(q.add_estruct)):
            e=[]
# cg_convert_meas_data.m:722
        else:
            e=q.add_estruct
# cg_convert_meas_data.m:724
        f=fliste(i_fliste)
# cg_convert_meas_data.m:727
        meas_dir=f.meas_dir
# cg_convert_meas_data.m:728
        fprintf('===========================================================================\n')
        fprintf('i_fliste = %i\n',i_fliste)
        fprintf('name     = %s\n',f.name)
        fprintf('meas_dir = %s\n',meas_dir)
        fprintf('===========================================================================\n')
        filename_e=fullfile(f.meas_dir,concat([f.name,'_e.mat']))
# cg_convert_meas_data.m:735
        if (q.ECALStructOutput):
            filename_pb=fullfile(f.meas_dir,concat([f.name,'_ecal.mat']))
# cg_convert_meas_data.m:737
        add_name_wand=''
# cg_convert_meas_data.m:739
        q.existing_channel_names = copy(cellarray([]))
# cg_convert_meas_data.m:740
        if (q.wand_new == 1):
            if (exist(filename_e,'file')):
                okay,q.e1,ff1=e_data_read_mat(filename_e,nargout=3)
# cg_convert_meas_data.m:743
                if (okay):
                    q.existing_channel_names = copy(cg_convert_meas_data_get_channel_names(q.e1))
# cg_convert_meas_data.m:745
        # description-file auslesen
      #--------------------------
        S=cg_convert_meas_data_get_descrip(f)
# cg_convert_meas_data.m:752
        #------------
        h[length(h) + 1]=concat([S.measurement,'/',S.date,'/',S.comment])
# cg_convert_meas_data.m:756
        #----------------
        if (q.CANread):
            if (q.wand_Tx_in_Rx):
                cg_convert_meas_data_CAN_TxRx(f)
            if (logical_not(isempty(f.can_file)) and exist(fullfile(f.meas_dir,f.can_file),'file')):
                ee=cg_convert_meas_data_CAN(f,q,S)
# cg_convert_meas_data.m:765
                e=merge_struct_f(e,ee)
# cg_convert_meas_data.m:766
        # TACC-data
      #----------
        if (q.TACCread):
            ee=cg_convert_meas_data_TACC(f,q)
# cg_convert_meas_data.m:772
            #----------
        else:
            if (q.ECALread == 1):
                ee,pb=cg_convert_meas_data_ECAL(f,q,nargout=2)
# cg_convert_meas_data.m:776
                # Zeit nullen
                if (logical_not(isempty(ee))):
                    __,tstartmin,__=e_data_get_tstart(ee,nargout=3)
# cg_convert_meas_data.m:781
                    ee=e_data_subtract_timeoffset(ee,tstartmin)
# cg_convert_meas_data.m:782
                    if (logical_not(isempty(pb))):
                        pb=pb_data_subtract_timeoffset(pb,tstartmin)
# cg_convert_meas_data.m:784
            else:
                if (q.ECALread == 2):
                    ee=cg_convert_meas_data_ECAL2(f,q)
# cg_convert_meas_data.m:788
                    # Zeit nullen
                    if (logical_not(isempty(ee))):
                        __,tstartmin,__=e_data_get_tstart(ee,nargout=3)
# cg_convert_meas_data.m:793
                        ee=e_data_subtract_timeoffset(ee,tstartmin)
# cg_convert_meas_data.m:794
        if (q.TACCread or q.ECALread):
            if (q.CANread and (q.calc_offset_tacc_can == 1) and isfield(ee,'VehicleDynamicsIn_signals_speed') and isfield(e,'PrivCAN_VehSpd')):
                #         figure(199)
  #         plot(ee.VehicleDynamicsIn_signals_speed.time,ee.VehicleDynamicsIn_signals_speed.vec*3.6,'b-')
  #         hold on
  #         plot(e.VehSpd.time,e.VehSpd.vec,'k-')
  #         hold off
                e=cg_merge_tac_can(ee,e,'VehicleDynamicsIn_signals_speed','PrivCAN_VehSpd')
# cg_convert_meas_data.m:810
                #         plot(e.VehicleDynamicsIn_signals_speed.time,e.VehicleDynamicsIn_signals_speed.vec*3.6,'b-')
  #         hold on
  #         plot(e.VehSpd.time,e.VehSpd.vec,'k-')
  #         hold off
            else:
                if (q.CANread and (q.calc_offset_tacc_can == 2) and isfield(ee,'VehicleDynamicsIn_signals_steering_wheel_angle') and (isfield(e,'PTCAN_LH3_BLW') or isfield(e,'PrivCAN_StW_Angl'))):
                    #         figure(199)
  #         plot(ee.VehicleDynamicsIn_signals_steeringWheelAngle.time,ee.VehicleDynamicsIn_signals_steeringWheelAngle.vec,'b-')
  #         hold on
  #         plot(e.PTCAN_LH3_BLW.time,e.PTCAN_LH3_BLW.vec,'k-')
  #         hold off
                    if (isfield(e,'PTCAN_LH3_BLW')):
                        e=cg_merge_tac_can(ee,e,'VehicleDynamicsIn_signals_steering_wheel_angle','PTCAN_LH3_BLW')
# cg_convert_meas_data.m:828
                    else:
                        e=cg_merge_tac_can(ee,e,'VehicleDynamicsIn_signals_steering_wheel_angle','PrivCAN_StW_Angl')
# cg_convert_meas_data.m:830
                    #         figure(200)
  #         plot(e.VehicleDynamicsIn_signals_steeringWheelAngle.time,e.VehicleDynamicsIn_signals_steeringWheelAngle.vec,'b-')
  #         hold on
  #         plot(e.PTCAN_LH3_BLW.time,e.PTCAN_LH3_BLW.vec,'k-')
  #         hold off
                else:
                    if (q.CANread and (q.calc_offset_tacc_can == 3) and isfield(ee,q.calc_offset_tacc_signal) and (isfield(e,q.calc_offset_can_signal))):
                        #         figure(199)
  #         plot(ee.VehicleDynamicsIn_signals_steeringWheelAngle.time,ee.VehicleDynamicsIn_signals_steeringWheelAngle.vec,'b-')
  #         hold on
  #         plot(e.PTCAN_LH3_BLW.time,e.PTCAN_LH3_BLW.vec,'k-')
  #         hold off
                        e=cg_merge_tac_can(ee,e,q.calc_offset_tacc_signal,q.calc_offset_can_signal)
# cg_convert_meas_data.m:847
                        #         plot(e.VehicleDynamicsIn_signals_steeringWheelAngle.time,e.VehicleDynamicsIn_signals_steeringWheelAngle.vec,'b-')
  #         hold on
  #         plot(e.PTCAN_LH3_BLW.time,e.PTCAN_LH3_BLW.vec,'k-')
  #         hold off
                    else:
                        e=merge_struct_f(e,ee)
# cg_convert_meas_data.m:854
        # find limits in e-data
      #-------------------------------
        if (q.find_limit_by_plot):
            q=cg_convert_find_limit_eData(e,q)
# cg_convert_meas_data.m:862
        # modify e-data by own functions
      #-------------------------------
        if (logical_not(isempty(e))):
            e=cg_convert_meas_data_eFkt(e,q)
# cg_convert_meas_data.m:868
        if (isempty(e)):
            warning('Aus der Messung <%s> sind keine Daten eingelsen worden!\n<%s>',f.name,f.meas_dir)
        else:
            # e-Struktur beschneiden
        #-----------------------
            e,fflag=e_data_reduce_time(e,q.tstart,q.tend,q.zero_time,nargout=2)
# cg_convert_meas_data.m:878
            if (fflag):
                fprintf('===========================================================================\n')
                fprintf('e_data-struct reduced to \n tstart = %f [s]\n tend = %f [s]\n zeroflag = %f \n',q.tstart,q.tend,q.zero_time)
                fprintf('===========================================================================\n')
            # e-Struktur speichern
        #---------------------
            eval(concat(['save '',filename_e,'' e']))
            fprintf('e-struct-Datei: <%s>\n',filename_e)
            #---------------------
            if (q.ECALStructOutput):
                eval(concat(['save '',filename_pb,'' pb']))
                fprintf('pb-struct-Datei: <%s>\n',filename_pb)
            # beschreibung
            if (q.write_signal_description):
                filename_excel=fullfile(f.meas_dir,concat([f.name,'.xlsx']))
# cg_convert_meas_data.m:900
                if (exist(filename_excel,'file')):
                    delete(filename_excel)
                e_data_print_signal_names_excel(e,filename_excel)
                fprintf('excel-Datei: <%s>\n',filename_excel)
            # e -> d bringen
        #---------------
            if (struct_isempty(e)):
                warning('e-structure is empty')
            else:
                if (logical_not(strcmp(q.save_type,'no'))):
                    d,u,c=d_data_read_e(e,q.delta_t,q.zero_time,q.tstart,q.tend,q.timeout,nargout=3)
# cg_convert_meas_data.m:913
                    if (q.delta_t0 >= 0.0 or q.delta_t0 >= 0.0):
                        if (q.delta_t0 > eps):
                            fprintf('delta_t0 = %f, wird zu Beginn abgeschnitten\n',q.delta_t0)
                        if (q.delta_t1 > eps):
                            fprintf('delta_t1 = %f, wird am Ende abgeschnitten\n',q.delta_t1)
                        d=struct_reduce_vecs_to_delta_t(d,q.delta_t0,q.delta_t1,'time',q.zero_time)
# cg_convert_meas_data.m:918
                    # modify d,u,c-data standard
          #---------------------------
                    if (q.mod_dDataCG):
                        d,u,c=cg_mod_d_data(d,u,c,nargout=3)
# cg_convert_meas_data.m:924
                    # modify d,u,c-data by own functions
          #------------------------------------
                    d,u,c=cg_convert_meas_data_dFkt(d,u,c,q,nargout=3)
# cg_convert_meas_data.m:929
                    #--------------------------------
                    if (q.trigger_measure):
                        d=d_data_trigger(d,q.trigger_signal_name,q.trigger_schwelle,q.trigger_vorschrift,q.trigger_vorlauf_zeit)
# cg_convert_meas_data.m:935
                    # Kommentar in Header einfügen
          #-----------------------------
                    h[length(h) + 1]=c
# cg_convert_meas_data.m:942
                    if 'mat_dspa' == (q.save_type):
                        filename=fullfile(f.meas_dir,concat([f.name,add_name_wand,'.mat']))
# cg_convert_meas_data.m:946
                        okay=d_data_save(filename,d,u,h,'dspa')
# cg_convert_meas_data.m:947
                        fprintf('Mat-Ausgabe-Datei dspa-Format: <%s>\n========================================================================================================\n',filename)
                    else:
                        if 'mat_duh' == (q.save_type):
                            filename=fullfile(f.meas_dir,concat([f.name,add_name_wand,'.mat']))
# cg_convert_meas_data.m:950
                            okay=d_data_save(filename,d,u,h,'duh')
# cg_convert_meas_data.m:951
                            fprintf('Mat-Ausgabe-Datei duh-Format: <%s>\n========================================================================================================\n',filename)
                        else:
                            if 'dia' == (q.save_type):
                                filename=fullfile(f.meas_dir,concat([f.name,add_name_wand,'.dat']))
# cg_convert_meas_data.m:954
                                okay=d_data_save(filename,d,u,h,'dia')
# cg_convert_meas_data.m:955
                                fprintf('Mat-Ausgabe-Datei dia-Format: <%s>\n========================================================================================================\n',filename)
                            else:
                                if 'dia_asc' == (q.save_type):
                                    filename=fullfile(f.meas_dir,concat([f.name,add_name_wand,'.dat']))
# cg_convert_meas_data.m:958
                                    okay=d_data_save(filename,d,u,h,'dia_asc')
# cg_convert_meas_data.m:959
                                    fprintf('Mat-Ausgabe-Datei diadem-Format: <%s>\n========================================================================================================\n',filename)
                                else:
                                    if 'no' == (q.save_type):
                                        fprintf('keine speicherung\n')
                                    else:
                                        warning('Kein gültiges Format für <%s>\n========================================================================================================\n',q.save_type)
                    if (q.cut_measurement_by_time):
                        slices,nslices=vektor_cut_in_slices(d.time,q.cut_measurement_time,'u',nargout=2)
# cg_convert_meas_data.m:970
                        if ((nslices > 1) and logical_not(isempty(f.can_file))):
                            ascii_file=fullfile(f.meas_dir,f.can_file)
# cg_convert_meas_data.m:973
                            if (exist(ascii_file,'file')):
                                b=mexReadCANBytes(ascii_file)
# cg_convert_meas_data.m:975
                                b.time = copy(b.time - (b.time(1) - slices(1).xstart))
# cg_convert_meas_data.m:976
                                b.n = copy(length(b.time))
# cg_convert_meas_data.m:977
                        if (nslices > 1):
                            okay=1
# cg_convert_meas_data.m:982
                            for i in arange(1,nslices).reshape(-1):
                                if (logical_not(strcmp(q.save_type,'no'))):
                                    filenameout=concat([f.name,'_',num2str(round(slices(i).xstart)),'_',num2str(round(slices(i).xend))])
# cg_convert_meas_data.m:986
                                    filenameout=fullfile(f.meas_dir,concat([filenameout,'_e.mat']))
# cg_convert_meas_data.m:987
                                    okay=e_data_reduce_file_by_time(slices(i).xstart,slices(i).xend,0,filename_e,filenameout)
# cg_convert_meas_data.m:988
                                    if (okay):
                                        fprintf('e-struct-Datei: <%s>\n',filenameout)
                                    else:
                                        error('e_data_reduce_file_by_time(slices(%i).xstart=%f,slices(%i).xend=%f,0,'%s','%s'); ging nicht',i,slices(i).xstart,slices(i).xend,filename_e,filenameout)
                                if (logical_not(okay)):
                                    break
                                # d-Struktur
                                filenameout=concat([f.name,'_',num2str(round(slices(i).xstart)),'_',num2str(round(slices(i).xend))])
# cg_convert_meas_data.m:1001
                                filenameout=fullfile(f.meas_dir,concat([filenameout,'.mat']))
# cg_convert_meas_data.m:1002
                                okay=d_data_reduce_file_by_time(slices(i).xstart,slices(i).xend,0,filename,q.save_type,filenameout)
# cg_convert_meas_data.m:1003
                                if (logical_not(okay)):
                                    break
                                # ascii-Datei
                                if ((nslices > 1) and logical_not(isempty(f.can_file))):
                                    if (exist(ascii_file,'file')):
                                        filenameout=concat([f.name,'_',num2str(round(slices(i).xstart)),'_',num2str(round(slices(i).xend))])
# cg_convert_meas_data.m:1011
                                        filenameout=fullfile(f.meas_dir,concat([filenameout,'.asc']))
# cg_convert_meas_data.m:1012
                                        i0=min(b.n,max(1,suche_index(b.time,slices(i).xstart,'====','v')))
# cg_convert_meas_data.m:1013
                                        i1=min(b.n,max(1,suche_index(b.time,slices(i).xend,'====','v')))
# cg_convert_meas_data.m:1014
                                        #            b1.id      = b.id(i0:i1);
        #            b1.channel = b.channel(i0:i1);
        #            b1.len     = b.len(i0:i1);
        #            b1.byte0   = b.byte0(i0:i1);
        #            b1.byte1   = b.byte1(i0:i1);
        #            b1.byte2   = b.byte2(i0:i1);
        #            b1.byte3   = b.byte3(i0:i1);
        #            b1.byte4   = b.byte4(i0:i1);
        #            b1.byte5   = b.byte5(i0:i1);
        #            b1.byte6   = b.byte6(i0:i1);
        #            b1.byte7   = b.byte7(i0:i1);
        #            b1.receive = b.receive(i0:i1);
                                        tic
                                        mexBDataSaveAscii(b,filenameout,i0,i1)
                                        toc
                                        fprintf('ascii-Datei: <%s>\n',filenameout)
    
    
    fprintf('===========================================================================\n')
    fprintf('Ende ----------------------------------------------------------------------\n')
    fprintf('===========================================================================\n')
    
    if (nargout >= 1):
        ookay=copy(okay)
# cg_convert_meas_data.m:1048
    
    if (nargout >= 2):
        dd=copy(d)
# cg_convert_meas_data.m:1049
    
    if (nargout >= 3):
        uu=copy(u)
# cg_convert_meas_data.m:1050
    
    if (nargout >= 4):
        hh=copy(h)
# cg_convert_meas_data.m:1051
    
    if (nargout >= 5):
        ee=copy(e)
# cg_convert_meas_data.m:1052
    
    if (nargout >= 6):
        md=copy(meas_dir)
# cg_convert_meas_data.m:1053
    
    return ookay,dd,uu,hh,ee,meas_dir
    
if __name__ == '__main__':
    pass
    
    #=====================================================================================================
#=====================================================================================================
#=====================================================================================================
#=====================================================================================================
#=====================================================================================================
#=====================================================================================================
#=====================================================================================================
    
@function
def cg_convert_meas_data_get_descrip(f=None,*args,**kwargs):
    varargin = cg_convert_meas_data_get_descrip.varargin
    nargin = cg_convert_meas_data_get_descrip.nargin

    # description-file auslesen
#
    if (f.description):
        descript_file=fullfile(f.meas_dir,'description.txt')
# cg_convert_meas_data.m:1066
        S=cg_prepare_measurement_description(descript_file)
# cg_convert_meas_data.m:1067
        if (isempty(S.date) and logical_not(isempty(f.can_file))):
            a=dir(fullfile(f.meas_dir,f.can_file))
# cg_convert_meas_data.m:1069
            v=datevec(a(1).date)
# cg_convert_meas_data.m:1070
            S.date = copy(concat([num2str(v(3)),'.',num2str(v(2)),'.',num2str(v(1))]))
# cg_convert_meas_data.m:1071
    else:
        if (logical_not(isempty(f.can_file))):
            a=dir(fullfile(f.meas_dir,f.can_file))
# cg_convert_meas_data.m:1074
            a(1).date = copy(str_change_f(a(1).date,'Mrz','Mar'))
# cg_convert_meas_data.m:1075
            v=datevec(a(1).date)
# cg_convert_meas_data.m:1076
            S.measurement = copy(f.name)
# cg_convert_meas_data.m:1077
            S.date = copy(concat([num2str(v(3)),'.',num2str(v(2)),'.',num2str(v(1))]))
# cg_convert_meas_data.m:1078
            S.comment = copy('no description-file')
# cg_convert_meas_data.m:1079
        else:
            a=dir(fullfile(f.meas_dir))
# cg_convert_meas_data.m:1081
            a(1).date = copy(str_change_f(a(1).date,'Mrz','Mar'))
# cg_convert_meas_data.m:1082
            v=datevec(a(1).date)
# cg_convert_meas_data.m:1083
            S.measurement = copy(f.name)
# cg_convert_meas_data.m:1084
            S.date = copy(concat([num2str(v(3)),'.',num2str(v(2)),'.',num2str(v(1))]))
# cg_convert_meas_data.m:1085
            S.comment = copy('no description-file')
# cg_convert_meas_data.m:1086
    
    return S
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_convert_meas_data_CAN(f=None,q=None,S=None,*args,**kwargs):
    varargin = cg_convert_meas_data_CAN.varargin
    nargin = cg_convert_meas_data_CAN.nargin

    # f(i).name        = 'measxyz'          Name
# f(i).meas_dir    = 'd:\abc\measxyz'   Verzeichnis
# f(i).can_file    = 'calogXXX.asc'     can-asc-file
# f(i).tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
# f(i).description = 0/1                ist description-file vorhanden
# q.CANstruct        Zusätzliche Signalliste mit dbc-File 
#                    q.CANstruct(i).dbcFile     dbc-File mit vollständigem Pfad
#                    q.CANstruct(i).channel     channel in Messung(1,2,3,...=
#                    q.CANstruct(i).mFile       m-file um Ssig zu erzeugen
#                    q.CANstruct(i).Ssig        Signalliste mit
    e=[]
# cg_convert_meas_data.m:1101
    for i in arange(1,q.n_CANstruct).reshape(-1):
        # DBC-File mit Datum richtig zuordnen
        channel=q.CANstruct(i).channel
# cg_convert_meas_data.m:1107
        if (datum_str_to_int(S.date) < 20101026):
            if (channel == 1):
                channel=2
# cg_convert_meas_data.m:1111
            else:
                if (channel == 2):
                    channel=1
# cg_convert_meas_data.m:1113
        #       if( datum_str_to_int(S.date) < 20101101 )
#         q.dbcfile0 = q.dbcfile0_rev14573;
#       end
#       if( datum_str_to_int(S.date) < 20111121 )
#         q.dbcfile0 = q.dbcfile0_rev22917;
#       end
#       if( datum_str_to_int(S.date) < 20120730 )
#         q.dbcfile0 = q.dbcfile0_rev27932;
#       end
        # Ssig erzeugen
        if (logical_not(isfield(q.CANstruct(i),'Ssig')) or isempty(q.CANstruct(i).Ssig)):
            s_file=str_get_pfe_f(q.CANstruct(i).mFile)
# cg_convert_meas_data.m:1128
            if (logical_not(isempty(s_file.dir))):
                org_dir=copy(pwd)
# cg_convert_meas_data.m:1130
                cd(s_file.dir)
            else:
                org_dir=''
# cg_convert_meas_data.m:1133
            if (logical_not(exist(concat([s_file.name,'.m']),'file'))):
                error('M-File: %s konnte nicht gefunden werden',q.CANstruct(i).mFile)
            else:
                fprintf('M-File: <%s>\n',concat([s_file.dir,s_file.name,'.m']))
            try:
                q.CANstruct(i).Ssig = copy(eval(s_file.name))
# cg_convert_meas_data.m:1141
                if (logical_not(isempty(org_dir))):
                    cd(org_dir)
            finally:
                pass
        # Wenn TACC-Messung und Vorgabe Name CAN-Log
        if (logical_not(isempty(q.CANstruct(i).messFile))):
            s_file=str_get_pfe_f(q.CANstruct(i).messFile)
# cg_convert_meas_data.m:1151
            if (logical_not(isempty(s_file.ext))):
                t_ext=s_file.ext
# cg_convert_meas_data.m:1153
            else:
                t_ext='asc'
# cg_convert_meas_data.m:1155
            mess_extra_file=fullfile(f.meas_dir,s_file.dir,concat([s_file.name,'.',t_ext]))
# cg_convert_meas_data.m:1157
        else:
            mess_extra_file=''
# cg_convert_meas_data.m:1159
        if (logical_not(isempty(mess_extra_file))):
            mess_full_file=copy(mess_extra_file)
# cg_convert_meas_data.m:1162
        else:
            mess_full_file=fullfile(f.meas_dir,f.can_file)
# cg_convert_meas_data.m:1164
        if (exist(mess_full_file,'file')):
            ee=can_asc_read_and_filter(mess_full_file,q.CANstruct(i).dbcFile,channel,q.CANstruct(i).Ssig)
# cg_convert_meas_data.m:1168
            fprintf('signals: %i\n',length(fieldnames(ee)))
            e=merge_struct_f(e,ee)
# cg_convert_meas_data.m:1173
        else:
            warning('Datei: <%s> \n does not exist',mess_full_file)
    
    
    return e
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_convert_meas_data_TACC(f=None,q=None,*args,**kwargs):
    varargin = cg_convert_meas_data_TACC.varargin
    nargin = cg_convert_meas_data_TACC.nargin

    # f.name        = 'measxyz'          Name
# f.meas_dir    = 'd:\abc\measxyz'   Verzeichnis
# f.can_file    = 'calogXXX.asc'     can-asc-file
# f.tacc        = 0/1                ist TaskData-Verzeichnis vorhanden
# f.description = 0/1                ist description-file vorhanden
    
    e=[]
# cg_convert_meas_data.m:1187
    if (logical_not(f.tacc)):
        warning('Messpfad <%s> ist kein TaskData-Verzeichnis vorhanden',f.meas_dir)
        return e
    
    
    taskdir=fullfile(f.meas_dir,'TaskData')
# cg_convert_meas_data.m:1194
    
    # Channel-Signale einlesen
    
    for i in arange(1,length(q.TaccChannels)).reshape(-1):
        channelname=q.TaccChannels[i]
# cg_convert_meas_data.m:1200
        ii=str_find_f(channelname,'Pb','vs')
# cg_convert_meas_data.m:1202
        if (ii > 1):
            searchname=channelname(arange(1,ii - 1))
# cg_convert_meas_data.m:1204
        else:
            searchname=copy(channelname)
# cg_convert_meas_data.m:1206
        ifound=cell_find_f(q.existing_channel_names,searchname,'f')
# cg_convert_meas_data.m:1209
        if (logical_not(isempty(ifound))):
            fprintf('<-> TACC-Channel-%s-übernehmen\n',channelname)
            e1=e_data_get_signals_with_name(q.e1,searchname)
# cg_convert_meas_data.m:1213
        else:
            fprintf('-> TACC-Channel-%s-lesen\n',channelname)
            e1=cg_read_tacc_channel(taskdir,channelname,200,q.timeout_destraj,q.TaccConvDir,q.TaccUseOldNames)
# cg_convert_meas_data.m:1216
            fprintf('signals: %i\n',length(fieldnames(e1)))
            fprintf('<- TACC-Channel-%s-lesen\n',channelname)
        if (logical_not(isempty(e1))):
            e=merge_struct_f(e,e1)
# cg_convert_meas_data.m:1221
    
    return e
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_convert_meas_data_ECAL(f=None,q=None,*args,**kwargs):
    varargin = cg_convert_meas_data_ECAL.varargin
    nargin = cg_convert_meas_data_ECAL.nargin

    # f.name         = 'measxyz'                         Name
# f.meas_dir     = 'd:\abc\measxyz'                  Verzeichnis
# f.ecal         = 0/1                               ist TaskData-Verzeichnis vorhanden
# f.ecal_files   = {'d:\abc\measxyz\ecal.ecal.hdf5'} ist ecal-Verzeichnis vorhanden
    
    # q.ECALChannels      celll array with all ecal-channels to read
# q.ECALStructOutput  0/1 read ecal struct pb
    
    if (logical_not(check_val_in_struct(q,'timeout_destraj','num',1))):
        q.timeout_destraj = copy(0.0)
# cg_convert_meas_data.m:1235
    
    if (logical_not(check_val_in_struct(q,'ECALStructOutput','num',1))):
        q.ECALStructOutput = copy(0)
# cg_convert_meas_data.m:1238
    
    if (logical_not(check_val_in_struct(q,'ECALChannels','cell',1))):
        error('q.ECALChannels is not set')
    
    
    
    
    pb=[]
# cg_convert_meas_data.m:1246
    e=[]
# cg_convert_meas_data.m:1247
    for i in arange(1,length(q.ECALChannels)).reshape(-1):
        channelname=q.ECALChannels[i]
# cg_convert_meas_data.m:1249
        e1,pb1=cg_read_ecal_channel(f.meas_dir,channelname,q.timeout_destraj,q.ECALStructOutput,nargout=2)
# cg_convert_meas_data.m:1251
        if (logical_not(isempty(e1))):
            e=merge_struct_f(e,e1)
# cg_convert_meas_data.m:1254
        if (logical_not(isempty(pb1))):
            pb=merge_struct_f(pb,pb1)
# cg_convert_meas_data.m:1257
    
    
    return e,pb
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_convert_meas_data_ECAL2(f=None,q=None,*args,**kwargs):
    varargin = cg_convert_meas_data_ECAL2.varargin
    nargin = cg_convert_meas_data_ECAL2.nargin

    # f.name         = 'measxyz'                         Name
# f.meas_dir     = 'd:\abc\measxyz'                  Verzeichnis
# f.ecal         = 0/1                               ist TaskData-Verzeichnis vorhanden
# f.ecal_files   = {'d:\abc\measxyz\ecal.ecal.hdf5'} ist ecal-Verzeichnis vorhanden
    
    e=[]
# cg_convert_meas_data.m:1268
    for i in arange(1,length(q.ECALChannels)).reshape(-1):
        channelname=q.ECALChannels[i]
# cg_convert_meas_data.m:1270
        fprintf('-> ECAL-Channel-%s-lesen\n',channelname)
        e1=cg_read_ecal_channel2(f.meas_dir,channelname,q.timeout_destraj,q.ECALUnitLinDatei)
# cg_convert_meas_data.m:1272
        fprintf('signals: %i\n',length(fieldnames(e1)))
        fprintf('<- ECAL-Channel-%s-lesen\n',channelname)
        if (logical_not(isempty(e1))):
            e=merge_struct_f(e,e1)
# cg_convert_meas_data.m:1277
    
    
    return e
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_convert_meas_data_eFkt(e=None,q=None,*args,**kwargs):
    varargin = cg_convert_meas_data_eFkt.varargin
    nargin = cg_convert_meas_data_eFkt.nargin

    
    # Modifyfunction e = name(e);
    
    for i in arange(1,q.n_eFkt).reshape(-1):
        dir_org=copy(pwd)
# cg_convert_meas_data.m:1288
        if (logical_not(isempty(q.eFkt(i).dir))):
            if (logical_not(exist(q.eFkt(i).dir,'dir'))):
                error('Das Verzeichnis <%s> aus q.mod_eDataFkt{%i} exisistiert nicht !',q.eFkt(i).dir,i)
            else:
                cd(q.eFkt(i).dir)
        try:
            eval(concat(['e=',q.eFkt(i).name,'(e);']))
            fprintf('eDAtaFkt: %s\n',concat(['e=',q.eFkt(i).name,'(e);']))
        finally:
            pass
        cd(dir_org)
    
    return e
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_convert_meas_data_dFkt(d=None,u=None,c=None,q=None,*args,**kwargs):
    varargin = cg_convert_meas_data_dFkt.varargin
    nargin = cg_convert_meas_data_dFkt.nargin

    
    # Modifyfunction [d,u,c] = name(d,u,c);
    
    for i in arange(1,q.n_dFkt).reshape(-1):
        dir_org=copy(pwd)
# cg_convert_meas_data.m:1313
        if (logical_not(isempty(q.dFkt(i).dir))):
            if (logical_not(exist(q.dFkt(i).dir,'dir'))):
                error('Das Verzeichnis <%s> aus q.mod_dDataFkt{%i} exisistiert nicht !',q.dFkt(i).dir,i)
            else:
                cd(q.dFkt(i).dir)
        try:
            eval(concat(['[d,u,c]=',q.dFkt(i).name,'(d,u,c);']))
            fprintf('dDAtaFkt: %s\n',concat(['[d,u,c]=',q.dFkt(i).name,'(d,u,c);']))
        finally:
            pass
        cd(dir_org)
    
    return d,u,c
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_convert_find_limit_eData(e=None,q=None,*args,**kwargs):
    varargin = cg_convert_find_limit_eData.varargin
    nargin = cg_convert_find_limit_eData.nargin

    # Liste der vorgeschlagenen Signale überprüfen
  #---------------------------------------------
    found,time0,time1=e_data_find_x_limit_by_plot(e,cellarray(['PTCAN_LH3_LM','PTCAN_LH3_BLW','PTCAN_BR5_Bremsdruck']),nargout=3)
# cg_convert_meas_data.m:1336
    if (found):
        s.tstart = copy(time0)
# cg_convert_meas_data.m:1339
        s.tend = copy(time1)
# cg_convert_meas_data.m:1340
    
    return q
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_convert_meas_data_CAN_TxRx(f=None,*args,**kwargs):
    varargin = cg_convert_meas_data_CAN_TxRx.varargin
    nargin = cg_convert_meas_data_CAN_TxRx.nargin

    filename=fullfile(f.meas_dir,f.can_file)
# cg_convert_meas_data.m:1346
    okay,c,nzeilen=read_ascii_file(filename,nargout=3)
# cg_convert_meas_data.m:1347
    if (okay):
        c=cell_change(c,'Tx','Rx')
# cg_convert_meas_data.m:1350
        okay=write_ascii_file(filename,c)
# cg_convert_meas_data.m:1352
    
    return
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_merge_tac_can(etacc=None,ecan=None,signal_tacc=None,signal_can=None,*args,**kwargs):
    varargin = cg_merge_tac_can.varargin
    nargin = cg_merge_tac_can.nargin

    fac,offset,errtext=get_unit_convert_fac_offset(getattr(etacc,(signal_tacc)).unit,getattr(ecan,(signal_can)).unit,nargout=3)
# cg_convert_meas_data.m:1357
    if (logical_not(isempty(errtext))):
        error(errtext)
    
    ntacc=length(getattr(etacc,(signal_tacc)).time)
# cg_convert_meas_data.m:1362
    ncan=length(getattr(ecan,(signal_can)).time)
# cg_convert_meas_data.m:1363
    veccan=abs(getattr(ecan,(signal_can)).vec)
# cg_convert_meas_data.m:1365
    timecan=getattr(ecan,(signal_can)).time
# cg_convert_meas_data.m:1366
    dtcan=mean(diff(timecan))
# cg_convert_meas_data.m:1367
    vectacc=dot(abs(getattr(etacc,(signal_tacc)).vec),fac) + offset
# cg_convert_meas_data.m:1368
    timetacc=getattr(etacc,(signal_tacc)).time
# cg_convert_meas_data.m:1369
    dttacc=mean(diff(timetacc))
# cg_convert_meas_data.m:1370
    if (abs(dtcan - dttacc) > 0.001):
        timenew=concat([arange(timetacc(1),timetacc(length(timetacc)),dtcan)])
# cg_convert_meas_data.m:1372
        vectacc=interp1(timetacc,vectacc,timenew,'linear','extrap')
# cg_convert_meas_data.m:1373
        ntacc=length(timenew)
# cg_convert_meas_data.m:1374
        timetacc=copy(timenew)
# cg_convert_meas_data.m:1375
    
    
    #   figure(300)
#   plot(vectacc,'b-')
#   hold on
#   plot(veccan,'k-')
#   hold off
    
    if (ncan >= ntacc):
        ioffset=vec_find_di_offset(veccan,vectacc)
# cg_convert_meas_data.m:1385
        if (ioffset > 0):
            ecan=e_data_reduce_time(ecan,getattr(ecan,(signal_can)).time(ioffset),- 1,1)
# cg_convert_meas_data.m:1387
        else:
            ecan=e_data_reduce_time(ecan,- 1,- 1,1)
# cg_convert_meas_data.m:1389
        etacc=e_data_reduce_time(etacc,- 1,- 1,1)
# cg_convert_meas_data.m:1391
    else:
        ioffset=vec_find_di_offset(vectacc,veccan)
# cg_convert_meas_data.m:1393
        if (ioffset > 0):
            etacc=e_data_reduce_time(etacc,timetacc(ioffset),- 1,1)
# cg_convert_meas_data.m:1396
        else:
            etacc=e_data_reduce_time(etacc,- 1,- 1,1)
# cg_convert_meas_data.m:1398
        ecan=e_data_reduce_time(ecan,- 1,- 1,1)
# cg_convert_meas_data.m:1400
    
    #   veccan   = abs(ecan.(signal_can).vec);
#   timecan  = ecan.(signal_can).time;
#   dtcan    = mean(diff(timecan));
#   vectacc   = abs(etacc.(signal_tacc).vec)*fac+offset;
#   timetacc  = etacc.(signal_tacc).time;
#   dttacc    = mean(diff(timetacc));
#   figure(310)
#   plot(vectacc,'b-')
#   hold on
#   plot(veccan,'k-')
#   hold off
    
    e=merge_struct_f(ecan,etacc)
# cg_convert_meas_data.m:1414
    return e
    
if __name__ == '__main__':
    pass
    
    
@function
def cg_convert_meas_data_get_channel_names(e1=None,*args,**kwargs):
    varargin = cg_convert_meas_data_get_channel_names.varargin
    nargin = cg_convert_meas_data_get_channel_names.nargin

    existing_channel_names=cellarray([])
# cg_convert_meas_data.m:1417
    field_names=fieldnames(e1)
# cg_convert_meas_data.m:1418
    for i in arange(1,length(field_names)).reshape(-1):
        c_names,icount=str_split(field_names[i],'_',nargout=2)
# cg_convert_meas_data.m:1420
        existing_channel_names=cell_add_if_new(existing_channel_names,c_names[1])
# cg_convert_meas_data.m:1421
    
    return existing_channel_names
    
if __name__ == '__main__':
    pass
    