function [Longitude,Latitude] = osm_data_find_path(way,long0,lat0,longN,latN,radius)

  n = length(way);
  
  filt_index_liste = ones(n,1);
  
  Longitude = [];
  Latitude  = [];
  
  % Start way finden long0,lat0
  [iway0,iGeo0] = osm_data_find_path_way(way,long0,lat0,longN,latN,radius,filt_index_liste);
  
  if( iway0 ) % wenn gefunden weiter suchen
    
    % gefundene way aus Filter Index austragen
    filt_index_liste(iway0) = 0;
    
    % Startwerte übergeben
    Longitude = way(iway0).Longitude;
    Latitude  = way(iway0).Latitude;
    
    run_flag = 1;
    
    while( run_flag )
    
      % Anschlußstück am Anfang suchen
      long0 = Longitude(1);
      lat0  = Latitude(1);
    
      [iway0,iGeo0,d0] = osm_data_find_path_way(way,long0,lat0,longN,latN,radius,filt_index_liste);
    
      % Anschlußstück am Ende suchen
      long1 = Longitude(length(Longitude));
      lat1  = Latitude(length(Latitude));

      [iway1,iGeo1,d1] = osm_data_find_path_way(way,long1,lat1,longN,latN,radius,filt_index_liste);
    
      if( iway0 && d0 < d1 ) % Am Anfang weitermachen

        % Unsortieren
        Longitude = umsortieren(Longitude);
        Latitude  = umsortieren(Latitude);
        
        % gefundene way Anhängen
        [Longitude,Latitude] = osm_data_find_path_add(Longitude,Latitude,way(iway0),iGeo0);
        
        % gefundene way aus Filter Index austragen
        filt_index_liste(iway0) = 0;

      elseif( iway1 && d1 < d0 ) % Am Ende weitermachen
        
        % gefundene way Anhängen
        [Longitude,Latitude] = osm_data_find_path_add(Longitude,Latitude,way(iway1),iGeo1);
        
        % gefundene way aus Filter Index austragen
        filt_index_liste(iway1) = 0;

      else
        run_flag = 0;
      end
      
    end    
  end


end

function [iway,iGeo,d] = osm_data_find_path_way(way,long0,lat0,longN,latN,radius,filt_index_liste)

  iway = 0;
  iGeo = 0;
  d = 1e30;
  flag = 0;
  for i=1:length(way)
    
    if( filt_index_liste(i) )
    
      for j=1:way(i).n
        d0 = sqrt((way(i).Longitude(j)-long0)^2+(way(i).Latitude(j)-lat0)^2);
        if( isempty(longN) )
          d1 = 1e10;
        else
          d1 = min(sqrt((way(i).Longitude(j)-longN).^2 + (way(i).Latitude(j)-latN).^2));
        end
        if( d0 < d && d0 < radius && d1 > radius)
          iway = i;
          iGeo = j;
          d    = d0;
        end
      end
      
    end
  end
end

function [Longitude,Latitude] = osm_data_find_path_add(Longitude,Latitude,way,iway)
  
  d0 = iway-1;
  d1 = way.n-iway;
  
  if( d0 > d1 ) % Zum Anfang hin dazunehmen
    
    for i=iway:-1:1  
      Longitude = [Longitude;way.Longitude(i)];
      Latitude = [Latitude;way.Latitude(i)];
    end
  else
    for i=iway:way.n  
      Longitude = [Longitude;way.Longitude(i)];
      Latitude = [Latitude;way.Latitude(i)];
    end
  end    
end
   