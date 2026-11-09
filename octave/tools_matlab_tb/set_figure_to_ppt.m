function set_figure_to_ppt(n_fig)
%
% Ändert Aussehen des  Plots n_fig oder des aktuellen Plots
% auf PowerPoint Ansicht (alles etwas fetter und
% größer)

if( nargin == 0 )
    n_fig = 0;
end

if( n_fig > 0 )
    
    figure(n_fig)
end

axesobj = get(n_fig,'Children');
for i=1:length(axesobj)
    
    actobj = axesobj(i);

    lineobj = findobj(actobj,'type', 'line');
    set(lineobj, 'linewidth', 2.0);

    %
    % Title
    %
    factor = 1.2;
    set(get(actobj,'Title'),'FontSize',get(get(actobj,'Title'),'FontSize')*factor)
    set(get(actobj,'XLabel'),'FontSize',get(get(actobj,'Title'),'FontSize')*factor)
    set(get(actobj,'YLabel'),'FontSize',get(get(actobj,'Title'),'FontSize')*factor)
    set(get(actobj,'ZLabel'),'FontSize',get(get(actobj,'Title'),'FontSize')*factor)

    textobj = findobj(actobj,'type', 'text');
    for i=1:length(textobj)
        set(textobj(i),'FontSize',get(textobj(i),'Fontsize')*factor)    
    end
end
