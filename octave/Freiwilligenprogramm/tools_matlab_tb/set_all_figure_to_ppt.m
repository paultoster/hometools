function set_all_figure_to_ppt
%
% Sucht alle Plots und ändert sofern Linien enthalten sind
% mit set_figure_to_ppt() auf PowerPoint Ansicht (alles etwas fetter und
% größer)

h_exist = get_fig_numbers;

for i=1:length(h_exist)
   
    figure(h_exist(i));
    
    lineobj = findobj(gca,'type', 'line');
    
    if( length(lineobj) > 0 )
    
        set_figure_to_ppt(h_exist(i))
    end
end
