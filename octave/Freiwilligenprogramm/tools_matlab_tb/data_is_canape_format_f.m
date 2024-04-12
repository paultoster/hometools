function  [okay] = data_is_canape_format_f(s_can)                      
                                                
% Canalyser-Messungen ist eine Ansammlung von 2 spaltigen Vektoren
% das wird gerüft
okay = 0;
if( strcmp(class(s_can),'struct') )
    
    c_names = fieldnames(s_can);
    
    % Prüfen ob t0 vorhanden
    
end
                       