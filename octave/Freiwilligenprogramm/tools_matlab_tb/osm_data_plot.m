function fig_num = osm_data_plot(way,tag_keyword_liste)
%
% fig_num = osm_data_plot(S,index_liste_way,tag_keyword_liste)
% 
% S                 strut       osm-Daten
% index_liste_way   vec         Liste mit index die zu Plotten sind
% tag_keyword_liste cellarray   Liste mit keywoertern zu plotten
  set_plot_standards
  nway = length(way);
  ntag = length(tag_keyword_liste);
  


  fig_num = figure;
  hold on
  for i = 1:nway
        
    ifarbe = mod(i-1,PlotStandards.nFarbe)+1;
    plot(way(i).Longitude,way(i).Latitude,'Color',PlotStandards.Farbe{ifarbe})

    % Tags
    itags = 0.;
    for j=1:ntag
      for k=1:length(way(i).tag)
        if( strcmp(tag_keyword_liste{j},way(i).tag{k}{1}) )
          t = way(i).tag{k}{2};
          ii = round(way(i).n/2.);
          text(way(i).Longitude(ii),way(i).Latitude(ii),t)
        end
      end
    end
      
  end
  hold off
  grid on 

end
