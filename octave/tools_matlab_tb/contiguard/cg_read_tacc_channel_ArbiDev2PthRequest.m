function eout = cg_read_tacc_channel_ArbiDev2PthRequest(e,name)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);

% Channels zuordnen
%                        ArbiDev2PthRequest_Application: [2785x1 double]
%                   ArbiDev2PthRequest_ArbitrationState: [2785x1 double]
%              ArbiDev2PthRequest_LateralControlQuality: [2785x1 double]
%             ArbiDev2PthRequest_LateralControlPriority: [2785x1 double]
%                     ArbiDev2PthRequest_PilotControlC0: [2785x1 double]
%               ArbiDev2PthRequest_YawAngleDeviationPsi: [2785x1 double]
%                  ArbiDev2PthRequest_LateralDeviationY: [2785x1 double]
%                         ArbiDev2PthRequest_mVersionNo: [2785x1 double]
%                          ArbiDev2PthRequest_Timestamp: [2785x1 double]
%                            ArbiDev2PthRequest_flagNew: [2785x1 double]

  for i=1:n
    
    switch(c_names{i})
      case 'ArbiDev2PthRequest_Application'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'Application';
       eout.(c_names{i}).lin      = 0;
      case 'ArbiDev2PthRequest_ArbitrationState'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'ArbitrationState';
       eout.(c_names{i}).lin      = 0;
      case 'ArbiDev2PthRequest_LateralControlPriority'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'Prioritaet';
       eout.(c_names{i}).lin      = 0;
      case 'ArbiDev2PthRequest_LateralControlQuality'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'Quality';
       eout.(c_names{i}).lin      = 0;
      case 'ArbiDev2PthRequest_LateralDeviationY'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'Abweichung y';
       eout.(c_names{i}).lin      = 1;
      case 'ArbiDev2PthRequest_mVersionNo'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'VesionsNummer';
       eout.(c_names{i}).lin      = 0;
      case 'ArbiDev2PthRequest_PilotControlC0'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '1/m';
       eout.(c_names{i}).comment  = 'C0';
       eout.(c_names{i}).lin      = 1;
      case 'ArbiDev2PthRequest_Timestamp'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment  = 'timestamp';
       eout.(c_names{i}).lin      = 0;
      case 'ArbiDev2PthRequest_YawAngleDeviationPsi'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = 'Abweichung psi';
       eout.(c_names{i}).lin      = 1;
      case 'ArbiDev2PthRequest_flag_new'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'flag New';
       eout.(c_names{i}).lin      = 0;
       
    end
  end
end