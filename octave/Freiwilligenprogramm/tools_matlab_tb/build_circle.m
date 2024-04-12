function [x,y] = build_circle(varargin)
%   [x,y] = build_circle();
%   [x,y] = build_circle('r',1.0,'x0',0.0,'y0',0.0,'phi_deg',360.0,'phi_rad',2*pi ...
%                       ,'n',100,'phi0_deg',0.0,'phi0_rad',0.0);
%
%   Bilde Kreisbogen um (x0,y0) mit Radius r über phi_deg Grad bzw. phi_rad
%   rad mit n Punkten
%   Detailed explanation goes here
  r   = 1.0;
  x0  = 0.0;
  y0  = 0.0;
  phi  = 2*pi;
  phi0 = 0.0;
  n   = 100;
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case 'r'
              r = varargin{i+1};
              if( ~isnumeric(r) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case 'x0'
              x0   = varargin{i+1};
              if( ~isnumeric(x0) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case {'y0'}
              y0 = varargin{i+1};
              if( ~isnumeric(y0) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case 'phi_rad'
              phi = varargin{i+1};
              if( ~isnumeric(phi) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case 'phi_deg'
              phi = varargin{i+1}/180*pi;
              if( ~isnumeric(phi) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist kein numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case 'n'
              n = varargin{i+1};
              if( ~isnumeric(n) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist kein numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case 'phi0_rad'
              phi0 = varargin{i+1};
              if( ~isnumeric(phi0) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case 'phi0_deg'
              phi0 = varargin{i+1}/180*pi;
              if( ~isnumeric(phi0) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist kein numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          otherwise
              tdum = sprintf('%s: Attribut <%s>  nicht okay',mfilename,varargin{i});
              error(tdum)

      end
      i = i+2;
  end
  
  if( n < 2 ), n = 2;end

  x = zeros(n,1);
  y = zeros(n,1);
  
  dphi = phi/(n-1);
  phi  = phi0;
  for i=1:n
    
    x(i) = x0 + r*cos(phi);
    y(i) = y0 + r*sin(phi);
    phi  = phi + dphi;
    
  end

end

