function [Longitude,Latitude,okay] = osm_data_LatLong(node,ref)
  okay      = 1;
  n         = length(ref);
  Latitude  = zeros(n,1);
  Longitude = zeros(n,1);
  for i=1:n

    index = osm_data_plot_find_node(node,ref(i));
    if( index )
      Longitude(i) = node(index).Longitude;
      Latitude(i) = node(index).Latitude;
    else
      warning('In S.node konnte ref(%i) = %i nicht gefunden werden',i,ref(i));
    end
  end
end
function index = osm_data_plot_find_node(node,id)
  index = 0;
  n = length(node);
  for i=1:n
    
    if( node(i).id == id )
      index = i;
      return
    end
  end
end