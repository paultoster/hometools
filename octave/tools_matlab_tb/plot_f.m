function [hfigure,okay,haxis] = plot_f(s_fig)
%=================================================================
% Plotroutinen
% Input
% s_fig.fig_num                         > 0  number of figure
%                                       <= 0 new figure
% s_fig.short_name_set                  = 1  set short name
%                                       = 0  not set (default)
% s_fig.shot_name                       Name for figure
% s_fig.dina4                           = 0  no formatation (default)
%                                       = 1  dina4 portrait
%                                       = 2  dina4 landscape
% s_fig.rows                            how many subplot rows (overrules s_fig.s_plot(i).position)
% s_fig.cols                            how many subplot cols (overrules
% s_fig.set_zaf                         wenn 1 setzt zaf-funktion (zoom all figures)
%                                       wenn 2 setzt zaf-Funktion ( mit
%                                       Anzeige im Command Fenster bei
%                                       erstellen)
% s_fig.set_scm                         wenn 1 setzt scm-funktion (scroll measurement)
%                                       wenn 2 setzt zaf-Funktion ( mit
%                                       Anzeige im Command Fenster bei
%                                       erstellen)
% s_fig.s_plot(i).position              [left,bottom,width,heitgh] in
%                                       proportion (0 ... 1.0)
% s_fig.s_plot(i).grid_set              plot grid
% s_fig.s_plot(i).legend_set            plot legend
% s_fig.s_plot(i).bot_title_set         plot bottom title
% s_fig.s_plot(i).bot_title{j}          title for each set at bottom
%                                       (former s_plot.s_data(i).bot_title   title for each data at bottom (e.g. file))
% s_fig.s_plot(i).title_set             plot title on top
% s_fig.s_plot(i).title                 title on top
% s_fig.s_plot(i).x_label_set           plot x-lable 
% s_fig.s_plot(i).x_label               x-lable
% s_fig.s_plot(i).y_label_set           plot y-lable 
% s_fig.s_plot(i).y_label               y-lable
% s_fig.s_plot(i).xlim_set              = 0,1 x-axis limitation
% s_fig.s_plot(i).xmin                  x-axis xmin if(xlim_set)
% s_fig.s_plot(i).xmax                  x-axis xmax if(xlim_set)
% s_fig.s_plot(i).ylim_set              = 0,1 y-axis limitation
% s_fig.s_plot(i).ymin                  y-axis ymin if(ylim_set)
% s_fig.s_plot(i).ymax                  y-axis ymax if(ylim_set)
% s_fig.s_plot(i).data_set              =1 if plot data shown in diagram
% s_fig.s_plot(i).s_data(i).ndim          =1 only y-Vecotr
%                                       =2 xy-Vecotr
% s_fig.s_plot(i).s_data(i).n_start       startindex
% s_fig.s_plot(i).s_data(i).n_end         endindex
% s_fig.s_plot(i).s_data(i).x_factor      x-factor (x*factor-offset)
% s_fig.s_plot(i).s_data(i).x_offset      x-offset 
% s_fig.s_plot(i).s_data(i).y_factor      y-factor (y*factor-offset)
% s_fig.s_plot(i).s_data(i).y_offset      y-offset 
% s_fig.s_plot(i).s_data(i).x_vec         x-vecotor
% s_fig.s_plot(i).s_data(i).y_vec         y-vecotor
% s_fig.s_plot(i).s_data(i).line_type     'none','-',':','--','.-'
% s_fig.s_plot(i).s_data(i).line_size     0.5,1,...
% s_fig.s_plot(i).s_data(i).line_color    [a b c]  ([0 0 0])
% s_fig.s_plot(i).s_data(i).marker_type   'none','+','o','*','.','x','s','d','^','v','>','<','p'
% s_fig.s_plot(i).s_data(i).marker_size   0.5,1, ...
% s_fig.s_plot(i).s_data(i).marker_n      -1 ... % Wieviele Marker zeichnen (-1: jeden Wert mit Marker zeichnen, default: 30 Marker verteilt)
% s_fig.s_plot(i).s_data(i).legend        legend_name
% s_fig.s_plot(i).s_data(i).bot_title_set plot bottom title
% s_fig.s_plot(i).s_data(i).bot_title     bottom text
%
% Beispiel::
% 	clear s_fig s_data
% 	fig_num = fig_num+1;
% 	set_plot_standards
% 	
% 	len = length(s_data);
% 	for i=1:len
%         name_d = 'pos_throttle';
%         if( ~isfield(s_data(1).d,name_d) )
%             dum = sprintf('error: tb_plot_laengs Variable s_data(%i).d.%s nicht vorhanden',i,'pos_throttle');
%             error(dum);
%         end
% 	end
% 	
% 	s_fig.fig_num            = fig_num;
% 	s_fig.short_name_set     = 1;
% 	s_fig.short_name          = 'laengs';
% 	s_fig.dina4              = 1; 
% 	s_fig.rows               = 3;
% 	s_fig.cols               = 1;
% 	
% 	s_fig.s_plot(1).grid_set           = 1;
% 	s_fig.s_plot(1).legend_set         = 1;
% 	s_fig.s_plot(1).bot_title_set      = 0;
% 	for i=1:len
%         s_fig.s_plot(1).bot_title{i}       = s_data(i).h{2};
% 	end
% 	s_fig.s_plot(1).title_set          = 0;
% 	s_fig.s_plot(1).title              = 0;
% 	s_fig.s_plot(1).x_label_set        = 1;
% 	s_fig.s_plot(1).x_label            = 'time [s]';
% 	s_fig.s_plot(1).y_label_set        = 1;
% 	s_fig.s_plot(1).y_label            = ['pos_throttle ',s_data(1).u.pos_throttle];
% 	s_fig.s_plot(1).xlim_set           = 0;
% 	s_fig.s_plot(1).xmin               = 0;
% 	s_fig.s_plot(1).xmax               = 0;
% 	s_fig.s_plot(1).ylim_set           = 1;
% 	s_fig.s_plot(1).ymin               = 0;
% 	s_fig.s_plot(1).ymax               = 1;
% 	s_fig.s_plot(1).data_set           = 1;
% 	
% 	for i=1:len
% 		s_data(i).ndim         = 2; 
% 		s_data(i).n_start      = 1;
% 		s_data(i).n_end        = -1;
% 		s_data(i).x_factor     = 1.0;
% 		s_data(i).x_offset     = 0.0;
% 		s_data(i).y_factor     = 1.0;
% 		s_data(i).y_offset     = 0.0;
% 		s_data(i).x_vec        = s_data(i).d.pos_throttle;
% 		s_data(i).y_vec        = s_data(i).d.pos_throttle;
% 		s_data(i).line_type    = PlotStandards.Ltype{1};                     % 'none','-',':','--','.-'
% 		s_data(i).line_size    = 2;
% 		s_data(i).line_color   = PlotStandards.Farbe{i};          % [a b c]  ([0 0 0])
% 		s_data(i).marker_type  = 'none';                  % 'none','+','o','*','.','x','s','d','^','v','>','<','p'
% 		s_data(i).marker_size  = 1;                       % 0.5,1, ...
% 		s_data(i).legend       = s_data(i).h{2};
% 	end
% 	
% 	s_fig.s_plot(1).s_data  = s_data;
% 	
% 	clear s_data
% 	
% 	plot_f(s_fig);

set_plot_standards
okay = 1;
hfigure = 0;
haxis   = [];
if( ~strcmp(class(s_fig),'struct') )
    fprintf('??? plot_f_error: input is not a structure\n');
    fprintf('??? plot_f_error: input is %s-class',char(class(s_plot)));
end

%------------------------------------------------------------------
% fig_num
if( ~isfield(s_fig,'fig_num') )
    s_fig.fig_num = -1;
end
%------------------------------------------------------------------
% short_name
% short_name_set
if( ~isfield(s_fig,'short_name') ...
  || ~(  ischar(s_fig.short_name) ...
      || iscell(s_fig.short_name) ...
      ) ...
  )
    s_fig.short_name_set = 0;
    
elseif( ~isfield(s_fig,'short_name_set') ...
      && ~isempty(s_fig.short_name) ...
      && (~isempty(s_fig.short_name)) ...
      )
    s_plot.short_name_set = 1;
end
%------------------------------------------------------------------
%  dina4
if( ~isfield(s_fig,'dina4') && ~isempty(s_fig.dina4))
    s_fig.dina4 = 0;
end
%------------------------------------------------------------------
% subplot_rows
% subplot_cols
% subplot_fig_num
if( ~isfield(s_fig,'rows') || isempty(s_fig.rows) )
    s_fig.rows = 1;
    s_fig.set_rows = 0;
else
    s_fig.set_rows = 1;
end
if( ~isfield(s_fig,'cols') || isempty(s_fig.cols) )
    s_fig.cols = 1;
    s_fig.set_cols = 0;
else
    s_fig.set_cols = 1;
end
% if( ~isfield(s_plot,'subplot_fig_num') )
%     s_plot.subplot_fig_num = 1;
%     s_plot.subplot_cols = 1;
%     s_plot.subplot_rows = 1;
% end

% if( s_plot.subplot_fig_num > (s_plot.subplot_cols*s_plot.subplot_rows) )
%     s_plot.subplot_fig_num = (s_plot.subplot_cols*s_plot.subplot_rows);
% end
%------------------------------------------------------------------
% set_zaf
if( ~isfield(s_fig,'set_zaf') )
    s_fig.set_zaf = 0;
end
%------------------------------------------------------------------
% set_scm
if( ~isfield(s_fig,'set_scm') )
    s_fig.set_scm = 0;
end
%-------------------------------------------------------------------
% position (proof)
flag = 0;
for i=1:length(s_fig.s_plot)
    if( isfield(s_fig.s_plot(i),'position') ...
      && ~isempty(s_fig.s_plot(i).position) ...
      && isnumeric(s_fig.s_plot(i).position) ...
      && length(s_fig.s_plot(i).position) >= 4 ...
      )
        s_fig.s_plot(i).position_set = 1;
        flag = 1;
    else
        s_fig.s_plot(i).position_set = 0;
    end
end
% ausschalte, wenn rows oder cols gesetzt
if( s_fig.set_rows || s_fig.set_cols )
    flag = 0;
    for i=1:length(s_fig.s_plot)
        s_fig.s_plot(i).position_set = 0;
    end
end
if( flag )
    s_fig.postion_set = 1;
    for i=1:length(s_fig.s_plot)
        if( s_fig.s_plot(i).position_set == 0 )
            error('plot_f_error: s_plot(%i).position is not set or not correct set',i);
        end
    end 
else
   s_fig.postion_set = 0;
end
%len_plot = min(s_fig.cols*s_fig.rows,length(s_fig.s_plot));
len_plot = length(s_fig.s_plot);

% set rows when rows are not set explicitly
if( (len_plot > 1) && ~s_fig.set_rows && ~s_fig.set_cols && ~s_fig.postion_set )

  s_fig.set_rows = 1;
  s_fig.rows     = len_plot;
  s_fig.set_cols = 1;
  s_fig.cols     = 1;
end
haxis = zeros(len_plot,1);
for iplot=1:len_plot
    s_plot = s_fig.s_plot(iplot);
    %------------------------------------------------------------------
    % position
    if( s_fig.postion_set )
        s_plot.position = s_plot.position(1:4);
    end

	%------------------------------------------------------------------
	% grid_set
	if( ~isfield(s_plot,'grid_set') || isempty(s_plot.grid_set) )
        s_plot.grid_set = 0;
	end
	%------------------------------------------------------------------
	% xlim_set
	if( ~isfield(s_plot,'xlim_set') ...
    || ~isfield(s_plot,'xmin') ...
    || ~isfield(s_plot,'xmax') ...
    || isempty(s_plot.xlim_set) ...
    || isempty(s_plot.xmin) ...
    || isempty(s_plot.xmax) ...
    )
        s_plot.xlim_set = 0;
	end
	if( (s_plot.xlim_set ) ...
    && (s_plot.xmin > s_plot.xmax) ...
    )
        dum         = s_plot.xmin;
        s_plot.xmin = s_plot.xmax;
        s_plot.xmax = dum;
	end
	%------------------------------------------------------------------
	% ylim_set
	if( ~isfield(s_plot,'ylim_set') ...
    || ~isfield(s_plot,'ymin') ...
    || ~isfield(s_plot,'ymax') ...
    || isempty(s_plot.ylim_set) ...
    || isempty(s_plot.ymin) ...
    || isempty(s_plot.ymax) ...
    )
        s_plot.ylim_set = 0;
	end
	if( (s_plot.ylim_set ) ...
    && (s_plot.ymin > s_plot.ymax) ...
    )
        dum         = s_plot.ymin;
        s_plot.ymin = s_plot.ymax;
        s_plot.ymax = dum;
	end
	%------------------------------------------------------------------
	% data_set
	% data
	% n_data
	% s_data(i).n_dim
	% s_data(i).x_vec
	% s_data(i).y_vec
	if( ~isfield(s_plot,'s_data') || isempty(s_plot.s_data) )
        s_plot.data_set = 0;
	end
	if( ~isfield(s_plot,'data_set') || isempty(s_plot.data_set) )
        s_plot.data_set = 0;
	end
	if( s_plot.data_set )
        s_plot.data_set = 1;
        s_plot.n_data = length(s_plot.s_data);
        c_mdim = {};
        c_ndim = {};
        for i=1:s_plot.n_data
            
            if( isempty(s_plot.s_data(i).x_vec) )
                error('plot_f_error: x_vec is empty');
            elseif( isempty(s_plot.s_data(i).y_vec) )
                error('plot_f_error: y_vec is empty');
            end            
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''n_dim'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag )
                command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''x_vec'');', ...
                                  i);
                eval(char(command));
                if( dum_flag )
                    c_ndim{i} = 1;
                else
                    c_ndim{i} = 0;
                end
                command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''y_vec'');', ...
                                  i);
                eval(char(command));
                if( dum_flag )
                    c_ndim{i} = c_ndim{i} + 1;
                else 
                    fprintf('??? pltmen_plot_function_error: No data s_data(%i).y_vec or x_vec found\n',i);
                    okay = 0;
                    return;
                end
            else
                if( s_plot.s_data(i).n_dim == 2 )
                    command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''x_vec'');', ...
                                     i);
                    eval(char(command));
                    if( ~dum_flag )
                        fprintf('??? pltmen_plot_function_error: No data s_data(%i).x_vec found\n',i);
                        okay = 0;
                        return
                    end
                    c_ndim{i} = 0;
                else
                    c_ndim{i} = 1;
                end
                command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''y_vec'');', ...
                                     i);
                eval(char(command));
                if( ~dum_flag ) 
                    fprintf('??? pltmen_plot_function_error: No data s_data(%i).y_vec found\n',i);
                    okay = 0;
                    return;
                end
                c_ndim{i} = c_ndim{i} + 1;
                
            end
            [ny,my] = size(s_plot.s_data(i).y_vec);
            if( my > ny )
                s_plot.s_data(i).y_vec = s_plot.s_data(i).y_vec';
                dum = ny;ny=my;my=dum;
            end
            if( c_ndim{i} == 2 )
                [nx,mx] = size(s_plot.s_data(i).x_vec);
                if( mx > nx )
                    s_plot.s_data(i).x_vec = s_plot.s_data(i).x_vec';
                    dum = nx;nx=mx;mx=dum;
                end
            else
                mx = my;
                nx = ny;
                for j=1:mx
                    s_plot.s_data(i).x_vec(:,j)= [1:1:ny]';
                end
            end
            if( mx < my )
                c_mdim{i} = mx;
            else
                    c_mdim{i}  = my;
            end
        end
	end
	%------------------------------------------------------------------
	% s_data(i).n_start
	% s_data(i).n_end
	if( s_plot.data_set )
        for i=1:s_plot.n_data
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''n_start'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).n_start) || (s_plot.s_data(i).n_start < 1) )
                s_plot.s_data(i).n_start = 1;
            end
            n_min = length(s_plot.s_data(i).y_vec(:,1));
            for j=1:c_mdim{i}
                if( c_ndim{i} == 2 )
                    n_min = min(n_min,length(s_plot.s_data(i).x_vec(:,j)));
                end
                n_min = min(n_min,length(s_plot.s_data(i).y_vec(:,j)));
            end
            if( s_plot.s_data(i).n_start > n_min )
                s_plot.s_data(i).n_start = n_min;
            end
                
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''n_end'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).n_end) || s_plot.s_data(i).n_end < 1 )
                    s_plot.s_data(i).n_end = min(length(s_plot.s_data(i).x_vec),length(s_plot.s_data(i).y_vec));
                                   
            end
            if( s_plot.s_data(i).n_end > n_min )
                s_plot.s_data(i).n_end = n_min;
            end
            if( s_plot.s_data(i).n_end < s_plot.s_data(i).n_start )
                s_plot.s_data(i).n_end = s_plot.s_data(i).n_start;
            end
                
        end
	end
	%------------------------------------------------------------------
	% s_data(i).x_offset
	% s_data(i).y_offset
	if( s_plot.data_set )
        for i=1:s_plot.n_data
            if( c_ndim{i} == 2 )
                command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''x_offset'');', ...
                                 i);
                eval(char(command));
                if( ~dum_flag || isempty(s_plot.s_data(i).x_offset) )
                    s_plot.s_data(i).x_offset = 0;
                end
            end
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''y_offset'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).y_offset) )
                s_plot.s_data(i).y_offset = 0;
            end        
        end    
	end
	%------------------------------------------------------------------
	% s_data(i).x_factor
	% s_data(i).y_factor
	if( s_plot.data_set )
        for i=1:s_plot.n_data
            if( c_ndim{i} == 2 )
                command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''x_factor'');', ...
                                 i);
                eval(char(command));
                if( ~dum_flag || isempty(s_plot.s_data(i).x_factor) )
                    s_plot.s_data(i).x_factor = 1.0;
                end
            end
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''y_factor'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).y_factor) )
                s_plot.s_data(i).y_factor = 1.0;
            end        
        end    
	end
	%------------------------------------------------------------------
	% s_data(i).line_type
	% s_data(i).line_size
	% s_data(i).line_color
	% s_data(i).marker_type
	% s_data(i).marker_size
  % s_data(i).marker_n
	if( s_plot.data_set )
        for i=1:s_plot.n_data
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''line_type'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).line_type) )
                s_plot.s_data(i).line_type = PlotStandards.Ltype{i};
            end        
	
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''line_size'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).line_size) )
                s_plot.s_data(i).line_size = PlotStandards.Lsize1;
            end        
	
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''line_color'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).line_color) )
                s_plot.s_data(i).line_color = PlotStandards.Mfarbe{i};
            end
            if( iscell(s_plot.s_data(i).line_color) )
                s_plot.s_data(i).line_color = s_plot.s_data(i).line_color{1};
            end
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''marker_type'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).marker_type) )
                s_plot.s_data(i).marker_type = PlotStandards.Mtype0;
            end        
	
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''marker_size'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).marker_size) )
                s_plot.s_data(i).marker_size = PlotStandards.Msize1;
            end        
            command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''marker_n'');', ...
                              i);
            eval(char(command));
            if( ~dum_flag || isempty(s_plot.s_data(i).marker_n) )
                s_plot.s_data(i).marker_n = 30;
            else
              if( s_plot.s_data(i).marker_n < 0 )
                s_plot.s_data(i).marker_n = s_plot.s_data(i).n_end - s_plot.s_data(i).n_start + 1;
              end
            end        
        end    
  end
	%------------------------------------------------------------------
	% legend_set
	% s_data(i).legend
	% c_legend{}
	if( s_plot.data_set )
        if( isfield(s_plot,'legend_set') ...
          && s_plot.legend_set ...
          )
            c_legend={}; 
            for i=1:s_plot.n_data
                command = sprintf('dum_flag = isfield(s_plot.s_data(%i),''legend'');', ...
                              i);
                eval(char(command));
                if( ~dum_flag || isempty(s_plot.s_data(i).legend) )
                    s_plot.s_data(i).legend = sprintf('curve %i',i);
                end
                c_legend{i} = ersetze_char(s_plot.s_data(i).legend,'_',' ');
                c_legend{i} = ersetze_char(c_legend{i},'\','/'); 
            end
        else
            s_plot.legend_set = 0;
        end
	end
	%------------------------------------------------------------------
	% s_data(i).bot_title_set
	% s_data(i).bot_title
  % bot_tile aus dem Grafen
  c_bot_title={};
	if( s_plot.data_set )
    for i=1:s_plot.n_data
      if( isfield( s_plot.s_data(i),'bot_title_set') && s_plot.s_data(i).bot_title_set )
        c_bot_title{length(c_bot_title)+1} = s_data(i).bot_title;
      end
    end 
  end
	%------------------------------------------------------------------
	% s_plot.bot_title_set
	% s_plot.bot_title
	% bot_title aus plot
	if(  isfield(s_plot,'bot_title_set') ...
    && ~isempty(s_plot.bot_title_set) ...
    && s_plot.bot_title_set ...
    )            
        if( isfield(s_plot,'bot_title') && ~isempty(s_plot.bot_title) )
                
            for i=1:length(s_plot.bot_title)
                a                                  = ersetze_char(s_plot.bot_title{i},'_',' ');
                c_bot_title{length(c_bot_title)+1} = ersetze_char(a,'\','/');
            end
        end
  end
  for i = 1:length(c_bot_title)
      c_bot_title{i} = ersetze_char(c_bot_title{i},'_',' ');
      c_bot_title{i} = ersetze_char(c_bot_title{i},'\','/');
  end
	%------------------------------------------------------------------
	% title_set
	% title
	if(  isfield(s_plot,'title_set') ...
    && ~isempty(s_plot.title_set) ...
    && s_plot.title_set ...
    )
        if( ~isfield(s_plot,'title') )
           sprintf('??? pltmen_plot_function_error: No data title found\n',i);
           okay = 0;
           return;
       else
           s_plot.title = ersetze_char(s_plot.title,'_',' ');
           s_plot.title = ersetze_char(s_plot.title,'\','/'); 
	
        end
            
        if(isempty(s_plot.title))
            s_plot.title_set = 0;
        end
        if( ~(  iscell(s_plot.title) ...
             || ischar(s_plot.title) ...
             ) ...
          )
           sprintf('??? pltmen_plot_function_error: title is not char or cell class\n',i);
           okay = 0;
           return;
        end
	end
	if( ~isfield(s_plot,'title_set') )
        if(  isfield(s_plot,'title') ...
          && ~isempty(s_plot.title) ...
          && (~isempty(s_plot.title)) ...
          && ( iscell(s_plot.title) ...
             || ischar(s_plot.title) ...
             ) ...
          )
            s_plot.title_set = 1;
        else
            s_plot.title_set = 0;
        end
	end
	%------------------------------------------------------------------
	% x_label_set
	% x_label
	if(  isfield(s_plot,'x_label_set') ...
    && ~isempty(s_plot.x_label_set) ...
    && s_plot.x_label_set ...
    )
        if( ~isfield(s_plot,'x_label') &&  ~isempty(s_plot.x_label) )
           dum = sprintf('??? pltmen_plot_function_error: No data x_label found\n',i);
           okay = 0;
           s_plot.x_label = dum;
           fprintf(dum);
           
       else
           s_plot.x_label = ersetze_char(s_plot.x_label,'_',' ');
           s_plot.x_label = ersetze_char(s_plot.x_label,'\','/'); 
           
        end
            
        if(isempty(s_plot.x_label))
            s_plot.x_label_set = 0;
        end
        if( ~(  iscell(s_plot.x_label) ...
             || ischar(s_plot.x_label) ...
             ) ...
          )
           dum = sprintf('??? pltmen_plot_function_error: x_label is not char or cell class\n',i);
           okay = 0;
           s_plot.x_label = dum;
           fprintf(dum);
        end
	end
	if( ~isfield(s_plot,'x_label_set') )
        if(  isfield(s_plot,'x_label') ...
          && ~isempty(s_plot.x_label) ...
          && (~isempty(s_plot.x_label)) ...
          && ( iscell(s_plot.x_label) ...
             || ischar(s_plot.x_label) ...
             ) ...
          )
            s_plot.x_label_set = 1;
        else
            s_plot.x_label_set = 0;
        end
	end
	%------------------------------------------------------------------
	% y_label_set
	% y_label
	if(  isfield(s_plot,'y_label_set') ...
    && ~isempty(s_plot.y_label_set) ...
    && s_plot.y_label_set ...
    )
        if( ~isfield(s_plot,'y_label') )
           dum = sprintf('??? pltmen_plot_function_error: No data y_label found\n',i);
           okay = 0;
           s_plot.y_label = dum;
           fprintf(dum);
       else
           s_plot.y_label = ersetze_char(s_plot.y_label,'_',' ');
           s_plot.y_label = ersetze_char(s_plot.y_label,'\','/'); 
           
        end
            
        if(isempty(s_plot.y_label))
            s_plot.y_label_set = 0;
        end
        if( ~(  iscell(s_plot.y_label) ...
             || ischar(s_plot.y_label) ...
             ) ...
          )
           dum = sprintf('??? pltmen_plot_function_error: y_label is not char or cell class\n',i);
           okay = 0;
           s_plot.y_label = dum;
           fprintf(dum);
           
        end
	end
	if( ~isfield(s_plot,'y_label_set') )
        if(   isfield(s_plot,'y_label') ...
          && ~isempty(s_plot.y_label) ...
          && (~isempty(s_plot.y_label)) ...
          && ( iscell(s_plot.y_label) ...
             || ischar(s_plot.y_label) ...
             ) ...
          )
            s_plot.y_label_set = 1;
        else
            s_plot.y_label_set = 0;
        end
	end
	
	%==================================================================
	%------------------------------------------------------------------
	if( s_fig.short_name_set )
		hfigure = p_figure(s_fig.fig_num,s_fig.dina4,s_fig.short_name);
	else
		hfigure = p_figure(s_fig.fig_num,s_fig.dina4,s_fig.short_name);
  end
  s_fig.fig_num = hfigure;
	%------------------------------------------------------------------
  if( s_fig.postion_set )
      axes('position',s_plot.position);
  else
      subplot(s_fig.rows,s_fig.cols,iplot);
  end
	%------------------------------------------------------------------
	if( s_plot.data_set )
        hold off
        for i=1:s_plot.n_data
	
            for j=1:c_mdim{i}
                plot( ...
                s_plot.s_data(i).x_vec(s_plot.s_data(i).n_start:s_plot.s_data(i).n_end,j)*s_plot.s_data(i).x_factor ...
                -s_plot.s_data(i).x_offset ...
                ,s_plot.s_data(i).y_vec(s_plot.s_data(i).n_start:s_plot.s_data(i).n_end,j)*s_plot.s_data(i).y_factor ...
                -s_plot.s_data(i).y_offset ...
                ,'LineStyle',s_plot.s_data(i).line_type ...
                ,'LineWidth',s_plot.s_data(i).line_size ...
                ,'Color',s_plot.s_data(i).line_color ...
                )
                hold on
            end
        end
            
        for i=1:s_plot.n_data
            for j=1:c_mdim{i}
                if( ~strcmp(s_plot.s_data(i).marker_type,'none') )
                    del_n = (s_plot.s_data(i).n_end-s_plot.s_data(i).n_start+1)/s_plot.s_data(i).marker_n;
                    plot( ...
                    s_plot.s_data(i).x_vec(s_plot.s_data(i).n_start:del_n:s_plot.s_data(i).n_end,j)*s_plot.s_data(i).x_factor ...
                    -s_plot.s_data(i).x_offset ...
                    ,s_plot.s_data(i).y_vec(s_plot.s_data(i).n_start:del_n:s_plot.s_data(i).n_end,j)*s_plot.s_data(i).y_factor ...
                    -s_plot.s_data(i).y_offset ...
                    ,'LineStyle','none' ...
                    ,'Color',s_plot.s_data(i).line_color ...
                    ,'Marker',s_plot.s_data(i).marker_type ...
                    ,'MarkerSize',s_plot.s_data(i).marker_size ...
                    )
                end
            end
       end
       hold off
       haxis(iplot) = gca;
  
	end    
	%------------------------------------------------------------------
	if( s_plot.grid_set )
        grid on
	else
        grid off
	end
	%------------------------------------------------------------------
	if( s_plot.xlim_set )
        xlim([s_plot.xmin s_plot.xmax]);
	end
	%------------------------------------------------------------------
	if( s_plot.ylim_set )
        ylim([s_plot.ymin s_plot.ymax]);
	end
	%------------------------------------------------------------------
	if( s_plot.x_label_set )
        xlabel(s_plot.x_label);
	end
	%------------------------------------------------------------------
	if( s_plot.y_label_set )
        ylabel(s_plot.y_label);
	end
	%------------------------------------------------------------------
	if( s_plot.title_set )
        title(s_plot.title);
	end
	%------------------------------------------------------------------
	if( s_plot.legend_set && isfield(s_plot,'n_data') && ~isempty(s_plot.n_data) )
        for i=1:s_plot.n_data
             if( ~strcmp(s_plot.s_data(i).marker_type,'none') )
                c_legend{i} = ['(',s_plot.s_data(i).marker_type,')',c_legend{i}];
             end
        end
        legend(c_legend);
	end
	%------------------------------------------------------------------
	if( ~isempty(c_bot_title) )
        for i=1:length(c_bot_title)
            if( i < 4 )
                x_text = -1.5;
                y_text = -0.75-0.25*(i-1);
            else
                x_text = 7;
                y_text = -0.75-0.25*(i-4);
            end
            text('String',              c_bot_title{i} ...
                ,'HorizontalAlignment', 'left' ...
                ,'VerticalAlignment',   'bottom' ...
                ,'Rotation',            0 ...
                ,'Units',               'centimeters' ...
                ,'Position',            [x_text,y_text] ...
                ,'Fontsize',            8 ...
                );
        end
    end
    if( s_fig.set_zaf == 2 )
        zaf('setact')
    elseif( s_fig.set_zaf == 1 )
      zaf('setact_silent')
    end
    if( s_fig.set_scm == 2 )
        scm('setact')
    elseif( s_fig.set_scm == 1 )
      scm('setact_silent')
    end
end % for iplot=1:len
