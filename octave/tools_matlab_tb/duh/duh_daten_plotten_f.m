% $JustDate:: 15.11.05  $, $Revision:: 3 $ $Author:: Tftbe1    $
% $JustDate:: 15 $, $Revision:: 3 $ $Author:: Tftbe1    $
function s_duh = duh_daten_plotten_f(s_duh)
%
% Daten einlesen
%

s_duh_liste = o_abfragen_verzweigung_liste_erstellen_f ...
             (1,'simple'               ,'Vektoren ausgewählte Datensätze in jeweils ein Bild plotten' ...
             ,1,'one_plot'             ,'Ausgewählte Vektoren in ein Bild plotten' ...
             ,1,'make_plot_config'     ,'Konfiguration für aufbereitetes Plotten errstellen(Daten sollten eingeladen sein)' ...
             ,1,'make_splot_config'    ,'Einfache (schnelle) Konfiguration für aufbereitetes Plotten errstellen(Daten sollten eingeladen sein)' ...
             ,1,'plot_config'          ,'Plotkonfiguration mit den eingeladenen Dateien ausführen' ...
             ,1,'plot_name'            ,'Signale gleicher Namensteile plotten' ...
             );

[end_flag,option,s_duh.s_prot,s_duh.s_remote] = o_abfragen_verzweigung_f(s_duh_liste,s_duh.s_prot,s_duh.s_remote);

if( end_flag )
   return;
end

if( s_duh.n_data == 0 )
    if( ~s_duh.s_remote.run_flag )
        input('Keine Daten vorhanden (Weiter mit <return>)','s')
    end
else
    

    switch option
        case 1 % einfaches Plotten

            s_duh = duh_daten_plotten_simple_f(s_duh);

        case 2 % einfaches Plotten in ein Bild

            s_duh = duh_daten_plotten_one_plot_f(s_duh);
            
        case 3 % Config erstellen
            
            s_duh = duh_daten_plot_config_erstellen_f(s_duh);
            
        case 4 % Einfache Config erstellen
            
            s_duh = duh_daten_plot_einfache_config_erstellen_f(s_duh);
            
        case 5 % Config ausführen
            
            s_duh = duh_daten_plot_config_ausfuehren_f(s_duh);

        case 6 % einfaches Plotten

            s_duh = duh_daten_plotten_name_f(s_duh);
            
    end
        
end

