% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
function  [okay] = data_is_canalyser_format_f(s_can)                      
                                                
% Canalyser-Messungen ist eine Ansammlung von 2 spaltigen Vektoren
% das wird gerüft
okay = 0;
if( strcmp(class(s_can),'struct') )
    
    c_names = fieldnames(s_can);
    for ic=1:length(c_names)
        
        if( isnumeric(s_can(1).(c_names{ic})) )
            [n,m] = size(s_can(1).(c_names{ic}));
            if( m == 2 )
                okay = 1;
                break
            end
        end
        if( okay )
            break
        end
    end
end
                       