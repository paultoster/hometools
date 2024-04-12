function out = abs_auswertung_f(in)
%
% Auswertung von ABS-Bremsung
% - Bremsneginn un Bremsende triggern
% 
% - Aufteilen in Phasen Cruisen,Schwellzeit,ABS-Zeit
% 	Cruisen 	von 	Beginn der messung bis Trigger Bremsbeginn
% 	Schwellzeit von	 	Trigger Bremsbeginn bis erste ABS-Tätigkeit (Valti) VA
% 	ABS-Zeit	von		erste ABS-Tätigkeit bis Trigger Bremsende
% 
% - Kalibrieren der Verzögerung: Offset errechnen aus Geschwindigkeitsverlauf Cruisen und mittlere Verzögerung
% 
% - Darstellen in den Phasen:
% 
% 		- Phasenlänge
% 		- mittlere Abbremsung
% 		- Endbremsdruck
% 		- Startgeschwindigkeit
% 		- Bremsweg aus Beschleunigung
% 		- Bremsweg aus Geschwindigkeit
% 		- Bremsweg aus Beschleunigung für 100 km/h-Beginn
% 		- Endbremsdruck THZ, Rad 1-4
% 		- mittlerer Bremsdruck THZ, Rad 1-4
% 
% - Diagrammdarstellung
% 
% 		- Shwellzeit
% 
% 			Pedalkraft
% 			THZ-Druck
% 			Raddruck
% 			Verzögerung
% 
% 		- Gesamtbremszeit
% 
% 			Valti
% 			Phase
% 			Radgeschwindigkeiten
% 			Raddrücke
% Inputgrößen/Beispiel
%
% in.time          = s_d.d.Timer_Dat2;              Zeit in [s]
% 
% in.a_mess        = s_d.d.Verz_laengs;             gemessene Verzögerung in [m/s/S]
% in.a_mess_T_filt = 0.01;
% 
% in.v_mess        = s_d.d.AbsRef;                  gemessene Geschwindigkeit in [m/s]
%
% in.s_mess        = s_d.d.WegPeisler;              gemessener Weg in [m]
% 
% in.f_pedal       = s_d.d.Pedalforce;              gemessene Pedalkraft in [N]
% 
% in.a_ref         = s_d.d.Tot_VehAcc;              ECU: ausgwertete Beschleunigung in [m/s{s]
% in.v_ref         = s_d.d.AbsRef;                  ECU: Referenzgeschw in [m/s]
% in.v_rad(:,1)    = s_d.d.Vel1;                    ECU: Radgeschw in [m/s]
% in.v_rad(:,2)    = s_d.d.Vel2;
% in.v_rad(:,3)    = s_d.d.Vel4;
% in.v_rad(:,4)    = s_d.d.Vel3;
% 
% in.p_thz         = s_d.d.PTmcSkal;                ECU: THZ-Druck 
% in.p_rad(:,1)    = s_d.d.PModFl;                  ECU: Modelldrücke (oder gemessen E5)
% in.p_rad(:,2)    = s_d.d.PModFr;
% in.p_rad(:,3)    = s_d.d.PModRl;
% in.p_rad(:,4)    = s_d.d.PModRr;
% 
% in.valti(1,:)   = s_d.d.Valti1;                   ECU: Valtisignale in [ms]
% in.valti(2,:)   = s_d.d.Valti2;
% in.valti(3,:)   = s_d.d.Valti4;
% in.valti(4,:)   = s_d.d.Valti3;
% 
% in.phase(1,:)   = s_d.d.Phase1;                   ECU: Phasensignale in [bit0 ABSincycle,bit7 Phase 0,bit6 Phase 1
% in.phase(2,:)   = s_d.d.Phase2;                                          bit5 Phase 2   ,bit4 Phase 3,bit3 Phase 4
% in.phase(3,:)   = s_d.d.Phase4;                                          bit2 Phase 5   ,bit1 leer]
% in.phase(4,:)   = s_d.d.Phase3;
%
% in.trig_start_sig = s_d.d.Pedalforce;             Trigger zur berechnung Beginn Bremsung (Pedalkraft, BLS)
% in.trig_start_thr = 15;                           Scshwellwert zur trigerung
% in.trig_start_rel = '>';                          Relation '>','<','>=','<=','==' zu Schwellwert
% 
% in.trig_end_sig = s_d.d.AbsRef                    Trigger zur berechnung Ende Bremsung (Geschwindigkeit, BLS)
% in.trig_end_thr = 0.70;                           Scshwellwert zur trigerung
% in.trig_end_rel = '<';                            Relation '>','<','>=','<=','==' zu Schwellwert
% 
% Output:
%                               Existenz:
% out.a_mess_exist
% out.f_pedal_exist
% out.a_ref_exist
% out.v_ref_exist
% out.v_rad_exist
% out.p_thz_exist
% out.p_rad_exist
% out.valti_exist
% out.phase_exist
%                               Zeiten:
% out.trig_start_time
% out.trig_start_index
% out.trig_end_time
% out.trig_end_index
% out.trig_start_abs_time
% out.trig_start_abs_index
%
% out.t_brems_ges               Gesamtbremszeit
% out.t_brems_schw              Schwellbremszeit
%
% out.v_brems_start             Geschwindigkeit zu Beginn
% out.v_brems_ges_end           Geschwindigkeit zum Ende Schwellzeit
% out.v_brems_schw_end          Geschwindigkeit zum Ende Bremszeit
%
% out.s_brems_ges_v             Gesamtbremsweg aus v_mess
% out.s_brems_ges_100_v         Gesamtbremsweg aus v_mess umgerechnet auf 100 kmh
% out.s_brems_schw_v            schwellbremsweg aus v_mess
% out.s_brems_schw_100_v        Schwellbremsweg aus v_mess umgerechnet auf 100 kmh
% out.a_brems_ges_mit_v         mittlere Beschleunigung  aus v_mess Gesamtbremsweg
% out.a_brems_ges_100_mit_v     mittlere Beschleunigung aus v_mess Gesamtbremsweg umgerechnet auf 100 kmh
%
% out.s_brems_ges_a             Gesamtbremsweg aus a_mess
% out.s_brems_ges_100_a         Gesamtbremsweg aus a_mess umgerechnet auf 100 kmh
% out.s_brems_schw_a            schwellbremsweg aus a_mess
% out.s_brems_schw_100a         schwellbremsweg aus a_mess umgerechnet auf 100 kmh
% out.a_brems_ges_mit_a         mittlere Beschleunigung  aus a_mess Gesamtbremsweg
% out.a_brems_ges_100_mit_a     mittlere Beschleunigung aus a_mess Gesamtbremsweg umgerechnet auf 100 kmh



%================
% Input asuwerten
%================
[in,out] = abs_auswertung_input_f(in);
%================
% Bremsweg
%================
[in,out] = abs_auswertung_bremsweg_f(in,out);
%================
% Ausgabe
%================
[in,out] = abs_auswertung_ausgabe_f(in,out);
%================
% Plotten
%================
if( get(0,'ch') )
    in.fig_num = floor(max(get(0,'ch')));
else
    in.fig_num = 0;
end
[in,out] = abs_auswertung_plot_schwellzeit_f(in,out);
[in,out] = abs_auswertung_plot_gesamt_f(in,out);
[in,out] = abs_auswertung_plot_anhalt_f(in,out);
figmen