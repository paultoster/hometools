function okay = struct_vector_out(S,varargin)
%
% okay = struct_vector_out(S,'excel',s_e,'icol',1,'irow',1,'cname',{'name1','name2'},'cunit',{'s','km/h'})
%

if( ~isstruct(S) )
    error('Keine Struktur')
end

s_e  = 0;
icol = 1;
irow = 1;
cname = {};
cunit = {};

i = 1;
while( i+1 <= length(varargin) )
    
    switch lower(varargin{i})
        case 'excel'
            s_e = varargin{i+1};
            if( ~isstruct(s_e) && ~isfield(s_e,'excel_fid') )
                tdum = sprintf('%s: Attribut <%s> ist nicht die passende excel-Sruktur',mfilename,varargin{i});
                error(tdum);
            end
        case 'icol'
            icol = varargin{i+1};
            if( ~isnumeric(icol)  )
                tdum = sprintf('%s: Attribut <%s> ist nicht numerisch',mfilename,varargin{i});
                error(tdum);
            end
        case 'irow'
            irow = varargin{i+1};
            if( ~isnumeric(irow)  )
                tdum = sprintf('%s: Attribut <%s> ist nicht numerisch',mfilename,varargin{i});
                error(tdum);
            end
        case 'cname'
            cname = varargin{i+1};
            if( ~iscell(cname)  )
                tdum = sprintf('%s: Attribut <%s> ist nicht cell-array',mfilename,varargin{i});
                error(tdum);
            end
        case 'cunit'
            cunit = varargin{i+1};
            if( ~iscell(cunit)  )
                tdum = sprintf('%s: Attribut <%s> ist nicht cell-array',mfilename,varargin{i});
                error(tdum);
            end
        otherwise
            tdum = sprintf('%s: Attribut <%s> ist nicht okay',mfilename,varargin{i});
            error(tdum)

    end
    i = i+2;
end

n = min(length(cunit),length(cname));

for i=1:n
    
    ic = icol+i-1;

    if( isfield(S,cname{i}) )
        
        [okay,s_e] = ausgabe_excel('val',s_e,'col',ic,'row',irow,  'val',cname{i});        
        [okay,s_e] = ausgabe_excel('val',s_e,'col',ic,'row',irow+1,'val',cunit{i});
        [okay,s_e] = ausgabe_excel('vec',s_e,'icol',ic,'irow',irow+2,'vec',S.(cname{i}));
    end
end
    
