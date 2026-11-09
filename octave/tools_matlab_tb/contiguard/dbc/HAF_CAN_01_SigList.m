function Ssig = HAF_CAN_01_SigList
%
% Design List of signals from Powertrain-Can VW do read from measurement
%
%   Ssig(i).name_in      = 'signal name';
%   Ssig(i).unit_in      = 'dbc unit';              (default '')
%   Ssig(i).lin_in       = 0/1;                     (default 0)
%   Ssig(i).name_sign_in = 'signal name for sign';  (default '')
%   Ssig(i).name_out     = 'output signal name';    (default name_in)
%   Ssig(i).unit_out     = 'output unit';           (default 'unit_in')
%   Ssig(i).comment      = 'description';           (default '')
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
  {{                  'name_in','unit_in','lin_in','name_sign_in',              'name_out','unit_out',                                                                                                                                                                                                                                        'comment'} ...
  ,{'VehSpd'                   ,'km/h'   ,0       ,''            ,'VehSpd'                ,'km/h'    ,'Fahrzeuggeschwindigkeit'                                                                                                                                                                                                                        } ...
  ,{'StW_Angl'                 ,'deg'    ,0       ,''            ,'StW_Angl'              ,'deg'     ,'Lenkradwinkel'                                                                                                                                                                                                                                  } ...
  ,{'StW_AnglSpd'              ,'deg/s'  ,0       ,''            ,'StW_AnglSpd'           ,'deg/s'   ,'Lenkradwinkel'                                                                                                                                                                                                                                  } ...
  ,{'VehYawRate_Raw'           ,'deg/s'  ,0       ,''            ,'VehYawRate_Raw'        ,'deg/s'   ,'Fahrzeuggierrate CAN Auflösung'                                                                                                                                                                                                                 } ...
  ,{'VehAccel_Y'               ,'m/s/s'  ,0       ,''            ,'VehAccel_Y'            ,'m/s/s'   ,'Fahrzeugquerbeschleunigung'                                                                                                                                                                                                                     } ...
  ,{'WhlPlsCnt_FL'             ,'enum'   ,0       ,''            ,'WhlPlsCnt_FL'          ,'enum'    ,'Raddrehpulse vorne links'                                                                                                                                                                                                                       } ...
  ,{'WhlPlsCnt_FR'             ,'enum'   ,0       ,''            ,'WhlPlsCnt_FR'          ,'enum'    ,'Raddrehpulse vorne rechts'                                                                                                                                                                                                                      } ...
  ,{'WhlPlsCnt_RL'             ,'enum'   ,0       ,''            ,'WhlPlsCnt_RL'          ,'enum'    ,'Raddrehpulse hinten links'                                                                                                                                                                                                                      } ...
  ,{'WhlPlsCnt_RR'             ,'enum'   ,0       ,''            ,'WhlPlsCnt_RR'          ,'enum'    ,'Raddrehpulse hinten rechts'                                                                                                                                                                                                                     } ...
  ,{'Gear'                     ,'-'      ,0       ,''            ,'Gear'                  ,'-'       ,'eingelegter Gang'                                                                                                                                                                                                                               } ...
  ,{'Brk_Torque'               ,'Nm'     ,0       ,''            ,'Brk_Torque'            ,'Nm'      ,'Bremsmoment'                                                                                                                                                                                                                                    } ...
  ,{'ABS_ACT'                  ,'enum'   ,0       ,''            ,'ABS_ACT'               ,'enum'    ,'ABS aktiv'                                                                                                                                                                                                                                      } ...
  ,{'TCS_ACT'                  ,'enum'   ,0       ,''            ,'TCS_ACT'               ,'enum'    ,'TCS aktiv'                                                                                                                                                                                                                                      } ...
  ,{'VSC_ACT'                  ,'enum'   ,0       ,''            ,'VSC_ACT'               ,'enum'    ,'ESP aktiv'                                                                                                                                                                                                                                      } ...
  ,{'VehAccel_X_Sen'           ,'m/s/s'  ,0       ,''            ,'VehAccel_X_Sen'        ,'m/s/s'   ,'Fahrzeugquerbeschleunigung'                                                                                                                                                                                                                     } ...
  ,{'ACCEL_PEDAL_TRAVEL'       ,'%'      ,0       ,''            ,'ACCEL_PEDAL_TRAVEL'    ,'%'       ,'Fahrergaspedalstellung'                                                                                                                                                                                                                         } ...
  ,{'RDU_FahrerLenkmoment'     ,'Nm'     ,0       ,''            ,'RDU_FahrerLenkmoment'  ,'Nm'      ,'gemessenes Fahrerhandmoment/Torsionsstab'                                                                                                                                                                                                       } ...
  ,{'Giergeschw'               ,'deg/s'  ,0       ,''            ,'Giergeschw'            ,'rad/s'   ,'A8 übertragene Giergeschwindigkeit'                                                                                                                                                                                                             } ...
  ,{'LRW'                      ,'deg'    ,0       ,''            ,'LRW'                   ,'rad'     ,'A8 übertragene Lenkwinkel'                                                                                                                                                                                                                      } ...
  ,{'LRW_Gesch'                ,'deg/s'  ,0       ,''            ,'LRW_Gesch'             ,'rad/s'   ,'A8 übertragene Lenkwinkelgeschw'                                                                                                                                                                                                                } ...
  ,{'WhlRPM_FL'                ,'rpm'    ,0       ,''            ,'WhlRPM_FL'             ,'rpm'     ,'Raddrehgeschwindigkeit vorne links'                                                                                                                                                                                                             } ...
  ,{'WhlDir_FL_Stat'           ,'enum'   ,0       ,''            ,'WhlDir_FL_Stat'        ,'enum'    ,'Status Raddrehrichtung vorne links 1: vor 2:rueck'                                                                                                                                                                                              } ...
  ,{'WhlRPM_FR'                ,'rpm'    ,0       ,''            ,'WhlRPM_FR'             ,'rpm'     ,'Raddrehgeschwindigkeit vorne rechts'                                                                                                                                                                                                            } ...
  ,{'WhlDir_FR_Stat'           ,'enum'   ,0       ,''            ,'WhlDir_FR_Stat'        ,'enum'    ,'Status Raddrehrichtung vorne rechts 1: vor 2:rueck'                                                                                                                                                                                             } ...
  ,{'WhlRPM_RL'                ,'rpm'    ,0       ,''            ,'WhlRPM_RL'             ,'rpm'     ,'Raddrehgeschwindigkeit hinten links'                                                                                                                                                                                                            } ...
  ,{'WhlDir_RL_Stat'           ,'enum'   ,0       ,''            ,'WhlDir_RL_Stat'        ,'enum'    ,'Status Raddrehrichtung hinten links 1: vor 2:rueck'                                                                                                                                                                                             } ...
  ,{'WhlRPM_RR'                ,'rpm'    ,0       ,''            ,'WhlRPM_RR'             ,'rpm'     ,'Raddrehgeschwindigkeit hinten rechts'                                                                                                                                                                                                           } ...
  ,{'WhlDir_RR_Stat'           ,'enum'   ,0       ,''            ,'WhlDir_RR_Stat'        ,'enum'    ,'Status Raddrehrichtung hinten rechts 1: vor 2:rueck'                                                                                                                                                                                            } ...
  ,{'ALIVE_HAF_A10'            ,'enum'   ,0       ,''            ,'ALIVE_HAF_A10'         ,'enum'    ,'Alivecounter HAF A10'                                                                                                                                                                                                                           } ...
  ,{'AVL_WMOM_PT_SUM'          ,'Nm'     ,0       ,''            ,''                      ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_SummeAktuell antreibendes Summen-Radmoment des Antriebsstrangs.'                                                                                                                                                   } ...
  ,{'QU_AVL_WMOM_PT_SUM'       ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                      } ...
  ,{'AVL_WMOM_PT_SUM_DTORQ_BOT','Nm'     ,0       ,''            ,''                      ,'Nm'      ,'Maximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt'                                                                                                                                                                     } ...
  ,{'AVL_WMOM_PT_SUM_DTORQ_TOP','Nm'     ,0       ,''            ,''                      ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_Summe_Schleppmoment_ObenMaximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt das kontinuierlich erreichbar ist.'                                                                             } ...
  ,{'ST_DRVDIR_DVCH'           ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Status_Fahrtrichtung_FahrerwunschGibt die wahrscheinliche Fahrtrichtung des Fahrzeuges an.'                                                                                                                                                     } ...
  ,{'ALIVE_HAF_A11'            ,'enum'   ,0       ,''            ,'ALIVE_HAF_A11'         ,'enum'    ,'Alivecounter HAF A11'                                                                                                                                                                                                                           } ...
  ,{'AVL_WMOM_PT_SUM_RECUP_MAX','Nm'     ,0       ,''            ,''                      ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_Summe_Rekuperation_MaximalSumme von dem maximalen Schleppmoment Unten und Bremsrekuperationsmoment, das momentan zur Verfügung steht.'                                                                             } ...
  ,{'AVL_WMOM_PT_SUM_MAX'      ,'Nm'     ,0       ,''            ,''                      ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_Summe_Maximal'                                                                                                                                                                                                     } ...
  ,{'ST_AVAI_INTV_PT_DRS '     ,'enum'   ,0       ,''            ,'ST_AVAI_INTV_PT_DRS '  ,'enum'    ,'Status_Verfügbarkeit_Eingriff_Antriebsstrang_FAS'                                                                                                                                                                                               } ...
  ,{'ST_PENG_PT'               ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Status_Kraftschluss_AntriebsstrangStellt eine verallgemeinerte Information über die Kraftschlussverhältnisse zwischen Antrieb und den angetriebenen Rädern sowie zwischen Rad und Karosserie dar.'                                              } ...
  ,{'REIN_PT'                  ,'-'      ,0       ,''            ,''                      ,'-'       ,'Verstärkung_Antriebsstrang'                                                                                                                                                                                                                     } ...
  ,{'QU_REIN_PT'               ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                      } ...
  ,{'ALIVE_HAF_A12'            ,'enum'   ,0       ,''            ,'ALIVE_HAF_A12'         ,'enum'    ,'Alivecounter HAF A12'                                                                                                                                                                                                                           } ...
  ,{'AVL_BRTORQ_SUM_DVCH'      ,'Nm'     ,0       ,''            ,''                      ,'Nm'      ,'Ist_Bremsmoment_Summe_FahrerwunschAktuelles radbezogenes Bremsmoment das der Fahrer über das Bremspedal versucht zu stellen. Bei einer Bremspedalbetätigung wird ein negativer Wert übertragen'                                                 } ...
  ,{'QU_AVL_BRTORQ_SUM_DVCH'   ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                      } ...
  ,{'AVL_ANG_ACPD_VIRT'        ,'%'      ,0       ,''            ,''                      ,'%'       ,'Ist Winkel Fahrpedal VirutellDieses Signal überträgt den errechneten Fahrpedalwinkel, der sich aus der aktuellen Fahrgeschwindigkeitsregelung ergibt. Finden keine FAS-Eingriffe statt, entspricht der virtuelle Fahrpedalwinkel dem Ist-Winkel'} ...
  ,{'ST_INTF_DRASY'            ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Status_Schnittstelle_FahrerassistenzsystemStatus zum Fahrpedal und zum Verhältnis der Fahreranforderung bzgl. der FAS-Anforderung.'                                                                                                             } ...
  ,{'ST_KL'                    ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Klemmenstatus'                                                                                                                                                                                                                                  } ...
  ,{'ST_ENG_RUN_DRV'           ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Status Motor läuft'                                                                                                                                                                                                                             } ...
  ,{'QU_TAR_WMOM_PT_SUM_DRS'   ,'enum'   ,0       ,''            ,'QU_TAR_WMOM_PT_SUM_DRS','enum'    ,'Qualifier Antriebsmomentenanforderung'                                                                                                                                                                                                          } ...
  ,{'TAR_WMOM_PT_SUM_DRS'      ,'Nm'     ,0       ,''            ,'TAR_WMOM_PT_SUM_DRS'   ,'Nm'      ,'Antriebsmomentenanforderung'                                                                                                                                                                                                                    } ...
  ,{'QU_TAR_STMOM_DV_ACT'      ,'enum'   ,0       ,''            ,'QU_TAR_STMOM_DV_ACT'   ,'enum'    ,'Qualifier Antriebsmomentenanforderung'                                                                                                                                                                                                          } ...
  ,{'TAR_STMOM_DV_ACT'         ,'Nm'     ,0       ,''            ,'TAR_STMOM_DV_ACT'      ,'Nm'      ,'Antriebsmomentenanforderung'                                                                                                                                                                                                                    } ...
  ,{'QU_TAR_BRTORQ_SUM'        ,'enum'   ,0       ,''            ,'QU_TAR_BRTORQ_SUM'     ,'enum'    ,'Qualifier Bremsmomentenanforderung'                                                                                                                                                                                                             } ...
  ,{'TAR_BRTORQ_SUM'           ,'Nm'     ,0       ,''            ,'TAR_BRTORQ_SUM'        ,'Nm'      ,'Bremsmomentenanforderung'                                                                                                                                                                                                                       } ...
  ,{'HAF_T1_TYPE'              ,'enum'   ,0       ,''            ,'HAF_T1_TYPE'           ,'enum'    ,'Testanforderungstyp (1: Lenkmoment,2: Antriebsmoment,3: Bremsmoment,4: SigGenStWhlTor,5: HDAXvref,6: HADYdeltaStWhl'                                                                                                                            } ...
  ,{'HAF_T1_StatusReqVal'      ,'enum'   ,0       ,''            ,'HAF_T1_StatusReqVal'   ,'enum'    ,'Anforderungsstatus 0: keine Anf.,1: Anforderung'                                                                                                                                                                                                } ...
  ,{'HAF_T1_ReqVal'            ,'-'      ,0       ,''            ,'HAF_T1_ReqVal'         ,'-'       ,'Anforderungswert'                                                                                                                                                                                                                               } ...
  ,{'HAF_T1_Faktor'            ,'-'      ,0       ,''            ,'HAF_T1_Faktor'         ,'-'       ,'Faktor auf Anforderungswert'                                                                                                                                                                                                                    } ...
  };

  Ssig = cell_liste2struct(c);

%   c = ...
%   {{                'name_in','unit_in','lin_in','name_sign_in',              'name_out','unit_out',                                                                                                                                                                                                                                                  'comment'} ...
%   ,{'AVL_WMOM_PT_SUM_ERR_AMP','Nm'     ,0       ,''            ,'VehSpd'                ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_Summe_Fehler_AmplitudeDie Fehleramplitude beschreibt die best mögliche Genauigkeit des tatsächlich antreibenden Radmomentes'                                                                                                 } ...
%   ,{'RQ_TAO_SSM'             ,'enum'   ,0       ,''            ,'StW_Angl'              ,'enum'    ,'Anforderung_Übernahme_StillstandsmanagementMit diesem Signal kann eine FAS Funktion die Übernahme durch das Stillstandsmanagement (SSM) anfordern, bzw. die Sicherung des Fahrzeuges im Stillstand durch hydraulisches oder mechanisches halten anfordern'} ...
%   ,{'TAR_BRTORQ_SUM'         ,'Nm'     ,0       ,''            ,'StW_AnglSpd'           ,'Nm'      ,'Soll_Bremsmoment_SummeSollwertvorgabe des radbezogenen Summenbremsmoments an das DSC-Steuergerät (unabhängig davon, ob es durch Reibbremse und/oder Bremsrekuperation umgesetzt wird).'                                                                   } ...
%   ,{'QU_TAR_BRTORQ_SUM'      ,'enum'   ,0       ,''            ,'VehYawRate_Raw'        ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'TAR_WMOM_PT_SUM_DRS'    ,'Nm'     ,0       ,''            ,'VehAccel_Y'            ,'Nm'      ,'Soll_Radmoment_Antriebsstrang_Summe_FASDieses Signal beinhaltet das angefordert (koordinierte und plausibilisierte) antreibende Summen-Radmoment der Fahrerassistenzsysteme.'                                                                             } ...
%   ,{'QU_TAR_WMOM_PT_SUM_DRS' ,'enum'   ,0       ,''            ,'WhlPlsCnt_FL'          ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'TAR_STMOM_DV_ACT'       ,'Nm'     ,0       ,''            ,'WhlPlsCnt_FR'          ,'Nm'      ,'Soll_Lenkmoment'                                                                                                                                                                                                                                          } ...
%   ,{'QU_TAR_STMOM_DV_ACT'    ,'enum'   ,0       ,''            ,'WhlPlsCnt_RL'          ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_ANG_ACPD'           ,'%'      ,0       ,''            ,'WhlPlsCnt_RR'          ,'%'       ,'Ist_Winkel_FahrpedalVom Antriebsstrang gemeldeter Istwinkel des Fahrpedals. 100% Fahrpedalwinkel wird nur bei erkanntem Kickdown versendet. Ohne Kickdown beträgt der Wert maximal 99.975%.'                                                              } ...
%   ,{'QU_AVL_ANG_ACPD'        ,'enum'   ,0       ,''            ,'Gear'                  ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'GRAD_AVL_ANG_ACPD'      ,'%/s'    ,0       ,''            ,'Brk_Torque'            ,'%/s'     ,'Gradient_Ist_Winkel_FahrpedalGradient des Ist_Winkel_Fahrpedals.'                                                                                                                                                                                         } ...
%   ,{'QU_AVL_RPM_BAX_RED'     ,'enum'   ,0       ,''            ,'ABS_ACT'               ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_RPM_BAX_RED'        ,'1/min'  ,0       ,''            ,'TCS_ACT'               ,'1/min'   ,'Ist_Drehzahl_Hinterachse_Redundant'                                                                                                                                                                                                                       } ...
%   ,{'ST_AVAI_INTV_PT_DRS'    ,'enum'   ,0       ,''            ,'VSC_ACT'               ,'enum'    ,'Status_Verfügbarkeit_Eingriff_Antriebsstrang_FASRückmeldung des Antriebsstranges ob Eingriffe bezüglich Fahrtrichtungswunsch oder Kraftschluss erlaubt sind. Dieses Signal ist Bestandteil der Domänenteilschnittstelle Zustand Antrieb'                  } ...
%   ,{'AVL_BRTORQ_SUM'         ,'Nm'     ,0       ,''            ,'VehAccel_X_Sen'        ,'Nm'      ,'Ist Bremsmoment SummeAktuelles radbezogene Summen-Reibbremsmoment des DSC-Steuergeräts. Ein negatives Bremsmoment entspricht einer Reibkraft entgegen der Fahrzeugbewegung.'                                                                              } ...
%   ,{'QU_AVL_BRTORQ_SUM'      ,'enum'   ,0       ,''            ,'ACCEL_PEDAL_TRAVEL'    ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'ATTA_ESTI'              ,'°'      ,0       ,''            ,'RDU_FahrerLenkmoment'  ,'°'       ,'Schwimmwinkel'                                                                                                                                                                                                                                            } ...
%   ,{'QU_VEH_DYNMC_DT_ESTI'   ,'enum'   ,0       ,''            ,'Giergeschw'            ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'ATTA_ESTI_ERR_AMP'      ,'°'      ,0       ,''            ,'LRW'                   ,'°'       ,'Schwimmwinkel Fehleramplitude'                                                                                                                                                                                                                            } ...
%   ,{'ATTAV_ESTI'             ,'°/s'    ,0       ,''            ,'LRW_Gesch'             ,'°/s'     ,'Schwimmwinkelgeschwindigkeit'                                                                                                                                                                                                                             } ...
%   ,{'ATTAV_ESTI_ERR_AMP'     ,'°/s'    ,0       ,''            ,'WhlRPM_FL'             ,'°/s'     ,'Schwimmwinkel Fehleramplitude'                                                                                                                                                                                                                            } ...
%   ,{'ACLNX_COG'              ,'m/s²'   ,0       ,''            ,'WhlDir_FL_Stat'        ,'m/s²'    ,'Längsbeschleunigung im Fahrzeugschwerpunkt. Eine positive Längsbeschleunigung wirkt in Fahrzeug X-Richtung. Fahrzeugkoordinatensystem gemäß ISO 8855.'                                                                                                    } ...
%   ,{'ACLNX_COG_ERR_AMP'      ,'m/s²'   ,0       ,''            ,'WhlRPM_FR'             ,'m/s²'    ,'Längsbeschleunigung_Schwerpunkt_Fehler_Amplitude'                                                                                                                                                                                                         } ...
%   ,{'QU_ACLNX_COG'           ,'enum'   ,0       ,''            ,'WhlDir_FR_Stat'        ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'ACLNY_COG'              ,'m/s²'   ,0       ,''            ,'WhlRPM_RL'             ,'m/s²'    ,'Querbeschleunigung Fahrzeugschwerpunkt'                                                                                                                                                                                                                   } ...
%   ,{'ACLNY_COG_ERR_AMP'      ,'m/s²'   ,0       ,''            ,'WhlDir_RL_Stat'        ,'m/s²'    ,'Querbeschleunigung_Schwerpunkt_Fehler_Amplitude'                                                                                                                                                                                                          } ...
%   ,{'QU_ACLNY_COG'           ,'enum'   ,0       ,''            ,'WhlRPM_RR'             ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'VYAW_VEH'               ,'°/s'    ,0       ,''            ,'WhlDir_RR_Stat'        ,'°/s'     ,'Giergeschwindigkeit_FahrzeugRichtung nach ISO 8855 (positiver Winkel entspricht Drehung gegen den Uhrzeigersinn).'                                                                                                                                        } ...
%   ,{'VYAW_VEH_ERR_AMP'       ,'°/s'    ,0       ,''            ,'ALIVE_HAF_A10'         ,'°/s'     ,'Giergeschwindigkeit_Fahrzeug_Fehler_Amplitude'                                                                                                                                                                                                            } ...
%   ,{'QU_VYAW_VEH'            ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'V_VEH_COG'              ,'km/h'   ,0       ,''            ,''                      ,'km/h'    ,'Geschwindigkeit Fahrzeugschwerpunkt'                                                                                                                                                                                                                      } ...
%   ,{'QU_V_VEH_COG'           ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'DVCO_VEH'               ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Fahrzustand_Fahrzeug'                                                                                                                                                                                                                                     } ...
%   ,{'MILE_WHL_FLH'           ,'cm'     ,0       ,''            ,''                      ,'cm'      ,'Wegstrecke Rad'                                                                                                                                                                                                                                           } ...
%   ,{'MILE_WHL_FRH'           ,'cm'     ,0       ,''            ,'ALIVE_HAF_A11'         ,'cm'      ,'Wegstrecke Rad'                                                                                                                                                                                                                                           } ...
%   ,{'SIGAGE_MILE_WHL_FS'     ,'ms'     ,0       ,''            ,''                      ,'ms'      ,'Signalalter'                                                                                                                                                                                                                                              } ...
%   ,{'QU_MILE_WHL_FLH'        ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'QU_MILE_WHL_FRH'        ,'enum'   ,0       ,''            ,'ST_AVAI_INTV_PT_DRS '  ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'MILE_WHL_RLH'           ,'cm'     ,0       ,''            ,''                      ,'cm'      ,'Wegstrecke Rad'                                                                                                                                                                                                                                           } ...
%   ,{'MILE_WHL_RRH'           ,'cm'     ,0       ,''            ,''                      ,'cm'      ,'Wegstrecke Rad'                                                                                                                                                                                                                                           } ...
%   ,{'SIGAGE_MILE_WHL_RS'     ,'ms'     ,0       ,''            ,''                      ,'ms'      ,'Signalalter'                                                                                                                                                                                                                                              } ...
%   ,{'QU_MILE_WHL_RLH'        ,'enum'   ,0       ,''            ,'ALIVE_HAF_A12'         ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'QU_MILE_WHL_RRH'        ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_RPM_WHL_RLH'        ,'rad/s'  ,0       ,''            ,''                      ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
%   ,{'AVL_RPM_WHL_RRH'        ,'rad/s'  ,0       ,''            ,''                      ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
%   ,{'AVL_RPM_WHL_FLH'        ,'rad/s'  ,0       ,''            ,''                      ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
%   ,{'AVL_RPM_WHL_FRH'        ,'rad/s'  ,0       ,''            ,''                      ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
%   ,{'AVL_QUAN_EES_WHL_RLH'   ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
%   ,{'AVL_QUAN_EES_WHL_RRH'   ,'enum'   ,0       ,''            ,'QU_TAR_WMOM_PT_SUM_DRS','enum'    ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
%   ,{'AVL_QUAN_EES_WHL_FLH'   ,'enum'   ,0       ,''            ,'TAR_WMOM_PT_SUM_DRS'   ,'enum'    ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
%   ,{'AVL_QUAN_EES_WHL_FRH'   ,'enum'   ,0       ,''            ,'QU_TAR_STMOM_DV_ACT'   ,'enum'    ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
%   ,{'QU_HOFF_RCOG'           ,'enum'   ,0       ,''            ,'TAR_STMOM_DV_ACT'      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_STMOM_DV_ACT'       ,'Nm'     ,0       ,''            ,'QU_TAR_BRTORQ_SUM'     ,'Nm'      ,'Ist_Lenkmoment_Fahrer_StellgliedDas Signal Ist_Lenkmoment_Fahrer stellt das Fahrerlenkmoment im Gegenuhrzeigersinn positiv dar'                                                                                                                           } ...
%   ,{'QU_AVL_STMOM_DV_ACT'    ,'enum'   ,0       ,''            ,'TAR_BRTORQ_SUM'        ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'MILE_VEH'               ,'m'      ,0       ,''            ,'HAF_T1_TYPE'           ,'m'       ,'Wegstrecke_FahrzeugBerechnete und plausibilisierte Wegstreckeninformation, die sich aus der Anzahl der gemessenen Geberflanken der Radsensoren ergibt'                                                                                                    } ...
%   ,{'QU_MILE_VEH'            ,'enum'   ,0       ,''            ,'HAF_T1_StatusReqVal'   ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_STEA_DV'            ,'°'      ,0       ,''            ,'HAF_T1_ReqVal'         ,'°'       ,'Ist_Lenkwinkel_FahrerTatsächlicher, offsetbereinigter Einschlag des Lenkrads durch den Fahrer auf das Lenkrad bezogen.'                                                                                                                                   } ...
%   ,{'AVL_STEAV_DV'           ,'°/s'    ,0       ,''            ,'HAF_T1_Faktor'         ,'°/s'     ,'Ist_Lenkwinkelgeschwindigkeit_Fahrer'                                                                                                                                                                                                                     } ...
%   ,{'QU_AVL_STEAV_DV'        ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'QU_AVL_STEA_DV'         ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'ST_GRSEL_DRV'           ,'enum'   ,0       ,''            ,''                      ,'enum'    ,'Status Gang Getriebe'                                                                                                                                                                                                                                     } ...
%   };
%   Ssig = cell_liste2struct(c);
  
  
   iSig = 0;
%   %===============================================================================================
%   % Vehicle Dynamics
%   %===============================================================================================
%   %-----------------------------------------------------------------------------------------------
%   % HAF_A1
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
%   % HAF_A2
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
%   % HAF_A3
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlPlsCnt_FL';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlPlsCnt_FL';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Raddrehpulse vorne links';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlPlsCnt_FR';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlPlsCnt_FR';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Raddrehpulse vorne rechts';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlPlsCnt_RL';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlPlsCnt_RL';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Raddrehpulse hinten links';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlPlsCnt_RR';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlPlsCnt_RR';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Raddrehpulse hinten rechts';
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
%   Ssig(iSig).name_in      = 'Brk_Torque';
%   Ssig(iSig).unit_in      = 'Nm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Brk_Torque';
%   Ssig(iSig).unit_out     = 'Nm';
%   Ssig(iSig).comment      = 'Bremsmoment';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ABS_ACT';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ABS_ACT';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'ABS aktiv';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'TCS_ACT';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'TCS_ACT';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'TCS aktiv';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'VSC_ACT';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'VSC_ACT';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'ESP aktiv';
%   %-----------------------------------------------------------------------------------------------
%   % HAF_A4
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
%   % iSig = iSig + 1;
%   % Ssig(iSig).name_in      = 'VehAccel_X_Est';
%   % Ssig(iSig).unit_in      = 'm/s/s';
%   % Ssig(iSig).lin_in       = 0;
%   % Ssig(iSig).name_sign_in = '';
%   % Ssig(iSig).name_out     = 'VehAccel_X_Est';
%   % Ssig(iSig).unit_out     = 'm/s/s';
%   % Ssig(iSig).comment      = 'Fahrzeugquerbeschleunigung Estimation';
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
%   % HAF_A8
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
%   Ssig(iSig).name_in      = 'Giergeschw';
%   Ssig(iSig).unit_in      = 'deg/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'Giergeschw';
%   Ssig(iSig).unit_out     = 'rad/s';
%   Ssig(iSig).comment      = 'A8 übertragene Giergeschwindigkeit';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'LRW';
%   Ssig(iSig).unit_in      = 'deg';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'LRW';
%   Ssig(iSig).unit_out     = 'rad';
%   Ssig(iSig).comment      = 'A8 übertragene Lenkwinkel';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'LRW_Gesch';
%   Ssig(iSig).unit_in      = 'deg/s';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'LRW_Gesch';
%   Ssig(iSig).unit_out     = 'rad/s';
%   Ssig(iSig).comment      = 'A8 übertragene Lenkwinkelgeschw';
%   %-----------------------------------------------------------------------------------------------
%   % HAF_A9
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlRPM_FL';
%   Ssig(iSig).unit_in      = 'rpm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlRPM_FL';
%   Ssig(iSig).unit_out     = 'rpm';
%   Ssig(iSig).comment      = 'Raddrehgeschwindigkeit vorne links';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlDir_FL_Stat';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlDir_FL_Stat';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Status Raddrehrichtung vorne links 1: vor 2:rueck';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlRPM_FR';
%   Ssig(iSig).unit_in      = 'rpm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlRPM_FR';
%   Ssig(iSig).unit_out     = 'rpm';
%   Ssig(iSig).comment      = 'Raddrehgeschwindigkeit vorne rechts';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlDir_FR_Stat';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlDir_FR_Stat';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Status Raddrehrichtung vorne rechts 1: vor 2:rueck';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlRPM_RL';
%   Ssig(iSig).unit_in      = 'rpm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlRPM_RL';
%   Ssig(iSig).unit_out     = 'rpm';
%   Ssig(iSig).comment      = 'Raddrehgeschwindigkeit hinten links';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlDir_RL_Stat';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlDir_RL_Stat';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Status Raddrehrichtung hinten links 1: vor 2:rueck';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlRPM_RR';
%   Ssig(iSig).unit_in      = 'rpm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlRPM_RR';
%   Ssig(iSig).unit_out     = 'rpm';
%   Ssig(iSig).comment      = 'Raddrehgeschwindigkeit hinten rechts';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'WhlDir_RR_Stat';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'WhlDir_RR_Stat';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Status Raddrehrichtung hinten rechts 1: vor 2:rueck';
%   
%   %-----------------------------------------------------------------------------------------------
%   % HAF_A10
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ALIVE_HAF_A10';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ALIVE_HAF_A10';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Alivecounter HAF A10';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM';
%   Ssig(iSig).unit_in  = 'Nm';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'Nm';
%   Ssig(iSig).comment  = 'Ist_Radmoment_Antriebsstrang_SummeAktuell antreibendes Summen-Radmoment des Antriebsstrangs.';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'QU_AVL_WMOM_PT_SUM';
%   Ssig(iSig).unit_in  = 'enum';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'enum';
%   Ssig(iSig).comment  = 'Qualifier';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM_DTORQ_BOT';
%   Ssig(iSig).unit_in  = 'Nm';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'Nm';
%   Ssig(iSig).comment  = 'Maximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM_DTORQ_TOP';
%   Ssig(iSig).unit_in  = 'Nm';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'Nm';
%   Ssig(iSig).comment  = 'Ist_Radmoment_Antriebsstrang_Summe_Schleppmoment_ObenMaximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt das kontinuierlich erreichbar ist.';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'ST_DRVDIR_DVCH';
%   Ssig(iSig).unit_in  = 'enum';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'enum';
%   Ssig(iSig).comment  = 'Status_Fahrtrichtung_FahrerwunschGibt die wahrscheinliche Fahrtrichtung des Fahrzeuges an.';
%   %-----------------------------------------------------------------------------------------------
%   % HAF_A11
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ALIVE_HAF_A11';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ALIVE_HAF_A11';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Alivecounter HAF A11';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM_RECUP_MAX';
%   Ssig(iSig).unit_in  = 'Nm';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'Nm';
%   Ssig(iSig).comment  = 'Ist_Radmoment_Antriebsstrang_Summe_Rekuperation_MaximalSumme von dem maximalen Schleppmoment Unten und Bremsrekuperationsmoment, das momentan zur Verfügung steht.';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM_MAX';
%   Ssig(iSig).unit_in  = 'Nm';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'Nm';
%   Ssig(iSig).comment  = 'Ist_Radmoment_Antriebsstrang_Summe_Maximal';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ST_AVAI_INTV_PT_DRS ';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ST_AVAI_INTV_PT_DRS ';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Status_Verfügbarkeit_Eingriff_Antriebsstrang_FAS';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'ST_PENG_PT';
%   Ssig(iSig).unit_in  = 'enum';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'enum';
%   Ssig(iSig).comment  = 'Status_Kraftschluss_AntriebsstrangStellt eine verallgemeinerte Information über die Kraftschlussverhältnisse zwischen Antrieb und den angetriebenen Rädern sowie zwischen Rad und Karosserie dar.';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'REIN_PT';
%   Ssig(iSig).unit_in  = '-';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = '-';
%   Ssig(iSig).comment  = 'Verstärkung_Antriebsstrang';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'QU_REIN_PT';
%   Ssig(iSig).unit_in  = 'enum';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'enum';
%   Ssig(iSig).comment  = 'Qualifier';
%   %-----------------------------------------------------------------------------------------------
%   % HAF_A12
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'ALIVE_HAF_A12';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'ALIVE_HAF_A12';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Alivecounter HAF A12';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'AVL_BRTORQ_SUM_DVCH';
%   Ssig(iSig).unit_in  = 'Nm';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'Nm';
%   Ssig(iSig).comment  = 'Ist_Bremsmoment_Summe_FahrerwunschAktuelles radbezogenes Bremsmoment das der Fahrer über das Bremspedal versucht zu stellen. Bei einer Bremspedalbetätigung wird ein negativer Wert übertragen';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'QU_AVL_BRTORQ_SUM_DVCH';
%   Ssig(iSig).unit_in  = 'enum';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'enum';
%   Ssig(iSig).comment  = 'Qualifier';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'AVL_ANG_ACPD_VIRT';
%   Ssig(iSig).unit_in  = '%';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = '%';
%   Ssig(iSig).comment  = 'Ist Winkel Fahrpedal VirutellDieses Signal überträgt den errechneten Fahrpedalwinkel, der sich aus der aktuellen Fahrgeschwindigkeitsregelung ergibt. Finden keine FAS-Eingriffe statt, entspricht der virtuelle Fahrpedalwinkel dem Ist-Winkel';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'ST_INTF_DRASY';
%   Ssig(iSig).unit_in  = 'enum';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'enum';
%   Ssig(iSig).comment  = 'Status_Schnittstelle_FahrerassistenzsystemStatus zum Fahrpedal und zum Verhältnis der Fahreranforderung bzgl. der FAS-Anforderung.';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'ST_KL';
%   Ssig(iSig).unit_in  = 'enum';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'enum';
%   Ssig(iSig).comment  = 'Klemmenstatus';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in  = 'ST_ENG_RUN_DRV';
%   Ssig(iSig).unit_in  = 'enum';
%   Ssig(iSig).lin_in   = 0;
%   Ssig(iSig).unit_out = 'enum';
%   Ssig(iSig).comment  = 'Status Motor läuft';
%   %-----------------------------------------------------------------------------------------------
%   %-----------------------------------------------------------------------------------------------
%   % HAF_D1
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'QU_TAR_WMOM_PT_SUM_DRS';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'QU_TAR_WMOM_PT_SUM_DRS';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Qualifier Antriebsmomentenanforderung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'TAR_WMOM_PT_SUM_DRS';
%   Ssig(iSig).unit_in      = 'Nm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'TAR_WMOM_PT_SUM_DRS';
%   Ssig(iSig).unit_out     = 'Nm';
%   Ssig(iSig).comment      = 'Antriebsmomentenanforderung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'QU_TAR_STMOM_DV_ACT';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'QU_TAR_STMOM_DV_ACT';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Qualifier Antriebsmomentenanforderung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'TAR_STMOM_DV_ACT';
%   Ssig(iSig).unit_in      = 'Nm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'TAR_STMOM_DV_ACT';
%   Ssig(iSig).unit_out     = 'Nm';
%   Ssig(iSig).comment      = 'Antriebsmomentenanforderung';
%   %-----------------------------------------------------------------------------------------------
%   % HAF_D2
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'QU_TAR_BRTORQ_SUM';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'QU_TAR_BRTORQ_SUM';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Qualifier Bremsmomentenanforderung';
%   %-----------------------------------------------------------------------------------------------
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'TAR_BRTORQ_SUM';
%   Ssig(iSig).unit_in      = 'Nm';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'TAR_BRTORQ_SUM';
%   Ssig(iSig).unit_out     = 'Nm';
%   Ssig(iSig).comment      = 'Bremsmomentenanforderung';
%   %-----------------------------------------------------------------------------------------------
%   % HAF_T1
%   %-----------------------------------------------------------------------------------------------  
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'HAF_T1_TYPE';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'HAF_T1_TYPE';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Testanforderungstyp (1: Lenkmoment,2: Antriebsmoment,3: Bremsmoment,4: SigGenStWhlTor,5: HDAXvref,6: HADYdeltaStWhl';
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'HAF_T1_StatusReqVal';
%   Ssig(iSig).unit_in      = 'enum';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'HAF_T1_StatusReqVal';
%   Ssig(iSig).unit_out     = 'enum';
%   Ssig(iSig).comment      = 'Anforderungsstatus 0: keine Anf.,1: Anforderung';
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'HAF_T1_ReqVal';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'HAF_T1_ReqVal';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Anforderungswert';
%   iSig = iSig + 1;
%   Ssig(iSig).name_in      = 'HAF_T1_Faktor';
%   Ssig(iSig).unit_in      = '-';
%   Ssig(iSig).lin_in       = 0;
%   Ssig(iSig).name_sign_in = '';
%   Ssig(iSig).name_out     = 'HAF_T1_Faktor';
%   Ssig(iSig).unit_out     = '-';
%   Ssig(iSig).comment      = 'Faktor auf Anforderungswert';
%  





% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM_ERR_AMP';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Ist_Radmoment_Antriebsstrang_Summe_Fehler_AmplitudeDie Fehleramplitude beschreibt die best mögliche Genauigkeit des tatsächlich antreibenden Radmomentes';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'RQ_TAO_SSM';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Anforderung_Übernahme_StillstandsmanagementMit diesem Signal kann eine FAS Funktion die Übernahme durch das Stillstandsmanagement (SSM) anfordern, bzw. die Sicherung des Fahrzeuges im Stillstand durch hydraulisches oder mechanisches halten anfordern';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'TAR_BRTORQ_SUM';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Soll_Bremsmoment_SummeSollwertvorgabe des radbezogenen Summenbremsmoments an das DSC-Steuergerät (unabhängig davon, ob es durch Reibbremse und/oder Bremsrekuperation umgesetzt wird).';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_TAR_BRTORQ_SUM';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'TAR_WMOM_PT_SUM_DRS';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Soll_Radmoment_Antriebsstrang_Summe_FASDieses Signal beinhaltet das angefordert (koordinierte und plausibilisierte) antreibende Summen-Radmoment der Fahrerassistenzsysteme.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_TAR_WMOM_PT_SUM_DRS';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'TAR_STMOM_DV_ACT';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Soll_Lenkmoment';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_TAR_STMOM_DV_ACT';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_ANG_ACPD';
% Ssig(iSig).unit_in  = '%';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '%';
% Ssig(iSig).comment  = 'Ist_Winkel_FahrpedalVom Antriebsstrang gemeldeter Istwinkel des Fahrpedals. 100% Fahrpedalwinkel wird nur bei erkanntem Kickdown versendet. Ohne Kickdown beträgt der Wert maximal 99.975%.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_ANG_ACPD';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'GRAD_AVL_ANG_ACPD';
% Ssig(iSig).unit_in  = '%/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '%/s';
% Ssig(iSig).comment  = 'Gradient_Ist_Winkel_FahrpedalGradient des Ist_Winkel_Fahrpedals.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_RPM_BAX_RED';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_RPM_BAX_RED';
% Ssig(iSig).unit_in  = '1/min';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '1/min';
% Ssig(iSig).comment  = 'Ist_Drehzahl_Hinterachse_Redundant';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ST_AVAI_INTV_PT_DRS';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Status_Verfügbarkeit_Eingriff_Antriebsstrang_FASRückmeldung des Antriebsstranges ob Eingriffe bezüglich Fahrtrichtungswunsch oder Kraftschluss erlaubt sind. Dieses Signal ist Bestandteil der Domänenteilschnittstelle Zustand Antrieb';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_BRTORQ_SUM';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Ist Bremsmoment SummeAktuelles radbezogene Summen-Reibbremsmoment des DSC-Steuergeräts. Ein negatives Bremsmoment entspricht einer Reibkraft entgegen der Fahrzeugbewegung.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_BRTORQ_SUM';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ATTA_ESTI';
% Ssig(iSig).unit_in  = '°';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '°';
% Ssig(iSig).comment  = 'Schwimmwinkel';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_VEH_DYNMC_DT_ESTI';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ATTA_ESTI_ERR_AMP';
% Ssig(iSig).unit_in  = '°';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '°';
% Ssig(iSig).comment  = 'Schwimmwinkel Fehleramplitude';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ATTAV_ESTI';
% Ssig(iSig).unit_in  = '°/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '°/s';
% Ssig(iSig).comment  = 'Schwimmwinkelgeschwindigkeit';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ATTAV_ESTI_ERR_AMP';
% Ssig(iSig).unit_in  = '°/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '°/s';
% Ssig(iSig).comment  = 'Schwimmwinkel Fehleramplitude';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ACLNX_COG';
% Ssig(iSig).unit_in  = 'm/s²';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'm/s²';
% Ssig(iSig).comment  = 'Längsbeschleunigung im Fahrzeugschwerpunkt. Eine positive Längsbeschleunigung wirkt in Fahrzeug X-Richtung. Fahrzeugkoordinatensystem gemäß ISO 8855.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ACLNX_COG_ERR_AMP';
% Ssig(iSig).unit_in  = 'm/s²';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'm/s²';
% Ssig(iSig).comment  = 'Längsbeschleunigung_Schwerpunkt_Fehler_Amplitude';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_ACLNX_COG';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ACLNY_COG';
% Ssig(iSig).unit_in  = 'm/s²';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'm/s²';
% Ssig(iSig).comment  = 'Querbeschleunigung Fahrzeugschwerpunkt';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ACLNY_COG_ERR_AMP';
% Ssig(iSig).unit_in  = 'm/s²';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'm/s²';
% Ssig(iSig).comment  = 'Querbeschleunigung_Schwerpunkt_Fehler_Amplitude';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_ACLNY_COG';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'VYAW_VEH';
% Ssig(iSig).unit_in  = '°/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '°/s';
% Ssig(iSig).comment  = 'Giergeschwindigkeit_FahrzeugRichtung nach ISO 8855 (positiver Winkel entspricht Drehung gegen den Uhrzeigersinn).';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'VYAW_VEH_ERR_AMP';
% Ssig(iSig).unit_in  = '°/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '°/s';
% Ssig(iSig).comment  = 'Giergeschwindigkeit_Fahrzeug_Fehler_Amplitude';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_VYAW_VEH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'V_VEH_COG';
% Ssig(iSig).unit_in  = 'km/h';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'km/h';
% Ssig(iSig).comment  = 'Geschwindigkeit Fahrzeugschwerpunkt';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_V_VEH_COG';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'DVCO_VEH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Fahrzustand_Fahrzeug';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'MILE_WHL_FLH';
% Ssig(iSig).unit_in  = 'cm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'cm';
% Ssig(iSig).comment  = 'Wegstrecke Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'MILE_WHL_FRH';
% Ssig(iSig).unit_in  = 'cm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'cm';
% Ssig(iSig).comment  = 'Wegstrecke Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'SIGAGE_MILE_WHL_FS';
% Ssig(iSig).unit_in  = 'ms';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'ms';
% Ssig(iSig).comment  = 'Signalalter';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_MILE_WHL_FLH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_MILE_WHL_FRH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'MILE_WHL_RLH';
% Ssig(iSig).unit_in  = 'cm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'cm';
% Ssig(iSig).comment  = 'Wegstrecke Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'MILE_WHL_RRH';
% Ssig(iSig).unit_in  = 'cm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'cm';
% Ssig(iSig).comment  = 'Wegstrecke Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'SIGAGE_MILE_WHL_RS';
% Ssig(iSig).unit_in  = 'ms';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'ms';
% Ssig(iSig).comment  = 'Signalalter';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_MILE_WHL_RLH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_MILE_WHL_RRH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_RPM_WHL_RLH';
% Ssig(iSig).unit_in  = 'rad/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'rad/s';
% Ssig(iSig).comment  = 'Ist_Drehzahl_Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_RPM_WHL_RRH';
% Ssig(iSig).unit_in  = 'rad/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'rad/s';
% Ssig(iSig).comment  = 'Ist_Drehzahl_Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_RPM_WHL_FLH';
% Ssig(iSig).unit_in  = 'rad/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'rad/s';
% Ssig(iSig).comment  = 'Ist_Drehzahl_Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_RPM_WHL_FRH';
% Ssig(iSig).unit_in  = 'rad/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'rad/s';
% Ssig(iSig).comment  = 'Ist_Drehzahl_Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_QUAN_EES_WHL_RLH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Ist Anzahl Geberflanken Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_QUAN_EES_WHL_RRH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Ist Anzahl Geberflanken Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_QUAN_EES_WHL_FLH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Ist Anzahl Geberflanken Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_QUAN_EES_WHL_FRH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Ist Anzahl Geberflanken Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_HOFF_RCOG';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_STMOM_DV_ACT';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Ist_Lenkmoment_Fahrer_StellgliedDas Signal Ist_Lenkmoment_Fahrer stellt das Fahrerlenkmoment im Gegenuhrzeigersinn positiv dar';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_STMOM_DV_ACT';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'MILE_VEH';
% Ssig(iSig).unit_in  = 'm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'm';
% Ssig(iSig).comment  = 'Wegstrecke_FahrzeugBerechnete und plausibilisierte Wegstreckeninformation, die sich aus der Anzahl der gemessenen Geberflanken der Radsensoren ergibt';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_MILE_VEH';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_STEA_DV';
% Ssig(iSig).unit_in  = '°';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '°';
% Ssig(iSig).comment  = 'Ist_Lenkwinkel_FahrerTatsächlicher, offsetbereinigter Einschlag des Lenkrads durch den Fahrer auf das Lenkrad bezogen.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_STEAV_DV';
% Ssig(iSig).unit_in  = '°/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '°/s';
% Ssig(iSig).comment  = 'Ist_Lenkwinkelgeschwindigkeit_Fahrer';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_STEAV_DV';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_STEA_DV';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ST_GRSEL_DRV';
% Ssig(iSig).unit_in  = 'enum';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'enum';
% Ssig(iSig).comment  = 'Status Gang Getriebe';
% 
% okay = struct2cell_liste(Ssig)

end
