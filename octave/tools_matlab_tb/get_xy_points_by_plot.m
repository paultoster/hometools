function  [x,y,ncount,okay] = get_xy_points_by_plot(varargin)
%
% [x,y,n,okay] = get_xy_points_by_plot('xvec',cxvec,'yvec',cyvec,...)
%
% 'xvec',cxvec              cellarray of x-vectors
%                           or vector only
% 'yvec',cyvec              cellarray of y-vectors
%                           or vector only
% 'legend',clegend          cellarray with legend text to x-y-vector
% 'xlimit',[xmin,xmax]      x-limitation inbetween value has to be
% 'ylimit',[ymin,ymax]      y-limitation inbetween value has to be
% 'text',text               text to give Anweisung
% 'npoints',n               how-many points (default 1)
% 'showstart',1/0           show by marker start
% 'fit_to'                  fit to curve cxvec{fit_to},cyvec{fit_to}
%                           by searching index
% 'print_for_m_file',1/0    makes a print to screen for copy
%
%
% x                         x-Values
% y                         y-Values
% n                         n-Values
% okay                      1/0
%
  set_plot_standards
  x = [];
  y = [];
  okay = 0;
  
  cxvec     = {};
  cyvec     = {};
  clegend   = {};
  xlimit    = [];
  ylimit    = [];
  tt        = '';
  npoints   = 1;
  showstart = 0;
  fit_to    = 0;
  print_for_m_file = 0;
  i = 1;
  while( i+1 <= length(varargin) )

      switch lower(varargin{i})
          case {'xvec'}
            cxvec = varargin{i+1};
          case {'yvec'}
            cyvec = varargin{i+1};
          case {'legend'}
            clegend = varargin{i+1};
          case {'xlimit'}
            xlimit = varargin{i+1};
          case {'ylimit'}
            ylimit = varargin{i+1};
          case 'text'
            tt = varargin{i+1};
          case 'npoints'
            npoints = varargin{i+1};
          case 'showstart'
            showstart = varargin{i+1};
          case 'fit_to'
            fit_to = varargin{i+1};
          case 'print_for_m_file'
            print_for_m_file = varargin{i+1};
          otherwise
            error('%s: Attribut <%s> nicht in der Liste vorhanden',mfilename,varargin{i});
      end
      i = i+2;
  end
  
  if( isnumeric(cxvec) )
    cxvec = {cxvec};
  end
  if( isnumeric(cyvec) )
    cyvec = {cyvec};
  end
  if( ischar(clegend) )
    clegend = {clegend};
  end
  if( ~isnumeric(xlimit) )
    error('%f_error: xlimit is not numeric',mfilename);
  end
  if( ~isnumeric(ylimit) )
    error('%f_error: ylimit is not numeric',mfilename);
  end
  if( ~ischar(tt) )
    tt = '';
  end

  
  npoints = max(1,npoints);
  
  if( isempty(tt) )
    tt = sprintf('npoints = %i anklicken',npoints);
  end
  
  n = min(length(cxvec),length(cyvec));

  if( fit_to > n ) fit_to = n; end
  
  iplot = p_figure(-1,1);
  
  for i=1:n
    hold on
    plot(cxvec{i},cyvec{i},'Color',PlotStandards.Farbe{i},'LineWidth',2)
    
    if( showstart )
      plot(cxvec{i}(1),cyvec{i}(1),'Marker','d','Color',PlotStandards.Farbe{i})
    end
    hold off
  end
  title(tt);
  grid on
  if( ~isempty(xlimit) )
    xlim(xlimit);
  end
  if( ~isempty(ylimit) )
    ylim(ylimit);
  end
  if( ~isempty(clegend) )
    legend(clegend,'Location','NorthOutside')
  end
  if( ~isempty(tt) )
    fprintf('%s \n',tt);
  end
  
  hold on
  
  ncount = 0;
  while(ncount < npoints)
    [x0,y0,but] = ginput(1);
    if( but == 1 )
      ncount = ncount + 1;
      if( ~isempty(xlimit) )
        if( x0 < xlimit(1) )
          x0 = xlimit(1);
        end
        if( length(xlimit) > 1 )
          if( x0 > xlimit(2) )
            x0 = xlimit(2);
          end
        end 
      end
      if( fit_to > 0 )
        index=such_index(cxvec{fit_to},x0);
        x(ncount) = cxvec{fit_to}(index);
      else
        x(ncount) = x0;  
      end
      if( ~isempty(ylimit) )
        if( y0 < ylimit(1) )
          y0 = ylimit(1);
        end
        if( length(ylimit) > 1 )
          if( y0 > ylimit(2) )
            y0 = ylimit(2);
          end
        end 
      end
      plot(x0,y0,'m+')
      if( fit_to > 0 )
        y(ncount) = cyvec{fit_to}(index);
      else
        y(ncount) = y0;  
      end  
      
      for i=1:n
        index=such_index(cxvec{i},x0);
        % plot(time0,ee.(cfields{i}).vec(index),'go','era','back')
        plot(cxvec{i}(index),cyvec{i}(index),'go')
      end
    end
    okay = 1;
  end  
  
  x = x';
  y = y';
  hold off
  close(iplot);
  
  if( print_for_m_file )
    
    cvecname = {'xvec','yvec'};
    cvec = {x,y};
    for j=1:2    
      fprintf('%s = [ ...\n',cvecname{j});
      for i=1:length(x)
        if( i == 1 )
          tt = ' ';
        else
          tt = ';';
        end
        fprintf('       %s %f ...\n',tt,cvec{j}(i));
      end
      fprintf('       ];\n');
    end
  end
