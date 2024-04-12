function eout = cg_read_tacc_channel_PoseOffsetCorrect(e,channel_name,use_old_names)

  eout = [];
  e = e_data_rename_signal(e,[channel_name,'_header_timestamp'],[channel_name,'_timestamp']);
if( use_old_names )
  e = e_data_rename_signal(e,[channel_name,'_dx_offset_fa_m'],[channel_name,'_dxOffsetFA_m']);
  e = e_data_rename_signal(e,[channel_name,'_dy_offset_fa_m'],[channel_name,'_dyOffsetFA_m']);
  e = e_data_rename_signal(e,[channel_name,'_dx_offset_ra_m'],[channel_name,'_dxOffsetRA_m']);
  e = e_data_rename_signal(e,[channel_name,'_dy_offset_ra_m'],[channel_name,'_dyOffsetRA_m']);
  e = e_data_rename_signal(e,[channel_name,'_dyaw_offset_rad'],[channel_name,'_dyawOffset_rad']);
  e = e_data_rename_signal(e,[channel_name,'_pose_offset_correct_m_version_no'],[channel_name,'_PoseOffsetCorrect_mVersionNo']);
end
  
  c_names = fieldnames(e);
  n       = length(c_names);
  

% Channels zuordnen
%       PoseOffsetCorrect_dxOffsetFA_m: [1x1 struct]
%       PoseOffsetCorrect_dyOffsetFA_m: [1x1 struct]
%     PoseOffsetCorrect_dyawOffset_rad: [1x1 struct]
%         PoseOffsetCorrect_mVersionNo: [1x1 struct]
%          PoseOffsetCorrect_timestamp: [1x1 struct]
% PoseOffsetCorrectPb_correction_activated

  for i=1:n
    
    switch(c_names{i})
      
      case {[channel_name,'_dxOffsetRA_m'] ...
           ,[channel_name,'_dx_offset_ra_m'] ...
           ,[channel_name,'_dyOffsetRA_m'] ...
           ,[channel_name,'_dy_offset_ra_m'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case {[channel_name,'_dxOffsetFA_m'] ...
           ,[channel_name,'_dx_offset_fa_m'] ...
           ,[channel_name,'_dyOffsetFA_m'] ...
           ,[channel_name,'_dy_offset_fa_m'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case {[channel_name,'_dyawOffset_rad'] ...
           ,[channel_name,'_dyaw_offset_rad'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case {[channel_name,'_mVersionNo'] ...
           ,[channel_name,'_m_version_no'] ...
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '-';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
      case [channel_name,'_timestamp']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
    end
  end
end