function figure_set_line_legend(line_obj,type)
%
% plot_figure_set_line_legend(line_obj,type)
%
% set line_obj in legend on or off
%
% line_obj      line object h = line('XData',xvec,'YData',yvec)
% type          'on' or 'off'  (if not 'on' than 'off'
%
% 
  if( ~exist('type','var') )
    type = 'on';
  end
  if( ~strcmpi(type,'on') )
    type = 'off';
  end
  okay = figure_proof_if_line(line_obj);
  
  if( okay )
    hAnnotation = get(line_obj,'Annotation');
    hLegendEntry = get(hAnnotation','LegendInformation');
    set(hLegendEntry,'IconDisplayStyle',type)
  end