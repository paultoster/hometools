function [okay,d,u,h] = dsparead(filename)
%
% [okay,d,u,h] = dsparead(filename)
%
% filename      char        Dateiname der Matlabdatei
%
% okay          double      1: ist okay
%                           0: keine Datei eingelesen
% [d,u,h]                   entsprechend diaread

s_read    = load(filename);

% Struktur auswerten
c_fieldnames = fieldnames(s_read);

% Alle Strukturanteile auswerten
for j=1:length(c_fieldnames)
                
    % Übergabe iter Strukturanteil
    child = s_read.(char(c_fieldnames(j)));
    okay = data_is_dspa_format_f(child);
    if( okay )
        % Daten transformieren in duh-Struktur
        [okay,d,u,h] = data_transform_dspa_to_duh_f(child);
        if( okay )
            return
        end
    end
end

d = struct([]);
u = struct([]);
h = {};
okay = 0;
        

