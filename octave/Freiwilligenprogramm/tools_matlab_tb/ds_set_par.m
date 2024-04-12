function par = ds_set_par(par,varargin)
%
%
% Parameter Type 'single':
%
% (wenn par nicht vorgegeben werden soll, kann
%  par = struct([]) verwendet werden)#
%
% par = ds_set_par(par
%                 ,['group','control'] ...
%                 ,'name','delta_t'
%                 ,'val',0.01 ...
%                 ,['unit','s'] ...
%                 ,['com','Abtastzeit Simulation'] ...
%                 );
%
% par.control.delta_t.v = 0.01
% par.control.delta_t.t = 'single'
% par.control.delta_t.u = 's'
% par.control.delta_t.c = 'Abtastzeit Simulation'
%
% Parameter Type 'vector':
%
% par = ds_set_par(par
%                 ,['group','control'] ...
%                 ,'name','igear'
%                 ,'val',[4.1,2.1,1.8,1.2,1.0] ...
%                 ,['unit','-'] ...
%                 ,['com','‹bersetzung Getriebe'] ...
%                 );
%
% par.control.delta_t.v = [4.1,2.1,1.8,1.2,1.0]
% par.control.delta_t.t = 'vector'
% par.control.delta_t.u = '-'
% par.control.delta_t.c = '‹bersetzung Getriebe'

% Parameter Type 'string':
%
% par = ds_set_par(par
%                 ,['group','control'] ...
%                 ,'name','run_name'
%                 ,'val','test' ...
%                 ,['com','Name'] ...
%                 );
% par.control.run_name.v = 'test'
% par.control.run_name.t = 'string'
% par.control.run_name.c = 'Name'
%
% Parameter Type '1dtable' oder 'table'
%
% par = ds_set_par(par ...
%                 ,'group','control' ...
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
% par.control.weg_x.t = '1dtable';
% par.control.weg_x.xn = 'time';
% par.control.weg_x.xv = [0:1:10]';
% par.control.weg_x.xu = 's';
% par.control.weg_x.xc = 'Zeitvektor';
% par.control.weg_x.yn = 'x';
% par.control.weg_x.yv = [0:1:10]'*10;
% par.control.weg_x.yu = 'm';
% par.control.weg_x.yc = 'x-Weg';
% par.control.weg_x.order = 1;
%
% Parameter Type '2dtable' 
%
% par = ds_set_par(par ...
%                 ,'group','control' ...
%                 ,'name','weg_x' ...
%                 ,'xname','time' ...
%                 ,'xunit','s' ...
%                 ,'xval',[0:1:10]' ...
%                 ,'xcom','Zeitvektor' ...
%                 ,'yname','x' ...
%                 ,'yunit','m' ...
%                 ,'yval',[0:1:3]' ...
%                 ,'ycom','x-Weg' ...
%                 ,'order',1
%                 ,'zname','z' ...
%                 ,'zunit','m/s' ...
%                 ,'zmat',[0:1:10]'*[0:1:3] ...
%                 ,'zcom','bla' ...
%                 );
% par.control.weg_x.t = '1dtable';
% par.control.weg_x.xn = 'time';
% par.control.weg_x.xv = [0:1:10]';
% par.control.weg_x.xu = 's';
% par.control.weg_x.xc = 'Zeitvektor';
% par.control.weg_x.yn = 'x';
% par.control.weg_x.yv = [0:1:10]'*10;
% par.control.weg_x.yu = 'm';
% par.control.weg_x.yc = 'x-Weg';
% par.control.weg_x.zn = 'z';
% par.control.weg_x.zm = [0:1:10]'*10;
% par.control.weg_x.zu = 'm';
% par.control.weg_x.zc = 'x-Weg';
% par.control.weg_x.order = 1;


group    = '';
unit     = '-';
comment  = '';
xname    = '';
xunit    = '-';
yname    = '';
yunit    = '-';
zname    = '';
zunit    = '-';
xcomment = '';
ycomment = '';
zcomment = '';
order    = 1;

i = 1;
while( i+1 <= length(varargin) )

    c = lower(varargin{i}(1));
    switch c
        case 'g'
            group = varargin{i+1};
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
        case 'z'
            if( strcmp(lower(varargin{i}(1:2)),'zn') )
                zname = varargin{i+1};
            elseif( strcmp(lower(varargin{i}(1:2)),'zm') )
                zmat = varargin{i+1};
            elseif( strcmp(lower(varargin{i}(1:2)),'zu') )
                zunit = varargin{i+1};
            elseif( strcmp(lower(varargin{i}(1:2)),'zc') )
                zcomment   = varargin{i+1};
            end

        case 'o'
            order = varargin{i+1};
        otherwise

            error('%s: Attribut <%s> nicht okay',mfilename,varargin{i})

    end
    i = i+2;
end

if( ~ischar(group) )    
    error('%s: group muﬂ char sein',mfilename)
end
group = str_cut_ae_f(group,' ');

if( ~exist('name','var') || isempty(name) )
    error('%s: name nicht gesetzt',mfilename)
end
if( ~ischar(name) )    
    error('%s: name muﬂ char sein',mfilename)
end
name = str_cut_ae_f(name,' ');


if( ~ischar(comment) )    
    error('%s: comment muﬂ char sein',mfilename)
end
comment = str_cut_ae_f(comment,' ');

if( exist('xvec','var') && exist('yvec','var') && ~exist('zmat','var') )
    type = '1dtable';
elseif( exist('xvec','var') && exist('yvec','var') && exist('zmat','var') )
    type = '2dtable';
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
        if( isempty(group) )
            
            % type   
            par = struct_set_val(par,[name,'.t'],'single');
            % Value    
            par = struct_set_val(par,[name,'.v'],val(1));
            % unit    
            par = struct_set_val(par,[name,'.u'],unit);
            % comment    
            par = struct_set_val(par,[name,'.c'],comment);
        else

            % type   
            par = struct_set_val(par,[group,'.',name,'.t'],'single');
            % Value    
            par = struct_set_val(par,[group,'.',name,'.v'],val(1));
            % unit    
            par = struct_set_val(par,[group,'.',name,'.u'],unit);
            % comment    
            par = struct_set_val(par,[group,'.',name,'.c'],comment);
        end
    case 'string'
        if( isempty(group) )
            % type   
            par = struct_set_val(par,[name,'.t'],'string');
            % Value    
            par = struct_set_val(par,[name,'.v'],val);
            % comment    
            par = struct_set_val(par,[name,'.c'],comment);
        else
            % type   
            par = struct_set_val(par,[group,'.',name,'.t'],'string');
            % Value    
            par = struct_set_val(par,[group,'.',name,'.v'],val);
            % comment    
            par = struct_set_val(par,[group,'.',name,'.c'],comment);
        end            
    case 'vector'
        
        if( exist('val','var') && ~exist('vec','var') )
            vec = val;
        end
            
        if( isempty(vec) ) 
            error('s: vec ist empty',mfilename)
        end
        [n,m] = size(vec);
        if(m > n )
            vec   = vec';
            [n,m] = size(vec);
        end
        if( ~ischar(unit) )    
            error('%s: unit muﬂ char sein',mfilename)
        end
        unit = str_cut_ae_f(unit,' ');

        if( isempty(group) )
            % type   
            par = struct_set_val(par,[name,'.t'],'vector');
            % type   
            par = struct_set_val(par,[name,'.v'],vec(1:n,1));
            % unit    
            par = struct_set_val(par,[name,'.u'],unit);
            % comment    
            par = struct_set_val(par,[name,'.c'],comment);
        else
            % type   
            par = struct_set_val(par,[group,'.',name,'.t'],'vector');
            % type   
            par = struct_set_val(par,[group,'.',name,'.v'],vec(1:n,1));
            % unit    
            par = struct_set_val(par,[group,'.',name,'.u'],unit);
            % comment    
            par = struct_set_val(par,[group,'.',name,'.c'],comment);
        end            
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

        if( isempty(group) )
           % type   
            par = struct_set_val(par,[name,'.t'],'1dtable');
            % comment
            par = struct_set_val(par,[name,'.c'],comment);
            % name   
            par = struct_set_val(par,[name,'.xn'],xname);
            % unit    
            par = struct_set_val(par,[name,'.xu'],xunit);
            % vec   
            par = struct_set_val(par,[name,'.xv'],xvec(1:n,1));
            % comment    
            par = struct_set_val(par,[name,'.xc'],xcomment);
            % name   
            par = struct_set_val(par,[name,'.yn'],yname);
            % unit    
            par = struct_set_val(par,[name,'.yu'],yunit);
            % vec
            par = struct_set_val(par,[name,'.yv'],yvec(1:n,1));
            % comment    
            par = struct_set_val(par,[name,'.yc'],ycomment);
            %Order
            par = struct_set_val(par,[name,'.lin'],order);    
        else
           % type   
            par = struct_set_val(par,[group,'.',name,'.t'],'1dtable');
            % comment
            par = struct_set_val(par,[group,'.',name,'.c'],comment);
            % name   
            par = struct_set_val(par,[group,'.',name,'.xn'],xname);
            % unit    
            par = struct_set_val(par,[group,'.',name,'.xu'],xunit);
            % vec   
            par = struct_set_val(par,[group,'.',name,'.xv'],xvec(1:n,1));
            % comment    
            par = struct_set_val(par,[group,'.',name,'.xc'],xcomment);
            % name   
            par = struct_set_val(par,[group,'.',name,'.yn'],yname);
            % unit    
            par = struct_set_val(par,[group,'.',name,'.yu'],yunit);
            % vec
            par = struct_set_val(par,[group,'.',name,'.yv'],yvec(1:n,1));
            % comment    
            par = struct_set_val(par,[group,'.',name,'.yc'],ycomment);
            %Order
            par = struct_set_val(par,[group,'.',name,'.lin'],order);    

        end
    case '2dtable'
        
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
        
        if( isempty(zmat) ) 
            error('s: zmat ist empty',mfilename)
        end
        [nz,mz] = size(zmat);

        if( nx ~= nz )
            error('Vektor muﬂ mit Matrix ¸bereinstimmen nx ~= nz!')
        end
        if( ny ~= mz )
            error('Vektor muﬂ mit Matrix ¸bereinstimmen ny ~= mz!')
        end
        if( ~ischar(yunit) )    
            error('%s: yunit muﬂ char sein',mfilename)
        end
        if( ~ischar(ycomment) )    
            error('%s: ycomment muﬂ char sein',mfilename)
        end
        ycomment = str_cut_ae_f(ycomment,' ');
        
        if( isempty(group) )
            % type   
            par = struct_set_val(par,[name,'.t'],'2dtable');
            % name   
            par = struct_set_val(par,[name,'.xn'],xname);
            % unit    
            par = struct_set_val(par,[name,'.xu'],xunit);
            % comment    
            par = struct_set_val(par,[name,'.xc'],xcomment);
            % vec   
            par = struct_set_val(par,[name,'.xv'],xvec(1:nx,1));
            % name   
            par = struct_set_val(par,[name,'.yn'],yname);
            % unit    
            par = struct_set_val(par,[name,'.yu'],yunit);
            % comment    
            par = struct_set_val(par,[name,'.yc'],ycomment);
            % vec
            par = struct_set_val(par,[name,'.yv'],yvec(1:ny,1));
            % name
            par = struct_set_val(par,[name,'.zn'],zname);
            % mat
            par = struct_set_val(par,[name,'.zm'],zmat);
            % unit    
            par = struct_set_val(par,[name,'.zu'],zunit);
            % comment    
            par = struct_set_val(par,[name,'.zc'],zcomment);
            %Order
            par = struct_set_val(par,[name,'.lin'],order);    
        else
            % type   
            par = struct_set_val(par,[group,'.',name,'.t'],'2dtable');
            % name   
            par = struct_set_val(par,[group,'.',name,'.xn'],xname);
            % unit    
            par = struct_set_val(par,[group,'.',name,'.xu'],xunit);
            % comment    
            par = struct_set_val(par,[group,'.',name,'.xc'],xcomment);
            % vec   
            par = struct_set_val(par,[group,'.',name,'.xv'],xvec(1:nx,1));
            % name   
            par = struct_set_val(par,[group,'.',name,'.yn'],yname);
            % unit    
            par = struct_set_val(par,[group,'.',name,'.yu'],yunit);
            % comment    
            par = struct_set_val(par,[group,'.',name,'.yc'],ycomment);
            % vec
            par = struct_set_val(par,[group,'.',name,'.yv'],yvec(1:ny,1));
            % name
            par = struct_set_val(par,[group,'.',name,'.zn'],zname);
            % mat
            par = struct_set_val(par,[group,'.',name,'.zm'],zmat);
            % unit    
            par = struct_set_val(par,[group,'.',name,'.zu'],zunit);
            % comment    
            par = struct_set_val(par,[group,'.',name,'.zc'],zcomment);
            %Order
            par = struct_set_val(par,[group,'.',name,'.lin'],order);    
        end            
    otherwise
    
        error('Dieser Typ: <%s> ist noch nicht bekannt',class(val));
end
 