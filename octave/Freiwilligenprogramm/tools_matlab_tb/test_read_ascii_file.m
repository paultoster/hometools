
dbc_file     = 'D:\canalyser\dbc\contiguard\ContiGuard_VPU.dbc';

can_asc_file = 'W:\mess\canalyser\Contiguard_Passat\1008311500_Passat_Einspur\Passat_Einspur_1.asc';
% can_asc_file = 'D:\canalyser\cfg\Lindau_Passat_Test_VPU_Schreibtisch\IQF_Botschaft_Mittenfuehrung_canlog.asc';

c_signale = {'VehSpd','SALaLoIqf_c0'}; 


[okay,e] = read_can_ascii(can_asc_file,dbc_file,2,c_signale);

