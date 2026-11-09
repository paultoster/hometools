function [index_liste,way] = osm_data_get_tagged_way(S,tag)
%
% Sucht in S-Structur in S.way(i) nach den passenden tags
% Gibt indexliste von S.way aus und die gesammelten Koordinaten
% way(indexliste(i)).Longitude
% way(indexliste(i)).Latitude
% way(indexliste(i)).id
% way(indexliste(i)).tag
% z.B.
% tag = {{'keyword1','value'},{'keyword2',''}}
% Es wird das tag-keywort 'keyword1' mit den Wert 'value'
% und alle tags mit keywort 'keyword2'
%

  index_liste = [];
  nway = length(S.way);
  
  n = length(tag);
  if( n == 0 )
    all_flag = 1;
  else
    all_flag = 0;
    for i=1:n
      if( ~iscell(tag{i}) || length(tag{i}) < 2 )
        error('tag muß eine doppelte celltsruktur sein z.B. tag = {{''keyword1'',''value''},{''keyword2'',''''}}')
      end
    end
  end
  
  for iway = 1:nway
    
    if( all_flag )
      index_liste = [index_liste,iway];
    else
    
      ntag = length(S.way(iway).tag);
      flag = 0;
      for j=1:ntag
        
        for k=1:n
          
          if(  strcmp(S.way(iway).tag{j}{1},tag{k}{1}) ...
            && ( isempty(tag{k}{2}) ...
               || strcmp(S.way(iway).tag{j}{2},tag{k}{2}) ...
               ) ...
            )
            index_liste = [index_liste,iway];
            flag = 1;
            break
          end
        end
        if( flag )
          break
        end
      end
    end
  end
  
  nind = length(index_liste);
  way = struct('id',cell(1,nind),'tag',cell(1,nind),'Longitude',cell(1,nind),'Latitude',cell(1,nind));

  for i = 1:nind
    
    index = index_liste(i);
    [Longitude,Latitude] = osm_data_LatLong(S.node,S.way(index).ref);
    
    way(i).id        = S.way(index).id;
    way(i).tag       = S.way(index).tag;
    way(i).Longitude = Longitude;
    way(i).Latitude  = Latitude;
    way(i).n         = length(Longitude);
  end
end