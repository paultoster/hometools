function okay = plot_bottom_date(textvar,fig_num)
%
% okay = plot_bottom_date(textvar[,fig_num])
% 
% Plottet einen Text klein mit vorangestelltem Datum unten rein
% z.B. plot_bottom(mfilename)
% Output:
% okay == 1 ist okay
%

if( ~exist('fig_num','var') )
    fig_num = gcf;
end
okay = plot_bottom([datestr(now),':',textvar],fig_num);
