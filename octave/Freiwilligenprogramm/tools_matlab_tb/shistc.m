function [nbar,xbar] = shistc(z,delta,nbarin,xbarin)
%
% [nbar,xbar] = shistc(z,delta)
% [nbar,xbar] = shistc(z,delta,nbarin,xbarin)
%
% z         Vektor
% delta     Breite 
% nbarin    alte Auswertung
% xbarin    alte Auswertung
%
% nnar(i  i=1:k    Anzahl
% xbar(i) i=1:k  z-Werte innerhalb delta
%  
% zmin = (floor(min(z)/(delta/2))+1)*(delta/2);
% zmax = (ceil(max(z)/(delta/2))+1)*(delta/2);
% edge     = [zmin-delta/2:delta:zmax+delta/2]';
%

if( ~exist('nbarin','var') || ~exist('xbarin','var') )
  newflag = 1;
else
  newflag = 0;
end
if( ~newflag && (isempty(nbarin) || isempty(xbarin)) )
  newflag = 1;
end

zmin = min(z);
zmax = max(z);

% Anlegen edge neu
if( newflag )
  if( zmax >= 0.0 ) % positiv

      edge_max = delta/2;
      while( zmax > edge_max )
          edge_max = edge_max + delta;
      end
  else
      edge_max = -delta/2;
      while( zmax <= edge_max )
          edge_max = edge_max - delta;
      end
      edge_max = edge_max + delta;
  end

  if( zmin < 0.0 ) % negativ

      edge_min = -delta/2;
      while( zmin <= edge_min )
          edge_min = edge_min - delta;
      end
  else
      edge_min = delta/2;
      while( zmin > edge_min )
          edge_min = edge_min + delta;
      end
      edge_min = edge_min - delta;
  end
  edge     = [edge_min:delta:edge_max]';

else % Verwenden edge alt
  
  delta = mean(diff(xbarin));
  nn    = length(xbarin);
  edge  = zeros(nn+1,1);
  
  for i=1:nn
    edge(i) = xbarin(i)-delta/2.;
  end
  edge(nn+1) = edge(nn)+delta;
  
  while( zmin <= edge(1) )
    edge = [edge(1)-delta;edge];
  end
  while( zmax > edge(length(edge)) )
    edge = [edge;edge(length(edge))+delta];
  end
    
end
  
for i=1:length(edge)-1
    xbar(i) = edge(i)+delta/2;
end

xbar =xbar';

nbar = xbar * 0;

% xbar mit alten Ergebnis füllen
if( ~newflag )
  istart = length(xbar);
  for i=1:length(xbar)
    if( abs(xbar(i) - xbarin(1)) < 1.0e-6 )
      istart = i;
      break;
    end
  end
  nn = length(nbarin);
  for i=istart:length(xbar)
    j = i-istart+1;
    if( j <= nn )
      nbar(i) = nbarin(j);
    end
  end
   
end


for i=1:length(z)
    
    for j=1:length(edge)-1
        
        if( (z(i) >= edge(j)) && (z(i) < edge(j+1)) )
            
            nbar(j) = nbar(j) + 1;
            break
        end
    end
end