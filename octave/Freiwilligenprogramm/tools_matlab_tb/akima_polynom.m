function p = akima_polynom(xvec,yvec,index)
%
% p = akima_polynom(xvec,yvec,index)
%
% berechnet polynom an dem index nach akima 3. Ordnung
%
%  dx = (x-xvec(index))/(xvec(index+1)-xvec(index))
%  y = p[1]+dx*(p[2]+dx*(p[3]+p[4]*dx)
%  y = p[1]+p[2]*dx+p[3]*dx^2+p[4]*dx^3
% 
  if( ~is_monoton_steigend(xvec) )
    error('akima_polynom: xvec ist nicht monoton steigend')
  end
  
  n = length(xvec);
  
  dxvec = diff(xvec);
  dxvec(length(dxvec)+1) = dxvec(length(dxvec));

  p = zeros(4,1);
  
  % Steigung zq bestimmen
  zq = zeros(5,1);
  if( index < 3 )
    for k=1:5
      i = 6-k;
      j = i+index-3;
      if( j >= 1 )
        zq(i) = (yvec(j+1)-yvec(j)) / dxvec(j);
      else
        zq(i) = 2.0*zq(i+1)+zq(i+2);
      end
    end
  else
    for i=1:5
      j = i+index-3;
      if( j < n )
        zq(i) = (yvec(j+1)-yvec(j)) / dxvec(j);
      else
        zq(i) = 2.0*zq(i-1)+zq(i-2);
      end
    end
  end

  % gewichtete Steigung
  w0  = abs(zq(4)-zq(3));
  w1  = abs(zq(2)-zq(1));
  zp0 = w0*zq(2)+w1*zq(3);
  zp0 = zp0/not_zero(w0 + w1);

  w0  = abs(zq(5)-zq(4));
  w1  = abs(zq(3)-zq(2));
  zp1 = w0*zq(3)+w1*zq(4);
  zp1 = zp1 / not_zero(w0 + w1);
  
  % Polynom
  p(1) = yvec(index);
  p(2) = zp0;
  if( index < n )
    dy = yvec(index+1)-yvec(index);
  else
    dy = yvec(index)-yvec(index-1);
  end
  p(3) = 3.0*dy/dxvec(index) - (zp1+2.0*zp0)/dxvec(index);
  p(4) = ((zp1+zp0)-2.0*dy/dxvec(index))/dxvec(index)/dxvec(index);
  
end