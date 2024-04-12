% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function  [okay,s_data] = duh_das_daten_einlesen_f(filename,c_prc_files)

okay = 1;
c_prc = {};
s_data.file        = '';
s_data.name        = '';
s_data.c_prc_files = {};
s_data.d           = 0;
s_data.u           = 0;
s_data.h           = {};

% Daten einlesen in Struktur
if( length(c_prc_files) == 0 ) % automatisches Einlesen
    [d,u,f,h,p] = dasread(filename);
%    clear mex
    if( ~strcmp(class(d),'struct') | strcmp(p,'no prc-File') )
        okay = 0;
    else
        c_prc{1} = p;
    end
else
    d = 0;
    u = 0;
    for i=1:length(c_prc_files)
        [d0,u0,f,h,p] = dasprcread(filename,c_prc_files{i});
 %       clear mex
        if( ~strcmp(class(d0),'struct') )
            okay = 0;
        else
            [d,u] = das_merge_struct_f(d,u,d0,u0);
            c_prc{i} = p;
        end
    end
end
if( ~strcmp(class(d),'struct') )
    okay = 0;
end
            
if( okay )
    
        [d,u]       = das_filter_falsche_werte_f(d,u);
           
        s_data.file        = filename;
        s_file             = str_get_pfe_f(filename);
        s_data.name        = s_file.name;
        s_data.c_prc_files = c_prc;
        s_data.d           = d;
        s_data.u           = u;
        
        if( isfield(h,'global') )
            
            % 101 Kommentar nach vorne sortieren !!!
            [n,m] = size(h.global);
            i1 = 0;
            icount = 0;
            for i=1:n
                comment = str_cut_ae_f(h.global{i,1},' ');
                if( strcmp(comment,'101' ) )
                    i1 = i;
                    icount = icount+1;
                    s_data.h{icount} = [comment,' ',h.global{i,2}];
                    break
                end
            end
            
            for i=1:n
                if( i ~= i1 )
                    comment = '';
                    for j=1:m
                        comment = [comment,' ',char(h.global{i,j})];
                    end
                    comment     = str_cut_ae_f(comment,' ');
                    icount = icount+1;
                    s_data.h{icount} = comment;
                end
            end
        end
        len = length(s_data.h);
        s_data.h{len+1} = [datestr(now),' read-das-data'];
end
