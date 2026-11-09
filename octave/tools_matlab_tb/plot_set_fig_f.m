function s_fig = plot_set_fig_f(s_fig,varargin)
% s_fig = plot_f_set_fig(s_fig  ...
% ,'fig_num',         1 ...
% ,'short_name',      's2' ...
% ,'dina4',           2 ...
% ,'set_zaf',         1 ...
% ,'rows',            6 ...
% ,'cols',            1 ...
% );


fig_num    = 0;
short_name = '';
dina4      = 0;
set_zaf    = 0;
rows       = 0;
cols       = 0;
i = 1;
while( i+1 <= length(varargin) )

    switch lower(varargin{i})
        case 'fig_num'
            fig_num = varargin{i+1};
        case 'short_name'
            short_name = varargin{i+1};
        case 'set_zaf'
            set_zaf = varargin{i+1};
        case 'dina4'
            dina4 = varargin{i+1};
        case 'rows'
            rows = varargin{i+1};
        case 'cols'
            cols = varargin{i+1};
        otherwise
            tdum = sprintf('%s: Attribut <%s> nicht okay',mfilename,varargin{i});
            error(tdum)

    end
    i = i+2;
end

if( ~isstruct(s_fig) )
  s_fig = struct;
end
s_fig.fig_num    = fig_num;
s_fig.short_name = short_name;
if( ~isempty(s_fig.short_name) )
  s_fig.short_name_set = 1;
else
  s_fig.short_name_set = 0;
end
s_fig.set_zaf    = set_zaf;
s_fig.dina4      = dina4;
s_fig.rows       = rows;
s_fig.cols       = cols;

