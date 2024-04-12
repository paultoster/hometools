function Ssig = ContiGuard_VPU_SigList
%
% Design List of signals from VPU-Can do read from measurement
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
  {{                     'name_in','unit_in','lin_in','name_sign_in',                    'name_out','unit_out',                                                                          'comment'} ...
  ,{'VehSpd'                      ,'km/h'   ,0       ,''            ,'PrivCAN_VehSpd'                      ,'km/h'    ,'Fahrzeuggeschwindigkeit'                                                          } ...
  ,{'VehYawRate_Raw'              ,'deg/s'  ,0       ,''            ,'PrivCAN_VehYawRate_Raw'              ,'deg/s'   ,'Fahrzeuggierrate CAN Auflösung'                                                   } ...
  ,{'VehAccel_Y'                  ,'m/s/s'  ,0       ,''            ,'PrivCAN_VehAccel_Y'                  ,'m/s/s'   ,'Fahrzeugquerbeschleunigung'                                                       } ...
  ,{'VehAccel_X_Sen'              ,'m/s/s'  ,0       ,''            ,'PrivCAN_VehAccel_X_Sen'              ,'m/s/s'   ,'Fahrzeugquerbeschleunigung'                                                       } ...
  ,{'VehAccel_X_Est'              ,'m/s/s'  ,0       ,''            ,'PrivCAN_VehAccel_X_Est'              ,'m/s/s'   ,'Fahrzeugquerbeschleunigung Estimation'                                            } ...
  ,{'Gear'                        ,'-'      ,0       ,''            ,'PrivCAN_Gear'                        ,'-'       ,'eingelegter Gang'                                                                 } ...
  ,{'StW_Angl'                    ,'deg'    ,0       ,''            ,'PrivCAN_StW_Angl'                    ,'deg'     ,'Lenkradwinkel'                                                                    } ...
  ,{'StW_AnglSpd'                 ,'deg/s'  ,0       ,''            ,'PrivCAN_StW_AnglSpd'                 ,'deg/s'   ,'Lenkradwinkel'                                                                    } ...
  ,{'RDU_FahrerLenkmoment'        ,'Nm'     ,0       ,''            ,'PrivCAN_RDU_FahrerLenkmoment'        ,'Nm'      ,'gemessenes Fahrerhandmoment/Torsionsstab'                                         } ...
  ,{'ACCEL_PEDAL_TRAVEL'          ,'%'      ,0       ,''            ,'PrivCAN_ACCEL_PEDAL_TRAVEL'          ,'%'       ,'Fahrergaspedalstellung'                                                           } ...
  ,{'RDU_Bremsdruck'              ,'bar'    ,0       ,''            ,'PrivCAN_RDU_Bremsdruck'              ,'bar'     ,'Bremsdruck'                                                                       } ...
  ,{'RDU_Blinker'                 ,'-'      ,0       ,''            ,'PrivCAN_RDU_Blinker'                 ,'-'       ,'Blinkerstellung'                                                                  } ...
  ,{'Mode_Steering_Assistance'    ,'-'      ,0       ,''            ,'PrivCAN_Mode_Steering_Assistance'    ,'-'       ,'Wavevorgabe 1: LDW & 2:virtWall & 4:LKAS'                                         } ...
  ,{'SALaLoIqf_available'         ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqfm_available'        ,'-'       ,'Available Mittenführung'                                                          } ...
  ,{'SALaLoIqf_c0'                ,'1/m'    ,0       ,''            ,'PrivCAN_SALaLoIqfm_c0'               ,'1/m'     ,'Kurvenkrümmung Mittenführung'                                                     } ...
  ,{'SALaLoIqf_c1'                ,'1/m/m'  ,0       ,''            ,'PrivCAN_SALaLoIqfm_c1'               ,'1/m/m'   ,'Kurvenkrümmungsänderung Mittenführung'                                            } ...
  ,{'SALaLoIqf_intervType'        ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqfm_intervType'       ,'-'       ,'Intervention Typ Mittenführung bit0: LKAS on'                                     } ...
  ,{'SALaLoIqf_dy'                ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqfm_dy'               ,'m'       ,'Mittenführung Querabweichung zur Trajektorie vom Fahrzeug ausgesehen '            } ...
  ,{'SALaLoIqf_psi'               ,'rad'    ,0       ,''            ,'PrivCAN_SALaLoIqfm_psi'              ,'rad'     ,'Mittenführung Gierwinkel zur Trajektorie vom Fahrzeug ausgesehen'                 } ...
  ,{'SALaLoIqf_projection'        ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqfm_projection'       ,'m'       ,'Mittenführung Projektion'                                                         } ...
  ,{'SALaLoIqf_leftStrength'      ,'%'      ,0       ,''            ,'PrivCAN_SALaLoIqfm_leftStrength'     ,'%'       ,'Mittenführung Reduzierung links um x % <= 100% '                                  } ...
  ,{'SALaLoIqf_rightStrength'     ,'%'      ,0       ,''            ,'PrivCAN_SALaLoIqfm_rightStrength'    ,'%'       ,'Mittenführung Reduzierung rechts um x % <= 100% '                                 } ...
  ,{'SALaLoIqf_midDistL'          ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_midDistL'         ,'m'       ,'mittlere Regeldistanz links (1. Begrenzung) '                                     } ...
  ,{'SALaLoIqf_maxDistL'          ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_maxDistL'         ,'m'       ,'maximale Regeldistanz links (1. Begrenzung) '                                     } ...
  ,{'SALaLoIqf_minDistL'          ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_minDistL'         ,'m'       ,'minimale Regeldistanz links (1. Begrenzung) '                                     } ...
  ,{'SALaLoIqf_tqRampDistL'       ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_tqRampDistL'      ,'m'       ,'Anstiegsbereich Regeldistanz links (1. Begrenzung)'                               } ...
  ,{'SALaLoIqf_availableL'        ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_availableL'       ,'-'       ,'linke Spurbegrenzung vorhanden (1. Spur)'                                         } ...
  ,{'SALaLoIqf_strengthL'         ,'%'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_strengthL'        ,'%'       ,'Begrenzung Eingriff linke Spurbegrenzung (1. Spur)'                               } ...
  ,{'SALaLoIqf_intervTypeL'       ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_intervTypeL'      ,'-'       ,'Interventionstyp linke Begrenzung (1. Spur)'                                      } ...
  ,{'SALaLoIqf_c0L'               ,'1/m'    ,0       ,''            ,'PrivCAN_SALaLoIqf1_c0L'              ,'1/m'     ,'Kurvenkrümmung linken Spurbegrenzung (1. Spur)'                                   } ...
  ,{'SALaLoIqf_c1L'               ,'1/m/m'  ,0       ,''            ,'PrivCAN_SALaLoIqf1_c1L'              ,'1/m/m'   ,'Änderung Kurvenkrümmung linken Spurbegrenzung (1. Spur)'                          } ...
  ,{'SALaLoIqf_dyL'               ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_dyL'              ,'m'       ,'Querabweichung zur linken Spurbegrenzung vom Fahrzeug gesehen (1. Spur)'          } ...
  ,{'SALaLoIqf_psiL'              ,'rad'    ,0       ,''            ,'PrivCAN_SALaLoIqf1_psiL'             ,'rad'     ,'Gierwinkel zur linken Spurbegrenzung vom Fahrzeug gesehen (1. Spur)'              } ...
  ,{'SALaLoIqf_projectionL'       ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_projectionL'      ,'m'       ,'Projektionslänge für Eingriff an linker Begrenzung (1. Spur)'                     } ...
  ,{'SALaLoIqf_TypeLeft_0x171'    ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_TypeLeft'         ,'-'       ,'Type Eingriff bit0: LDW, bit1: Intv linker Begrenzung (1. Spur)'                  } ...
  ,{'SALaLoIqf_midDistR'          ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_midDistR'         ,'m'       ,'mittlere Regeldistanz rechts (1. Begrenzung) '                                    } ...
  ,{'SALaLoIqf_maxDistR'          ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_maxDistR'         ,'m'       ,'maximale Regeldistanz rechts (1. Begrenzung) '                                    } ...
  ,{'SALaLoIqf_minDistR'          ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_minDistR'         ,'m'       ,'minimale Regeldistanz rechts (1. Begrenzung) '                                    } ...
  ,{'SALaLoIqf_tqRampDistR'       ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_tqRampDistR'      ,'m'       ,'Anstiegsbereich Regeldistanz rechts (1. Begrenzung)'                              } ...
  ,{'SALaLoIqf_availableR'        ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_availableR'       ,'-'       ,'rechte Spurbegrenzung vorhanden (1. Spur)'                                        } ...
  ,{'SALaLoIqf_strengthR'         ,'%'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_strengthR'        ,'%'       ,'Begrenzung Eingriff rechte Spurbegrenzung (1. Spur)'                              } ...
  ,{'SALaLoIqf_intervTypeR'       ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_intervTypeR'      ,'-'       ,'Interventionstyp rechte Begrenzung (1. Spur)'                                     } ...
  ,{'SALaLoIqf_c0R'               ,'1/m'    ,0       ,''            ,'PrivCAN_SALaLoIqf1_c0R'              ,'1/m'     ,'Kurvenkrümmung rechten Spurbegrenzung (1. Spur)'                                  } ...
  ,{'SALaLoIqf_c1R'               ,'1/m/m'  ,0       ,''            ,'PrivCAN_SALaLoIqf1_c1R'              ,'1/m/m'   ,'Änderung Kurvenkrümmung rechten Spurbegrenzung (1. Spur)'                         } ...
  ,{'SALaLoIqf_dyR'               ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_dyR'              ,'m'       ,'Querabweichung zur rechten Spurbegrenzung vom Fahrzeug gesehen (1. Spur)'         } ...
  ,{'SALaLoIqf_psiR'              ,'rad'    ,0       ,''            ,'PrivCAN_SALaLoIqf1_psiR'             ,'rad'     ,'Gierwinkel zur rechten Spurbegrenzung vom Fahrzeug gesehen (1. Spur)'             } ...
  ,{'SALaLoIqf_projectionR'       ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_projectionR'      ,'m'       ,'Projektionslänge für Eingriff an rechter Begrenzung (1. Spur)'                    } ...
  ,{'SALaLoIqf_TypeRight_0x172'   ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf1_TypeRight'        ,'-'       ,'Type Eingriff bit0: LDW, bit1: Intv rechter Begrenzung (1. Spur)'                 } ...
  ,{'SALaLoIqf7_midDistL'         ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_midDistL'         ,'m'       ,'mittlere Regeldistanz links (2. Begrenzung) '                                     } ...
  ,{'SALaLoIqf7_maxDistL'         ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_maxDistL'         ,'m'       ,'maximale Regeldistanz links (2. Begrenzung) '                                     } ...
  ,{'SALaLoIqf7_minDistL'         ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_minDistL'         ,'m'       ,'minimale Regeldistanz links (2. Begrenzung) '                                     } ...
  ,{'SALaLoIqf7_tqRampDistL'      ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_tqRampDistL'      ,'m'       ,'Anstiegsbereich Regeldistanz links (2. Begrenzung)'                               } ...
  ,{'SALaLoIqf8_availableL'       ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_availableL'       ,'-'       ,'linke Spurbegrenzung vorhanden (2. Spur)'                                         } ...
  ,{'SALaLoIqf8_strengthL'        ,'%'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_strengthL'        ,'%'       ,'Begrenzung Eingriff linke Spurbegrenzung (2. Spur)'                               } ...
  ,{'SALaLoIqf8_intervTypeL'      ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_intervTypeL'      ,'-'       ,'Interventionstyp linke Begrenzung (2. Spur)'                                      } ...
  ,{'SALaLoIqf8_c0L'              ,'1/m'    ,0       ,''            ,'PrivCAN_SALaLoIqf2_c0L'              ,'1/m'     ,'Kurvenkrümmung linken Spurbegrenzung (2. Spur)'                                   } ...
  ,{'SALaLoIqf8_c1L'              ,'1/m/m'  ,0       ,''            ,'PrivCAN_SALaLoIqf2_c1L'              ,'1/m/m'   ,'Änderung Kurvenkrümmung linken Spurbegrenzung (2. Spur)'                          } ...
  ,{'SALaLoIqf8_dyL'              ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_dyL'              ,'m'       ,'Querabweichung zur linken Spurbegrenzung vom Fahrzeug gesehen (2. Spur)'          } ...
  ,{'SALaLoIqf8_psiL'             ,'rad'    ,0       ,''            ,'PrivCAN_SALaLoIqf2_psiL'             ,'rad'     ,'Gierwinkel zur linken Spurbegrenzung vom Fahrzeug gesehen (2. Spur)'              } ...
  ,{'SALaLoIqf8_projectionL'      ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_projectionL'      ,'m'       ,'Projektionslänge für Eingriff an linker Begrenzung (2. Spur)'                     } ...
  ,{'SALaLoIqf_TypeLeft_0x178'    ,''       ,0       ,''            ,'PrivCAN_SALaLoIqf2_TypeLeft'         ,''        ,'Type Eingriff bit0: LDW, bit1: Intv linker Begrenzung (2. Spur)'                  } ...
  ,{'SALaLoIqf7_midDistR'         ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_midDistR'         ,'m'       ,'mittlere Regeldistanz rechts (2. Begrenzung) '                                    } ...
  ,{'SALaLoIqf7_maxDistR'         ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_maxDistR'         ,'m'       ,'maximale Regeldistanz rechts (2. Begrenzung) '                                    } ...
  ,{'SALaLoIqf7_minDistR'         ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_minDistR'         ,'m'       ,'minimale Regeldistanz rechts (2. Begrenzung) '                                    } ...
  ,{'SALaLoIqf7_tqRampDistR'      ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_tqRampDistR'      ,'m'       ,'Anstiegsbereich Regeldistanz rechts (2. Begrenzung)'                              } ...
  ,{'SALaLoIqf9_availableR'       ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_availableR'       ,'-'       ,'rechte Spurbegrenzung vorhanden (2. Spur)'                                        } ...
  ,{'SALaLoIqf9_strengthR'        ,'%'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_strengthR'        ,'%'       ,'Begrenzung Eingriff rechte Spurbegrenzung (2. Spur)'                              } ...
  ,{'SALaLoIqf9_intervTypeR'      ,'-'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_intervTypeR'      ,'-'       ,'Interventionstyp rechte Begrenzung (2. Spur)'                                     } ...
  ,{'SALaLoIqf9_c0R'              ,'1/m'    ,0       ,''            ,'PrivCAN_SALaLoIqf2_c0R'              ,'1/m'     ,'Kurvenkrümmung rechten Spurbegrenzung (2. Spur)'                                  } ...
  ,{'SALaLoIqf9_c1R'              ,'1/m/m'  ,0       ,''            ,'PrivCAN_SALaLoIqf2_c1R'              ,'1/m/m'   ,'Änderung Kurvenkrümmung rechten Spurbegrenzung (2. Spur)'                         } ...
  ,{'SALaLoIqf9_dyR'              ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_dyR'              ,'m'       ,'Querabweichung zur rechten Spurbegrenzung vom Fahrzeug gesehen (2. Spur)'         } ...
  ,{'SALaLoIqf9_psiR'             ,'rad'    ,0       ,''            ,'PrivCAN_SALaLoIqf2_psiR'             ,'rad'     ,'Gierwinkel zur rechten Spurbegrenzung vom Fahrzeug gesehen (2. Spur)'             } ...
  ,{'SALaLoIqf9_projectionR'      ,'m'      ,0       ,''            ,'PrivCAN_SALaLoIqf2_projectionR'      ,'m'       ,'Projektionslänge für Eingriff an rechter Begrenzung (2. Spur)'                    } ...
  ,{'SALaLoIqf_TypeRight_0x179'   ,''       ,0       ,''            ,'PrivCAN_SALaLoIqf2_TypeRight'        ,''        ,'Type Eingriff bit0: LDW, bit1: Intv rechter Begrenzung (2. Spur)'                 } ...
  ,{'ExtSteerReq_Ang_active'      ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_Ang_active'      ,'-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_Ang_priority'    ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_Ang_priority'    ,'-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_Ang_quality'     ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_Ang_quality'     ,'-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_Ang_value'       ,'deg'    ,0       ,''            ,'PrivCAN_ExtSteerReq_Ang_value'       ,'deg'     ,''                                                                                 } ...
  ,{'ExtSteerReq_Tor_active'      ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_Tor_active'      ,'-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_Tor_priority'    ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_Tor_priority'    ,'-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_Tor_value'       ,'Nm'     ,0       ,''            ,'PrivCAN_ExtSteerReq_Tor_value'       ,'Nm'      ,''                                                                                 } ...
  ,{'ExtSteerReq_Dev2Pth_y'       ,'m'      ,0       ,''            ,'PrivCAN_ExtSteerReq_Dev2Pth_y'       ,'m'       ,''                                                                                 } ...
  ,{'ExtSteerReq_Dev2Pth_psi'     ,'rad'    ,0       ,''            ,'PrivCAN_ExtSteerReq_Dev2Pth_psi'     ,'rad'     ,''                                                                                 } ...
  ,{'ExtSteerReq_Dev2Pth_c0'      ,'1/m'    ,0       ,''            ,'PrivCAN_ExtSteerReq_Dev2Pth_c0'      ,'1/m'     ,''                                                                                 } ...
  ,{'ExtSteerReq_Dev2Pth_quality' ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_Dev2Pth_quality' ,'-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_Dev2Pth_priority','-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_Dev2Pth_priority','-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_Dev2Pth_active'  ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_Dev2Pth_active'  ,'-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_C0C1_c0'         ,'1/m'    ,0       ,''            ,'PrivCAN_ExtSteerReq_C0C1_c0'         ,'1/m'     ,''                                                                                 } ...
  ,{'ExtSteerReq_C0C1_c1'         ,'1/m/m'  ,0       ,''            ,'PrivCAN_ExtSteerReq_C0C1_c1'         ,'1/m/m'   ,''                                                                                 } ...
  ,{'ExtSteerReq_C0C1_quality'    ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_C0C1_quality'    ,'-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_C0C1_priority'   ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_C0C1_priority'   ,'-'       ,''                                                                                 } ...
  ,{'ExtSteerReq_C0C1_active'     ,'-'      ,0       ,''            ,'PrivCAN_ExtSteerReq_C0C1_active'     ,'-'       ,''                                                                                 } ...
  ,{'RP_Req_Parking_Brake'            ,''               ,0       ,''            ,'PrivCAN_RP_Req_Parking_Brake'            ,''               ,'parking brake request'                                                                                                                                                                                                                                                                                             } ...
  ,{'RP_Req_Press_FL'                 ,'bar'            ,0       ,''            ,'PrivCAN_RP_Req_Press_FL'                 ,'bar'            ,'requested pressure FL'                                                                                                                                                                                                                                                                                             } ...
  ,{'RP_Req_Yawrate'                  ,'°/s'            ,0       ,''            ,'PrivCAN_RP_Req_Yawrate'                  ,'°/s'            ,'requested yawrate'                                                                                                                                                                                                                                                                                                 } ...
  ,{'RP_Req_Press_Qual_FL'            ,''               ,0       ,''            ,'PrivCAN_RP_Req_Press_Qual_FL'            ,''               ,'type of pressure request FL'                                                                                                                                                                                                                                                                                       } ...
  ,{'RP_Req_Press_FR'                 ,'bar'            ,0       ,''            ,'PrivCAN_RP_Req_Press_FR'                 ,'bar'            ,'requested pressure FR'                                                                                                                                                                                                                                                                                             } ...
  ,{'RP_Req_Yawrate_Qual'             ,''               ,0       ,''            ,'PrivCAN_RP_Req_Yawrate_Qual'             ,''               ,'type of yawrate request'                                                                                                                                                                                                                                                                                           } ...
  ,{'RP_Req_Press_Qual_FR'            ,''               ,0       ,''            ,'PrivCAN_RP_Req_Press_Qual_FR'            ,''               ,'type of pressure request FR'                                                                                                                                                                                                                                                                                       } ...
  ,{'RP_Req_Press_RL'                 ,'bar'            ,0       ,''            ,'PrivCAN_RP_Req_Press_RL'                 ,'bar'            ,'requested pressure RL'                                                                                                                                                                                                                                                                                             } ...
  ,{'RP_Req_Press_Qual_RL'            ,''               ,0       ,''            ,'PrivCAN_RP_Req_Press_Qual_RL'            ,''               ,'type of pressure request RL'                                                                                                                                                                                                                                                                                       } ...
  ,{'RP_Req_Press_RR'                 ,'bar'            ,0       ,''            ,'PrivCAN_RP_Req_Press_RR'                 ,'bar'            ,'requested pressure RR'                                                                                                                                                                                                                                                                                             } ...
  ,{'RP_Req_Press_Qual_RR'            ,''               ,0       ,''            ,'PrivCAN_RP_Req_Press_Qual_RR'            ,''               ,'type of pressure request RR'                                                                                                                                                                                                                                                                                       } ...
  ,{'IQF1_LdwStatus'              ,'-'      ,0       ,''            ,'PrivCAN_IQF1_LdwStatus'              ,'-'       ,'LDW Aktivstatus 0:off,1:L,2:R'                                                    } ...
  ,{'IQF1_LdwIntens'              ,'-'      ,0       ,''            ,'PrivCAN_IQF1_LdwIntens'              ,'-'       ,'LDW Intensität 0:low,1:medium,2:high'                                             } ...
  ,{'IQF1_RefActivity'            ,'-'      ,0       ,''            ,'PrivCAN_IQF1_RefActivity'            ,'-'       ,'2: ref angle 1:ref torque 0:no activity'                                          } ...
  ,{'IQF1_RefAng'                 ,'deg'    ,0       ,''            ,'PrivCAN_IQF1_RefAng'                 ,'deg'     ,'Solllenkwinkel IQF-Regler'                                                        } ...
  ,{'IQF1_RefPriority'            ,'-'      ,0       ,''            ,'PrivCAN_IQF1_RefPriority'            ,'-'       ,''                                                                                 } ...
  ,{'IQF1_RefQuality'             ,'-'      ,0       ,''            ,'PrivCAN_IQF1_RefQuality'             ,'-'       ,''                                                                                 } ...
  ,{'IQF1_RefTorque'              ,'Nm'     ,0       ,''            ,'PrivCAN_IQF1_RefTorque'              ,'Nm'      ,''                                                                                 } ...
  ,{'IQF1_Status'                 ,'-'      ,0       ,''            ,'PrivCAN_IQF1_Status'                 ,'-'       ,''                                                                                 } ...
  ,{'IQF2_Curvature'              ,'1/m'    ,0       ,''            ,'PrivCAN_IQF2_Curvature'              ,'1/m'     ,''                                                                                 } ...
  ,{'IQF2_Failure'                ,'-'      ,0       ,''            ,'PrivCAN_IQF2_Failure'                ,'-'       ,''                                                                                 } ...
  ,{'IQF2_HandTorque'             ,'Nm'     ,0       ,''            ,'PrivCAN_IQF2_HandTorque'             ,'Nm'      ,''                                                                                 } ...
  ,{'IQF2_HandsOffDetect'         ,'-'      ,0       ,''            ,'PrivCAN_IQF2_HandsOffDetect'         ,'-'       ,''                                                                                 } ...
  ,{'IQF2_IntvStrength'           ,'%'      ,0       ,''            ,'PrivCAN_IQF2_IntvStrength'           ,'%'       ,''                                                                                 } ...
  ,{'IPAS_Soll_Lenkmoment'        ,'Nm'     ,0       ,''            ,'PrivCAN_IPAS_Soll_Lenkmoment'        ,'Nm'      ,'Solllenkmoment IPAS'                                                              } ...
  ,{'IPAS_ACTIVE'                 ,'-'      ,0       ,''            ,'PrivCAN_IPAS_ACTIVE'                 ,'-'       ,'IPAS active'                                                                      } ...
  ,{'IPAS_Debug_Int'              ,'-'      ,0       ,''            ,'PrivCAN_IPAS_Debug_Int'              ,'-'       ,'IPAS Debug integer value'                                                         } ...
  ,{'IPAS_Debug'                  ,'-'      ,0       ,''            ,'PrivCAN_IPAS_Debug'                  ,'-'       ,'Debug-Größe'                                                                      } ...
  ,{'ACC_MODE'                    ,'-'      ,0       ,''            ,'PrivCAN_ACC_MODE'                    ,''        ,'ACC-Mode'                                                                         } ...
  ,{'ACCReqMax'                   ,'m/s/s'  ,0       ,''            ,'PrivCAN_ACCaReqMax'                  ,'m/s/s'   ,'ACC Sollbeschleunigung Max'                                                       } ...
  ,{'ACCReqMin'                   ,'m/s/s'  ,0       ,''            ,'PrivCAN_ACCaReqMin'                  ,'m/s/s'   ,'ACC Sollbeschleunigung Min'                                                       } ...
  ,{'Obj0Dist'                    ,'m'      ,0       ,''            ,'PrivCAN_ACCObj0Dist'                 ,'m'       ,'Objekt-Distanz'                                                                   } ...
  ,{'SLA_WarnSpd_Val'             ,'km/h'   ,0       ,''            ,'PrivCAN_SLA_WarnSpd_Val'             ,'m/s'     ,'SLA- Warngeschwindigkeit'                                                         } ...
  ,{'BSDxPosLeft'                 ,'m'      ,0       ,''            ,'PrivCAN_BSDxPosLeft'                 ,'m'       ,'BSD-Sensor links x-Abstand zu Fahrzeug'                                           } ...
  ,{'BSDyPosLeft'                 ,'m'      ,0       ,''            ,'PrivCAN_BSDyPosLeft'                 ,'m'       ,'BSD-Sensor links y-Abstand zu Fahrzeug'                                           } ...
  ,{'BSDxPosRight'                ,'m'      ,0       ,''            ,'PrivCAN_BSDxPosRight'                ,'m'       ,'BSD-Sensor rechts x-Abstand zu Fahrzeug'                                          } ...
  ,{'BSDyPosRight'                ,'m'      ,0       ,''            ,'PrivCAN_BSDyPosRight'                ,'m'       ,'BSD-Sensor rechts y-Abstand zu Fahrzeug'                                          } ...
  ,{'vlaengsCorsys'               ,'km/h'   ,1       ,''            ,'PrivCAN_vlaengsCorsys'               ,'km/h'    ,'Laengsgeschwindigkeit am Aufhängungspunkt'                                        } ...
  ,{'vquerCorsys'                 ,'km/h'   ,1       ,''            ,'PrivCAN_vquerCorsys'                 ,'km/h'    ,'Quergeschwindigkeit am Aufhängungspunkt'                                          } ...
  ,{'betaCorsys'                  ,'deg'    ,1       ,''            ,'PrivCAN_betaCorsys'                  ,'deg'     ,'Schwimmwinkel am Aufhängungspunkt'                                                } ...
  ,{'Longitude'                   ,'Minutes',1       ,''            ,'PrivCAN_Longitude'                   ,'Minutes' ,'Längengrad Messpunkt Auto VBox'                                                   } ...
  ,{'Latitude'                    ,'Minutes',1       ,''            ,'PrivCAN_Latitude'                    ,'Minutes' ,'Breitengrad Messpunkt Auto VBox'                                                  } ...
  ,{'Heading'                     ,'deg'    ,1       ,''            ,'PrivCAN_Heading'                     ,'deg'     ,'Headingwikel VBox'                                                                } ...
  ,{'IOmg_Z'                      ,'°/s'    ,1       ,''            ,'PrivCAN_IOmg_Z'                      ,'rad/s'   ,'Längengrad Messpunkt Auto Imar'                                                   } ...
  ,{'Tra_0_XS'                    ,'m'      ,1       ,''            ,'PrivCAN_Tra_0_XS'                    ,'m'       ,'x-Koordinate Schittpunkt Trajektorie'                                             } ...
  ,{'Tra_0_YS'                    ,'m'      ,1       ,''            ,'PrivCAN_Tra_0_YS'                    ,'m'       ,'y-Koordinate Schittpunkt Trajektorie'                                             } ...
  ,{'Tra_0_AlphaS'                ,'rad'    ,1       ,''            ,'PrivCAN_Tra_0_AlphaS'                ,'rad'     ,'Yaw-winkel der trajektorie'                                                       } ...
  ,{'Tra_0_C0S'                   ,'1/m'    ,1       ,''            ,'PrivCAN_Tra_0_C0S'                   ,'1/m'     ,'Curvature der trajektorie'                                                        } ...
  ,{'Tra_0_iTraAct'               ,'-'      ,1       ,''            ,'PrivCAN_Tra_0_iTraAct'               ,'-'       ,'Welches Segment'                                                                  } ...
  ,{'Tra_1_XPosEgo'               ,'m'      ,1       ,''            ,'PrivCAN_Tra_1_XPosEgo'               ,'m'       ,'x-Koordinate Ego-Position'                                                        } ...
  ,{'Tra_1_YPosEgo'               ,'m'      ,1       ,''            ,'PrivCAN_Tra_1_YPosEgo'               ,'m'       ,'y-Koordinate Ego-Position'                                                        } ...
  ,{'Tra_1_YawPosEgo'             ,'rad'    ,1       ,''            ,'PrivCAN_Tra_1_YawPosEgo'             ,'rad'     ,'Yaw-winkel (Gier,um x-Achse) Rad im Fahrzeugreferenzsystem (Aufbau) hinten rechts'} ...
  ,{'Tra_2_XVBox'                 ,'m'      ,1       ,''            ,'PrivCAN_Tra_2_XVBox'                 ,'m'       ,'x-Koordinate VBox'                                                                } ...
  ,{'Tra_2_YVBox'                 ,'m'      ,1       ,''            ,'PrivCAN_Tra_2_YVBox'                 ,'m'       ,'x-Koordinate VBox'                                                                } ...
  ,{'Tra_2_YawVBox'               ,'rad'    ,1       ,''            ,'PrivCAN_Tra_2_YawVBox'               ,'rad'     ,'Yaw-winkel VBox'                                                                  } ...
  };
  
  Ssig = cell_liste2struct(c);

%   iSig = 0;
%   %===============================================================================================
%   % Vehicle Dynamics
%   %===============================================================================================
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'VehSpd';
%   Ssig(iSig).unit_in      = 'km/h';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'VehSpd';
%   Ssig(iSig).unit_out     = 'km/h';
%   Ssig(iSig).comment      = 'Fahrzeuggeschwindigkeit';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'VehYawRate_Raw';
%   Ssig(iSig).unit_in      = 'deg/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'VehYawRate_Raw';
%   Ssig(iSig).unit_out     = 'deg/s';
%   Ssig(iSig).comment      = 'Fahrzeuggierrate CAN Auflösung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'VehAccel_Y';
%   Ssig(iSig).unit_in      = 'm/s/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'VehAccel_Y';
%   Ssig(iSig).unit_out     = 'm/s/s';
%   Ssig(iSig).comment      = 'Fahrzeugquerbeschleunigung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'VehAccel_X_Sen';
%   Ssig(iSig).unit_in      = 'm/s/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'VehAccel_X_Sen';
%   Ssig(iSig).unit_out     = 'm/s/s';
%   Ssig(iSig).comment      = 'Fahrzeugquerbeschleunigung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'VehAccel_X_Est';
%   Ssig(iSig).unit_in      = 'm/s/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'VehAccel_X_Est';
%   Ssig(iSig).unit_out     = 'm/s/s';
%   Ssig(iSig).comment      = 'Fahrzeugquerbeschleunigung Estimation';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Gear';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Gear';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'eingelegter Gang';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'StW_Angl';
%   Ssig(iSig).unit_in      = 'deg';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'StW_Angl';
%   Ssig(iSig).unit_out     = 'deg';
%   Ssig(iSig).comment      = 'Lenkradwinkel';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'StW_AnglSpd';
%   Ssig(iSig).unit_in      = 'deg/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'StW_AnglSpd';
%   Ssig(iSig).unit_out     = 'deg/s';
%   Ssig(iSig).comment      = 'Lenkradwinkel';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'RDU_FahrerLenkmoment';
%   Ssig(iSig).unit_in      = 'Nm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'RDU_FahrerLenkmoment';
%   Ssig(iSig).unit_out     = 'Nm';
%   Ssig(iSig).comment      = 'gemessenes Fahrerhandmoment/Torsionsstab';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ACCEL_PEDAL_TRAVEL';
%   Ssig(iSig).unit_in      = '%';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ACCEL_PEDAL_TRAVEL';
%   Ssig(iSig).unit_out     = '%';
%   Ssig(iSig).comment      = 'Fahrergaspedalstellung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'RDU_Bremsdruck';
%   Ssig(iSig).unit_in      = 'bar';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'RDU_Bremsdruck';
%   Ssig(iSig).unit_out     = 'bar';
%   Ssig(iSig).comment      = 'Bremsdruck';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'RDU_Blinker';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'RDU_Blinker';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Blinkerstellung';
%   %===============================================================================================
%   % Grid Input
%   %===============================================================================================
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Mode_Steering_Assistance';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Mode_Steering_Assistance';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Wavevorgabe 1: LDW & 2:virtWall & 4:LKAS';
%   %-----------------------------------------------------------------------------------------------
%   % lateral Situation analyse Signals
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_available';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqfm_available';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Available Mittenführung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_c0';
%   Ssig(iSig).unit_in      = '1/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqfm_c0';
%   Ssig(iSig).unit_out     = '1/m';
%   Ssig(iSig).comment      = 'Kurvenkrümmung Mittenführung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_c1';
%   Ssig(iSig).unit_in      = '1/m/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqfm_c1';
%   Ssig(iSig).unit_out     = '1/m/m';
%   Ssig(iSig).comment      = 'Kurvenkrümmungsänderung Mittenführung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_intervType';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqfm_intervType';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Intervention Typ Mittenführung bit0: LKAS on';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_dy';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqfm_dy';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Mittenführung Querabweichung zur Trajektorie vom Fahrzeug ausgesehen ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_psi';
%   Ssig(iSig).unit_in      = 'rad';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqfm_psi';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Mittenführung Gierwinkel zur Trajektorie vom Fahrzeug ausgesehen';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_projection';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqfm_projection';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Mittenführung Projektion';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_leftStrength';
%   Ssig(iSig).unit_in      = '%';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqfm_leftStrength';
%   Ssig(iSig).unit_out     = '%';
%   Ssig(iSig).comment      = 'Mittenführung Reduzierung links um x % <= 100% ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_rightStrength';
%   Ssig(iSig).unit_in      = '%';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqfm_rightStrength';
%   Ssig(iSig).unit_out     = '%';
%   Ssig(iSig).comment      = 'Mittenführung Reduzierung rechts um x % <= 100% ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_midDistL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_midDistL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'mittlere Regeldistanz links (1. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_maxDistL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_maxDistL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'maximale Regeldistanz links (1. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_minDistL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_minDistL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'minimale Regeldistanz links (1. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_tqRampDistL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_tqRampDistL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Anstiegsbereich Regeldistanz links (1. Begrenzung)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_availableL';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_availableL';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'linke Spurbegrenzung vorhanden (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_strengthL';
%   Ssig(iSig).unit_in      = '%';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_strengthL';
%   Ssig(iSig).unit_out     = '%';
%   Ssig(iSig).comment      = 'Begrenzung Eingriff linke Spurbegrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_intervTypeL';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_intervTypeL';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Interventionstyp linke Begrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_c0L';
%   Ssig(iSig).unit_in      = '1/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_c0L';
%   Ssig(iSig).unit_out     = '1/m';
%   Ssig(iSig).comment      = 'Kurvenkrümmung linken Spurbegrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_c1L';
%   Ssig(iSig).unit_in      = '1/m/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_c1L';
%   Ssig(iSig).unit_out     = '1/m/m';
%   Ssig(iSig).comment      = 'Änderung Kurvenkrümmung linken Spurbegrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_dyL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_dyL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Querabweichung zur linken Spurbegrenzung vom Fahrzeug gesehen (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_psiL';
%   Ssig(iSig).unit_in      = 'rad';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_psiL';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Gierwinkel zur linken Spurbegrenzung vom Fahrzeug gesehen (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_projectionL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_projectionL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Projektionslänge für Eingriff an linker Begrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_TypeLeft_0x171';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_TypeLeft';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Type Eingriff bit0: LDW, bit1: Intv linker Begrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_midDistR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_midDistR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'mittlere Regeldistanz rechts (1. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_maxDistR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_maxDistR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'maximale Regeldistanz rechts (1. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_minDistR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_minDistR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'minimale Regeldistanz rechts (1. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_tqRampDistR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_tqRampDistR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Anstiegsbereich Regeldistanz rechts (1. Begrenzung)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_availableR';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_availableR';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'rechte Spurbegrenzung vorhanden (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_strengthR';
%   Ssig(iSig).unit_in      = '%';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_strengthR';
%   Ssig(iSig).unit_out     = '%';
%   Ssig(iSig).comment      = 'Begrenzung Eingriff rechte Spurbegrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_intervTypeR';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_intervTypeR';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Interventionstyp rechte Begrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_c0R';
%   Ssig(iSig).unit_in      = '1/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_c0R';
%   Ssig(iSig).unit_out     = '1/m';
%   Ssig(iSig).comment      = 'Kurvenkrümmung rechten Spurbegrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_c1R';
%   Ssig(iSig).unit_in      = '1/m/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_c1R';
%   Ssig(iSig).unit_out     = '1/m/m';
%   Ssig(iSig).comment      = 'Änderung Kurvenkrümmung rechten Spurbegrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_dyR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_dyR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Querabweichung zur rechten Spurbegrenzung vom Fahrzeug gesehen (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_psiR';
%   Ssig(iSig).unit_in      = 'rad';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_psiR';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Gierwinkel zur rechten Spurbegrenzung vom Fahrzeug gesehen (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_projectionR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_projectionR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Projektionslänge für Eingriff an rechter Begrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_TypeRight_0x172';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf1_TypeRight';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Type Eingriff bit0: LDW, bit1: Intv rechter Begrenzung (1. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf7_midDistL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_midDistL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'mittlere Regeldistanz links (2. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf7_maxDistL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_maxDistL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'maximale Regeldistanz links (2. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf7_minDistL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_minDistL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'minimale Regeldistanz links (2. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf7_tqRampDistL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_tqRampDistL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Anstiegsbereich Regeldistanz links (2. Begrenzung)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf8_availableL';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_availableL';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'linke Spurbegrenzung vorhanden (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf8_strengthL';
%   Ssig(iSig).unit_in      = '%';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_strengthL';
%   Ssig(iSig).unit_out     = '%';
%   Ssig(iSig).comment      = 'Begrenzung Eingriff linke Spurbegrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf8_intervTypeL';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_intervTypeL';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Interventionstyp linke Begrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf8_c0L';
%   Ssig(iSig).unit_in      = '1/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_c0L';
%   Ssig(iSig).unit_out     = '1/m';
%   Ssig(iSig).comment      = 'Kurvenkrümmung linken Spurbegrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf8_c1L';
%   Ssig(iSig).unit_in      = '1/m/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_c1L';
%   Ssig(iSig).unit_out     = '1/m/m';
%   Ssig(iSig).comment      = 'Änderung Kurvenkrümmung linken Spurbegrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf8_dyL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_dyL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Querabweichung zur linken Spurbegrenzung vom Fahrzeug gesehen (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf8_psiL';
%   Ssig(iSig).unit_in      = 'rad';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_psiL';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Gierwinkel zur linken Spurbegrenzung vom Fahrzeug gesehen (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf8_projectionL';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_projectionL';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Projektionslänge für Eingriff an linker Begrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_TypeLeft_0x178';
%   Ssig(iSig).unit_in      = '';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_TypeLeft';
%   Ssig(iSig).unit_out     = '';
%   Ssig(iSig).comment      = 'Type Eingriff bit0: LDW, bit1: Intv linker Begrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf7_midDistR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_midDistR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'mittlere Regeldistanz rechts (2. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf7_maxDistR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_maxDistR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'maximale Regeldistanz rechts (2. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf7_minDistR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_minDistR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'minimale Regeldistanz rechts (2. Begrenzung) ';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf7_tqRampDistR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_tqRampDistR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Anstiegsbereich Regeldistanz rechts (2. Begrenzung)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf9_availableR';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_availableR';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'rechte Spurbegrenzung vorhanden (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf9_strengthR';
%   Ssig(iSig).unit_in      = '%';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_strengthR';
%   Ssig(iSig).unit_out     = '%';
%   Ssig(iSig).comment      = 'Begrenzung Eingriff rechte Spurbegrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf9_intervTypeR';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_intervTypeR';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Interventionstyp rechte Begrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf9_c0R';
%   Ssig(iSig).unit_in      = '1/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_c0R';
%   Ssig(iSig).unit_out     = '1/m';
%   Ssig(iSig).comment      = 'Kurvenkrümmung rechten Spurbegrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf9_c1R';
%   Ssig(iSig).unit_in      = '1/m/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_c1R';
%   Ssig(iSig).unit_out     = '1/m/m';
%   Ssig(iSig).comment      = 'Änderung Kurvenkrümmung rechten Spurbegrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf9_dyR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_dyR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Querabweichung zur rechten Spurbegrenzung vom Fahrzeug gesehen (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf9_psiR';
%   Ssig(iSig).unit_in      = 'rad';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_psiR';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Gierwinkel zur rechten Spurbegrenzung vom Fahrzeug gesehen (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf9_projectionR';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_projectionR';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Projektionslänge für Eingriff an rechter Begrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SALaLoIqf_TypeRight_0x179';
%   Ssig(iSig).unit_in      = '';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SALaLoIqf2_TypeRight';
%   Ssig(iSig).unit_out     = '';
%   Ssig(iSig).comment      = 'Type Eingriff bit0: LDW, bit1: Intv rechter Begrenzung (2. Spur)';
%   %-----------------------------------------------------------------------------------------------
%   % external steer angel or torque demand from Grid
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Ang_active';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Ang_active';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Ang_priority';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Ang_priority';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Ang_quality';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Ang_quality';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Ang_value';
%   Ssig(iSig).unit_in      = 'deg';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Ang_value';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Tor_active';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Tor_active';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Tor_priority';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Tor_priority';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Tor_value';
%   Ssig(iSig).unit_in      = 'Nm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Tor_value';
%   Ssig(iSig).unit_out     = 'Nm';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   % dev2Path-Demand from Grid
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Dev2Pth_y';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Dev2Pth_y';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Dev2Pth_psi';
%   Ssig(iSig).unit_in      = 'rad';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Dev2Pth_psi';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Dev2Pth_c0';
%   Ssig(iSig).unit_in      = '1/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Dev2Pth_c0';
%   Ssig(iSig).unit_out     = '1/m';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Dev2Pth_quality';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Dev2Pth_quality';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Dev2Pth_priority';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Dev2Pth_priority';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_Dev2Pth_active';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_Dev2Pth_active';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   % C0C1-Demand (curvature) from Grid
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_C0C1_c0';
%   Ssig(iSig).unit_in      = '1/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_C0C1_c0';
%   Ssig(iSig).unit_out     = '1/m';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_C0C1_c1';
%   Ssig(iSig).unit_in      = '1/m/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_C0C1_c1';
%   Ssig(iSig).unit_out     = '1/m/m';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_C0C1_quality';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_C0C1_quality';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_C0C1_priority';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_C0C1_priority';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ExtSteerReq_C0C1_active';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ExtSteerReq_C0C1_active';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   % IQF-output
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF1_IntvActvStatus';
%   % Ssig(iSig).unit_in      = '-';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_IntvActvStatus';
%   % Ssig(iSig).unit_out     = '-';
%   % Ssig(iSig).comment      = 'Intervention Aktivstatus 0:off,1:L,2:L+VW,3:R,4:R+VW,IQF-Regler';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF1_LdwActvStatus';
%   % Ssig(iSig).unit_in      = '-';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_LdwActvStatus';
%   % Ssig(iSig).unit_out     = '-';
%   % Ssig(iSig).comment      = 'LDW Aktivstatus 0:off,1:L,2:R';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF1_LdwActvIntens';
%   % Ssig(iSig).unit_in      = '-';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_LdwActvIntens';
%   % Ssig(iSig).unit_out     = '-';
%   % Ssig(iSig).comment      = 'LDW Intensität 0:low,1:medium,2:high';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF1_LkasIntvMaxStrength';
%   % Ssig(iSig).unit_in      = '%';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_LkasIntvMaxStrength';
%   % Ssig(iSig).unit_out     = '%';
%   % Ssig(iSig).comment      = 'Begrenzung Lkas+Intv';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF1_LcaStrength';
%   % Ssig(iSig).unit_in      = '%';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_LkasIntvMaxStrength';
%   % Ssig(iSig).unit_out     = '%';
%   % Ssig(iSig).comment      = 'Begrenzung Lkas+Intv';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF1_Curvature';
%   % Ssig(iSig).unit_in      = '1/m';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_Curvature';
%   % Ssig(iSig).unit_out     = '1/m';
%   % Ssig(iSig).comment      = 'Solllenkwinkel IQF-Regler';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF1_LkasIntvDynFac';
%   % Ssig(iSig).unit_in      = '%';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_LkasIntvDynFac';
%   % Ssig(iSig).unit_out     = '%';
%   % Ssig(iSig).comment      = 'Stärke Eingriff IQF-Regler';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF1_IntvStrength';
%   % Ssig(iSig).unit_in      = '%';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_LkasIntvDynFac';
%   % Ssig(iSig).unit_out     = '%';
%   % Ssig(iSig).comment      = 'Stärke Eingriff IQF-Regler';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF1_LkasActive';
%   % Ssig(iSig).unit_in      = '-';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_LkasActive';
%   % Ssig(iSig).unit_out     = '-';
%   % Ssig(iSig).comment      = 'Lkas-active Flag IQF-Regler';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF2_Status';
%   % Ssig(iSig).unit_in      = '-';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF1_Status';
%   % Ssig(iSig).unit_out     = '-';
%   % Ssig(iSig).comment      = 'Status IQF-Regler';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF2_IntervTorque';
%   % Ssig(iSig).unit_in      = 'Nm';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF2_IntervTorque';
%   % Ssig(iSig).unit_out     = 'Nm';
%   % Ssig(iSig).comment      = 'Solllenkwinkel IQF-Regler';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF2_IntervType';
%   % Ssig(iSig).unit_in      = '-';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF2_IntervType';
%   % Ssig(iSig).unit_out     = '-';
%   % Ssig(iSig).comment      = 'Interventionstyp 1:Torque,2:RefAngle  IQF-Regler';
%   %-----------------------------------------------------------------------------------------------
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'IQF2_GradLim';
%   % Ssig(iSig).unit_in      = '%';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'IQF2_GradLim';
%   % Ssig(iSig).unit_out     = '%';
%   % Ssig(iSig).comment      = 'Grad der Limitierung beim Einfaden';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF1_LdwStatus';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF1_LdwStatus';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'LDW Aktivstatus 0:off,1:L,2:R';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF1_LdwIntens';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF1_LdwIntens';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'LDW Intensität 0:low,1:medium,2:high';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF1_RefActivity';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF1_RefActivity';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '2: ref angle 1:ref torque 0:no activity';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF1_RefAng';
%   Ssig(iSig).unit_in      = 'deg';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF1_RefAng';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Solllenkwinkel IQF-Regler';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF1_RefPriority';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF1_RefPriority';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF1_RefQuality';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF1_RefQuality';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF1_RefTorque';
%   Ssig(iSig).unit_in      = 'Nm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF1_RefTorque';
%   Ssig(iSig).unit_out     = 'Nm';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF1_Status';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF1_Status';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF2_Curvature';
%   Ssig(iSig).unit_in      = '1/m';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF2_Curvature';
%   Ssig(iSig).unit_out     = '1/m';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF2_Failure';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF2_Failure';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF2_HandTorque';
%   Ssig(iSig).unit_in      = 'Nm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF2_HandTorque';
%   Ssig(iSig).unit_out     = 'Nm';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF2_HandsOffDetect';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF2_HandsOffDetect';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IQF2_IntvStrength';
%   Ssig(iSig).unit_in      = '%';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IQF2_IntvStrength';
%   Ssig(iSig).unit_out     = '%';
%   Ssig(iSig).comment      = '';
%   %-----------------------------------------------------------------------------------------------
%   % steer angle control - Output
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IPAS_Soll_Lenkmoment';
%   Ssig(iSig).unit_in      = 'Nm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IPAS_Soll_Lenkmoment';
%   Ssig(iSig).unit_out     = 'Nm';
%   Ssig(iSig).comment      = 'Solllenkmoment IPAS';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IPAS_ACTIVE';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IPAS_ACTIVE';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'IPAS active';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IPAS_Debug_Int';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IPAS_Debug_Int';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'IPAS Debug integer value';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IPAS_Debug';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IPAS_Debug';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Debug-Größe';
%   %-----------------------------------------------------------------------------------------------
%   % ACC
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ACC_MODE';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ACC_MODE';
%   Ssig(iSig).unit_out     = '';
%   Ssig(iSig).comment      = 'ACC-Mode';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ACCReqMax';
%   Ssig(iSig).unit_in      = 'm/s/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ACCaReqMax';
%   Ssig(iSig).unit_out     = 'm/s/s';
%   Ssig(iSig).comment      = 'ACC Sollbeschleunigung Max';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ACCReqMin';
%   Ssig(iSig).unit_in      = 'm/s/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ACCaReqMin';
%   Ssig(iSig).unit_out     = 'm/s/s';
%   Ssig(iSig).comment      = 'ACC Sollbeschleunigung Min';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Obj0Dist';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ACCObj0Dist';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'Objekt-Distanz';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'SLA_WarnSpd_Val';
%   Ssig(iSig).unit_in      = 'km/h';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'SLA_WarnSpd_Val';
%   Ssig(iSig).unit_out     = 'm/s';
%   Ssig(iSig).comment      = 'SLA- Warngeschwindigkeit';
%   %-----------------------------------------------------------------------------------------------
%   % BSD - Sensor
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'BSDxPosLeft';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'BSDxPosLeft';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'BSD-Sensor links x-Abstand zu Fahrzeug';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'BSDyPosLeft';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'BSDyPosLeft';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'BSD-Sensor links y-Abstand zu Fahrzeug';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'BSDxPosRight';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'BSDxPosRight';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'BSD-Sensor rechts x-Abstand zu Fahrzeug';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'BSDyPosRight';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'BSDyPosRight';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'BSD-Sensor rechts y-Abstand zu Fahrzeug';
%   %-----------------------------------------------------------------------------------------------
%   % corSys measurement
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'vlaengsCorsys';
%   Ssig(iSig).unit_in      = 'km/h';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'vlaengsCorsys';
%   Ssig(iSig).unit_out     = 'km/h';
%   Ssig(iSig).comment      = 'Laengsgeschwindigkeit am Aufhängungspunkt';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'vquerCorsys';
%   Ssig(iSig).unit_in      = 'km/h';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'vquerCorsys';
%   Ssig(iSig).unit_out     = 'km/h';
%   Ssig(iSig).comment      = 'Quergeschwindigkeit am Aufhängungspunkt';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'betaCorsys';
%   Ssig(iSig).unit_in      = 'deg';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'betaCorsys';
%   Ssig(iSig).unit_out     = 'deg';
%   Ssig(iSig).comment      = 'Schwimmwinkel am Aufhängungspunkt';
%   %-----------------------------------------------------------------------------------------------
%   % VBox measurement
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Longitude';
%   Ssig(iSig).unit_in      = 'Minutes';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Longitude';
%   Ssig(iSig).unit_out     = 'Minutes';
%   Ssig(iSig).comment      = 'Längengrad Messpunkt Auto VBox';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Latitude';
%   Ssig(iSig).unit_in      = 'Minutes';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Latitude';
%   Ssig(iSig).unit_out     = 'Minutes';
%   Ssig(iSig).comment      = 'Breitengrad Messpunkt Auto VBox';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Heading';
%   Ssig(iSig).unit_in      = 'deg';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Heading';
%   Ssig(iSig).unit_out     = 'deg';
%   Ssig(iSig).comment      = 'Headingwikel VBox';
%   %-----------------------------------------------------------------------------------------------
%   % IMAR measurement
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'IOmg_Z';
%   Ssig(iSig).unit_in      = '°/s';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'IOmg_Z';
%   Ssig(iSig).unit_out     = 'rad/s';
%   Ssig(iSig).comment      = 'Längengrad Messpunkt Auto Imar';
%   %-----------------------------------------------------------------------------------------------
%   % self defined output from Canalyser calc for trajectory
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_0_XS';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_0_XS';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'x-Koordinate Schittpunkt Trajektorie';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_0_YS';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_0_YS';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'y-Koordinate Schittpunkt Trajektorie';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_0_AlphaS';
%   Ssig(iSig).unit_in      = 'rad';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_0_AlphaS';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Yaw-winkel der trajektorie';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_0_C0S';
%   Ssig(iSig).unit_in      = '1/m';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_0_C0S';
%   Ssig(iSig).unit_out     = '1/m';
%   Ssig(iSig).comment      = 'Curvature der trajektorie';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_0_iTraAct';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_0_iTraAct';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Welches Segment';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_1_XPosEgo';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_1_XPosEgo';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'x-Koordinate Ego-Position';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_1_YPosEgo';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_1_YPosEgo';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'y-Koordinate Ego-Position';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_1_YawPosEgo';
%   Ssig(iSig).unit_in      = 'rad';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_1_YawPosEgo';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Yaw-winkel (Gier,um x-Achse) Rad im Fahrzeugreferenzsystem (Aufbau) hinten rechts';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_2_XVBox';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_2_XVBox';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'x-Koordinate VBox';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_2_YVBox';
%   Ssig(iSig).unit_in      = 'm';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_2_YVBox';
%   Ssig(iSig).unit_out     = 'm';
%   Ssig(iSig).comment      = 'x-Koordinate VBox';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'Tra_2_YawVBox';
%   Ssig(iSig).unit_in      = 'rad';
%   Ssig(iSig).lin_in       = 1;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Tra_2_YawVBox';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'Yaw-winkel VBox';
%   
end