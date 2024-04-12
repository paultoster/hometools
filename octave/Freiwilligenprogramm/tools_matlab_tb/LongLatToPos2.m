function [ x,y,phi,b ] = LongLatToPos2( Latitude,Longitude, typ , Heading , htyp)
% Berechnung über sphärische Winkel und Polarkoordnaten
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

  b = GPSbasisdaten( Latitude,Longitude, typ);
  
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

  for j = 1:m
    for i = 1:n
      lamb1 = (-1) * fac * Longitude(i,j);
      beta1 = fac * Latitude(i,j);
      
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
      if( (abs(thet01) > 1e-9) && (abs(thet02) > 1e-9) )
%         alpha = sin(s-thet01)*sin(s-thet02);
%         alpha = alpha / sin(s) / sin(s-thet21);
%         alpha = atan(alpha)*2.;
       
        alpha = cos(thet21)-cos(thet01)*cos(thet02);
        alpha = alpha / sin(thet01) / sin(thet02);
        alpha = acos(alpha);
      else
        alpha = 0.0;
      end
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
      x(i,j) = D01 * cos(alpha);
      y(i,j) = D01 * sin(alpha);
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