function h = figure_chs(varargin)


l = length(varargin);
switch( l )
    case 0
        h = figure
    case 1
        h = figure(varargin{1});
    case 2
        h = figure(varargin{1},varargin{2});
    case 3
        h = figure(varargin{1},varargin{2},varargin{3});
    case 4
        h = figure(varargin{1},varargin{2},varargin{3},varargin{4});
    case 5
        h = figure(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5});
    case 6
        h = figure(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
    case 7
        h = figure(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7});
    case 8
        h = figure(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8});
    case 9
        h = figure(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9});
    case 10
        h = figure(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9},varargin{10});
    otherwise
        error('error_figure_chs: too many arguments > 10, please modifiy figure_chs.m')
end

hmenu = findobj(h,'label','chs');

if (isempty(hmenu)),
    uimenu(gcf,'label','chs','callback','crosshair_subplots(''init'');');
    
    % situar la figura en primer plano
    figure(h);
end,
