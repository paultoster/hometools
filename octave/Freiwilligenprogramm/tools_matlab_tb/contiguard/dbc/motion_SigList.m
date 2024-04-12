function Ssig = motion_SigList
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
  {{                  'name_in','unit_in','lin_in','unit_out',                                                                                                                                                                                                                                                  'comment'} ...
  ,{'ATTA_ESTI'                ,'°'      ,0       ,'°'       ,'Schwimmwinkel'                                                                                                                                                                                                                                            } ...
  ,{'QU_VEH_DYNMC_DT_ESTI'     ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'ATTAV_ESTI'               ,'°/s'    ,0       ,'°/s'     ,'Schwimmwinkelgeschwindigkeit'                                                                                                                                                                                                                             } ...
  ,{'QU_TAR_STMOM_DV_ACT'      ,'ENUM'   ,0       ,'ENUM'    ,'QualifierSollLenkmomentFahrerStellglied0xF Signal ungültig Wird nicht aktiv gesetzt0xE Standby: Sollwerte nicht umsetz Wird auch im Fehlerfall gesetzt.0x7 Sollwerte nicht vorhanden0x2 Sollwerte umsetzen Es wird ein Lenkmoment angefordert.'           } ...
  ,{'TAR_STMOM_DV_ACT'         ,'Nm'     ,0       ,'Nm'      ,'Soll_Lenkmoment_Fahrer_Stellglied: Gestelltes Motormoment für den EPS Aktuator. Offsetmoment (+/-1Nm).'                                                                                                                                                   } ...
  ,{'QU_TAR_WMOM_PT_SUM_DRS'   ,'ENUM'   ,0       ,'ENUM'    ,'Qualifier_Soll_Radmoment_Antriebsstrang_Summe_FAS, Signaltabelle aus Nachrichtenkatalog entnehmen!'                                                                                                                                                       } ...
  ,{'TAR_WMOM_PT_SUM_DRS'      ,'Nm'     ,0       ,'Nm'      ,'Soll_Radmoment_Antriebsstrang_Summe_FAS: Dieses Signal beinhaltet das angefordert (koordinierte und plausibilisierte) antreibende Summen-Radmoment der Fahrerassistenzsysteme.'                                                                           } ...
  ,{'QU_TAR_BRTORQ_SUM'        ,'ENUM'   ,0       ,'ENUM'    ,'Qualifier Soll_Bremsmoment_Summe0 = 0xE01 = 0x202 = 0x243 = 0x26'                                                                                                                                                                                         } ...
  ,{'RQ_TAO_SSM'               ,'ENUM'   ,0       ,'ENUM'    ,'Anforderung_Übernahme_StillstandsmanagementMit diesem Signal kann eine FAS Funktion die Übernahme durch das Stillstandsmanagement (SSM) anfordern, bzw. die Sicherung des Fahrzeuges im Stillstand durch hydraulisches oder mechanisches halten anfordern'} ...
  ,{'TAR_BRTORQ_SUM'           ,'Nm'     ,0       ,'Nm'      ,'Soll_Bremsmoment_SummeSollwertvorgabe des radbezogenen Summenbremsmoments an das DSC-Steuergerät (unabhängig davon, ob es durch Reibbremse und/oder Bremsrekuperation umgesetzt wird).'                                                                   } ...
  ,{'QU_TAR_DIFF_BRTORQ_YMR'   ,'ENUM'   ,0       ,'ENUM'    ,'Qualifier_Soll_Differenz_Bremsmoment_Giermomentverteilung'                                                                                                                                                                                                } ...
  ,{'TAR_DIFF_BRTORQ_FTAX_YMR' ,'Nm'     ,0       ,'Nm'      ,'Soll_Differenz_Bremsmoment_Vorderachse_Giermomentverteilung: Einzustellendes Raddifferenzbremsmoment der Giermomentverteilung an der Vorderachse. Ein positiver Wert erzeugt ein linksdrehendes Giermoment über die Vorderachse.'                         } ...
  ,{'TAR_DIFF_BRTORQ_BAX_YMR'  ,'Nm'     ,0       ,'Nm'      ,'Soll_Differenz_Bremsmoment_Hinterachse_Giermomentverteilung: Einzustellendes Raddifferenzbremsmoment der Giermomentverteilung an der Hinterachse. Ein positiver Wert erzeugt ein linksdrehendes Giermoment über die Hinterachse.'                         } ...
  ,{'FACT_TAR_COMPT_DRV_YMR'   ,''       ,0       ,''        ,'Faktor_Soll_Kompensation_Antrieb_Giermomentverteilung'                                                                                                                                                                                                    } ...
  ,{'QU_V_VEH_COG'             ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'V_VEH_COG'                ,'km/h'   ,0       ,'km/h'    ,'Geschwindigkeit Fahrzeugschwerpunkt'                                                                                                                                                                                                                      } ...
  ,{'QU_VYAW_VEH'              ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'VYAW_VEH'                 ,'°/s'    ,0       ,'°/s'     ,'Giergeschwindigkeit_FahrzeugRichtung nach ISO 8855 (positiver Winkel entspricht Drehung gegen den Uhrzeigersinn).'                                                                                                                                        } ...
  ,{'QU_ACLNX_COG'             ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'ACLNX_COG'                ,'m/s²'   ,0       ,'m/s²'    ,'Längsbeschleunigung im Fahrzeugschwerpunkt. Eine positive Längsbeschleunigung wirkt in Fahrzeug X-Richtung. Fahrzeugkoordinatensystem gemäß ISO 8855.'                                                                                                    } ...
  ,{'QU_ACLNY_COG'             ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'ACLNY_COG'                ,'m/s²'   ,0       ,'m/s²'    ,'Querbeschleunigung Fahrzeugschwerpunkt'                                                                                                                                                                                                                   } ...
  ,{'AVL_RPM_WHL_FLH'          ,'rad/s'  ,0       ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
  ,{'AVL_RPM_WHL_FRH'          ,'rad/s'  ,0       ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
  ,{'AVL_RPM_WHL_RLH'          ,'rad/s'  ,0       ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
  ,{'AVL_RPM_WHL_RRH'          ,'rad/s'  ,0       ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
  ,{'QU_AVL_STMOM_DV_ACT'      ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'AVL_STMOM_DV_ACT'         ,'Nm'     ,0       ,'Nm'      ,'Ist_Lenkmoment_Fahrer_StellgliedDas Signal Ist_Lenkmoment_Fahrer stellt das Fahrerlenkmoment im Gegenuhrzeigersinn positiv dar'                                                                                                                           } ...
  ,{'QU_AVL_FORC_GRD'          ,''       ,0       ,''        ,''                                                                                                                                                                                                                                                         } ...
  ,{'AVL_FORC_GRD'             ,'kN'     ,0       ,'kN'      ,''                                                                                                                                                                                                                                                         } ...
  ,{'QU_HOFF_RCOG'             ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'QU_FN_EST'                ,''       ,0       ,''        ,''                                                                                                                                                                                                                                                         } ...
  ,{'QU_SER_STMOM_DV_ACT'      ,''       ,0       ,''        ,''                                                                                                                                                                                                                                                         } ...
  ,{'QU_AVL_STEA_DV'           ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'AVL_STEA_DV'              ,'°'      ,0       ,'°'       ,'Ist_Lenkwinkel_FahrerTatsächlicher, offsetbereinigter Einschlag des Lenkrads durch den Fahrer auf das Lenkrad bezogen.'                                                                                                                                   } ...
  ,{'AVL_STEAV_DV'             ,'°/s'    ,0       ,'°/s'     ,'Ist_Lenkwinkelgeschwindigkeit_Fahrer'                                                                                                                                                                                                                     } ...
  ,{'QU_AVL_STEAV_DV'          ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'Ist_Motormoment_EPS'      ,''       ,0       ,''        ,''                                                                                                                                                                                                                                                         } ...
  ,{'AVL_WMOM_PT_SUM_MAX'      ,'Nm'     ,0       ,'Nm'      ,'Obere Grenze für die aktuell umsetzbare Anforderung des antreibenden Summen-Radmomentes bezogen auf die aktuell anliegenden Übersetzungsverhältnisse. Die Wirkrichtung des Radmom'                                                                        } ...
  ,{'AVL_WMOM_PT_SUM_DTORQ_BOT','Nm'     ,0       ,'Nm'      ,'Maximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt'                                                                                                                                                                               } ...
  ,{'AVL_WMOM_PT_SUM_DTORQ_TOP','Nm'     ,0       ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_Summe_Schleppmoment_ObenMaximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt das kontinuierlich erreichbar ist.'                                                                                       } ...
  ,{'QU_AVL_WMOM_PT_SUM'       ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'AVL_WMOM_PT_SUM'          ,'Nm'     ,0       ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_SummeAktuell antreibendes Summen-Radmoment des Antriebsstrangs.'                                                                                                                                                             } ...
  ,{'AVL_WMOM_PT_SUM_RECUP_MAX','Nm'     ,0       ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_Summe_Rekuperation_MaximalSumme von dem maximalen Schleppmoment Unten und Bremsrekuperationsmoment, das momentan zur Verfügung steht.'                                                                                       } ...
  ,{'REIN_PT'                  ,''       ,0       ,''        ,'Verstärkung_Antriebsstrang'                                                                                                                                                                                                                               } ...
  ,{'QU_REIN_PT'               ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'QU_AVL_BRTORQ_SUM'        ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'AVL_BRTORQ_SUM'           ,'Nm'     ,0       ,'Nm'      ,'Ist Bremsmoment SummeAktuelles radbezogene Summen-Reibbremsmoment des DSC-Steuergeräts. Ein negatives Bremsmoment entspricht einer Reibkraft entgegen der Fahrzeugbewegung.'                                                                              } ...
  ,{'AVL_BRTORQ_SUM_DVCH'      ,'Nm'     ,0       ,'Nm'      ,'Ist_Bremsmoment_Summe_FahrerwunschAktuelles radbezogenes Bremsmoment das der Fahrer über das Bremspedal versucht zu stellen. Bei einer Bremspedalbetätigung wird ein negativer Wert übertragen'                                                           } ...
  ,{'QU_AVL_BRTORQ_SUM_DVCH'   ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'QU_SER_ECBA'              ,''       ,0       ,''        ,''                                                                                                                                                                                                                                                         } ...
  ,{'QU_SER_CLCTR_YMR'         ,''       ,0       ,''        ,''                                                                                                                                                                                                                                                         } ...
  ,{'AVL_QUAN_EES_WHL_FLH'     ,''       ,0       ,''        ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
  ,{'AVL_QUAN_EES_WHL_FRH'     ,''       ,0       ,''        ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
  ,{'AVL_QUAN_EES_WHL_RLH'     ,''       ,0       ,''        ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
  ,{'AVL_QUAN_EES_WHL_RRH'     ,''       ,0       ,''        ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
  ,{'QU_AVL_ANG_ACPD'          ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'AVL_ANG_ACPD'             ,'%'      ,0       ,'%'       ,'Ist_Winkel_FahrpedalVom Antriebsstrang gemeldeter Istwinkel des Fahrpedals. 100% Fahrpedalwinkel wird nur bei erkanntem Kickdown versendet. Ohne Kickdown beträgt der Wert maximal 99.975%.'                                                              } ...
  ,{'AVL_ANG_ACPD_VIRT'        ,'%'      ,0       ,'%'       ,'Ist Winkel Fahrpedal VirutellDieses Signal überträgt den errechneten Fahrpedalwinkel, der sich aus der aktuellen Fahrgeschwindigkeitsregelung ergibt. Finden keine FAS-Eingriffe statt, entspricht der virtuelle Fahrpedalwinkel dem Ist-Winkel'          } ...
  ,{'ST_INTF_DRASY'            ,''       ,0       ,''        ,'Status_Schnittstelle_FahrerassistenzsystemStatus zum Fahrpedal und zum Verhältnis der Fahreranforderung bzgl. der FAS-Anforderung.'                                                                                                                       } ...
  ,{'ST_AVAI_INTV_PT_DRS'      ,''       ,0       ,''        ,'Status_Verfügbarkeit_Eingriff_Antriebsstrang_FASRückmeldung des Antriebsstranges ob Eingriffe bezüglich Fahrtrichtungswunsch oder Kraftschluss erlaubt sind. Dieses Signal ist Bestandteil der Domänenteilschnittstelle Zustand Antrieb'                  } ...
  ,{'ST_KL'                    ,''       ,0       ,''        ,'Klemmenstatus'                                                                                                                                                                                                                                            } ...
  ,{'ST_ENG_RUN_DRV'           ,''       ,0       ,''        ,'Status Motor läuft'                                                                                                                                                                                                                                       } ...
  ,{'ST_DRVDIR_DVCH'           ,''       ,0       ,''        ,'Status_Fahrtrichtung_FahrerwunschGibt die wahrscheinliche Fahrtrichtung des Fahrzeuges an.'                                                                                                                                                               } ...
  ,{'ST_GRSEL_DRV'             ,''       ,0       ,''        ,'Status Gang Getriebe'                                                                                                                                                                                                                                     } ...
  ,{'QU_ACLNZ_COG'             ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
  ,{'ACLNZ_COG'                ,'m/s²'   ,0       ,'m/s²'    ,'Z-Beschleunigung Fahrzeugschwerpunkt'                                                                                                                                                                                                                     } ...
  ,{'QU_VPI_COG'               ,''       ,0       ,''        ,''                                                                                                                                                                                                                                                         } ...
  ,{'VPI_COG'                  ,'°/s'    ,0       ,'°/s'     ,''                                                                                                                                                                                                                                                         } ...
  ,{'QU_VROLL_COG'             ,''       ,0       ,''        ,''                                                                                                                                                                                                                                                         } ...
  ,{'VROLL_COG'                ,'°/s'    ,0       ,'°/s'     ,''                                                                                                                                                                                                                                                         } ...
  };
  Ssig = cell_liste2struct(c);

% c = ...
%   {{                  'name_in','unit_in','lin_in','unit_out',                                                                                                                                                                                                                                                  'comment'} ...
%   ,{'AVL_WMOM_PT_SUM'          ,'Nm'     ,0       ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_SummeAktuell antreibendes Summen-Radmoment des Antriebsstrangs.'                                                                                                                                                             } ...
%   ,{'QU_AVL_WMOM_PT_SUM'       ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_WMOM_PT_SUM_ERR_AMP'  ,'Nm'     ,0       ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_Summe_Fehler_AmplitudeDie Fehleramplitude beschreibt die best mögliche Genauigkeit des tatsächlich antreibenden Radmomentes'                                                                                                 } ...
%   ,{'REIN_PT'                  ,''       ,0       ,''        ,'Verstärkung_Antriebsstrang'                                                                                                                                                                                                                               } ...
%   ,{'QU_REIN_PT'               ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'RQ_TAO_SSM'               ,''       ,0       ,''        ,'Anforderung_Übernahme_StillstandsmanagementMit diesem Signal kann eine FAS Funktion die Übernahme durch das Stillstandsmanagement (SSM) anfordern, bzw. die Sicherung des Fahrzeuges im Stillstand durch hydraulisches oder mechanisches halten anfordern'} ...
%   ,{'TAR_BRTORQ_SUM'           ,'Nm'     ,0       ,'Nm'      ,'Soll_Bremsmoment_SummeSollwertvorgabe des radbezogenen Summenbremsmoments an das DSC-Steuergerät (unabhängig davon, ob es durch Reibbremse und/oder Bremsrekuperation umgesetzt wird).'                                                                   } ...
%   ,{'QU_TAR_BRTORQ_SUM'        ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'TAR_WMOM_PT_SUM_DRS'      ,'Nm'     ,0       ,'Nm'      ,'Soll_Radmoment_Antriebsstrang_Summe_FASDieses Signal beinhaltet das angefordert (koordinierte und plausibilisierte) antreibende Summen-Radmoment der Fahrerassistenzsysteme.'                                                                             } ...
%   ,{'QU_TAR_WMOM_PT_SUM_DRS'   ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'TAR_STMOM_DV_ACT'         ,'Nm'     ,0       ,'Nm'      ,'Soll_Lenkmoment'                                                                                                                                                                                                                                          } ...
%   ,{'QU_TAR_STMOM_DV_ACT'      ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_ANG_ACPD'             ,'%'      ,0       ,'%'       ,'Ist_Winkel_FahrpedalVom Antriebsstrang gemeldeter Istwinkel des Fahrpedals. 100% Fahrpedalwinkel wird nur bei erkanntem Kickdown versendet. Ohne Kickdown beträgt der Wert maximal 99.975%.'                                                              } ...
%   ,{'QU_AVL_ANG_ACPD'          ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_ANG_ACPD_VIRT'        ,'%'      ,0       ,'%'       ,'Ist Winkel Fahrpedal VirutellDieses Signal überträgt den errechneten Fahrpedalwinkel, der sich aus der aktuellen Fahrgeschwindigkeitsregelung ergibt. Finden keine FAS-Eingriffe statt, entspricht der virtuelle Fahrpedalwinkel dem Ist-Winkel'          } ...
%   ,{'GRAD_AVL_ANG_ACPD'        ,'%/s'    ,0       ,'%/s'     ,'Gradient_Ist_Winkel_FahrpedalGradient des Ist_Winkel_Fahrpedals.'                                                                                                                                                                                         } ...
%   ,{'ST_INTF_DRASY'            ,''       ,0       ,''        ,'Status_Schnittstelle_FahrerassistenzsystemStatus zum Fahrpedal und zum Verhältnis der Fahreranforderung bzgl. der FAS-Anforderung.'                                                                                                                       } ...
%   ,{'ST_DRVDIR_DVCH'           ,''       ,0       ,''        ,'Status_Fahrtrichtung_FahrerwunschGibt die wahrscheinliche Fahrtrichtung des Fahrzeuges an.'                                                                                                                                                               } ...
%   ,{'QU_AVL_RPM_BAX_RED'       ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_RPM_BAX_RED'          ,'1/min'  ,0       ,'1/min'   ,'Ist_Drehzahl_Hinterachse_Redundant'                                                                                                                                                                                                                       } ...
%   ,{'ST_PENG_PT'               ,''       ,0       ,''        ,'Status_Kraftschluss_AntriebsstrangStellt eine verallgemeinerte Information über die Kraftschlussverhältnisse zwischen Antrieb und den angetriebenen Rädern sowie zwischen Rad und Karosserie dar.'                                                        } ...
%   ,{'ST_AVAI_INTV_PT_DRS'      ,''       ,0       ,''        ,'Status_Verfügbarkeit_Eingriff_Antriebsstrang_FASRückmeldung des Antriebsstranges ob Eingriffe bezüglich Fahrtrichtungswunsch oder Kraftschluss erlaubt sind. Dieses Signal ist Bestandteil der Domänenteilschnittstelle Zustand Antrieb'                  } ...
%   ,{'AVL_BRTORQ_SUM'           ,'Nm'     ,0       ,'Nm'      ,'Ist Bremsmoment SummeAktuelles radbezogene Summen-Reibbremsmoment des DSC-Steuergeräts. Ein negatives Bremsmoment entspricht einer Reibkraft entgegen der Fahrzeugbewegung.'                                                                              } ...
%   ,{'QU_AVL_BRTORQ_SUM'        ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'QU_AVL_BRTORQ_SUM_DVCH'   ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_BRTORQ_SUM_DVCH'      ,'Nm'     ,0       ,'Nm'      ,'Ist_Bremsmoment_Summe_FahrerwunschAktuelles radbezogenes Bremsmoment das der Fahrer über das Bremspedal versucht zu stellen. Bei einer Bremspedalbetätigung wird ein negativer Wert übertragen'                                                           } ...
%   ,{'ST_KL'                    ,''       ,0       ,''        ,'Klemmenstatus'                                                                                                                                                                                                                                            } ...
%   ,{'AVL_WMOM_PT_SUM_RECUP_MAX','Nm'     ,0       ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_Summe_Rekuperation_MaximalSumme von dem maximalen Schleppmoment Unten und Bremsrekuperationsmoment, das momentan zur Verfügung steht.'                                                                                       } ...
%   ,{'AVL_WMOM_PT_SUM_DTORQ_BOT','Nm'     ,0       ,'Nm'      ,'Maximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt'                                                                                                                                                                               } ...
%   ,{'AVL_WMOM_PT_SUM_DTORQ_TOP','Nm'     ,0       ,'Nm'      ,'Ist_Radmoment_Antriebsstrang_Summe_Schleppmoment_ObenMaximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt das kontinuierlich erreichbar ist.'                                                                                       } ...
%   ,{'ATTA_ESTI'                ,'°'      ,0       ,'°'       ,'Schwimmwinkel'                                                                                                                                                                                                                                            } ...
%   ,{'QU_VEH_DYNMC_DT_ESTI'     ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'ATTA_ESTI_ERR_AMP'        ,'°'      ,0       ,'°'       ,'Schwimmwinkel Fehleramplitude'                                                                                                                                                                                                                            } ...
%   ,{'ATTAV_ESTI'               ,'°/s'    ,0       ,'°/s'     ,'Schwimmwinkelgeschwindigkeit'                                                                                                                                                                                                                             } ...
%   ,{'ATTAV_ESTI_ERR_AMP'       ,'°/s'    ,0       ,'°/s'     ,'Schwimmwinkel Fehleramplitude'                                                                                                                                                                                                                            } ...
%   ,{'ACLNX_COG'                ,'m/s²'   ,0       ,'m/s²'    ,'Längsbeschleunigung im Fahrzeugschwerpunkt. Eine positive Längsbeschleunigung wirkt in Fahrzeug X-Richtung. Fahrzeugkoordinatensystem gemäß ISO 8855.'                                                                                                    } ...
%   ,{'ACLNX_COG_ERR_AMP'        ,'m/s²'   ,0       ,'m/s²'    ,'Längsbeschleunigung_Schwerpunkt_Fehler_Amplitude'                                                                                                                                                                                                         } ...
%   ,{'QU_ACLNX_COG'             ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'ACLNY_COG'                ,'m/s²'   ,0       ,'m/s²'    ,'Querbeschleunigung Fahrzeugschwerpunkt'                                                                                                                                                                                                                   } ...
%   ,{'ACLNY_COG_ERR_AMP'        ,'m/s²'   ,0       ,'m/s²'    ,'Querbeschleunigung_Schwerpunkt_Fehler_Amplitude'                                                                                                                                                                                                          } ...
%   ,{'QU_ACLNY_COG'             ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'VYAW_VEH'                 ,'°/s'    ,0       ,'°/s'     ,'Giergeschwindigkeit_FahrzeugRichtung nach ISO 8855 (positiver Winkel entspricht Drehung gegen den Uhrzeigersinn).'                                                                                                                                        } ...
%   ,{'VYAW_VEH_ERR_AMP'         ,'°/s'    ,0       ,'°/s'     ,'Giergeschwindigkeit_Fahrzeug_Fehler_Amplitude'                                                                                                                                                                                                            } ...
%   ,{'QU_VYAW_VEH'              ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'V_VEH_COG'                ,'km/h'   ,0       ,'km/h'    ,'Geschwindigkeit Fahrzeugschwerpunkt'                                                                                                                                                                                                                      } ...
%   ,{'QU_V_VEH_COG'             ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'DVCO_VEH'                 ,''       ,0       ,''        ,'Fahrzustand_Fahrzeug'                                                                                                                                                                                                                                     } ...
%   ,{'MILE_WHL_FLH'             ,'cm'     ,0       ,'cm'      ,'Wegstrecke Rad'                                                                                                                                                                                                                                           } ...
%   ,{'MILE_WHL_FRH'             ,'cm'     ,0       ,'cm'      ,'Wegstrecke Rad'                                                                                                                                                                                                                                           } ...
%   ,{'SIGAGE_MILE_WHL_FS'       ,'ms'     ,0       ,'ms'      ,'Signalalter'                                                                                                                                                                                                                                              } ...
%   ,{'QU_MILE_WHL_FLH'          ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'QU_MILE_WHL_FRH'          ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'MILE_WHL_RLH'             ,'cm'     ,0       ,'cm'      ,'Wegstrecke Rad'                                                                                                                                                                                                                                           } ...
%   ,{'MILE_WHL_RRH'             ,'cm'     ,0       ,'cm'      ,'Wegstrecke Rad'                                                                                                                                                                                                                                           } ...
%   ,{'SIGAGE_MILE_WHL_RS'       ,'ms'     ,0       ,'ms'      ,'Signalalter'                                                                                                                                                                                                                                              } ...
%   ,{'QU_MILE_WHL_RLH'          ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'QU_MILE_WHL_RRH'          ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_RPM_WHL_RLH'          ,'rad/s'  ,0       ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
%   ,{'AVL_RPM_WHL_RRH'          ,'rad/s'  ,0       ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
%   ,{'AVL_RPM_WHL_FLH'          ,'rad/s'  ,0       ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
%   ,{'AVL_RPM_WHL_FRH'          ,'rad/s'  ,0       ,'rad/s'   ,'Ist_Drehzahl_Rad'                                                                                                                                                                                                                                         } ...
%   ,{'AVL_QUAN_EES_WHL_RLH'     ,''       ,0       ,''        ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
%   ,{'AVL_QUAN_EES_WHL_RRH'     ,''       ,0       ,''        ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
%   ,{'AVL_QUAN_EES_WHL_FLH'     ,''       ,0       ,''        ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
%   ,{'AVL_QUAN_EES_WHL_FRH'     ,''       ,0       ,''        ,'Ist Anzahl Geberflanken Rad'                                                                                                                                                                                                                              } ...
%   ,{'QU_HOFF_RCOG'             ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_STMOM_DV_ACT'         ,'Nm'     ,0       ,'Nm'      ,'Ist_Lenkmoment_Fahrer_StellgliedDas Signal Ist_Lenkmoment_Fahrer stellt das Fahrerlenkmoment im Gegenuhrzeigersinn positiv dar'                                                                                                                           } ...
%   ,{'QU_AVL_STMOM_DV_ACT'      ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'MILE_VEH'                 ,'m'      ,0       ,'m'       ,'Wegstrecke_FahrzeugBerechnete und plausibilisierte Wegstreckeninformation, die sich aus der Anzahl der gemessenen Geberflanken der Radsensoren ergibt'                                                                                                    } ...
%   ,{'QU_MILE_VEH'              ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'AVL_STEA_DV'              ,'°'      ,0       ,'°'       ,'Ist_Lenkwinkel_FahrerTatsächlicher, offsetbereinigter Einschlag des Lenkrads durch den Fahrer auf das Lenkrad bezogen.'                                                                                                                                   } ...
%   ,{'AVL_STEAV_DV'             ,'°/s'    ,0       ,'°/s'     ,'Ist_Lenkwinkelgeschwindigkeit_Fahrer'                                                                                                                                                                                                                     } ...
%   ,{'QU_AVL_STEAV_DV'          ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'QU_AVL_STEA_DV'           ,''       ,0       ,''        ,'Qualifier'                                                                                                                                                                                                                                                } ...
%   ,{'ST_ENG_RUN_DRV'           ,''       ,0       ,''        ,'Status Motor läuft'                                                                                                                                                                                                                                       } ...
%   ,{'ST_GRSEL_DRV'             ,''       ,0       ,''        ,'Status Gang Getriebe'                                                                                                                                                                                                                                     } ...
%   };
% 
%   Ssig = cell_liste2struct(c);

% iSig = 0;
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Ist_Radmoment_Antriebsstrang_SummeAktuell antreibendes Summen-Radmoment des Antriebsstrangs.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_WMOM_PT_SUM';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM_ERR_AMP';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Ist_Radmoment_Antriebsstrang_Summe_Fehler_AmplitudeDie Fehleramplitude beschreibt die best mögliche Genauigkeit des tatsächlich antreibenden Radmomentes';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'REIN_PT';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Verstärkung_Antriebsstrang';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_REIN_PT';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'RQ_TAO_SSM';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_ANG_ACPD_VIRT';
% Ssig(iSig).unit_in  = '%';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '%';
% Ssig(iSig).comment  = 'Ist Winkel Fahrpedal VirutellDieses Signal überträgt den errechneten Fahrpedalwinkel, der sich aus der aktuellen Fahrgeschwindigkeitsregelung ergibt. Finden keine FAS-Eingriffe statt, entspricht der virtuelle Fahrpedalwinkel dem Ist-Winkel';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'GRAD_AVL_ANG_ACPD';
% Ssig(iSig).unit_in  = '%/s';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '%/s';
% Ssig(iSig).comment  = 'Gradient_Ist_Winkel_FahrpedalGradient des Ist_Winkel_Fahrpedals.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ST_INTF_DRASY';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Status_Schnittstelle_FahrerassistenzsystemStatus zum Fahrpedal und zum Verhältnis der Fahreranforderung bzgl. der FAS-Anforderung.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ST_DRVDIR_DVCH';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Status_Fahrtrichtung_FahrerwunschGibt die wahrscheinliche Fahrtrichtung des Fahrzeuges an.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_RPM_BAX_RED';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).name_in  = 'ST_PENG_PT';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Status_Kraftschluss_AntriebsstrangStellt eine verallgemeinerte Information über die Kraftschlussverhältnisse zwischen Antrieb und den angetriebenen Rädern sowie zwischen Rad und Karosserie dar.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ST_AVAI_INTV_PT_DRS';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_BRTORQ_SUM_DVCH';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_BRTORQ_SUM_DVCH';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Ist_Bremsmoment_Summe_FahrerwunschAktuelles radbezogenes Bremsmoment das der Fahrer über das Bremspedal versucht zu stellen. Bei einer Bremspedalbetätigung wird ein negativer Wert übertragen';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ST_KL';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Klemmenstatus';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM_RECUP_MAX';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Ist_Radmoment_Antriebsstrang_Summe_Rekuperation_MaximalSumme von dem maximalen Schleppmoment Unten und Bremsrekuperationsmoment, das momentan zur Verfügung steht.';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM_DTORQ_BOT';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Maximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_WMOM_PT_SUM_DTORQ_TOP';
% Ssig(iSig).unit_in  = 'Nm';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = 'Nm';
% Ssig(iSig).comment  = 'Ist_Radmoment_Antriebsstrang_Summe_Schleppmoment_ObenMaximales Schleppmoment des Antriebs ausgehend vom aktuellen Betriebspunkt das kontinuierlich erreichbar ist.';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'DVCO_VEH';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_MILE_WHL_FRH';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_MILE_WHL_RRH';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Ist Anzahl Geberflanken Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_QUAN_EES_WHL_RRH';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Ist Anzahl Geberflanken Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_QUAN_EES_WHL_FLH';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Ist Anzahl Geberflanken Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'AVL_QUAN_EES_WHL_FRH';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Ist Anzahl Geberflanken Rad';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_HOFF_RCOG';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
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
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'QU_AVL_STEA_DV';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Qualifier';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ST_ENG_RUN_DRV';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Status Motor läuft';
% %-----------------------------------------------------------------------------------------------
% iSig = iSig + 1;
% Ssig(iSig).name_in  = 'ST_GRSEL_DRV';
% Ssig(iSig).unit_in  = '';
% Ssig(iSig).lin_in   = 0;
% Ssig(iSig).unit_out = '';
% Ssig(iSig).comment  = 'Status Gang Getriebe';
% 
% okay = struct2cell_liste(Ssig);
end
