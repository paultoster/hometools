
meas_dir     = 'D:\mess\ecal\Contiguard_Passat_Li_DC_507\170711_Ffm_Waypoint\2017-07-11-14-26-07-672_TopView_VisuAndSpectraPConly';
channel_name = 'TPVehDsrdTrajPb';
channel_name = 'TrainParkLearnPathPb';
channel_name = 'VehiclePosePb';

data         =  eCAL.measurement.getData(meas_dir, {channel_name});

unit_lin_datei = 'cg_e_struct_units_lin.dat';
e = cg_read_ecal_get_vector_struct(data.(channel_name),channel_name,unit_lin_datei);

