function [ x,y,phi,b ] = LongLatToPos( Latitude,lat_typ,Longitude,long_typ,Heading,htyp,start_lat,start_long,headfac,headoffset)
%
% [ x,y,phi,b ] = LongLatToPos( Latitude,lat_typ,Longitude,long_typ)
% [ x,y,phi,b ] = LongLatToPos( Latitude,lat_typ,Longitude,long_typ,Heading,htyp)
% [ x,y,phi,b ] = LongLatToPos( Latitude,lat_typ,Longitude,long_typ,Heading,htyp,start_lat,start_long)
% [ x,y,phi,b ] = LongLatToPos( Latitude,lat_typ,Longitude,long_typ,Heading,htyp,start_lat,start_long,headfac,headoffset)
%
% Berechnung über sphärische Winkel und Polarkoordnaten
% zum Vergleich mit einfacher Berechnung
%
% typ = 'deg' => fac = 2*pi/360
% typ = 'min' => fac = 2*pi/360/60
%
% hytp        => Einheit Heading
%
% start_lat     Latitudecoordinate zur Skalierung (rad) (default [] =>
%                  Basisstation suchen )
% start_long    Longitudecoordinate zur Skalierung (rad)(default [] =>
%                  Basisstation suchen )
%
% headfac,headoffset   phi = headoffset - Heading * headfac
%
% Heading und htyp können weggelassen werden
%
% x [m]     => -Longitude des Messpuktes
% y [m]     => Latiude des Messpunktes
% phi [rad] => Richtungswinkel im x-y-Plot
% b         => Basiswerte
%
% b.deg2rad            Umrechnung
% b.re                 Radius Erde
% b.radprometer 
% b.typ                'rad'/'deg'
% b.LatBasisStation    Ursprung
% b.LongBasisStation   Ursprung
% b.BasisStation       Name

  if( ~exist('start_lat','var') )
    start_lat = [];
  end
  if( ~exist('start_long','var') )
    start_long = [];
  end
  if( ~exist('headfac','var') )
    headfac = 1.;
  end
  if( ~exist('headoffset','var') )
    headoffset = 0.;
  end
  phi = [];
  
  switch(long_typ)
    case 'deg'
      fac = pi/180;
    case '°'
      fac = pi/180;
    case {'min','Minutes'}
      fac = pi/180/60;
    case 'rad'
      fac = 1.0;
    otherwise
      error('typ = %s nicht bekannt',typ);
  end
  Longitude = Longitude * fac;
  if( ~isempty(start_long)  )
    start_long = start_long * fac;
  end
  switch(lat_typ)
    case 'deg'
      fac = pi/180;
    case '°'
      fac = pi/180;
    case {'min','Minutes'}
      fac = pi/180/60;
    case 'rad'
      fac = 1.0;
    otherwise
      error('typ = %s nicht bekannt',typ);
  end
  Latitude  = Latitude * fac;
  if( ~isempty(start_lat)  )
    start_lat = start_lat * fac;
  end
  
  % Umrechnung, da ursprünglich Longitude mit VBox negativ ist
  % waum auch immer
  if( mean(Longitude) < 0.0 )
    Longitude = Longitude * (-1.);
  end
  if( ~isempty(start_long)  )
    if( mean(start_long) < 0.0 )
      start_long = start_long * (-1.);
    end
  end
  

  b = GPSbasisdaten(Latitude,Longitude, 'rad',start_lat,start_long);
  
  
  [x,y] = LongLatToPos2_XY(Longitude,Latitude,b);

  % Basisstationspunkt als Koordinatenurspung
  [x0,y0] = LongLatToPos2_XY(b.LongBasisStation,b.LatBasisStation,b);
  x = x - x0(1);
  y = y - y0(1);
  
  if( exist('Heading','var') )

    if( ~exist('htyp','var')  )
      htyp = 'deg';
    end
    switch(htyp)
      case {'deg','Degrees','°'}
        fac = pi/180;
      case {'min','Minutes'}
        fac = pi/180/60;
      case 'rad'
        fac = 1;
      otherwise
        error('htyp = %s nicht bekannt',htyp);
    end    
    phi = (Heading * fac)*headfac + headoffset;
    
  end
  
end
function   [x,y] = LongLatToPos2_XY(Longitude,Latitude,b)

  lamb0 = b.Long0;
  beta0 = b.Lat0;

  [nLat,mLat]   = size(Latitude);
  [nLong,mLong] = size(Longitude);

  n = min(nLat,nLong);
  m = min(mLat,mLong);

  x = zeros(n,m);
  y = zeros(n,m);
  

  alpha_old = 0.;
  for j = 1:m
    for i = 1:n
      
%       if( i == 1930 )
%         a = 0;
%       end
      lamb1 = Longitude(i,j);
      beta1 = Latitude(i,j);
      
      % Bogenmaß Ursprung zu Messpunkt
      [thet01] = LongLatToPos2_Bogenmass(lamb0,beta0,lamb1,beta1);

      % Bogenmaß Ursprung zu Messpunkt entlang x-Achse (gleicher
      % Breitengrad)
      [thet02] = LongLatToPos2_Bogenmass(lamb0,beta0,lamb1,beta0);

      % Bogenmaß Messpunkt auf x-Achse zu Messpunkt
      [thet21] = LongLatToPos2_Bogenmass(lamb1,beta0,lamb1,beta1);
      
      
      % Radius Polarkoordinate
      D01 = b.re * thet01;
      
      % Winkel Polarkoordinate (sphärischer Winkel)
%       s = (thet01+thet02+thet21)/2.;
      if( (abs(thet01) > eps) && (abs(thet02) > eps) )
%         alpha = sin(s-thet01)*sin(s-thet02);
%         alpha = alpha / sin(s) / sin(s-thet21);
%         alpha = atan(alpha)*2.;
       
        alpha = cos(thet21)-cos(thet01)*cos(thet02);
        alpha = alpha / sin(thet01) / sin(thet02);
        alpha = acos(alpha);
      else
        alpha = alpha_old;
      end
      alpha_old = alpha;
      % Richtung nach Quadrant
      %-----------------------
%       if( (lamb1 >= lamb0) && (beta1 >= beta0) ) 
%         alpha = alpha;
%       else
      if( (lamb1 < lamb0) && (beta1 >= beta0) )
        alpha = pi-alpha;
      elseif( (lamb1 < lamb0) && (beta1 < beta0) ) 
        alpha = pi+alpha;
      elseif( (lamb1 >= lamb0) && (beta1 < beta0) ) 
        alpha = 2*pi-alpha;
      end        
      x(i,j) = real(D01 * cos(alpha));
      y(i,j) = real(D01 * sin(alpha));
    end
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