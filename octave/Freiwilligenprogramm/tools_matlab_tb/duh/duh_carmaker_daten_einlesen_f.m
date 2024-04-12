function  [okay,s_data] = duh_carmaker_daten_einlesen_f(filename)

okay = 1;
s_data.file        = '';
s_data.name        = '';
s_data.d           = 0;
s_data.u           = 0;
s_data.h           = {};

% Daten einlesen in Struktur
[d,u,h] = ccmread('erg_file',filename);
%
if( ~isstruct(d) )
    okay = 0;
end
            
if( okay )
    
        [d,u]       = das_filter_falsche_werte_f(d,u);
           
        s_data.file        = filename;
        s_file             = str_get_pfe_f(filename);
        s_data.name        = s_file.name;
        s_data.c_prc_files = '';
        s_data.d           = d;
        s_data.u           = u;
        s_data.h           = h;
        
        len = length(s_data.h);
        s_data.h{len+1} = [datestr(now),' read-carmaker-data'];
end
