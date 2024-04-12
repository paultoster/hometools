function [xvec,yvec] = build_box(varargin)
%
%
% [xvec,yvec] = build_box('x0',x0,'y0',y0,'cyaw',cyaw,'syaw',syaw,'laenge',laenge,'breite',breite)
%
%        breite
% (4) +---------------+ (3)
%     |               |  
%     |               |  
%     |               |  laenge
%     |               |  
%     |               |  
%     |               |  
%     |      (1,6)    |  
% (5) +-------+-------+ (2)  
%         x0,y0
%
%          ^
%          |  Richtung von caw = cos(yaw) syaw = sin(yaw)
%          |
  x0  = 0.0;
  y0  = 0.0;
  syaw  = 0;
  cyaw  = 1.0;
  laenge = 2.0;
  breite = 1.0;
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
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
          case 'syaw'
              syaw = varargin{i+1};
              if( ~isnumeric(syaw) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case 'cyaw'
              cyaw = varargin{i+1};
              if( ~isnumeric(cyaw) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist kein numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case 'laenge'
              laenge = varargin{i+1};
              if( ~isnumeric(laenge) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist kein numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          case 'breite'
              breite = varargin{i+1};
              if( ~isnumeric(breite) )
                  tdum = sprintf('%s: Wert für Attribut <%s>  ist nicht numerich',mfilename,varargin{i});
                  error(tdum)
              end        
          otherwise
              tdum = sprintf('%s: Attribut <%s>  nicht okay',mfilename,varargin{i});
              error(tdum)

      end
      i = i+2;
  end
  
  cbeta = -syaw;
  sbeta = +cyaw;
  % 1
  xvec = x0;
  yvec = y0;
  % 2
  xvec = [xvec;x0-breite/2*cbeta];
  yvec = [yvec;y0-breite/2*sbeta];
  % 3
  xvec = [xvec;x0-breite/2*cbeta+laenge*cyaw];
  yvec = [yvec;y0-breite/2*sbeta+laenge*syaw];
  % 4
  xvec = [xvec;x0+breite/2*cbeta+laenge*cyaw];
  yvec = [yvec;y0+breite/2*sbeta+laenge*syaw];
  % 5
  xvec = [xvec;x0+breite/2*cbeta];
  yvec = [yvec;y0+breite/2*sbeta];
  % 6
  xvec = [xvec;x0];
  yvec = [yvec;y0];
end
 