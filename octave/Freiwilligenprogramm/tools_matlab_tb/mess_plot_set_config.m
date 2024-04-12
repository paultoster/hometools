function config_plot_names = lat_plot_set_config(config_names,auswahl_liste)
%
% config_plot_names = lat_plot_set_config(config_names,auswahl_liste)
%
% Macht eine Gui um eine Auswahl zu treffen (Check-Boxen)
%
% config_names       cell array    Liste mit möglichen Auswahl in strings
%                                  z.B. {'AW1','AW2','AW3'}
% auswahl_liste      cell array    Liste mit einer Vorazuswahl
%                                  z.B. {'AW1'} oder {}
%
% config_plot_names  cell array    Liste mit der Auswahl
%
  config_val = lat_plot_set_config_set_val(config_names,auswahl_liste);
  
  % Abfrage nach welchen Plots
  config_index_liste = check_box('Plots??',config_names,config_val); 

  % ausgewählte Plots in output schreiben
  n = length(config_index_liste);
  config_plot_names = cell(1,n);
  for i=1:n
    config_plot_names{i} = config_names{config_index_liste(i)};
  end
end
function config_val = lat_plot_set_config_set_val(config_name,auswahl_liste)


  n = length(config_name);
  config_val = cell(1,n);
  for i=1:n, config_val{i} = 0;end
  for i=1:length(auswahl_liste)
     ifound = cell_find_f(config_name,auswahl_liste{i},'f');
     if( ~isempty(ifound) )
       config_val{ifound(1)} = 1;
%      else
%        error('lat_plot_set_config_set_val: Name: <%s> konnte in Liste nicht gefunde´n werden',auswahl_liste{i});
     end
  end   
end