function s_duh = duh_daten_bearbeiten_kennzahlen_f(s_duh)

s_duh_liste = o_abfragen_verzweigung_liste_erstellen_f ...
             (1,'stat_value'         ,'Statistik berechnen und zusammenfassen' ...
             ,1,'polynom'            ,'Koeffizienten für Polynom erstellen' ...
             ,1,'comp_data_set'      ,'Datensätze vergleichen' ...
             ,1,'offset_corr'        ,'Offset X-Wert(Zeit) aus Korrelation zweier Signale(2 datensätze) finden' ...
             ,1,'mean_part'          ,'konstantes Mittelwertstück aus einem Signal finden' ...
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
    case 1 % Statistik
        
        s_duh = duh_daten_bearb_stat_calc(selection,s_duh);
    case 2 % Polynom
        
        s_duh = duh_daten_bearb_polynom(selection,s_duh);
    case 3 % Vergleich
        
        s_duh = duh_daten_bearb_vergleich(selection,s_duh);
    case 4 % Offset
        
        s_duh = duh_daten_bearb_offset_corr(selection,s_duh);

    case 5 % größtes Mittelwertstück
        
        s_duh = duh_daten_bearb_mean_part(selection,s_duh);
end
