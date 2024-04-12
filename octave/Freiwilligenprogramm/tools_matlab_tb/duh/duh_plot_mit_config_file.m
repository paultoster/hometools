function [okay,s_duh] = duh_plot_mit_config_file(s_duh,s_f,selection)

okay = 1;
set_plot_standards

% fig_num
%========
s_duh.n_plot = s_duh.n_plot+1;
s_fig.fig_num            = s_duh.n_plot;

% short_name
%===========
if( length(s_f.short_name) > 0 )
    s_fig.short_name_set     = 1;
    s_fig.short_name         = s_f.short_name;
else
    s_fig.short_name_set     = 0;
    s_fig.short_name         = '';
end

% format
%=======
s_fig.dina4              = PlotStandards.(s_f.format); 

% rows and cols
%==============
s_fig.rows               = s_f.rows;
s_fig.cols               = s_f.cols;

% Subplot
%========
for i_p=1:length(s_f.s_plot)
    
    s_p = s_f.s_plot(i_p);
    
    % Titel
    %======
    if( length(s_p.title) > 0 )
        s_fig.s_plot(i_p).title_set     = 1;
        s_fig.s_plot(i_p).title         = s_p.title;
    else
        s_fig.s_plot(i_p).title_set     = 0;
        s_fig.s_plot(i_p).title         = '';
    end
    
    % Fußtittel
    %==========
    
    % Keine
    if( strcmp(s_p.bot_title,PlotStandards.bot_title_names{1}) )
        s_fig.s_plot(i_p).bot_title_set = 0;
    % Dateiname
    elseif( strcmp(s_p.bot_title,PlotStandards.bot_title_names{2}) )
        s_fig.s_plot(i_p).bot_title_set = 1;
        
        for id = 1:length(selection)
            id1 = selection(id);
            s_fig.s_plot(i_p).bot_title{id} = s_duh.s_data(id1).file;
        end
    % Ansonsten
    else        
        s_fig.s_plot(i_p).bot_title_set = 0;
    end    
    
    % Legende
    %========
    if( length(s_p.legend_choice) > 0 )
        switch(s_p.legend_choice)
            case PlotStandards.legend_choice{1} % None

                s_fig.s_plot(i_p).legend_set = 0;
                legend_filename_flag          = 0;
                legend_varname_flag          = 0;
                legend_unit_flag             = 0;

            case PlotStandards.legend_choice{2} % varname

                s_fig.s_plot(i_p).legend_set = 1;
                legend_filename_flag          = 0;
                legend_varname_flag          = 1;
                legend_unit_flag             = 0;

            case PlotStandards.legend_choice{3} % varname+unit

                s_fig.s_plot(i_p).legend_set = 1;
                legend_filename_flag          = 0;
                legend_varname_flag          = 1;
                legend_unit_flag             = 1;

            case PlotStandards.legend_choice{4} % varname+unit

                s_fig.s_plot(i_p).legend_set = 1;
                legend_filename_flag          = 1;
                legend_varname_flag          = 0;
                legend_unit_flag             = 0;

            otherwise

                s_fig.s_plot(i_p).legend_set = 0;
                legend_filename_flag          = 0;
                legend_varname_flag          = 0;
                legend_unit_flag             = 0;
        end
    end    
    % Grid
    %========
    s_fig.s_plot(i_p).grid_set = s_p.grid_set;
    
    % xlim
    %=====
    s_fig.s_plot(i_p).xlim_set = s_p.xlim_set;
    s_fig.s_plot(i_p).xmin     = s_p.xmin;
    s_fig.s_plot(i_p).xmax     = s_p.xmax;
    
    % ylim
    %=====
    s_fig.s_plot(i_p).ylim_set = s_p.ylim_set;
    s_fig.s_plot(i_p).ymin     = s_p.ymin;
    s_fig.s_plot(i_p).ymax     = s_p.ymax;
    
    % x-label
    %========
    if( length(s_p.x_label) > 0 )
        s_fig.s_plot(i_p).x_label_set = 1;
        s_fig.s_plot(i_p).x_label     = s_p.x_label;
    else
        s_fig.s_plot(i_p).x_label_set = 0;
        s_fig.s_plot(i_p).x_label     = '';
    end

    % y-label
    %========
    if( length(s_p.y_label) > 0 )
        s_fig.s_plot(i_p).y_label_set = 1;
        s_fig.s_plot(i_p).y_label     = s_p.y_label;
    else
        s_fig.s_plot(i_p).y_label_set = 0;
        s_fig.s_plot(i_p).y_label     = '';
    end
    
    % dat-set
    %========
    s_fig.s_plot(i_p).data_set = s_p.data_set;
    
    if( s_p.data_set )
        
        i_data = 0;
        for is = 1:length(selection)
            
            id = selection(is);

%        for id = 1:s_duh.n_data
            
            for ig=1:length(s_p.s_data)
                
                s_data = s_p.s_data(ig);
                
                if( ( s_data.ndim == 1 & isfield(s_duh.s_data(id).d,s_data.y_vec_name) ) ...
                  | ( s_data.ndim >= 2 & isfield(s_duh.s_data(id).d,s_data.y_vec_name) & isfield(s_duh.s_data(id).d,s_data.x_vec_name) ) ...
                  )
              
                    i_data = i_data + 1;
                    
                    s_fig.s_plot(i_p).s_data(i_data).ndim     = s_data.ndim;
                    s_fig.s_plot(i_p).s_data(i_data).n_start  = s_data.n_start;
                    s_fig.s_plot(i_p).s_data(i_data).n_end    = s_data.n_end;
                    
                    if( s_data.ndim >= 2 )
                        s_fig.s_plot(i_p).s_data(i_data).x_vec    = s_duh.s_data(id).d.(s_data.x_vec_name);
                        s_fig.s_plot(i_p).s_data(i_data).x_offset = s_data.x_offset;
                        
                        if( isfield(s_data,'x_factor') )
                            s_fig.s_plot(i_p).s_data(i_data).x_vec = s_fig.s_plot(i_p).s_data(i_data).x_vec * s_data.x_factor;
                        end                            
                    end
                    
                    s_fig.s_plot(i_p).s_data(i_data).y_vec    = s_duh.s_data(id).d.(s_data.y_vec_name);
                    s_fig.s_plot(i_p).s_data(i_data).y_offset = s_data.y_offset;
                    if( isfield(s_data,'y_factor') )
                        s_fig.s_plot(i_p).s_data(i_data).y_vec = s_fig.s_plot(i_p).s_data(i_data).y_vec * s_data.y_factor;
                    end                            
                    
                    
                    s_fig.s_plot(i_p).s_data(i_data).line_type  = PlotStandards.Ltype{1};
                    s_fig.s_plot(i_p).s_data(i_data).line_size  = s_data.line_size;
                    s_fig.s_plot(i_p).s_data(i_data).line_color = PlotStandards.(s_data.line_color_name);

                    if( length(selection) == 1 )
                        s_fig.s_plot(i_p).s_data(i_data).marker_type  = 'none';
                        s_fig.s_plot(i_p).s_data(i_data).marker_size  = 5;
                    else
                        s_fig.s_plot(i_p).s_data(i_data).marker_type  = PlotStandards.Mtype{min(length(PlotStandards.Mtype),id)};
                        s_fig.s_plot(i_p).s_data(i_data).marker_size  = 5;
                    end
                    
                    if( s_fig.s_plot(i_p).legend_set )
                        
                        t1 = '';
                        if( legend_filename_flag )
                            t1 = [t1,s_duh.s_data(id).name,' '];
                        end
                        if( legend_varname_flag )
                            t1 = [t1,s_data.y_vec_name];
                        end
                        
                        if( legend_unit_flag ...
                          & isfield(s_duh.s_data(id).u,s_data.y_vec_name) ...
                          & length(s_duh.s_data(id).u.(s_data.y_vec_name)) > 0 ...
                          )
                            t1 = [t1,'[',s_duh.s_data(id).u.(s_data.y_vec_name),']'];
                        end
                        
%                         if( s_duh.n_data > 1 )
%                             t1 = [t1,'(',num2str(id),')'];
%                         end
                            
                        s_fig.s_plot(i_p).s_data(i_data).legend = t1;
                       
                    end
                                       
                else
                    if( s_data.ndim == 1 )
                        warning('Der Vektor <%s> ist nicht in dem Datensatz %i enthalten',s_data.y_vec_name,id);
                    else
                        warning('Der Vektor <%s,%s> ist nicht in dem Datensatz %i enthalten',s_data.x_vec_name,s_data.y_vec_name,id);
                    end
                end
            end
        end
    end
end

% Plot ausführen
plot_f(s_fig)