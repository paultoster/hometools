function s_duh = duh_daten_bearbeiten_f(s_duh)

s_duh_liste = o_abfragen_verzweigung_liste_erstellen_f ...
             (1,'trigger_offset'     ,'Datensätze mit Ereignis zeitl. Nullpunkt verschieben' ...
             ,1,'trigger_cut_end'    ,'Datensätze mit Ereignis zeitl. am Ende wegschneiden' ...
             ,1,'adapt_delta_t'      ,'alle Daten auf eine Abtastrate ändern' ... 
             ,1,'one_time_vec'       ,'alle Daten auf eine Zeitbasis ändern' ...
             ,1,'x_slice'            ,'Datensatz auf einen Ausschnitt reduzieren' ...
             ,1,'x_cut_begin'        ,'n-Werte am Anfang wegschneiden' ...
             ,1,'x_cut_end'          ,'n-Werte am Ende wegschneiden' ...
             ,1,'x_index'            ,'Indexbereich festlegen' ...
             ,1,'lower_sample'       ,'Abtastung reduzieren' ...
             ,1,'peak_filter'        ,'Datensätze Peaks ausfiltern' ...
             ,1,'peak_filter2'       ,'Datensätze 2 Peaks hintereinander ausfiltern' ...
             ,1,'peak_filter3'       ,'Datensätze Nullwerte mit hohem Gradient am Rand ausfiltern' ...
             ,1,'peak_filter4'       ,'Datensätze Fehlwerte anhand Zähler-Signal ausfiltern' ...
             ,1,'peak_filter5'       ,'Datensätze mit längeren Ausetzer auf einen beliebigen Wert ausfiltern' ...
             ,1,'peak_filter6'       ,'Signale aus Datensätze grafisch kennzeichnen, wo auszufiltern' ...
             ,1,'lbf_filter'         ,'lbf-Filter (lowpass butterworth filter 2. order)' ...
             ,1,'pt1_filter'         ,'PT1-Filter (lowpass)' ...
             ,1,'un1_filter'         ,'Polynomenfilter 1. Ordnung von Ullrich Neumann ' ...
             ,1,'offset_factor'      ,'offset und factor für einzelne Kanäle (auch reziprok gerechnet)' ...
             ,1,'offset_calc'        ,'Angleichen eines Kanals zu bestimmten Zeitpunkt/x_Wert bzw. Bereich auf einen vorgegebenen Wert' ...
             ,1,'derivation'         ,'Ableitung und Filter' ...
             ,1,'integration'        ,'Integration' ...
             ,1,'two_channels'       ,'2 Kanäle miteinander verarbeiten mit +-:*' ...
             ,1,'cat_datsets'        ,'Datensätze aneinanderhängen' ...
             );

[end_flag,option,s_duh.s_prot,s_duh.s_remote] = o_abfragen_verzweigung_f(s_duh_liste,s_duh.s_prot,s_duh.s_remote);

if( end_flag )
   return;
end

% Datennsätze auswählen

if( s_duh.n_data == 0 )
    if( ~s_duh.s_remote.run_flag )
        input('Keine Daten vorhanden (Weiter mit <return>)','s')
    end
    return
end
for i= 1:s_duh.n_data
    s_frage.c_liste{i} = sprintf('%s(%s)',s_duh.s_data(i).name,s_duh.s_data(i).h{1});
end

s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
s_frage.command        = 'data_set';
s_frage.single         = 0;

[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    

switch option
    case 1 % Datensätze trigger offset-verschieben
        
        s_duh = duh_daten_bearb_trigger_offset(selection,s_duh);
        
    case 2 % Datensätze trigger Ende abschneiden
        
        s_duh = duh_daten_bearb_trigger_cut_end(selection,s_duh);
    case 3 % Datensätze auf gleiche Zeitbasis bringen
        
        s_duh = duh_daten_bearb_adapt_delta_t(selection,s_duh);
    case 4 % Datensätze auf gleiche Zeitbasis bringen
        
        s_duh = duh_daten_bearb_one_time_vec(selection,s_duh);
    case 5 % Datensätze auf einen Ausschnit reduzieren
        
        s_duh = duh_daten_bearb_x_slice(selection,s_duh);
    case 6 % Datensätze vorne reduzieren/beschneiden
        
        s_duh = duh_daten_bearb_x_cut(selection,s_duh,0);
    case 7 % Datensätze hinten reduzieren/beschneiden
        
        s_duh = duh_daten_bearb_x_cut(selection,s_duh,1);     
    case 8 % Datensätze Indexbereich festlegen
        
        s_duh = duh_daten_bearb_x_cut(selection,s_duh,2);
        
    case 9 % Abtastung ändern
        
        s_duh = duh_daten_bearb_abtastung(selection,s_duh);
    case 10 % Datensätze Peaks ausfiltern
        
        s_duh = duh_daten_bearb_peak_filter(selection,s_duh)
        
    case 11 % Datensätze Peaks mit 2 Stellen ausfiltern
        
        s_duh = duh_daten_bearb_peak_filter2(selection,s_duh);
        
    case 12 % Datensätze Nullwerte mit hohem Gradient am Rand ausfiltern
        
        s_duh = duh_daten_bearb_peak_filter3(selection,s_duh);
    case 13 % Datensätze mit Clock rausfiltern
        
        s_duh = duh_daten_bearb_peak_filter4(selection,s_duh);
    case 14 % Datensätze mit längeren Peaks rausfiltern
        
        s_duh = duh_daten_bearb_peak_filter5(selection,s_duh);
    case 15 % Datensätze mit längeren Peaks Grafisch rausfiltern
        
        s_duh = duh_daten_bearb_peak_filter6(selection,s_duh);
    case 16 % lowpass butterworth filter
        
        s_duh = duh_daten_bearb_lbf(selection,s_duh);
    case 17 % PT1 - filter
        
        s_duh = duh_daten_bearb_pt1_filt(selection,s_duh);
    case 18 % UN1 - filter
        
        s_duh = duh_daten_bearb_un1_filt(selection,s_duh);
%     case 16 % UN2 - filter
%         
%         s_duh = duh_daten_bearb_un2_filt(selection,s_duh);
    case 19 % Offset und Factor
        
        s_duh = duh_daten_bearb_offset_factor(selection,s_duh);
    case 20 % Offset berechnen
        
        s_duh = duh_daten_bearb_offset_calc(selection,s_duh);
    case 21 % Ableitung und Filter
        
        s_duh = duh_daten_bearb_dt1_filt(selection,s_duh);
        
    case 22 % Inegtrieren
        
        s_duh = duh_daten_bearb_integration(selection,s_duh);
    case 23 % Zwei Kanäle verarbeiten
        
        s_duh = duh_daten_bearb_two_channels(selection,s_duh);
    case 24 % Datensätze aneinander hängen
        
        s_duh = duh_daten_bearb_cat_datasets(selection,s_duh);
end
