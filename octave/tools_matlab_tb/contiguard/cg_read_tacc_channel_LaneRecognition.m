function eout = cg_read_tacc_channel_LaneRecognition(e)

  eout = [];
  
  c_names = fieldnames(e);
  n       = length(c_names);
% Channels zuordnen
%           LaneRecognition_bSystemAvailable: [1x1 struct]
%                   LaneRecognition_fB0m_m: [1x1 struct]
%                LaneRecognition_fC0hm_1pm: [1x1 struct]
%               LaneRecognition_fC1hm_1pm2: [1x1 struct]
%      LaneRecognition_fMarkingWidthLeft_m: [1x1 struct]
%     LaneRecognition_fMarkingWidthRight_m: [1x1 struct]
%                 LaneRecognition_fPsi_rad: [1x1 struct]
%               LaneRecognition_fTheta_rad: [1x1 struct]
%                  LaneRecognition_fYEgo_m: [1x1 struct]
%               LaneRecognition_mVersionNo: [1x1 struct]
%                LaneRecognition_timestamp: [1x1 struct]

  for i=1:n
    switch(c_names{i})
      case 'LaneRecognition_bSystemAvailable'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.('bSystemAvailable').time    = tin;
       eout.('bSystemAvailable').vec     = vin;
       eout.('bSystemAvailable').unit    = '-';
       eout.('bSystemAvailable').comment = '';
       eout.('bSystemAvailable').lin     = 0;
      case 'LaneRecognition_fB0m_m'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.('fB0m_m').time    = double(tin);
       eout.('fB0m_m').vec     = double(vin);
       eout.('fB0m_m').unit    = 'm';
       eout.('fB0m_m').comment = '';
       eout.('fB0m_m').lin     = 1;
      case 'LaneRecognition_fC0hm_1pm'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.('fC0hm_1pm').time = double(tin);
       eout.('fC0hm_1pm').vec  = double(vin);
       eout.('fC0hm_1pm').unit = '1/m';
       eout.('fC0hm_1pm').comment = '';
       eout.('fC0hm_1pm').lin     = 1;
      case 'LaneRecognition_fC1hm_1pm2'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.('fC1hm_1pm2').time = double(tin);
       eout.('fC1hm_1pm2').vec  = double(vin);
       eout.('fC1hm_1pm2').unit = '1/m/m';
       eout.('fC1hm_1pm2').comment = '';
       eout.('fC1hm_1pm2').lin     = 1;
      case 'LaneRecognition_fMarkingWidthLeft_m'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.('fMarkingWidthLeft_m').time = double(tin);
       eout.('fMarkingWidthLeft_m').vec  = double(vin);
       eout.('fMarkingWidthLeft_m').unit = 'm';
       eout.('fMarkingWidthLeft_m').comment = '';
       eout.('fMarkingWidthLeft_m').lin     = 1;
      case 'LaneRecognition_fMarkingWidthRight_m'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.('fMarkingWidthRight_m').time    = double(tin);
       eout.('fMarkingWidthRight_m').vec     = double(vin);
       eout.('fMarkingWidthRight_m').unit    = 'm';
       eout.('fMarkingWidthRight_m').comment = '';
       eout.('fMarkingWidthRight_m').lin     = 1;
      case 'LaneRecognition_fPsi_rad'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.('fPsi_rad').time = double(tin);
       eout.('fPsi_rad').vec  = double(vin);
       eout.('fPsi_rad').unit = 'rad';
       eout.('fPsi_rad').comment = '';
       eout.('fPsi_rad').lin     = 1;
      case 'LaneRecognition_fTheta_rad'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.('fTheta_rad').time = double(tin);
       eout.('fTheta_rad').vec  = double(vin);
       eout.('fTheta_rad').unit = 'rad';
       eout.('fTheta_rad').comment = '';
       eout.('fTheta_rad').lin     = 1;
      case 'LaneRecognition_fYEgo_m'
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.('fYEgo_m').time = double(tin);
       eout.('fYEgo_m').vec  = double(tin);
       eout.('fYEgo_m').unit = 'm';
       eout.('fYEgo_m').comment = '';
       eout.('fYEgo_m').lin     = 1;       
    end
  end
end