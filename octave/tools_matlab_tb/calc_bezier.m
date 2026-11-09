function [x,y,z,A] = calc_bezier(varargin)
%
% Bezierberechnung mit 3 Punkten oder 2 Punkte und zwei Steigungen
%
%   x = x0*(1-z)^2 + x1*z^2 + xs*2*z*(1-z)
%   y = y0*(1-z)^2 + y1*z^2 + ys*2*z*(1-z)
%
% Berechnung
% [x,y,z,A] = calc_bezier('P0',[0,0],'P1',[100,10],'PS',[50,3],'x',x); oder
% [x,y,z,A] = calc_bezier('P0',[0,0],'P1',[100,10],'PS',[50,3],'z',z); oder
%
% [x,y,z,A] = calc_bezier('x0',0,'y0',0,'x1',100,'y1',10,'xs',50,'ys',3,'x',x); oder
% [x,y,z,A] = calc_bezier('x0',0,'y0',0,'x1',100,'y1',10,'xs',50,'ys',3,'z',z); oder
%
% [x,y,z,A] = calc_bezier('P0',[0,0],'P1',[100,10],'yp0',3,'yp1',4,'x',x); oder
% [x,y,z,A] = calc_bezier('P0',[0,0],'P1',[100,10],'yp0',3,'yp1',4,'z',z); oder
%
% [x,y,z,A] = calc_bezier('x0',0,'y0',0,'x1',100,'y1',10,'yp0',3,'yp1',4,'x',x);
% [x,y,z,A] = calc_bezier('x0',0,'y0',0,'x1',100,'y1',10,'yp0',3,'yp1',4,'z',z);
%
% 
% Berechnung y = f(x) Aufgelöste Darstellung oder [x,y] = f(z) Parametrische
% Darstellung
% Wenn A zurückgegeben wird, kann dies in einer nächsten Berechnung mit
% (...,'A',A,...) benutzt werden 
%
% (...,'plot',1,...) Plottet den Graf
%
% TZS Berthold 3052 10/07

a.init = 1;
a.x0   = [];
a.y0   = [];
a.x1   = [];
a.y1   = [];
a.xs   = [];
a.ys   = [];
a.yp0   = [];
a.yp1   = [];

x  = [];
y  = [];
z  = [];
A  = [];

plot_flag = 0;
calc_flag = 0;

i = 1;
while( i+1 <= length(varargin) )

    switch lower(varargin{i})
        case 'p0'
            a.x0 = varargin{i+1}(1);
            a.y0 = varargin{i+1}(2);

        case 'p1'
            a.x1 = varargin{i+1}(1);
            a.y1 = varargin{i+1}(2);
        case {'ps','p2'}
            a.xs = varargin{i+1}(1);
            a.ys = varargin{i+1}(2);
        case 'x0'
            a.x0 = varargin{i+1}(1);
        case 'y0'
            a.y0 = varargin{i+1}(1);
        case 'x1'
            a.x1 = varargin{i+1}(1);
        case 'y1'
            a.y1 = varargin{i+1}(1);
        case {'xs','x2'}
            a.xs = varargin{i+1}(1);
        case {'ys','ys'}
            a.ys = varargin{i+1}(1);
        case 'yp0'
            a.yp0 = varargin{i+1}(1);
        case 'yp1'
            a.yp1 = varargin{i+1}(1);
        case 'x'
            x = varargin{i+1};
        case 'z'
            z = varargin{i+1};
        case 'A'
            A = varargin{i+1};
        case 'plot'
            plot_flag = varargin{i+1};
        otherwise
            if( ischar(varargin{i}) )
                tdum = sprintf('%s: Attribut <%s> ist nicht okay',mfilename,varargin{i});
            elseif( isnumeric(varargin{i}) )
                tdum = sprintf('%s: Attribut <%s> ist nicht okay',mfilename,varargin{i});
            else
                varargin{i}
                tdum = sprintf('%s: Attribut ist nicht okay',mfilename);
            end
            error(tdum)

    end
    i = i+2;
end

init = isstruct(A) && isfield(A,'init') && A.init == 1;
if( ~init )
    
    A = a;

    if( isempty(A.x0) )
        error('%s: A.x0 ist nicht gesetzt',mfilename);
    end
    if( isempty(A.y0) )
        error('%s: A.y0 ist nicht gesetzt',mfilename);
    end
    if( isempty(A.x1) )
        error('%s: A.x1 ist nicht gesetzt',mfilename);
    end
    if( isempty(A.y1) )
        error('%s: A.y1 ist nicht gesetzt',mfilename);
    end
    
    if( length(A.yp0) > 0 && length(A.yp1) > 0 )
        
        if( abs(A.yp1-A.yp0) < eps )
            error('%s: A.yp0=%g ist gleich A.yp1=%g, darf nicht sein',mfilename,A.yp1,A.yp0);
        end
        
        D = A.yp1 - A.yp0;
        if( abs(D) < eps )
            
            A.xs = A.x1;
            A.ys = A.y1;
        else
            A.xs = (A.y0-A.x0*A.yp0-A.y1+A.x1*A.yp1)/D;
            A.ys = A.yp0*(A.xs-A.x0)+A.y0;
        end
    end
    
    if( isempty(A.xs) )
        error('%s: A.xs ist nicht gesetzt',mfilename);
    end
    if( isempty(A.ys) )
        error('%s: A.ys ist nicht gesetzt',mfilename);
    end
    
    if( abs(A.x1-A.x0) < eps )
        error('%s: Der Abstand von A.x0=%g und A.x1=%g ist kleine eps',mfilename,A.x0,A.x1);
    end
    
    
    % Initialisieren:
    %================
    
    A.E = 2*A.xs-A.x0-A.x1;
    
    if( abs(A.E) < eps )
        
        A.B2 = 1./(A.x1-A.x0);
        A.B1 = -A.x0*A.B2;
        A.B3 = 0.0;
        A.B4 = 0.0;
        A.B5 = 0.0;

    else
        A.B1 = (A.xs-A.x0)/A.E;
        A.B2 = 0.0;
        A.B3 = -sign(A.E);
        A.B4 = (A.xs*A.xs-A.x0*A.x1)/A.E/A.E;
        A.B5 = -1.0/A.E;
    end
    
end

if( ~isempty(x) )

    C = A.B4+A.B5*x;
    if( min(C) < 0 )
        error('%s: Problem Lösung',mfilename)
    end
    B = A.B1+A.B2*x+A.B3*sqrt(C);
    
    y = A.y0*(1-B).^2+A.y1*B.^2+A.ys*2.0*B.*(1.0-B);
    
    z = max(0.0,(A.xs-A.x0)^2-(A.x0+A.x1-2*A.xs)*(A.x0-x));
    z = (sqrt(z)-(A.xs-A.x0))/(A.x0+A.x1-2*A.xs);
    
    calc_flag = 1;
    
elseif( ~isempty(z) )
    
    x = A.x0*(1-z).^2 + A.x1*z.^2 + A.xs*z.*(1-z)*2.0;
    y = A.y0*(1-z).^2 + A.y1*z.^2 + A.ys*z.*(1-z)*2.0;
    
    calc_flag = 1;
    
end

if( calc_flag && plot_flag )
    
    Px = [A.x0;A.x1];
    Py = [A.y0;A.y1];
    Qx = [A.x1;A.xs;A.x0];
    Qy = [A.y1;A.ys;A.y0];

    figure
    plot(x,y,'g-','LineWidth',2)
    hold on
    plot(Px,Py,'k:')
    plot(Qx,Qy,'r-')
    hold off
    grid on
    
end    

