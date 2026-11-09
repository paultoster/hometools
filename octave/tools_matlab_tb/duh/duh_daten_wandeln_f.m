% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
%version 2 TBert/TZS/3052 20040917
function s_duh = duh_daten_einlesen_f(s_duh)
%
% Daten aus Verzeichnis einlesen und in matlab wandeln
%
s_duh_liste = o_abfragen_verzweigung_liste_erstellen_f ...
             (1,'das_wand'                ,'Datalyser(.dat) mit prc-Filevorgabe wandeln' ...
             ,1,'dl2_wand'                ,'Datalyser(.dl2) mit prc-File wandeln' ...
             ,1,'csvmat_wand'             ,'csv/mat-Daten wandeln' ...
             ,1,'canascii_wand'           ,'Canalyser Ascii-Daten mit dbc-Files wandeln' ...
             ,1,'all_wand'                ,'mat/das/dl2/dia/csv/can_asc wandeln in dspa/duh/vec/csv/dia' ...
             ,1,'dl2_anal'                ,'Datalyser(.dl2) mit prc-File analysieren' ...
             ,1,'canmat_to_estruct'       ,'Canalyser-generierte Messdatei in e-Struct überführen' ...
             ,1,'estruct_to_dstruct'      ,'e-Struct-matlab-datei überführen in d-Struct-matlab-Datei' ...
             );

[end_flag,option,s_duh.s_prot,s_duh.s_remote] = o_abfragen_verzweigung_f(s_duh_liste,s_duh.s_prot,s_duh.s_remote);

if( end_flag )
   return;
end
switch option
    case 1 % Datalyser mit prc-Filevorgabe wandeln
        
        s_duh = duh_das_daten_wandeln_f(s_duh);
        
    case 2 % Datalyser(dl2) mit prc-File wandeln

        s_duh = duh_das2_daten_wandeln_f(s_duh);
        
    case 3 % CSV-Datenfiles wandeln
        
        s_duh = duh_csv_daten_wandeln_f(s_duh);

    case 4 % can ascii-Datenfiles wandeln
        
        s_duh = duh_canascii_daten_wandeln_f(s_duh);

    case 5 % allgemein-Datenfiles wandeln
        
        s_duh = duh_all_daten_wandeln_f(s_duh);

    case 6 % Datalyser(dl2) mit prc-File analysieren

        s_duh = duh_das2_daten_analyse_f(s_duh);

    case 7 % Canalyser-generierte Messdatei in e-Struct überführen

        s_duh = duh_canmat_daten_in_estruct_f(s_duh);
        
end

            
    
    