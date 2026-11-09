function d = struct_vec_beschneiden(d,varargin)
%
% d_out = struct_vec_beschneiden(d_in,'i_start',i0,'i_end',i1);
%
c_names = fieldnames(d);
nmax = 0;
for i=1:length(c_names)
    if( isnumeric(d.(c_names{i})) )        
        nmax = max(nmax,length(d.(c_names{i})));
    end
end
i_start = 1;
i_end   = nmax;

i = 1;
while( i+1 <= length(varargin) )

    switch lower(varargin{i})
        case {'i_start','istart'}
            i_start = varargin{i+1};
            if( ~isnumeric(varargin{i+1}) )
                error('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
            end        
        case {'i_end','iend'}
            i_end   = varargin{i+1};
            if( ~isnumeric(varargin{i+1}) )
                error('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
            end        

    end
    i = i+2;
end

i_start = max(1,i_start);

for i=1:length(c_names)
    if( isnumeric(d.(c_names{i})) )
        d.(c_names{i}) = d.(c_names{i})(i_start:min(i_end,length(d.(c_names{i}))));
    end
end
