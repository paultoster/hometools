function [ x,y,phi,b ] = LongLatToPos3( Latitude,Longitude, typ , Heading , htyp)
% Berechnung wie Telematic
% zum Vergleich mit einfacher Berechnung
%
% x => Longitude des Messpuktes
% y => -Latiude des Messpunktes
% x0,y0  ist die Basisstation
%
% typ = 'deg' => fac = 2*pi/360
% typ = 'min' => fac = 2*pi/360/60
  phi = [];

  if( ~exist('typ','var')  )
    typ = 'deg';
  end

  b = GPSbasisdaten(Latitude,Longitude, typ);
  
  % Basisstationspunkt als Koordinatenurspung
  fac = pi/180/60;     % Faktor von min -> rad
  lamb0 = (-1.0) * b.LongBasisStation * fac;
  beta0 = b.LatBasisStation * fac;
  

  [nLat,mLat]   = size(Latitude);
  [nLong,mLong] = size(Longitude);

  n = min(nLat,nLong);
  m = min(mLat,mLong);

  x = zeros(n,m);
  y = zeros(n,m);
  
  switch(typ)
    case 'deg'
      fac = pi/180;
    case {'min','Minutes'}
      fac = pi/180/60;
    otherwise
      error('typ = %s nicht bekannt',typ);
  end

  c = sqrt(2.0*(1.0-cos(pi/180)));
  for j = 1:m
    for i = 1:n
      lamb1 = (-1) * fac * Longitude(i,j);
      beta1 = fac * Latitude(i,j);
      
      dy = (beta1-beta0)*b.re;
      
      d  = cos(beta0)*b.re*c;
      theta = acos(1-((d/b.re)^2)/2.);
      D     = theta*b.re;
      dx    = (lamb1-lamb0)*180/pi*D;
      
      x(i,j) = dx;
      y(i,j) = dy;
    end
  end
  
  if( exist('Heading','var') )

    if( ~exist('htyp','var')  )
      htyp = 'deg';
    end
    switch(htyp)
      case {'deg','Degrees'}
        fac = pi/180;
      case 'min'
        fac = pi/180/60;
      case 'rad'
        fac = 1;
      otherwise
        error('htyp = %s nicht bekannt',htyp);
    end
    
    phi = Heading * fac;
  end
  
end
function [theta] = LongLatToPos2_Bogenmass(lamb1,beta1,lamb2,beta2)

slamb1 = sin(lamb1);
clamb1 = cos(lamb1);
sbeta1 = sin(beta1);
cbeta1 = cos(beta1);
slamb2 = sin(lamb2);
clamb2 = cos(lamb2);
sbeta2 = sin(beta2);
cbeta2 = cos(beta2);

a = (cbeta2 * clamb2 - cbeta1 * clamb1);
b = (cbeta2 * slamb2 - cbeta1 * slamb1);
c = (sbeta2          - sbeta1);

theta = acos(1.0-0.5*(a*a+b*b+c*c));

end