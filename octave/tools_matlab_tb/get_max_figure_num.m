function fignum = get_max_figure_num
%
% fignum = get_max_figure_num
%
% get biggest number of figures
%
fignum = max(get_fig_numbers);
if( isempty(fignum) )
  fignum = 0;
end