% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function  [okay,s_data] = duh_dascsv_daten_einlesen_f(filename)

okay = 1;
s_data.file        = '';
s_data.name        = '';
s_data.d           = 0;
s_data.u           = 0;
s_data.h           = {};

% Daten einlesen in Struktur
[d,u,f] = dascsvread(filename);
%    clear mex
if( ~isstruct(d) )
    okay = 0;
end

if( ~isfield(d,'Timer_1_1') )
    c_names = fieldnames(d);
    for i=1:length(c_names)        
        if( strcmp(c_names{i},'Time') )            
            d.('Timer_1_1') = d.(c_names{i});
            u.('Timer_1_1') = u.(c_names{i});
        end
    end
end
            
if( okay )
    
        [d,u]       = das_filter_falsche_werte_f(d,u);
           
        s_data.file        = filename;
        s_file             = str_get_pfe_f(filename);
        s_data.name        = s_file.name;
        s_data.c_prc_files = '';
        s_data.d           = d;
        s_data.u           = u;

        s_data.h{1}     = filename;
        s_data.h{2} = [datestr(now),' read-datcsv-data'];
end
