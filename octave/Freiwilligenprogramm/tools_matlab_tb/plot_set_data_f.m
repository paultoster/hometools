function s_fig = plot_set_data_f(s_fig,iplot,idata,varargin)
% s_fig = plot_f_set_data_fig_f(s_fig,1  ...
% ,'x_vec',          vecx ...
% ,'y_vec',          vecy ...
% ,'n_start',        1 ...     
% ,'n_end',          -1 ...
% ,'x_factor',       1 ...
% ,'x_offset',       0 ...
% ,'y_factor',       1 ...
% ,'y_offset',       0 ...
% ,'line_type'       '-' ...   % 'none','-',':','--','.-'
% ,'line_size',      1 ...
% ,'line_color',     [0,0,1] ...
% ,'marker_type',    'none' ...  % 'none','+','o','*','.','x','s','d','^','v','>','<','p'
% ,'marker_size',    10 ...
% ,'legend',         'Kraft'...
% ,'bot_title',      'Messung A' ...
% ,'unit',           'm' ...
% );
% Optional
% ,'bot_title_set',  0 ...
% ,'ndim',           1 ...  % 1,2

set_plot_standards

x_vec       = '';
y_vec       = '';
n_start     = 1;
n_end       = -1;
x_factor    = 1;
x_offset    = 0;
y_factor    = 1;
y_offset    = 0;
line_type   = '-';
line_size   = 1;
line_color  = PlotStandards.Ltype{idata};
marker_type = 'none';
marker_size = 10;
marker_n    = 30;
legend      = 0;
unit        = 0;
bot_title   = 0;

bot_title_set = '';
ndim          = '';

i = 1;
while( i+1 <= length(varargin) )

    switch lower(varargin{i})
        case 'x_vec'
            x_vec = varargin{i+1};
        case 'y_vec'
            y_vec = varargin{i+1};
        case 'n_start'
            n_start = varargin{i+1};
        case 'n_end'
            n_end = varargin{i+1};
        case 'x_factor'
            x_factor = varargin{i+1};
        case 'x_offset'
            x_offset = varargin{i+1};
        case 'y_factor'
            y_factor = varargin{i+1};
        case 'y_offset'
            y_offset = varargin{i+1};
        case 'line_type'
            line_type = varargin{i+1};
        case 'line_size'
            line_size = varargin{i+1};
        case 'line_color'
            line_color = varargin{i+1};
        case 'marker_type'
            marker_type = varargin{i+1};
        case 'marker_size'
            marker_size = varargin{i+1};
        case 'marker_n'
            marker_n = varargin{i+1};
        case 'legend'
            legend = varargin{i+1};
        case 'unit'
            unit = varargin{i+1};
        case 'bot_title'
            bot_title = varargin{i+1};
        case 'bot_title_set'
            bot_title_set = varargin{i+1};
        case 'ndim'
            ndim = varargin{i+1};
        otherwise
            tdum = sprintf('%s: Attribut <%s> nicht okay',mfilename,varargin{i});
            error(tdum)

    end
    i = i+2;
end

if( ~isstruct(s_fig) )
  error('s_fig muss eine Struktur von plot_set_fig_f sein');
end
if( ~isstruct(s_fig.s_plot(iplot)) )
  error('s_fig.s_plot(%i) muss eine Struktur von plot_set_plot_f sein',iplot);
end

% vektoren
if( islogical(y_vec) ) 
  s_fig.s_plot(iplot).s_data(idata).y_vec = double(y_vec);
  s_fig.s_plot(iplot).s_data(idata).ndim  = 1;
elseif( isnumeric(y_vec) ) 
  s_fig.s_plot(iplot).s_data(idata).y_vec = y_vec;
  s_fig.s_plot(iplot).s_data(idata).ndim  = 1;
else
  error('y_vec muss angegeben werden');
end
if( isnumeric(x_vec) ) 
  s_fig.s_plot(iplot).s_data(idata).x_vec = x_vec;
  s_fig.s_plot(iplot).s_data(idata).ndim  = s_fig.s_plot(iplot).s_data(idata).ndim + 1;
end

s_fig.s_plot(iplot).s_data(idata).n_start  = n_start;
s_fig.s_plot(iplot).s_data(idata).n_end    = n_end;
s_fig.s_plot(iplot).s_data(idata).x_factor = x_factor;
s_fig.s_plot(iplot).s_data(idata).x_offset = x_offset;
s_fig.s_plot(iplot).s_data(idata).y_factor = y_factor;
s_fig.s_plot(iplot).s_data(idata).y_offset = y_offset;
s_fig.s_plot(iplot).s_data(idata).line_type   = line_type;
s_fig.s_plot(iplot).s_data(idata).line_size   = line_size;
s_fig.s_plot(iplot).s_data(idata).line_color  = line_color;
s_fig.s_plot(iplot).s_data(idata).marker_type = marker_type;
s_fig.s_plot(iplot).s_data(idata).marker_size = marker_size;
s_fig.s_plot(iplot).s_data(idata).marker_n    = marker_n;

if( ischar(legend) )
  s_fig.s_plot(iplot).s_data(idata).legend = legend;
else
  s_fig.s_plot(iplot).s_data(idata).legend = sprintf('data%i',idata);
end

if( ischar(unit) )
  unit=str_cut_a_f(unit,'[');
  unit=str_cut_e_f(unit,']');
  s_fig.s_plot(iplot).s_data(idata).legend = sprintf('%s[%s]' ...
      ,s_fig.s_plot(iplot).s_data(idata).legend ...
      ,unit);
end

if( ischar(bot_title) )
  s_fig.s_plot(iplot).s_data(idata).bot_title     = bot_title;
  s_fig.s_plot(iplot).s_data(idata).bot_title_set = 1;
else
  s_fig.s_plot(iplot).s_data(idata).bot_title_set = 0;
end

% Optional
if( isnumeric(bot_title_set) )
  s_fig.s_plot(iplot).s_data(idata).bot_title_set = bot_title_set;
end
if( isnumeric(ndim) )
  s_fig.s_plot(iplot).s_data(idata).ndim = ndim;
end

s_fig.s_plot(iplot).data_set      = 1;