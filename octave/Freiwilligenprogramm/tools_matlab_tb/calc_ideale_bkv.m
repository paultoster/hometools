function [f_va,f_ha,z] = calc_ideale_bkv(varargin);
%
%Aufruf
% [f_va,f_ha] = calc_ideale_bkv('type','rel','mass',2000,'psi',0.5,'chi',0.2,'z_start',0,'z_end',1.0,'points',100)
%
% ideal Bremskraftverteilung relativ oder absolut
%Input
%
% 'type'        'rel','abs'     relativ oder absolut default 'rel'
% 'mass'        kg              Fzg-Mass
% 'psi'         -               Hinterachslast
% 'chi'         -               bezogener Höhenschwerpunkt
% 'alpha'       grad            Steigungswinkel (defaukt 0 )
% 'z_start'     m/s/s/g         Erster Wert Abbremsung (default 0)
% 'z_end'       m/s/s/g         Erster Wert Abbremsung (default 0)
% 'del_z'       m/s/s/g         Schrittweite, wenn nicht 'points' angegeben
% 'points'      -               Anzahl der Punkte (default 100)

i = 1;

type = '';
mass = [];
psi  = [];
chi  = [];
alpha = 0.0;
z_start = 0.0;
z_end   = 1.0;
del_z   = [];
points  = 100;
while( i+1 <= length(varargin) )

    switch lower(varargin{i})
        case 'type'
            type = varargin{i+1};
        case 'mass'
            mass = varargin{i+1};
        case 'psi'
            psi = varargin{i+1};
        case 'chi'
            chi = varargin{i+1};
        case 'alpha'
            alpha = varargin{i+1};
        case 'z_start'
            z_start = varargin{i+1};
        case 'z_end'
            z_end = varargin{i+1};
        case 'del_z'
            del_z = varargin{i+1};
        case 'points'
            points = varargin{i+1};
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


if( isempty(type) )
    error('%s: type=''rel'' oder ''abs'' ist nicht gesetzt',mfilename);
end
if( isempty(psi) )
    error('%s: psi ist nicht gesetzt',mfilename);
end
if( isempty(chi) )
    error('%s: chi ist nicht gesetzt',mfilename);
end

z_start = abs(z_start);
z_end   = abs(z_end);
if( ~isempty(del_z) )
    del_z = abs(del_z);
else
    points  = max(points,1);
    del_z = (z_end-z_start)/(points-1);
end
alpha   = alpha/180*pi;

if( z_start > z_end )
    
    dum     = z_start;
    z_start = z_end;
    z_end   = dum;
end
% Berechnung
%===========

if( del_z < eps )
    z = z_start;
else
    z = [z_start:del_z:z_end]';
end


f_va = (z-sin(alpha)).*((1-psi)+chi/cos(alpha)*(z-sin(alpha)));
f_ha = (z-sin(alpha)).*(psi-chi/cos(alpha)*(z-sin(alpha)));

if( type(1) == 'a' ) % absolut
    
    if( isempty(mass) )
        error('%s: mass ist nicht gesetzt',mfilename);
    end
    
    f_va = f_va * mass * 9.81;
    f_ha = f_ha * mass * 9.81;
    
end

