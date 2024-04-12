function sout = struct_sortiere_wie(sin,smuster)
%
% sout = struct_sortiere_wie(sin,smuster)
%
% Sortiert Struktur sin wie smuster, 
% fehlende Werte werden defaultbesetzt
%

n = length(sin);
c_muster = fieldnames(smuster);

sout = struct([]);

for i = 1:length(c_muster)
    
    if( isfield(sin,c_muster{i}) )
        
        for j=1:n
           
            sout(j).(c_muster{i}) = sin(j).(c_muster{i});
        end
            
    else % Feld nicht vorhanden
        
        if( ischar(smuster(1).(c_muster{i})) )
            for j=1:n
                sout(j).(c_muster{i}) = '';
            end
        elseif( isnumeric(smuster(1).(c_muster{i})) )
            for j=1:n
                sout(j).(c_muster{i}) = 0;
            end
        elseif( isstruct(smuster(1).(c_muster{i})) )
            for j=1:n
                sout(j).(c_muster{i}) = struct([]);
            end
        elseif( iscell(smuster(1).(c_muster{i})) )
            for j=1:n
                sout(j).(c_muster{i}) = {};
            end
        end
    end
end
