% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
function   [okay,s_data] = duh_pick_duh_f(d,u,h)


% sortiert d,u - Strukturenn bzw. h-cellarray in die s_data Struktur ein
% und prüft konsistenz von d und u
%
okay   = 1;
s_data = 0;
% d:
if( ~strcmp(class(d),'struct') )
    okay = 0;
    return
else
    c_d_names = fieldnames(d);
    len_d_names = length(c_d_names);
    ncount = 0;
    for i = 1:len_d_names
        if( strcmp(class(d.(c_d_names{i})),'double') )
            val = d.(c_d_names{i});
            [n,m] = size(val);
            if( m > n )
                val = val';
                [n,m] = size(val);
            end
            s_data.d.(c_d_names{i}) = val;
            ncount = ncount + 1;
            end
        end
    end
    if( ncount == 0 )
        okay = 0;
        return
    end
end
% u:
if( nargin < 2 | ~strcmp(class(u),'struct')) % kein u bzw. keine Struktur
    c_d_names = fieldnames(s_data.d);
    len_d_names = length(c_d_names);
    for i = 1:len_d_names
        s_data.u.(c_d_names{i}) = '';
    end
else
    c_d_names = fieldnames(s_data.d);
    len_d_names = length(c_d_names);
    c_u_names     = fieldnames(u);
    len_u_names = length(c_u_names);
    
    for i = 1:len_d_names
        found_flag = 0;
        for j = 1:len_u_names
            if( strcmp(c_d_names{i},c_u_names{j}) )
                s_data.u.(c_d_names{i}) = u.(c_u_names{j});
                found_flag = 1;
                break
            end
        end
        if( ~found_flag )
            s_data.u.(c_d_names{i}) = '';
        end
    end
end
% h:
if( nargin < 3  ) % kein u bzw. keine Struktur
    s_data.h = {};
elseif( strcmp(class(h),'char') )
    s_data.h{1} = h;
elseif( strcmp(class(h),'cell') )
    s_data.h = h;
else
    s_data.h = {};
end
    


