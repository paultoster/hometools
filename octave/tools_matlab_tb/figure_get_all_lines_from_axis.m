function hlines = figure_get_all_lines_from_axis(haxis)
%
% hlines = figure_get_all_lines_from_axis(haxis)
% hlines = figure_get_all_lines_from_axis(gca) % get current axis
%
  hlines = [];
  childs = get(haxis,'children');
  for ch=1:size(childs,1)
    if ((strcmp( get(childs(ch),'type'),'line') == 1) )
        hlines(length(hlines)+1) = childs(ch);
    end
  end
  hlines = hlines';
  
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