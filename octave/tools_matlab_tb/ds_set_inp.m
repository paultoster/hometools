function inp = ds_set_inp(inp,varargin)
%
% Inputtyp: Single
% inp = ds_set_inp(inp
%                 ,'name','v_veh'
%                 ,'val',80 ...
%                 ,['unit','km/h'] ...
%                 ,['com','Fahrgeschwindigkeit'] ...
%                 );
%
% inp.v_veh.v = 80
% inp.v_veh.t = 'single'
% inp.v_veh.u = 'km/h'
% inp.v_veh.c = 'Fahrgeschwindigkeit'
%
% Inputtyp: Vector
% inp = ds_set_inp(inp
%                 ,'name','v_veh'
%                 ,'val',[80,20,40,30] ...
%                 ,['unit','km/h'] ...
%                 ,['com','Fahrgeschwindigkeit'] ...
%                 );
%
% inp.v_veh.v = [80,20,40,30]
% inp.v_veh.t = 'vector'
% inp.v_veh.u = 'km/h'
% inp.v_veh.c = 'Fahrgeschwindigkeit'
%
% Inputtyp: string
%
% inp = ds_set_inp(inp
%                 ,'name','test'
%                 ,'val','test' ...
%                 ,['com','Testeingabe'] ...
%                 );
%
% inp.v_veh.v = 'test'
% inp.v_veh.t = 'string'
% inp.v_veh.c = 'Fahrgeschwindigkeit'
%
% Parameter Type '1dtable' oder 'table'
%
% inp = ds_set_inp(inp ...
%                 ,'name','weg_x' ...
%                 ,'xname','time' ...
%                 ,'xunit','s' ...
%                 ,'xval',[0:1:10]' ...
%                 ,'xcom','Zeitvektor' ...
%                 ,'yname','x' ...
%                 ,'yunit','m' ...
%                 ,'yval',[0:1:10]'*10 ...
%                 ,'ycom','x-Weg' ...
%                 ,'order',1
%                 );
% inp.weg_x.t = '1dtable';
% inp.weg_x.xn = 'time';
% inp.weg_x.xv = [0:1:10]';
% inp.weg_x.xu = 's';
% inp.weg_x.xc = 'Zeitvektor';
% inp.weg_x.yn = 'x';
% inp.weg_x.yv = [0:1:10]'*10;
% inp.weg_x.yu = 'm';
% inp.weg_x.yc = 'x-Weg';
% inp.weg_x.order = 1;

unit    = '-';
comment = '';
xunit    = '-';
yunit    = '-';
xcomment = '';
ycomment = '';
order    = 1;

i = 1;
while( i+1 <= length(varargin) )

    c = lower(varargin{i}(1));
    switch c
        case 'n'
            name = varargin{i+1};
        case 'v'
            val = varargin{i+1};
        case 'u'
            unit = varargin{i+1};
        case 'c'
            comment   = varargin{i+1};
        case 'x'
            
            if( strcmp(lower(varargin{i}(1:2)),'xn') )
                xname = varargin{i+1};
            elseif( strcmp(lower(varargin{i}(1:2)),'xv') )
                xvec = varargin{i+1};
            elseif( strcmp(lower(varargin{i}(1:2)),'xu') )
                xunit = varargin{i+1};
            elseif( strcmp(lower(varargin{i}(1:2)),'xc') )
                xcomment   = varargin{i+1};
            end
            
        case 'y'
            if( strcmp(lower(varargin{i}(1:2)),'yn') )
                yname = varargin{i+1};
            elseif( strcmp(lower(varargin{i}(1:2)),'yv') )
                yvec = varargin{i+1};
            elseif( strcmp(lower(varargin{i}(1:2)),'yu') )
                yunit = varargin{i+1};
            elseif( strcmp(lower(varargin{i}(1:2)),'yc') )
                ycomment   = varargin{i+1};
            end
        otherwise

            error('%s: Attribut <%s> nicht okay',mfilename,varargin{i})

    end
    i = i+2;
end

if( ~exist('name','var') || isempty(name) )
    error('%s: name nicht gesetzt',mfilename)
end

if( exist('xvec','var') && exist('yvec','var') && ~exist('zmat','var') )
    type = '1dtable';
elseif( (exist('vec','var')|| (exist('val','var') && isnumeric(val) && length(val) > 1) ) )
    type = 'vector';
elseif( exist('val','var') && ischar(val) )
    type = 'string';
elseif(exist('val','var') && isnumeric(val) )
    type = 'single';
else
    error('%s: type nicht erkannt (''val'',(''xvec'',''yvec''),(''xvec'',''yvec'',''zmat''))')
end

switch(type) 
    
    case 'single'
        
        if( isempty(val) )
            error('%s: value nicht gesetzt',mfilename)
        end
        if( ~ischar(unit) )    
            error('%s: unit muﬂ char sein',mfilename)
        end
        unit = str_cut_ae_f(unit,' ');

        % Value    
        inp = struct_set_val(inp,[name,'.v'],val);
        % type   
        inp = struct_set_val(inp,[name,'.t'],'single');
        % unit    
        inp = struct_set_val(inp,[name,'.u'],unit);
        % comment    
        inp = struct_set_val(inp,[name,'.c'],comment);

    case 'string'

        % Value    
        inp = struct_set_val(inp,[name,'.v'],val);
        % type   
        inp = struct_set_val(inp,[name,'.t'],'string');
        % comment    
        inp = struct_set_val(inp,[name,'.c'],comment);

    case 'vector'
        
        if( exist('val','var') && ~exist('vec','var') )
            vec = val;
        end
            
        if( isempty(vec) ) 
            error('s: vec ist empty',mfilename)
        end
        [n,m] = size(vec);
        if(m > n )
            vec = vec';
            n = m;
        end
        
        if( ~ischar(unit) )    
            error('%s: unit muﬂ char sein',mfilename)
        end
        unit = str_cut_ae_f(unit,' ');

        % Value    
        inp = struct_set_val(inp,[name,'.v'],val);
        % type   
        inp = struct_set_val(inp,[name,'.t'],'vector');
        % unit    
        inp = struct_set_val(inp,[name,'.u'],unit);
        % comment    
        inp = struct_set_val(inp,[name,'.c'],comment);

    case '1dtable'
        
        if( ~isnumeric(order) )
            error('%s: order muﬂ 0,1 sein (step,linear)',mfilename)
        end
        if( isempty(xvec) ) 
            error('s: xvec ist empty',mfilename)
        end
        [nx,mx] = size(xvec);
        if(mx > nx )
            xvec = xvec';
            nx = mx;
        end
        
        if( ~ischar(xunit) )    
            error('%s: xunit muﬂ char sein',mfilename)
        end
        if( ~ischar(xcomment) )    
            error('%s: xcomment muﬂ char sein',mfilename)
        end
        xcomment = str_cut_ae_f(xcomment,' ');

        if( isempty(yvec) ) 
            error('s: yvec ist empty',mfilename)
        end
        [ny,my] = size(yvec);
        if(my > ny )
            yvec = yvec';
            ny = my;
        end
        
        if( ~ischar(yunit) )    
            error('%s: yunit muﬂ char sein',mfilename)
        end
        if( ~ischar(ycomment) )    
            error('%s: ycomment muﬂ char sein',mfilename)
        end
        ycomment = str_cut_ae_f(ycomment,' ');
        
        n = min(nx,nx);

        % type   
        inp = struct_set_val(inp,[name,'.t'],'1dtable');
        % comment    
        inp = struct_set_val(inp,[name,'.c'],comment);
        % name   
        inp = struct_set_val(inp,[name,'.xn'],xname);
        % unit    
        inp = struct_set_val(inp,[name,'.xu'],xunit);
        % vec   
        inp = struct_set_val(inp,[name,'.xv'],xvec(1:n,1));
        % comment    
        inp = struct_set_val(inp,[name,'.xc'],xcomment);
        % name   
        inp = struct_set_val(inp,[name,'.yn'],yname);
        % unit    
        inp = struct_set_val(inp,[name,'.yu'],yunit);
        % vec
        inp = struct_set_val(inp,[name,'.yv'],yvec(1:n,1));
        % comment    
        inp = struct_set_val(inp,[name,'.yc'],ycomment);
        %Order
        inp = struct_set_val(inp,[name,'.lin'],order);    

end

% if( ~exist('val','var') || isempty(val) )
%     error('%s: value nicht gesetzt',mfilename)
% end
% 
% if( ~ischar(name) )    
%     error('%s: name muﬂ char sein',mfilename)
% end
% 
% name = str_cut_ae_f(name,' ');
% if( ~ischar(val) && ~isnumeric(val) )    
%     error('%s: val muﬂ char oder double sein',mfilename)
% end
% if( ~ischar(unit) )    
%     error('%s: unit muﬂ char sein',mfilename)
% end
% unit = str_cut_ae_f(unit,' ');
% if( ~ischar(comment) )    
%     error('%s: comment muﬂ char sein',mfilename)
% end
% comment = str_cut_ae_f(comment,' ');
% 
%            
% if( isnumeric(val) && length(val) == 1)    
% elseif( isnumeric(val) )    
% elseif( ischar(val) )
%     
% else
%     
%     error('Dieser Typ: <%s> ist noch nicht bekannt',class(val));
% end
%  

    
        
        



                