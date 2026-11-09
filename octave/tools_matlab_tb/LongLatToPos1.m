function [ x,y,phi,b ] = LongLatToPos1( Latitude,Longitude, typ , Heading , htyp)
% Umrechnung Bogemmaß in Meter mit Urspung in Basisstation
% Koordinaten Basisstation in GPSbasisdaten
%
% x => Longitude des Messpuktes
% y => -Latiude des Messpunktes
% x0,y0  ist die Basisstation
% x = -re * fac * Longitude * cos(fac * Latitude) - x0;
% y = re * fac * Latitude - y0;
%
% typ = 'deg' => fac = 2*pi/360
% typ = 'min' => fac = 2*pi/360/60
  phi = [];

  if( ~exist('typ','var')  )
    typ = 'deg';
  end

  b = GPSbasisdaten(Latitude,Longitude, typ);
  
  % Basisstationspunkt als Koordinatenurspung
  fac = pi/180/60;     % Faktor von min -> deg
  x0  = (-1) * b.re * fac * b.LongBasisStation * cos(fac * b.LatBasisStation);
  y0  = b.re * fac * b.LatBasisStation;


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

  for j = 1:m
    for i = 1:n       
      y(i,j) = b.re * fac * Latitude(i,j) - y0;
      x(i,j) = (-1) * b.re * fac * Longitude(i,j) * cos(fac * Latitude(i,j)) - x0;
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