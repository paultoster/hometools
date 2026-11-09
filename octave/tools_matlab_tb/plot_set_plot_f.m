function s_fig = plot_set_plot_f(s_fig,iplot,varargin)
% s_fig = plot_f_set_plot_f(s_fig,1  ...
% ,'position',        [0.1,0.5,0.8,0.2] ...     %[left,bottom,width,heitgh]
% ,'grid_set',        1 ...
% ,'legend_set',      0 ...
% ,'title',           'Test' ...
% ,'x_label',         'Time [s]' ...
% ,'y_label',         'y [m]' ...
% ,'xmin',            0 ...
% ,'xmax',            1 ...
% ,'ymin',            -2 ...
% ,'ymax',            2 ...
% );
% opitional auch:
% ,'title_set',       1 ....
% ,'x_label_set',       1 ....
% ,'y_label_set',       1 ....
% ,'xlim_set',          1 ....
% ,'ylim_set',          1 ....
% ,'data_set',          1 ....
% ,'bot_title_set'      0 ....
% ,'bot_title'          {'',''}


position    = 0;
title       = '';
grid_set    = 0;
legend_set  = 0;
x_label     = 0;
y_label     = 1;
xmin        = '';
xmax        = '';
ymin        = '';
ymax        = '';
title_set   = '';
x_label_set = '';
y_label_set = '';
xlim_set    = '';
ylim_set    = '';
data_set    = '';
bot_title_set = '';
bot_title     = {};
i = 1;
while( i+1 <= length(varargin) )

    switch lower(varargin{i})
        case 'position'
            position = varargin{i+1};
        case 'title'
            title = varargin{i+1};
        case 'grid_set'
            grid_set = varargin{i+1};
        case 'legend_set'
            legend_set = varargin{i+1};
        case 'x_label'
            x_label = varargin{i+1};
        case 'y_label'
            y_label = varargin{i+1};
        case 'xmin'
            xmin = varargin{i+1};
        case 'xmax'
            xmax = varargin{i+1};
        case 'ymin'
            ymin = varargin{i+1};
        case 'ymax'
            ymax = varargin{i+1};
        case 'title_set'
            title_set = varargin{i+1};
        case 'x_label_set'
            x_label_set = varargin{i+1};
        case 'y_label_set'
            y_label_set = varargin{i+1};
        case 'xlim_set'
            xlim_set = varargin{i+1};
        case 'ylim_set'
            ylim_set = varargin{i+1};
        case 'data_set'
            data_set = varargin{i+1};
        case 'bot_title_set'
            bot_title_set = varargin{i+1};
        case 'bot_title'
            bot_title = varargin{i+1};
        otherwise
            tdum = sprintf('%s: Attribut <%s> nicht okay',mfilename,varargin{i});
            error(tdum)

    end
    i = i+2;
end

if( ~isstruct(s_fig) )
  error('s_fig muss eine Struktur von plot_set_fig_f sein');
end

if( length(position) == 4 ) 
  s_fig.s_plot(iplot).position = position;
  s_fig.rows                   = [];
  s_fig.cols                   = [];
else
  if( s_fig.cols == 0 )
    s_fig.cols = 1;
  end
  while( s_fig.rows*s_fig.cols < iplot )
    s_fig.rows = s_fig.rows+1;
  end
end

s_fig.s_plot(iplot).title      = title;
if( ~isempty(title) )
  s_fig.s_plot(iplot).title_set = 1;
end
s_fig.s_plot(iplot).grid_set   = grid_set;
s_fig.s_plot(iplot).legend_set = legend_set;

if( ischar(x_label) )
  s_fig.s_plot(iplot).x_label     = x_label;
  s_fig.s_plot(iplot).x_label_set = 1;
end

if( ischar(y_label) )
  s_fig.s_plot(iplot).y_label     = y_label;
  s_fig.s_plot(iplot).y_label_set = 1;
end

if( isnumeric(xmin) && isnumeric(xmax) )
  s_fig.s_plot(iplot).xmin     = xmin;
  s_fig.s_plot(iplot).xmax     = xmax;
  s_fig.s_plot(iplot).xlim_set = 1;
end
if( isnumeric(ymin) && isnumeric(ymax) )
  s_fig.s_plot(iplot).ymin     = ymin;
  s_fig.s_plot(iplot).ymax     = ymax;
  s_fig.s_plot(iplot).ylim_set = 1;
end

s_fig.s_plot(iplot).data_set = 0;

% Optional:

if( isnumeric(title_set) )
  s_fig.s_plot(iplot).title_set = title_set;
end
if( isnumeric(x_label_set) )
  s_fig.s_plot(iplot).x_label_set = x_label_set;
end
if( isnumeric(y_label_set) )
  s_fig.s_plot(iplot).y_label_set = y_label_set;
end
if( isnumeric(xlim_set) )
  s_fig.s_plot(iplot).xlim_set = xlim_set;
end
if( isnumeric(ylim_set) )
  s_fig.s_plot(iplot).ylim_set = ylim_set;
end
if( isnumeric(data_set) )
  s_fig.s_plot(iplot).data_set = data_set;
end
if( isnumeric(bot_title_set) && ~isempty(bot_title) )
  s_fig.s_plot(iplot).bot_title_set = bot_title_set;
  s_fig.s_plot(iplot).bot_title     = bot_title;
end



