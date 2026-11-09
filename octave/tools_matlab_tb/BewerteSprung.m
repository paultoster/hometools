function [iReak,iEnd] = BewerteSprung(varargin)
%
% [iReak,iEnd] =
% BewerteSprung('signal',signal,'startindex',istart,'schwelle0',sw0,'schwelle1',sw1,'deltaiEnd',10)
%
  iReak = 0;
  iEnd  = 0;
  signal    = [];
  istart    = 1;
  schwelle0 = [];
  schwelle1 = [];
  deltaiEnd = 3;
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case 'signal'
              signal = varargin{i+1};
          case 'startindex'
              istart = round(varargin{i+1});
          case 'schwelle0'
              schwelle0 = varargin{i+1};
          case 'schwelle1'
              schwelle1 = varargin{i+1};
          case 'deltaiend'
              deltaiEnd = round(varargin{i+1});
          otherwise
              tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type)
              error(tdum)

      end
      i = i+2;
  end

  if( isempty(signal) )
    
    error('signal muß gesetzt sein')
  end
  
  if( isempty(schwelle0) )  
    schwelle0 = (max(signal)-min(signal))*0.01;
  end
  
  if( isempty(schwelle1) )  
    schwelle1 = (max(signal)-min(signal))*0.01;
  end
  
  n = length(signal);
  
  itype = 0;  % 0: Reaktion suchen
              % 1: Endwert suchen
              % 2: Endwert prüfen
              % 3: Ende
  sig0  =  signal(istart);
  for i=istart+1:n
    
    if( itype == 0 )
      
      if( abs(signal(i)-sig0) > schwelle0 )
        itype = 1;
        iReak = i;
        iEnd  = n;
      end
    elseif( itype == 1 ) % Endwert suchen
      
      if( abs(signal(i)-sold) < schwelle1 )
        itype  = 2;
        icount = 1;
        iStern = i;
      end
      
    elseif( itype == 2 ) % Endwert prüfen
      
      if( abs(signal(i)-sold) > schwelle1 )
        itype = 1;
      else
        icount = icount + 1;
      end
      if( icount >= deltaiEnd )
        itype = 3;
        iEnd  = iStern;
      end
    else
      break;
    end
    sold = signal(i);
  end
end        
      
      
      
      
    
  
  
  