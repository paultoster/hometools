
clear q
% q.read_type      = 1  Verzeichnis wird interaktiv ausgewählt
%                       q.start_dir angeben, um
%                       Daten-Verzeichnis auszuwählen
%                       (tacc-Messordner oder Ordner mit
%                       mat-Dateien)
%                       (q.start_dir angeben)
%                  = 2  mat-Dateien interaktiv auswählen
%                       (q.start_dir angeben)
%                  = 3  übergeordnetes Verzeichnis zu Einlesen 
%                       angeben q.read_meas_path angeben, 
%                       (q.read_meas_path angeben)
%                  = 4  Liste mit einzulesenden Messverzeichnissen 
%                       q.read_list = {'dir1',dir2'}oder
%                       explizite Canalyser-Ascii Dateien in
%                       q.read_list = {'datei1.asc','datei2.asc'}
%                       angeben
%                  (default: 2)
% q.start_dir        (q.read_type = 1,2) Start-Dir zum Suchen 
%
% q.read_meas_path   (q.read_type = 3) Verzeichnis unter dem alle 
%                                      Messungen gewandelt werden
% q.read_list        (q.read_type = 4) Liste mit Dateien (Canalyser-ascii)
%                                      oder Verzeichnissen
%
% q.mat_type                           Typ der Matlabdatei
%                                      = 'd' oder '' (default) d-Daten
%                                        Struktur mit Vektoren und einer
%                                        Zeitbasis
%                                      = 'e' oder '' (default) e-Daten
%                                        Struktur mit Vektor-struktur mit
%                                        jeweiliger Zeitbasis (s. e_data_read_mat.m)
%                                      = 'b' oder '' (default) b-Daten
%                                        CAN-Ascci-Daten
%
% q.file_number                        0/n  beliebig/n-Anzahl
q.read_type = 2;
% meas_dir einladen
if( qlast_exist(1) )
  q.start_dir = qlast_get(1);
else
  q.start_dir = 'D:\mess\tacc';
end

q.mat_type  = 'e';
q.file_number = 1;
fliste = cg_get_mat_filenames(q);

% make copy if not exist
%======================
old_name      = str_change_f(fliste(1).name,'_e','_oldnames_e','r');
old_file_name = fullfile(fliste(1).mat_dir,[old_name,'.mat']);
if( ~exist(old_file_name,'file') )
  [okay,message,copy_flag] = copy_file(fliste(1).mat_fullfile,old_file_name,0);
end
load(fliste(1).mat_fullfile);

% meas_dir speichern
if( ~isempty(fliste(1).meas_dir) )
  qlast_set(1,fliste(1).meas_dir);
end

% Daten wandeln
%==========================================================================
% VehicleDynamicsIn
%--------------------------------------------------------------------------
channel_name = 'VehicleDynamicsIn';
e = e_data_rename_signal(e,[channel_name,'_flagNew'],[channel_name,'_flag_new']);
e = e_data_rename_signal(e,[channel_name,'_signals_steeringWheelAngle'],[channel_name,'_signals_steering_wheel_angle']);
e = e_data_rename_signal(e,[channel_name,'_signals_latAcc'],[channel_name,'_signals_lat_acc']);
e = e_data_rename_signal(e,[channel_name,'_signals_longAcc'],[channel_name,'_signals_long_acc']);
e = e_data_rename_signal(e,[channel_name,'_signals_steeringWheelAngleSpeed'],[channel_name,'_signals_steering_wheel_angle_speed']);
e = e_data_rename_signal(e,[channel_name,'_signals_speedPerWheel0'],[channel_name,'_signals_speed_per_wheel0']);
e = e_data_rename_signal(e,[channel_name,'_signals_speedPerWheel1'],[channel_name,'_signals_speed_per_wheel1']);
e = e_data_rename_signal(e,[channel_name,'_signals_speedPerWheel2'],[channel_name,'_signals_speed_per_wheel2']);
e = e_data_rename_signal(e,[channel_name,'_signals_speedPerWheel3'],[channel_name,'_signals_speed_per_wheel3']);

% VehicleDynamicsIn
%--------------------------------------------------------------------------
channel_name = 'PowerTrainIn';
e = e_data_rename_signal(e,[channel_name,'_flagNew'],[channel_name,'_flag_new']);
e = e_data_rename_signal(e,[channel_name,'_err_engineSpeed'],[channel_name,'_errs_engine_speed']);
e = e_data_rename_signal(e,[channel_name,'_err_engineTorque'],[channel_name,'_errs_engine_torque']);
e = e_data_rename_signal(e,[channel_name,'_signals_engineSpeed'],[channel_name,'_signals_engine_speed']);
e = e_data_rename_signal(e,[channel_name,'_signals_gasPedalPos'],[channel_name,'_signals_gas_pedal_pos']);
e = e_data_rename_signal(e,[channel_name,'_signals_gasPedalPosGrad'],[channel_name,'_signals_gas_pedal_pos_grad']);

% VehDsrdTraj
%--------------------------------------------------------------------------
channel_name = 'VehiclePose';
e = e_data_rename_signal(e,[channel_name,'_flagNew'],[channel_name,'_flag_new']);
e = e_data_rename_signal(e,[channel_name,'_motionStatus'],[channel_name,'_motion_status']);
e = e_data_rename_signal(e,[channel_name,'_xRA_m'],[channel_name,'_x_ra_m']);
e = e_data_rename_signal(e,[channel_name,'_xCOG_m'],[channel_name,'_x_cog_m']);
e = e_data_rename_signal(e,[channel_name,'_yRA_m'],[channel_name,'_y_ra_m']);
e = e_data_rename_signal(e,[channel_name,'_yCOG_m'],[channel_name,'_y_cog_m']);

% AD2PDev2PthRequest
%--------------------------------------------------------------------------
channel_name = 'AD2PDev2PthRequest';
e = e_data_rename_signal(e,[channel_name,'_flagNew'],[channel_name,'_flag_new']);
e = e_data_rename_signal(e,[channel_name,'_lateralControlPriority'],[channel_name,'_lateral_control_priority']);
e = e_data_rename_signal(e,[channel_name,'_lateralControlQuality'],[channel_name,'_lateral_control_quality']);
e = e_data_rename_signal(e,[channel_name,'_lateralDeviationY'],[channel_name,'_lateral_deviation_y']);
e = e_data_rename_signal(e,[channel_name,'_pilotControlC0'],[channel_name,'_pilot_control_c0']);
e = e_data_rename_signal(e,[channel_name,'_yawAngleDeviationPsi'],[channel_name,'_yaw_angle_deviation_psi']);





% VehDsrdTraj
%--------------------------------------------------------------------------
channel_names = {'HAPSVehDsrdTraj','TPVehDsrdTraj','GPVehDsrdTraj','PlannerVehDsrdTraj'};
for i=1:length(channel_names)
  channel_name = channel_names{i};
  e = e_data_rename_signal(e,[channel_name,'_flagNew'],[channel_name,'_flag_new']);
  e = e_data_rename_signal(e,[channel_name,'_minLateralWidth'],[channel_name,'_min_lateral_width']);
  e = e_data_rename_signal(e,[channel_name,'_changeCounter'],[channel_name,'_change_counter']);
  e = e_data_rename_signal(e,[channel_name,'_currPosIdx'],[channel_name,'_curr_pos_idx']);
  e = e_data_rename_signal(e,[channel_name,'_lateralControlQuality'],[channel_name,'_lateral_control_quality']);
  e = e_data_rename_signal(e,[channel_name,'_lateralControlPriority'],[channel_name,'_lateral_control_priority']);
  e = e_data_rename_signal(e,[channel_name,'_worldCoord'],[channel_name,'_world_coord']);
  e = e_data_rename_signal(e,[channel_name,'_pointFrnt_*'],[channel_name,'_point_*']);
  e = e_data_rename_signal(e,[channel_name,'_pointRear_*'],[channel_name,'_p_rear_*']);   
  e = e_data_rename_signal(e,[channel_name,'_speed_speed'],[channel_name,'_speed_v']);   
  e = e_data_rename_signal(e,[channel_name,'_speed_direction'],[channel_name,'_speed_dir']);   
end

% VehDsrdTraj1
%--------------------------------------------------------------------------

if( ~isfield(e,'VehDsrdTraj1_flag_new') )
  e = convert_to_VehDsrdTraj1(e);
end
  
  
% Save File Copy old to name_old
%===============================

save(fliste(1).mat_fullfile,'e');
