function [okay,s_data] = duh_ascii_canalyser_daten_einlesen_f(mess_file,c_dbc_files,chanvec,delta_t)
%
% [okay,s_data] = duh_ascii_canalyser_daten_einlesen_f(mess_file,c_dbc_files,chanvec,delta_t)
%
okay = 1;

% Daten einlesen in Struktur
d = 0;
u = 0;
for j=1:min(length(c_dbc_files),length(chanvec))
    
    [d0,u0] = canread(mess_file,c_dbc_files{j},delta_t,chanvec(j));
%       clear mex

    if( j == 1 )
        d = d0;
        u = u0;
    else
        if( ~isstruct(d0) )
            okay = 0;
        else
           [d,u] = das_merge_struct_f(d,u,d0,u0);
           d     = struct_reduce_vecs_to_min_length(d);
        end
    end
end
if( okay )
    s_data.d           = d;
    s_data.u           = u;
    s_data.h           = {'Canalyser-Daten'};
    s_data.file        = mess_file;
    s_file             = str_get_pfe_f(mess_file);
    s_data.name        = s_file.name;
    s_data.c_prc_files = c_dbc_files;
end
