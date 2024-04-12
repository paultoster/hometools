function Ssig = PQ35_46_mit_6D0_SigList
%
% Design List of signals from Powertrain-Can VW do read from measurement
%
% Ssig(i).name_in      = 'signal name';
% Ssig(i).unit_in      = 'dbc unit';
% Ssig(i).lin_in       = 0/1;
% Ssig(i).name_sign_in = 'signal name for sign';
% Ssig(i).name_out     = 'output signal name';
% Ssig(i).unit_out     = 'output unit';
% Ssig(i).comment      = 'description';
%
% name_in      is name from dbc, could also be used with two and mor names
%              in cell array {'nameold','namenew'}, if their was an change
%              in dbc, use for old measurements
% unit_in      will used if no unit is in dbc for that input signal
% lin_in       =0/1 linearise if to interpolate to a commen time base
% name_sign_in if in dbc-File is a particular signal for sign (how VW
%              uses) exist
% name_out     output name in Matlab
% unit_out     output unit
% comment      description

  c = ...
  {{                       'name_in','unit_in','lin_in',                 'name_sign_in',          'name_out','unit_out',                                                    'comment'} ...
  ,{'PT_LH2_ALT_Requested_motor_torque','Nm'     ,0       ,'PT_LH2_ALT_Req_motor_torque_Sign','PT_LH2_ALT_Requested_motor_torque'      ,'Nm'      ,'angefordertes Motormoment Lenkung'                          } ...
  ,{'PT_LH2_ALT_Req_motor_torque_Sign' ,''       ,0       ,''                             ,'PT_LH2_ALT_Req_motor_torque_Sign'    ,''        ,'Vorzeichen angefordertes Motormoment Lenkung'               } ...
  ,{'PT_LH2_ALT_Motor_torque'          ,'Nm'     ,0       ,'LH2_ALT_Motor_torque_Sign'    ,'PT_LH2_ALT_Motor_torque'      ,'Nm'      ,'aktuelles Motormoment Lenkung'                              } ...
  ,{'LH2_ALT_Motor_torque_Sign'     ,''       ,0       ,''                             ,'LH2_ALT_Motor_torque_Sign'    ,''        ,'Vorzeichen aktuelles Motormoment Lenkung'                   } ...
  ,{'PT_LH3_BLW'                       ,'deg'    ,0       ,'LH3_BLWSign'                  ,'PT_LH3_BLW'     ,'rad'     ,'Lenkwinkel Lenkungssteuergerät aus Motorbewegung'           } ...
  ,{'LH3_BLWSign'                   ,'-'      ,0       ,''                             ,'LH3_BLWSign' ,'-'       ,'Vorzeichen Lenkwinkel Lenkungssteuergerät aus Motorbewegung'} ...
  ,{'PT_LH3_LM'                        ,'Nm'     ,0       ,'LH3_LMSign'                   ,'PT_LH3_LM'      ,'Nm'      ,'gemessenes Lenkmoment Lenkungssteuergerät'                  } ...
  ,{'LH3_LMSign'                    ,''       ,0       ,''                             ,'LH3_LMSign'  ,''        ,'Vorzeichen gemessenes Lenkmoment Lenkungssteuergerät'       } ...
  ,{'PT_LW1_LRW'                       ,'deg'    ,0       ,'LW1_LRW_Sign'                 ,'PT_LW1_LRW'     ,'rad'     ,'Lenkradwinkel vom PT-CAN-Bus'                               } ...
  ,{'LW1_LRW_Sign'                  ,''       ,0       ,''                             ,'LW1_LRW_Sign' ,''        ,'Vorzeichen Lenkradwinkel Lenkungssteuergerät'               } ...
  ,{'PT_LW1_Lenk_Gesch'                ,'deg/s'  ,0       ,'LW1_Gesch_Sign'               ,'PT_LW1_Lenk_Gesch'    ,'rad/s'   ,'Lenkradwinkelgeschw Lenkungssteuergerät'                    } ...
  ,{'LW1_Gesch_Sign'                ,''       ,0       ,''                             ,'LW1_Gesch_Sign',''        ,'Vorzeichen Lenkradwinkelgeschw Lenkungssteuergerät'         } ...
  };

  Ssig = cell_liste2struct(c);

% iSig = 0;
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'PT_LH2_ALT_Requested_motor_torque';
% Ssig(iSig).unit_in      = 'Nm';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = 'PT_LH2_ALT_Req_motor_torque_Sign';
% Ssig(iSig).name_out     = 'PT_LH2_ALT_Requested_motor_torque';
% Ssig(iSig).unit_out     = 'Nm';
% Ssig(iSig).comment      = 'angefordertes Motormoment Lenkung';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'PT_LH2_ALT_Req_motor_torque_Sign';
% Ssig(iSig).unit_in      = '';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = '';
% Ssig(iSig).name_out     = 'PT_LH2_ALT_Req_motor_torque_Sign';
% Ssig(iSig).unit_out     = '';
% Ssig(iSig).comment      = 'Vorzeichen angefordertes Motormoment Lenkung';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'PT_LH2_ALT_Motor_torque';
% Ssig(iSig).unit_in      = 'Nm';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = 'LH2_ALT_Motor_torque_Sign';
% Ssig(iSig).name_out     = 'PT_LH2_ALT_Motor_torque';
% Ssig(iSig).unit_out     = 'Nm';
% Ssig(iSig).comment      = 'aktuelles Motormoment Lenkung';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'LH2_ALT_Motor_torque_Sign';
% Ssig(iSig).unit_in      = '';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = '';
% Ssig(iSig).name_out     = 'LH2_ALT_Motor_torque_Sign';
% Ssig(iSig).unit_out     = '';
% Ssig(iSig).comment      = 'Vorzeichen aktuelles Motormoment Lenkung';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'PT_LH3_BLW';
% Ssig(iSig).unit_in      = 'deg';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = 'LH3_BLWSign';
% Ssig(iSig).name_out     = 'PT_LH3_BLW';
% Ssig(iSig).unit_out     = 'rad';
% Ssig(iSig).comment      = 'Lenkwinkel Lenkungssteuergerät aus Motorbewegung';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'LH3_BLWSign';
% Ssig(iSig).unit_in      = '-';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = '';
% Ssig(iSig).name_out     = 'LH3_BLWSign';
% Ssig(iSig).unit_out     = '-';
% Ssig(iSig).comment      = 'Vorzeichen Lenkwinkel Lenkungssteuergerät aus Motorbewegung';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'PT_LH3_LM';
% Ssig(iSig).unit_in      = 'Nm';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = 'LH3_LMSign';
% Ssig(iSig).name_out     = 'PT_LH3_LM';
% Ssig(iSig).unit_out     = 'Nm';
% Ssig(iSig).comment      = 'gemessenes Lenkmoment Lenkungssteuergerät';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'LH3_LMSign';
% Ssig(iSig).unit_in      = '';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = '';
% Ssig(iSig).name_out     = 'LH3_LMSign';
% Ssig(iSig).unit_out     = '';
% Ssig(iSig).comment      = 'Vorzeichen gemessenes Lenkmoment Lenkungssteuergerät';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'PT_LW1_LRW';
% Ssig(iSig).unit_in      = 'deg';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = 'LW1_LRW_Sign';
% Ssig(iSig).name_out     = 'PT_LW1_LRW';
% Ssig(iSig).unit_out     = 'rad';
% Ssig(iSig).comment      = 'Lenkradwinkel vom PT-CAN-Bus';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'LW1_LRW_Sign';
% Ssig(iSig).unit_in      = '';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = '';
% Ssig(iSig).name_out     = 'LW1_LRW_Sign';
% Ssig(iSig).unit_out     = '';
% Ssig(iSig).comment      = 'Vorzeichen Lenkradwinkel Lenkungssteuergerät';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'PT_LW1_Lenk_Gesch';
% Ssig(iSig).unit_in      = 'deg/s';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = 'LW1_Gesch_Sign';
% Ssig(iSig).name_out     = 'PT_LW1_Lenk_Gesch';
% Ssig(iSig).unit_out     = 'rad/s';
% Ssig(iSig).comment      = 'Lenkradwinkelgeschw Lenkungssteuergerät';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in      = 'LW1_Gesch_Sign';
% Ssig(iSig).unit_in      = '';
% Ssig(iSig).lin_in       = 0;
% Ssig(iSig).name_sign_in = '';
% Ssig(iSig).name_out     = 'LW1_Gesch_Sign';
% Ssig(iSig).unit_out     = '';
% Ssig(iSig).comment      = 'Vorzeichen Lenkradwinkelgeschw Lenkungssteuergerät';
% 
% okay = struct2cell_liste(Ssig);
end
