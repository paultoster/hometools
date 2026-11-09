% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function  [okay,s_data,n_data] = duh_dspa_daten_einlesen_f(filename)

okay = 1;
n_data = 0;
s_data(1).file        = '';
s_data(1).c_prc_files = {};
s_data(1).d           = 0;
s_data(1).u           = 0;
s_data(1).h   = {};

found_flag = 0;
% Daten einlesen in Struktur
s_read    = load(filename);
        
% Struktur auswerten
c_fieldnames = fieldnames(s_read);
        
% Alle Strukturanteile auswerten
for j=1:length(c_fieldnames)
            
    % Übergabe iter Strukturanteil
    child = getfield(s_read,char(c_fieldnames(j)));
    % Daten transformieren in duh-Struktur
    [okay_d,d,u,c_comment] = data_transform_dspa_to_duh_f(child);                      
            
    if( okay_d )
        found_flag = 1;
        n_data = n_data + 1;
        s_data(n_data).file      = filename;
        s_data(n_data).d         = d;
        s_data(n_data).u         = u;
        s_data(n_data).h         = c_comment;
    end
end
if( ~found_flag )
    okay = 0;
end
