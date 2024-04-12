function haxis = figure_get_all_axis(hfig)
%
% haxis = figure_get_all_axis(hfig)
%
  haxis = [];
  childs = get(hfig,'children');
  for ch=1:size(childs,1)
    if ((strcmp( get(childs(ch),'type'),'axes') == 1) && (strcmp(get(childs(ch),'Tag'), 'legend') == 0))
        haxis(length(haxis)+1) = childs(ch);
    end
  end
  
%   axesHandles = get(fig, 'Children');
%   axesHandles = figure_get_all_axis(h);
%   classHandles = handle(axesHandles);
%   count = length(axesHandles);
%   isNotInstanceOfSubtype = false(1, count);
%   for i = 1:count
%     isNotInstanceOfSubtype(i) = strcmp(class(classHandles(i)), 'axes') == 1;
%   end
%   axesHandles = axesHandles(isNotInstanceOfSubtype);

end