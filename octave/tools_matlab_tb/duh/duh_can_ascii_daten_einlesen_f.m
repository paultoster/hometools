function  [okay,s_data] = duh_can_ascii_daten_einlesen_f(filename,c_dbc_files,delta_t,chanvec)

okay = 1;
c_prc = {};
s_data.file        = '';
s_data.name        = '';
s_data.c_prc_files = {};
s_data.d           = 0;
s_data.u           = 0;
s_data.h           = {};

nchanvec           = length(chanvec);
if(nchanvec == 0 )
    chanvec  = 0;
    nchanvec = 1;
end

% Daten einlesen in Struktur
d = 0;
u = 0;
for i=1:length(c_dbc_files)
    ichan = chanvec(min(i,nchanvec));
    [d0,u0,f]=canread(filename,c_dbc_files{i},delta_t,ichan);
    %[d0,u0,f,h,p,a] = das2prcread(filename,c_prc_files{i});
%       clear mex
    if( ~strcmp(class(d0),'struct') )
        okay = 0;
    else
       [d,u] = das_merge_struct_f(d,u,d0,u0);
    end
end

if( ~strcmp(class(d),'struct') )
    okay = 0;
end
            
if( okay )
               
        s_data.file        = filename;
        s_file             = str_get_pfe_f(filename);
        s_data.name        = s_file.name;
        s_data.c_prc_files = c_dbc_files;
        s_data.d           = d;
        s_data.u           = u;
        
        s_data.h{1} = [datestr(now),' read-can_ascii-data'];
end
