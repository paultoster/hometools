function  [okay] = data_is_canape_format_f(s_can)                      
                                                
% Canalyser-Messungen ist eine Ansammlung von 2 spaltigen Vektoren
% das wird ger�ft
okay = 0;
if( strcmp(class(s_can),'struct') )
    
    c_names = fieldnames(s_can);
    
    % Pr�fen ob t0 vorhanden
    
end
                       