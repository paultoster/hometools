function di = phaseshift(x,y,type,maxshift)
%
% di = phaseshift(x,y[,type,maxshift])
%
% Phasenverschiebung aus Correlationsberechnung zwischen x und y
% id ist die Anzahl der Indizes die verschoben sind
%
% type  = 'stand'   (default) standard
%       = 'self'    eigene berechnung
% maxshift          maximales shift (default n-1)
% id < 0 bedeutet y ist um di hinter x 
% id > 0 bedeutet y ist um di vor x 
%
% Phasenverschiebung
%===================
  if( ~exist('type','var') )
    type = 'stand';
  end
  if( ~exist('maxshift','var') )
    maxshift = min(length(x),length(y))-1;
  end
  maxshift = abs(maxshift);
  
  if( strcmp(type,'stand') )
    [R0, lags0]    = sxcorr(x,maxshift,'none');
    [R, lags]      = sxcorr(x,y,maxshift,'none');

    [R0max,iR0max] = max(R0);
    [Rmax,iRmax]   = max(R);

    di             = iR0max - iRmax;
  else
    vecs = [-maxshift:1:maxshift];
    n = min(length(x),length(y));
    summin = 1.0e20;
    di     = 0;
    for ish=1:length(vecs)
      shift = vecs(ish);
      sum  = 0.0;
      n1   = 0;
      for i=1:n
        j = floor(i-shift);
        if( j > 0 && j <= n )
          sum  = sum + abs(x(i)-y(j));
          n1   = n1 + 1;
        end
      end
      if( n1 > 0 )
        sum = sum/n1;
        if( sum < summin )
         summin = sum;
         di     = shift;
        end
      end
    end
  end
end