function c2 = cell_cut(c1,icutstart,icutend)
%
% c2 = cell_cut(c1,icut)
% c2 = cell_cut(c1,icutstart,icutend)
%
% Löscht aus cell-array das Element icut oder icutstart:icutend
% 
c2 = {};

if( ~iscell(c1) )
    error('cell_cut: c1 ist kein cell-array')
end
if( ~exist('icutstart','var') )
    error('cell_cut: icutstart ist leer')
end
if( ~exist('icutend','var') )
    icutend = icutstart;
end
if( icutstart > icutend )
    a = icutstart;
    icutstart = icutend;
    icutend   = a;
end

[nrows,ncols] = size(c1);

if( nrows >= ncols )
    if( icutend > nrows )
        icutend = nrows;
    end
    if( nrows == 1 )
        c2 = {};
    else
        for i=1:nrows+icutstart-icutend-1
            for j=1:ncols
                if( i >= icutstart )
                    c2{i,j} = c1{i+icutend-icutstart+1,j};
                else
                    c2{i,j} = c1{i,j};
                end
            end
        end
    end
else
    if( icutend > ncols )
        icutend = ncols;
    end
    if( ncols == 1 )
        c2 = {};
    else
        for i=1:nrows
            for j=1:ncols+icutstart-icutend-1
                if( j >= icutstart )
                    c2{i,j} = c1{i,j+icutend-icutstart+1};
                else
                    c2{i,j} = c1{i,j};
                end
            end
        end
    end
end