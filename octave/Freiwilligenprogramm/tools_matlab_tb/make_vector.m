function vec = make_vector(varargin)
%
% Erstellt Vektor mit mindestens drei Informationen mit Keywörtern
% 'start','end','length' oder 'len','delta'
% zsätzlich kann noch 'type' für Zeilenvektor 'row' oder Spaltenvektor
% 'col' angegeben werden (default('row'))
%
% z.B. vec = make_vector('start',0,'end',10,'length',11,'type','col');

vtype  = 'row';
i = 1;
while( i+1 <= length(varargin) )

    switch lower(varargin{i})
        case 'start'
            vstart = varargin{i+1};
            if( ~isnumeric(vstart) )
                tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
                error(tdum)
            end        
        case 'end'
            vend   = varargin{i+1};
            if( ~isnumeric(vend) )
                tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
                error(tdum)
            end        
        case {'length','len'}
            vlength = varargin{i+1};
            if( ~isnumeric(vlength) )
                tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
                error(tdum)
            end        
        case 'delta'
            vdelta = varargin{i+1};
            if( ~isnumeric(vdelta) )
                tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i})
                error(tdum)
            end        
        case 'type'
            vtype = varargin{i+1};
            if( ~ischar(vtype) )
                tdum = sprintf('%s: Wert für Attribut <%s>  ist kein string',mfilename,varargin{i})
                error(tdum)
            end        
        otherwise
            tdum = sprintf('%s: Attribut <%s>  nicht okay',mfilename,varargin{i})
            error(tdum)

    end
    i = i+2;
end

% 'start','end','length'
if( exist('vstart','var') && exist('vend','var') && exist('vlength','var') )
    vlength = abs(vlength);
    if( vlength > 1 ) 
        vdelta =  (vend-vstart)/(vlength-1);
    end

% 'start','end','delta'
elseif( exist('vstart','var') && exist('vend','var') && exist('vdelta','var') )
    
    if(  (vdelta >= 0 && vstart >= vend) ...
      || (vdelta < 0 && vstart < vend) ...
      )
        vdelta = vdelta * (-1);
    end
    
    if( abs(vdelta) == 0 )
        vlength = 1;
    else
        vlength = (vend-vstart)/vdelta+1;
    end

% 'start','delta','length'
elseif( exist('vstart','var') && exist('vdelta','var') && exist('vlength','var') )

    vlength = abs(vlength);    
    vend = vstart + vdelta * (vlength-1);

% 'end','delta','length'
elseif( exist('vend','var') && exist('vdelta','var') && exist('vlength','var') )

    vlength = abs(vlength);    
    vstart = vend - vdelta * (vlength-1);
else
    tdum = sprintf('%s: Mindestens drei Angaben machen:''start'',val,''end'',val,''delta'',val,''length'',val ',mfilename)
    error(tdum)
    
end

if( vlength > 1 )
    
    vec = [vstart:vdelta:vend];
else
    vec = vstart;
end

if( ~strcmp(vtype,'col') )
    vec = vec';
end
