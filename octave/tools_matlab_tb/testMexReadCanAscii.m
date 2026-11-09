
dbc_file     = 'D:\canalyser\dbc\contiguard\ContiGuard_VPU.dbc';

can_asc_file = 'R:\mess\canalyser\Contiguard_Passat\1008311500_Passat_Einspur\Passat_Einspur_1.asc';
% can_asc_file = 'D:\canalyser\cfg\Lindau_Passat_Test_VPU_Schreibtisch\IQF_Botschaft_Mittenfuehrung_canlog.asc';

c_signale = {'VehSpd','SALaLoIqf_c0'}; 

channel = 2;

e = mexReadCanAscii(can_asc_file,dbc_file,c_signale,channel); 

e