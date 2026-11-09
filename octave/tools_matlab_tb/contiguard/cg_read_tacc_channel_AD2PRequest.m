function eout = cg_read_tacc_channel_AD2PRequest(e,name)

  eout = [];
  c_names = fieldnames(e);
  n       = length(c_names);

% Channels zuordnen
%                               AD2PDev2PthRequest_active: [2785x1 double]
%             AD2PDev2PthRequest_lateralControlPriority: [2785x1 double]
%              AD2PDev2PthRequest_lateralControlQuality: [2785x1 double]
%                  AD2PDev2PthRequest_lateralDeviationY: [2785x1 double]
%                         AD2PDev2PthRequest_mVersionNo: [2785x1 double]
%                     AD2PDev2PthRequest_pilotControlC0: [2785x1 double]
%                          AD2PDev2PthRequest_timestamp: [2785x1 double]
%               AD2PDev2PthRequest_yawAngleDeviationPsi: [2785x1 double]
%                            AD2PDev2PthRequest_flagNew: [2785x1 double]

  for i=1:n
    
    switch(c_names{i})
      case 'AD2PDev2PthRequest_active'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'Active';
       eout.(c_names{i}).lin      = 0;
      case 'AD2PDev2PthRequest_lateralControlPriority'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'Prioritaet';
       eout.(c_names{i}).lin      = 0;
      case 'AD2PDev2PthRequest_lateralControlQuality'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'Quality';
       eout.(c_names{i}).lin      = 0;
      case 'AD2PDev2PthRequest_lateralDeviationY'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment  = 'Abweichung y';
       eout.(c_names{i}).lin      = 1;
      case 'AD2PDev2PthRequest_mVersionNo'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'VesionsNummer';
       eout.(c_names{i}).lin      = 0;
      case 'AD2PDev2PthRequest_pilotControlC0'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '1/m';
       eout.(c_names{i}).comment  = 'C0';
       eout.(c_names{i}).lin      = 1;
      case 'AD2PDev2PthRequest_timestamp'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment  = 'timestamp';
       eout.(c_names{i}).lin      = 0;
      case 'AD2PDev2PthRequest_yawAngleDeviationPsi'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment  = 'Abweichung psi';
       eout.(c_names{i}).lin      = 1;
      case 'AD2PDev2PthRequest_flag_new'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'enum';
       eout.(c_names{i}).comment  = 'flag New';
       eout.(c_names{i}).lin      = 0;
       
    end
  end
end