function bool=is_monoton(xvec,steigend,streng)
%
% bool=is_monoton(xvec,steigend,streng)
%
% Prüft, ob monoton steigend, fallend und streng monoton
%
% xvec     Vektor
% steigend  1/0   steigend/fallend  (default: 1)
% streng    1/0   streng/nicht streng (default: 1)
%
  dx = diff(xvec);
  bool = 1;
  if( ~exist('steigend','var') )
    steigend = 1;
  end
  if( ~exist('streng','var') )
    streng = 1;
  end
  if( steigend )
    if( streng )
      if any(dx<=0)
         bool = 0;
      end
    else
      if any(dx<0)
         bool = 0;
      end
    end
  else
    if( streng )
      if any(dx>=0)
         bool = 0;
      end
    else
      if any(dx>0)
         bool = 0;
      end
    end

  end
end