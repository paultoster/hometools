%=================================================================
% Plotroutinen
% Input
% s_plot.fig_num                  > 0  number of figure
%                                 <= 0 new figure
% s_plot.short_name_set           = 1  set short name
%                                 = 0  not set (default)
% s_plot.shot_name                Name for figure
% s_plot.dina4                    = 0  no formatation (default)
%                                 = 1  dina4 portrait
%                                 = 2  dina4 landscape
% s_plot.subplot_rows             how many rows
% s_plot.subplot_cols             how many cols
% s_plot.subplot_fig_num          actual figure number
% s_plot.grid_set                 plot grid
% s_plot.legend_set               plot legend
% s_plot.bot_title_set            plot bottom title
% s_plot.bot_title(i)             title for each set at bottom
%                                 (former s_plot.data(i).bot_title   title for each data at bottom (e.g. file))
% s_plot.title_set                plot title on top
% s_plot.title                    title on top
% s_plot.x_label_set              plot x-lable 
% s_plot.x_label                  x-lable
% s_plot.y_label_set              plot y-lable 
% s_plot.y_label                  y-lable
% s_plot.xlim_set                 = 0,1 x-axis limitation
% s_plot.xmin                     x-axis xmin if(xlim_set)
% s_plot.xmax                     x-axis xmax if(xlim_set)
% s_plot.ylim_set                 = 0,1 y-axis limitation
% s_plot.ymin                     y-axis ymin if(ylim_set)
% s_plot.ymax                     y-axis ymax if(ylim_set)
% s_plot.data_set            =1 if plot data shown in diagram
% s_plot.data(i).ndim        =1 only y-Vecotr
%                                 =2 xy-Vecotr
% s_plot.data(i).n_start      startindex
% s_plot.data(i).n_end        endindex
% s_plot.data(i).x_offset    x-offset (minus)
% s_plot.data(i).y_offset    y-offset (minus)
% s_plot.data(i).x_vec       x-vecotor
% s_plot.data(i).y_vec       y-vecotor
% s_plot.data(i).line_type   'none','-',':','--','.-'
% s_plot.data(i).line_size   0.5,1,...
% s_plot.data(i).line_color  [a b c]  ([0 0 0])
% s_plot.data(i).marker_type 'none','+','o','*','.','x','s','d','^','v','>','<','p'
% s_plot.data(i).marker_size 0.5,1, ...
% s_plot.data(i).legend      legend

% Beispiel::
% 	clear s_plot s_data
% 	set_standards
% 	
% 	s_plot.fig_num            = 20;
% 	s_plot.short_name_set     = 0;
% 	s_plot.shot_name          = '';
% 	s_plot.dina4              = 1; 
% 	s_plot.subplot_rows       = 3;
% 	s_plot.subplot_cols       = 1;
% 	s_plot.subplot_fig_num    = 1;
% 	s_plot.grid_set           = 1;
% 	s_plot.legend_set         = 1;
% 	s_plot.bot_title_set      = 1;
% 	s_plot.bot_title{1}       = file_name;
% 	s_plot.title_set          = 0;
% 	s_plot.title              = 0;
% 	s_plot.x_label_set        = 0;
% 	s_plot.x_label            = '';
% 	s_plot.y_label_set        = 1;
% 	s_plot.y_label            = 'torque steering wheel [Nm]';
% 	s_plot.xlim_set           = 1;
% 	s_plot.xmin               = time_start;
% 	s_plot.xmax               = time_end;
% 	s_plot.ylim_set           = 0;
% 	s_plot.ymin               = 0;
% 	s_plot.ymax               = 1;
% 	s_plot.data_set           = 1;
% 	
% 	s_data(1).ndim         = 2; 
% 	s_data(1).n_start      = 1;
% 	s_data(1).n_end        = n;
% 	s_data(1).x_offset     = 0;
% 	s_data(1).y_offset     = 0;
% 	s_data(1).x_vec        = time;
% 	s_data(1).y_vec        = DES_ST_WH_TOR*lsb_M;
% 	s_data(1).line_type    = '-';                     % 'none','-',':','--','.-'
% 	s_data(1).line_size    = 1;
% 	s_data(1).line_color   = Standards.Mrot;          % [a b c]  ([0 0 0])
% 	s_data(1).marker_type  = 'none';                  % 'none','+','o','*','.','x','s','d','^','v','>','<','p'
% 	s_data(1).marker_size  = 1;                       % 0.5,1, ...
% 	s_data(1).legend       = 'DES_ST_WH_TOR';
% 	
% 	s_data(2).ndim         = 2; 
% 	s_data(2).n_start      = 1;
% 	s_data(2).n_end        = n;
% 	s_data(2).x_offset     = 0;
% 	s_data(2).y_offset     = 0;
% 	s_data(2).x_vec        = time;
% 	s_data(2).y_vec        = EpsTorBarTor*lsb_M;
% 	s_data(2).line_type    = '-';                     % 'none','-',':','--','.-'
% 	s_data(2).line_size    = 1;
% 	s_data(2).line_color   = Standards.Mblau;          % [a b c]  ([0 0 0])
% 	s_data(2).marker_type  = 'none';                  % 'none','+','o','*','.','x','s','d','^','v','>','<','p'
% 	s_data(2).marker_size  = 1;                       % 0.5,1, ...
% 	s_data(2).legend       = 'EpsTorBarTor';
% 	
% 	s_plot.data  = s_data;
% 	
% 	pltmen_plot_function(s_plot);




function [handle,okay] = pltmen_plot_function(s_plot)

set_plot_standards
okay = 1;
if( ~strcmp(class(s_plot),'struct') )
    fprintf('??? pltmen_plot_function_error: input is not a structure\n');
    fprintf('??? pltmen_plot_function_error: input is %s-class',char(class(s_plot)));
end

%------------------------------------------------------------------
% fig_num
if( ~isfield(s_plot,'fig_num') )
    s_plot.fig_num = -1;
end
%------------------------------------------------------------------
% short_name
% short_name_set
if( ~isfield(s_plot,'short_name') ...
  | ~(strcmp(class(s_plot.short_name),'char') ...
     | strcmp(class(s_plot.short_name),'cell') ...
     ) ...
  )
    s_plot.short_name_set = 0;
    
elseif( ~isfield(s_plot,'short_name_set') ...
      & (length(short_name) > 0) ...
      )
    s_plot.short_name_set = 1;
end
%------------------------------------------------------------------
%  dina4
if( ~isfield(s_plot,'dina4') )
    s_plot.dina4 = 0;
end
%------------------------------------------------------------------
% subplot_rows
% subplot_cols
% subplot_fig_num
if( ~isfield(s_plot,'subplot_rows') )
    s_plot.subplot_rows = 1;
end
if( ~isfield(s_plot,'subplot_cols') )
    s_plot.subplot_cols = 1;
end
if( ~isfield(s_plot,'subplot_fig_num') )
    s_plot.subplot_fig_num = 1;
    s_plot.subplot_cols = 1;
    s_plot.subplot_rows = 1;
end

if( s_plot.subplot_fig_num > (s_plot.subplot_cols*s_plot.subplot_rows) )
    s_plot.subplot_fig_num = (s_plot.subplot_cols*s_plot.subplot_rows);
end
%------------------------------------------------------------------
% grid_set
if( ~isfield(s_plot,'grid_set') )
    s_plot.grid_set = 1;
end
%------------------------------------------------------------------
% xlim_set
if( ~isfield(s_plot,'xlim_set') ...
  | ~isfield(s_plot,'xmin') ...
  | ~isfield(s_plot,'xmax') ...
  )
    s_plot.xlim_set = 0;
end
if( (s_plot.xlim_set ) ...
  & (s_plot.xmin > s_plot.xmax) ...
  )
    dum         = s_plot.xmin;
    s_plot.xmin = s_plot.xmax;
    s_plot.xmax = dum;
end
%------------------------------------------------------------------
% ylim_set
if( ~isfield(s_plot,'ylim_set') ...
  | ~isfield(s_plot,'ymin') ...
  | ~isfield(s_plot,'ymax') ...
  )
    s_plot.ylim_set = 0;
end
if( (s_plot.ylim_set ) ...
  & (s_plot.ymin > s_plot.ymax) ...
  )
    dum         = s_plot.ymin;
    s_plot.ymin = s_plot.ymax;
    s_plot.ymax = dum;
end
%------------------------------------------------------------------
% data_set
% data
% n_data
% data(i).n_dim
% data(i).x_vec
% data(i).y_vec
if( ~isfield(s_plot,'data') )
    s_plot.data_set = 0;
end
if( ~isfield(s_plot,'data_set') ...
  | s_plot.data_set ...
  )
    s_plot.data_set = 1;
    s_plot.n_data = length(s_plot.data);
    c_mdim = {};
    c_ndim = {};
    for i=1:s_plot.n_data
        
        command = sprintf('dum_flag = isfield(s_plot.data(%i),''n_dim'');', ...
                          i);
        eval(char(command));
        if( ~dum_flag )
            command = sprintf('dum_flag = isfield(s_plot.data(%i),''x_vec'');', ...
                              i);
            eval(char(command));
            if( dum_flag )
                c_ndim{i} = 1;
            else
                c_ndim{i} = 0;
            end
            command = sprintf('dum_flag = isfield(s_plot.data(%i),''y_vec'');', ...
                              i);
            eval(char(command));
            if( dum_flag )
                c_ndim{i} = c_ndim{i} + 1;
            else 
                fprintf('??? pltmen_plot_function_error: No data data(%i).y_vec or x_vec found\n',i);
                okay = 0;
                return;
            end
        else
            if( s_plot.data(i).n_dim == 2 )
                command = sprintf('dum_flag = isfield(s_plot.data(%i),''x_vec'');', ...
                                 i);
                eval(char(command));
                if( ~dum_flag )
                    fprintf('??? pltmen_plot_function_error: No data data(%i).x_vec found\n',i);
                    okay = 0;
                    return
                end
                c_ndim{i} = 0;
            else
                c_ndim{i} = 1;
            end
            command = sprintf('dum_flag = isfield(s_plot.data(%i),''y_vec'');', ...
                                 i);
            eval(char(command));
            if( ~dum_flag ) 
                fprintf('??? pltmen_plot_function_error: No data data(%i).y_vec found\n',i);
                okay = 0;
                return;
            end
            c_ndim{i} = c_ndim{i} + 1;
            
        end
        [ny,my] = size(s_plot.data(i).y_vec);
        if( my > ny )
            s_plot.data(i).y_vec = s_plot.data(i).y_vec';
            dum = ny;ny=my;my=dum;
        end
        if( c_ndim{i} == 2 )
            [nx,mx] = size(s_plot.data(i).x_vec);
            if( mx > nx )
                s_plot.data(i).x_vec = s_plot.data(i).x_vec';
                dum = nx;nx=mx;mx=dum;
            end
        else
            mx = my;
            nx = ny;
            for j=1:mx
                s_plot.data(i).x_vec(:,j)= [1:1:ny]';
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
% data(i).n_start
% data(i).n_end
if( s_plot.data_set )
    for i=1:s_plot.n_data
        command = sprintf('dum_flag = isfield(s_plot.data(%i),''n_start'');', ...
                          i);
        eval(char(command));
        if( ~dum_flag | length(s_plot.data(i).n_start)==0 | (s_plot.data(i).n_start < 1) )
            s_plot.data(i).n_start = 1;
        end
        n_min = length(s_plot.data(1).y_vec(:,1));
        for j=1:c_mdim{i}
            if( c_ndim{i} == 2 )
                n_min = min(n_min,length(s_plot.data(i).x_vec(:,j)));
            end
            n_min = min(n_min,length(s_plot.data(i).y_vec(:,j)));
        end
        if( s_plot.data(i).n_start > n_min )
            s_plot.data(i).n_start = n_min;
        end
            
        command = sprintf('dum_flag = isfield(s_plot.data(%i),''n_end'');', ...
                          i);
        eval(char(command));
        if( ~dum_flag | length(s_plot.data(i).n_end)==0)
                s_plot.data(i).n_end = n_min;
                               
        end
        if( s_plot.data(i).n_end > n_min )
            s_plot.data(i).n_end = n_min;
        end
        if( s_plot.data(i).n_end < s_plot.data(i).n_start )
            s_plot.data(i).n_end = s_plot.data(i).n_start;
        end
            
    end
end
%------------------------------------------------------------------
% data(i).x_offset
% data(i).y_offset
if( s_plot.data_set )
    for i=1:s_plot.n_data
        if( c_ndim{i} == 2 )
            command = sprintf('dum_flag = isfield(s_plot.data(%i),''x_offset'');', ...
                             i);
            eval(char(command));
            if( ~dum_flag | length(s_plot.data(i).x_offset)==0 )
                s_plot.data(i).x_offset = 0;
            end
        end
        command = sprintf('dum_flag = isfield(s_plot.data(%i),''y_offset'');', ...
                          i);
        eval(char(command));
        if( ~dum_flag | length(s_plot.data(i).y_offset)==0 )
            s_plot.data(i).y_offset = 0;
        end        
    end    
end
%------------------------------------------------------------------
% data(i).line_type
% data(i).line_size
% data(i).line_color
% data(i).marker_type
% data(i).marker_size
if( s_plot.data_set )
    for i=1:s_plot.n_data
        command = sprintf('dum_flag = isfield(s_plot.data(%i),''line_type'');', ...
                          i);
        eval(char(command));
        if( ~dum_flag | length(s_plot.data(i).line_type)==0 )
            s_plot.data(i).line_type = PlotStandards.Ltype(i);
        end        

        command = sprintf('dum_flag = isfield(s_plot.data(%i),''line_size'');', ...
                          i);
        eval(char(command));
        if( ~dum_flag | length(s_plot.data(i).line_size)==0 )
            s_plot.data(i).line_size = PlotStandards.Lsize1;
        end        

        command = sprintf('dum_flag = isfield(s_plot.data(%i),''line_color'');', ...
                          i);
        eval(char(command));
        if( ~dum_flag | length(s_plot.data(i).line_color)==0 )
            s_plot.data(i).line_color = PlotStandards.Mfarbe{i};
        end                
        command = sprintf('dum_flag = isfield(s_plot.data(%i),''marker_type'');', ...
                          i);
        eval(char(command));
        if( ~dum_flag | length(s_plot.data(i).marker_type)==0 )
            s_plot.data(i).marker_type = PlotStandards.Mtype0;
        end        

        command = sprintf('dum_flag = isfield(s_plot.data(%i),''marker_size'');', ...
                          i);
        eval(char(command));
        if( ~dum_flag | length(s_plot.data(i).marker_size)==0 )
            s_plot.data(i).marker_size = PlotStandards.Msize1;
        end        
    end    
end
%------------------------------------------------------------------
% legend_set
% data(i).legend
% c_legend{}
if( s_plot.data_set )
    if( isfield(s_plot,'legend_set') ...
      & s_plot.legend_set ...
      )
        c_legend={}; 
        for i=1:s_plot.n_data
            command = sprintf('dum_flag = isfield(s_plot.data(%i),''legend'');', ...
                          i);
            eval(char(command));
            if( ~dum_flag | length(s_plot.data(i).legend)==0 )
                s_plot.data(i).legend = sprintf('curve %i',i);
            end
            c_legend{i} = ersetze_char(s_plot.data(i).legend,'_',' ');
            c_legend{i} = ersetze_char(c_legend{i},'\','/'); 
        end
    else
        s_plot.legend_set = 0;
    end
end
%------------------------------------------------------------------
% bot_title_set
% data(i).bot_title
% c_bot_title{}
if( isfield(s_plot,'bot_title_set') ...
  & s_plot.bot_title_set ...
  )
    c_bot_title={}; 
        
    if( isfield(s_plot,'bot_title') )
            
        for i=1:length(s_plot.bot_title)
            c_bot_title{i} = ersetze_char(s_plot.bot_title(i),'_',' ');
            c_bot_title{i} = ersetze_char(c_bot_title{i},'\','/');
        end
    else
                
        for i=1:s_plot.n_data
            command = sprintf('dum_flag = isfield(s_plot.data(%i),''bot_title'');', i);
            eval(char(command));
            if( ~dum_flag | length(s_plot.data(i).bot_title)==0 )
                s_plot.data(i).bot_tile = sprintf('curve %i',i);
            else
                c_bot_title{i} = ersetze_char(s_plot.data(i).bot_title,'_',' ');
                c_bot_title{i} = ersetze_char(c_bot_title{i},'\','/');
            end
        end
    end
else
    s_plot.bot_title_set = 0;
end
%------------------------------------------------------------------
% title_set
% title
if( isfield(s_plot,'title_set') ...
  & s_plot.title_set ...
  )
    if( ~isfield(s_plot,'title') )
       sprintf('??? pltmen_plot_function_error: No data title found\n',i);
       okay = 0;
       return;
   else
       s_plot.title = ersetze_char(s_plot.title,'_',' ');
       s_plot.title = ersetze_char(s_plot.title,'\','/'); 

    end
        
    if(length(s_plot.title) == 0)
        s_plot.title_set = 0;
    end
    if( ~( strcmp(class(s_plot.title),'cell') ...
         | strcmp(class(s_plot.title),'char') ...
         ) ...
      )
       sprintf('??? pltmen_plot_function_error: title is not char or cell class\n',i);
       okay = 0;
       return;
    end
end
if( ~isfield(s_plot,'title_set') )
    if( isfield(s_plot,'title') ...        
      & (length(s_plot.title) > 0) ...
      & ( strcmp(class(s_plot.title),'cell') ...
        | strcmp(class(s_plot.title),'char') ...
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
if( isfield(s_plot,'x_label_set') ...
  & s_plot.x_label_set ...
  )
    if( ~isfield(s_plot,'x_label') )
       sprintf('??? pltmen_plot_function_error: No data x_label found\n',i);
       okay = 0;
       return;
   else
       s_plot.x_label = ersetze_char(s_plot.x_label,'_',' ');
       s_plot.x_label = ersetze_char(s_plot.x_label,'\','/'); 
       
    end
        
    if(length(s_plot.x_label) == 0)
        s_plot.x_label_set = 0;
    end
    if( ~( strcmp(class(s_plot.x_label),'cell') ...
         | strcmp(class(s_plot.x_label),'char') ...
         ) ...
      )
       sprintf('??? pltmen_plot_function_error: x_label is not char or cell class\n',i);
       okay = 0;
       return;
    end
end
if( ~isfield(s_plot,'x_label_set') )
    if( isfield(s_plot,'x_label') ...        
      & (length(s_plot.x_label) > 0) ...
      & ( strcmp(class(s_plot.x_label),'cell') ...
        | strcmp(class(s_plot.x_label),'char') ...
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
if( isfield(s_plot,'y_label_set') ...
  & s_plot.y_label_set ...
  )
    if( ~isfield(s_plot,'y_label') )
       sprintf('??? pltmen_plot_function_error: No data y_label found\n',i);
       okay = 0;
       return;
   else
       s_plot.y_label = ersetze_char(s_plot.y_label,'_',' ');
       s_plot.y_label = ersetze_char(s_plot.y_label,'\','/'); 
       
    end
        
    if(length(s_plot.y_label) == 0)
        s_plot.y_label_set = 0;
    end
    if( ~( strcmp(class(s_plot.y_label),'cell') ...
         | strcmp(class(s_plot.y_label),'char') ...
         ) ...
      )
       sprintf('??? pltmen_plot_function_error: y_label is not char or cell class\n',i);
       okay = 0;
       return;
    end
end
if( ~isfield(s_plot,'y_label_set') )
    if( isfield(s_plot,'y_label') ...        
      & (length(s_plot.y_label) > 0) ...
      & ( strcmp(class(s_plot.y_label),'cell') ...
        | strcmp(class(s_plot.y_label),'char') ...
        ) ...
      )
        s_plot.y_label_set = 1;
    else
        s_plot.y_label_set = 0;
    end
end

%==================================================================
%------------------------------------------------------------------
if( s_plot.fig_num > 0 )
    handle = figure(s_plot.fig_num);
elseif( s_plot.subplot_fig_num == 1)
    handle = figure;
end
%------------------------------------------------------------------
if( s_plot.short_name_set )
    set(handle,'Name',s_plot.short_name)
end
%------------------------------------------------------------------
if( s_plot.dina4 == 1 )
    set(handle,'PaperType','A4')
    set(handle,'PaperOrientation','portrait')
    set(handle,'PaperPositionMode','manual')
    set(handle,'PaperUnit','centimeters ')
    set(handle,'PaperPosition',[0.63452 0.63452 19.715 28.408])
elseif( s_plot.dina4 == 2 )
    set(handle,'PaperType','A4')
    set(handle,'PaperOrientation','landscape')
    set(handle,'PaperPositionMode','manual')
    set(handle,'PaperUnit','centimeters ')
    set(handle,'PaperPosition',[0.63452 0.63452 28.408 19.715])
end
%------------------------------------------------------------------
subplot(s_plot.subplot_rows,s_plot.subplot_cols,s_plot.subplot_fig_num);
%------------------------------------------------------------------
if( s_plot.data_set )
    hold off
    for i=1:s_plot.n_data

        for j=1:c_mdim{i}
            plot( ...
            s_plot.data(i).x_vec(s_plot.data(i).n_start:s_plot.data(i).n_end,j) ...
            -s_plot.data(i).x_offset ...
            ,s_plot.data(i).y_vec(s_plot.data(i).n_start:s_plot.data(i).n_end,j) ...
            -s_plot.data(i).y_offset ...
            ,'LineStyle',s_plot.data(i).line_type ...
            ,'LineWidth',s_plot.data(i).line_size ...
            ,'Color',s_plot.data(i).line_color ...
            ,'Marker',s_plot.data(i).marker_type ...
            ,'MarkerSize',s_plot.data(i).marker_size ...
            )
            hold on
        end
   end
   hold off
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
if( s_plot.legend_set )
    legend(c_legend);
end
%------------------------------------------------------------------
if( s_plot.bot_title_set )
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
            ,'Position',            [x_text,y_text] ...
            ,'Units',               'centimeters' ...
            ,'Fontsize',            6 ...
            );
    end
end
