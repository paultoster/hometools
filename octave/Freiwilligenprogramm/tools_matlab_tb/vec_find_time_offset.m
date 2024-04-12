function [di,Err] = vec_find_di_offset(yvec0,yvec1)
%
% [di,Err] = vec_find_di_offset(yvec0,yvec1)
%
% Finde den Offset mit der kleinsten Abweichung von yvec1 in
% yvec0. Es muss gegeben sein length(yvec0) >= length(yvec1)
%
% di      index yvec1(i) passt am besten zu yvec0(i+di)
%         di ist maximal length(yvec0) - length(yvec1)
% Err     Quadratwurzelabweichung
%
  [n,m] =size(yvec0);
  if( m > n )
    yvec0 = yvec0';
    nn    = n;
    n     = m;
    m     = nn;
  end
  n0 = n*m;
  [n,m] =size(yvec1);
  if( m > n )
    yvec1 = yvec1';
    nn    = n;
    n     = m;
    m     = nn;
  end
  n1 = n*m;
  
  if( n0 < n1 )
    error('vec0 ist kleiner vec1, siehe Hilfe vec_find_di_offset');
  end
  
  dn = n0 - n1/2;
  
  for i = 0:dn
    i10 = 1;
    i11 = n1;
    i00 = 1+i;
    i01 = n1+i;
    d = (n1+i)-n0;
    if( d > 0 )
      i01 = n0;
      i11 = n1-d;
    end
      
    delta = yvec0(i00:i01)-yvec1(i10:i11);
    e     = sqrt(delta' * delta);
    if( i == 0 )
      di  = i;
      Err = e;
    else
      if( e < Err )
        di = i;
        Err = e;
      end
    end
  end
  
  
  
end
