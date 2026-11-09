function b = GPSbasisdaten(Lat,Long,typ,start_lat,start_long)
% basisdaten
% start_lat     Latitudecoordinate zur Skalierung (rad) (default [] =>
%                  Basisstation suchen )
% start_long    Longitudecoordinate zur Skalierung (rad)(default [] =>
%                  Basisstation suchen )
% b.deg2rad            Umrechnung
% b.re                 Radius Erde
% b.radprometer 
% b.typ                'rad'/'deg'
% b.LatBasisStation    Ursprung
% b.LongBasisStation   Ursprung
% b.BasisStation       Name
% b.Lat0               Berechnungsursprung 1000 m verschoebn
% b.Long0
%
  if( ~exist('start_lat','var') )
    start_lat = [];
  end
  if( ~exist('start_long','var') )
    start_long = [];
  end
  lat0  = [(49*60 + 51.3828)/60.*pi/180. ...
          ,(49*60 + 51.33423)/60.*pi/180. ...
          ,(49*60 + 51.3345)/60.*pi/180. ...
          ,(2.940459976759315e+003)/60.*pi/180. ...
          ,(3008.2186)/60.*pi/180. ...
          ,(2893.52)/60.*pi/180. ...
          ,(49*60+51.22823)/60.*pi/180. ...
          ,53.034560 * pi/180 ...
          ,48.7889582631321230 * pi/180 ...
          ]  ;
  long0 = [(7*60 + 37.3975)/60.*pi/180. ...
          ,(7*60 + 36.50023)/60.*pi/180. ...
          ,(7*60 + 36.4146)/60.*pi/180. ...
          ,(7.290021657424406e+002)/60.*pi/180. ...
          ,(515.5655)/60.*pi/180. ...
          ,(705.612)/60.*pi/180. ...
          ,(8*60+35.05613)/60.*pi/180. ...
          , 7.514925 * pi/180. ...
          , 9.2262647334364711 * pi/180. ...
          ] ;

  name0 = {'Pferdsfeld(Baustelle)' ...
          ,'Pferdsfeld2(Linien)' ...
          ,'Pferdsfeld West' ...
          ,'RegensburgTeststrecke' ...
          ,'FfmTeststrecke' ...
          ,'Mittelwert Aschheim' ...
          ,'Griesheim Flagplatz Kurve30' ...
          ,'Papenburg Buero' ...
          ,'Stuttgart Daimler Vordere Ecke Windkanal' ...
          };



  switch(typ)
    case 'deg'
      Lat  = Lat*pi/180.;
      Long = Long*pi/180.;
    case {'min','Minutes'}
      Lat  = Lat/60.*pi/180.;
      Long = Long/60.*pi/180.;
    case 'rad'
      %Lat  = Lat;
      %Long = Long;
    otherwise
      error('typ = %s nicht bekannt',typ);
  end


delta  = sqrt((lat0-Lat(1)).^2 + (long0-Long(1)).^2);

[dmin,imin] = min(delta);

b = [];
b.deg2rad     = pi/180.;          % [rad/deg]
b.re          = 6371.315*1000;    % [m]
b.radprometer = 1./b.re;          % [rad/m]
b.typ         = 'rad';
if( ~isempty(start_lat) && ~isempty(start_long) )
  
  b.LatBasisStation  = start_lat;     % [rad]
  b.LongBasisStation = start_long;    % [rad]
  b.BasisStation     = 'Vorgabe';
elseif( dmin > b.radprometer*1000 )
  
  b.LatBasisStation  = Lat(1);     % [rad]
  b.LongBasisStation = Long(1);    % [rad]
  b.BasisStation     = 'Messstart';
else

  b.LatBasisStation  = lat0(imin);     % [rad]
  b.LongBasisStation = long0(imin);    % [rad]
  b.BasisStation     = name0{imin};
end

% Berechnungsursprung
phi0    = 1000./b.re;
b.Lat0  = min(Lat)-phi0;
phi0    = 1000/(cos(b.LatBasisStation)*b.re);
b.Long0 = min(Long)-phi0;


