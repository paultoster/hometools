function eout = cg_read_tacc_channel_CanMsgLatCtrl(e,channel_name)
  e = e_data_rename_signal(e,[channel_name,'_header_timestamp'],[channel_name,'_timestamp']);
  c_names = fieldnames(e);
  n       = length(c_names);
%                    CanMsgLatCtrlPb_angle_active: [1x1 struct]
%                      CanMsgLatCtrlPb_angle_prio: [1x1 struct]
%                   CanMsgLatCtrlPb_angle_quality: [1x1 struct]
%                     CanMsgLatCtrlPb_angle_value: [1x1 struct]
%                     CanMsgLatCtrlPb_c0c1_active: [1x1 struct]
%                         CanMsgLatCtrlPb_c0c1_c0: [1x1 struct]
%                         CanMsgLatCtrlPb_c0c1_c1: [1x1 struct]
%                    CanMsgLatCtrlPb_c0c1_changed: [1x1 struct]
%                       CanMsgLatCtrlPb_c0c1_prio: [1x1 struct]
%                    CanMsgLatCtrlPb_c0c1_quality: [1x1 struct]
%                CanMsgLatCtrlPb_dev_2_pth_active: [1x1 struct]
%                    CanMsgLatCtrlPb_dev_2_pth_c0: [1x1 struct]
%                  CanMsgLatCtrlPb_dev_2_pth_prio: [1x1 struct]
%                   CanMsgLatCtrlPb_dev_2_pth_psi: [1x1 struct]
%               CanMsgLatCtrlPb_dev_2_pth_quality: [1x1 struct]
%              CanMsgLatCtrlPb_dev_2_pth_ramp_out: [1x1 struct]
%             CanMsgLatCtrlPb_dev_2_pth_timestamp: [1x1 struct]
%                     CanMsgLatCtrlPb_dev_2_pth_y: [1x1 struct]
%         CanMsgLatCtrlPb_header_timestamp_source: [1x1 struct]
%     CanMsgLatCtrlPb_header_timestamp_sync_state: [1x1 struct]
%                   CanMsgLatCtrlPb_torque_active: [1x1 struct]
%                     CanMsgLatCtrlPb_torque_prio: [1x1 struct]
%                 CanMsgLatCtrlPb_torque_ramp_out: [1x1 struct]
%                    CanMsgLatCtrlPb_torque_value: [1x1 struct]
%                 CanMsgLatCtrlPb_yaw_rate_active: [1x1 struct]
%                   CanMsgLatCtrlPb_yaw_rate_prio: [1x1 struct]
%                CanMsgLatCtrlPb_yaw_rate_quality: [1x1 struct]
%                  CanMsgLatCtrlPb_yaw_rate_value: [1x1 struct]
%                       CanMsgLatCtrlPb_timestamp: [1x1 struct]

  for i=1:n
    
    switch(c_names{i})
      
      case {[channel_name,'_torque_value']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'Nm';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case {[channel_name,''],[channel_name,'_dev_2_pth_y']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'm';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case {[channel_name,'_angle_value'],[channel_name,'_dev_2_pth_psi']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case {[channel_name,'_yaw_rate_value']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'rad/s';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;       
      case {[channel_name,'_c0c1_c0'],[channel_name,'_dev_2_pth_c0']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '1/m';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 1;
      case [channel_name,'_c0c1_c1']
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = '1/m/m';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
      case {[channel_name,'_timestamp'],[channel_name,'_header_timestamp']}
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = tin;
       eout.(c_names{i}).vec  = vin;
       eout.(c_names{i}).unit = 'us';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
      case {[channel_name,'_angle_active'] ...
           ,[channel_name,'_angle_prio'] ...
           ,[channel_name,'_angle_quality'] ...
           ,[channel_name,'_c0c1_active'] ...  
           ,[channel_name,'_c0c1_changed'] ...  
           ,[channel_name,'_c0c1_prio'] ...  
           ,[channel_name,'_c0c1_quality'] ...             
           ,[channel_name,'_dev_2_pth_active'] ...  
           ,[channel_name,'_dev_2_pth_prio'] ...  
           ,[channel_name,'_dev_2_pth_quality'] ...
           ,[channel_name,'_torque_active'] ...     
           ,[channel_name,'_torque_prio'] ...     
           ,[channel_name,'_torque_ramp_out'] ...     
           ,[channel_name,'_yaw_rate_active'] ...     
           ,[channel_name,'_yaw_rate_prio'] ...     
           ,[channel_name,'_yaw_rate_quality'] ...                
           }
       [tin,vin] = elim_nicht_monoton(e.(c_names{i}).time,e.(c_names{i}).vec);
       eout.(c_names{i}).time = double(tin);
       eout.(c_names{i}).vec  = double(vin);
       eout.(c_names{i}).unit = '-';
       eout.(c_names{i}).comment = '';
       eout.(c_names{i}).lin     = 0;
    end
  end
end

%   eout = [];
%   c_names = fieldnames(e);
%   n       = length(c_names);
% 
%   for i=1:n
%     vecname = c_names{i};
%     [tin,vin] = elim_nicht_monoton(double(e.(c_names{i}).time),double(e.(c_names{i}).vec));
% 
%     eout.(vecname).time = tin;
%     eout.(vecname).vec  = vin;
%     if(  strcmp(vecname,'CanMsgLatCtrl_torqueActive') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_torqueValue') )
%       eout.(vecname).unit = 'Nm';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_torquePrio') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_angleActive') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_angleValue') )
%       eout.(vecname).unit = 'deg';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_angleQuality') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_anglePrio') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_dev2PthActive') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_dev2PthC0') )
%       eout.(vecname).unit = '1/m';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_dev2PthY') )
%       eout.(vecname).unit = 'm';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_dev2PthPsi') )
%       eout.(vecname).unit = 'deg';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_dev2PthQuality') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_dev2PthPrio') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_c0C1Active') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_c0C1Changed') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_c0C1_C0') )
%       eout.(vecname).unit = '1/m';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_c0C1_C1') )
%       eout.(vecname).unit = '1/m/m';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_c0C1Changed') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_c0C1Quality') )
%       eout.(vecname).unit = 'enum';
%     elseif( strcmp(vecname,'CanMsgLatCtrl_c0C1Prio') )
%       eout.(vecname).unit = 'enum';
%     else
%       eout.(vecname).unit = '';
%     end    
%     
%     if(  strcmp(eout.(vecname).unit,'enum') )
%       eout.(vecname).lin  = 0;       
%     else
%       eout.(vecname).lin  = 1;       
%     end
%     eout.(vecname).comment = '';       
%   end
% end