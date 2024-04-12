%=================================================================
% Plotroutinen
function plot_vergleich(fig_num,plot_dina4,subplot_rows,subplot_cols,subplot_fig, ...
                        x_lab_title,y_lab_title,top_title,c_bot_title, ...
                        c_x,c_x_offset,c_y,c_y_offset, ...
                        set_legend,c_legend,c_color,c_line_type,c_line_size,c_marker_type,c_marker_size, ...
                        set_xlim,val_xlim,set_ylim,val_ylim, ...
                        short_name_set,short_name)

if( fig_num <= 0 )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('fig_num = %i <= 0\n');
    return;
end

n_c = length(c_x);

if( length(c_x_offset) < n_c )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('cell array length does''t match\n');
    fprintf('length(c_x_offset) < length(c_x)');
    return;
end
if( length(c_y) < n_c )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('cell array length does''t match\n');
    fprintf('length(c_y) < length(c_x)');
    return;
end
if( length(c_y_offset) < n_c )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('cell array length does''t match\n');
    fprintf('length(c_y_offset) < length(c_x)');
    return;
end
if( set_legend & length(c_legend) < n_c )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('cell array length does''t match\n');
    fprintf('length(c_legend) < length(c_x)');
    return;
end
if( length(c_color) < n_c )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('cell array length does''t match\n');
    fprintf('length(c_color) < length(c_x)');
    return;
end
if( length(c_line_type) < n_c )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('cell array length does''t match\n');
    fprintf('length(c_line_type) < length(c_x)');
    return;
end
if( length(c_line_size) < n_c )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('cell array length does''t match\n');
    fprintf('length(c_line_size) < length(c_x)');
    return;
end
if( length(c_marker_type) < n_c )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('cell array length does''t match\n');
    fprintf('length(c_marker_type) < length(c_x)');
    return;
end
if( length(c_marker_size) < n_c )
    fprintf('\nError in vergleich_beladung_plot:\n\n');
    fprintf('cell array length does''t match\n');
    fprintf('length(c_marker_size) < length(c_x)');
    return;
end
c_legend1 = {};
c_line_size1   = c_line_size;
c_line_type1   = c_line_type;
c_marker_size1 = c_marker_size;
c_marker_type1 = c_marker_type;
c_color1       = c_color;
for i=1:n_c
    if(set_legend ~= 0)
        c_legend1{i} = c_legend{i};
    end
    if( c_line_size1{i} <= 0 )
        c_line_size1{i} = 1;
        c_line_type1{i}  = 'none';
    end
    if( c_marker_size1{i} <= 0 )
        c_marker_size1{i} = 1;
        c_marker_type1{i}  = 'none';
    end
    [n,m] = size(c_color1{i});
    if( n ~= 1 & m ~= 3 )
        c_color1{i} = [0,0,0];
    end
end

if( subplot_fig > subplot_cols*subplot_rows )
    subplot_fig1 = subplot_cols*subplot_rows;
else
    subplot_fig1 = subplot_fig;
end
c_x1={};
c_y1={};
for i=1:n_c
    if( length(c_x{i}) < length(c_y{i}) )
        c_x1{i} = c_x{i};
        c_y1{i} = c_y{i}(1:length(c_x{i}));
    elseif( length(c_x{i}) > length(c_y{i}) )
        c_x1{i} = c_x{i}(1:length(c_y{i}));
        c_y1{i} = c_y{i};
    else
        c_x1{i} = c_x{i};
        c_y1{i} = c_y{i};
    end
end
c_x_offset1={};
c_y_offset1={};
for i=1:n_c
    c_x_offset1{i} = c_x_offset{i}(1);
    c_y_offset1{i} = c_y_offset{i}(1);
end

%===========================================================
figure(fig_num);
if( short_name_set & strcmp(class(short_name),'char') )
    set(fig_num,'Name',short_name)
end
if( plot_dina4 == 1 )
    set(fig_num,'PaperType','A4')
    set(fig_num,'PaperOrientation','portrait')
    set(fig_num,'PaperPositionMode','manual')
    set(fig_num,'PaperUnit','centimeters ')
    set(fig_num,'PaperPosition',[0.63452 0.63452 19.715 28.408])
elseif( plot_dina4 == 2 )
    set(fig_num,'PaperType','A4')
    set(fig_num,'PaperOrientation','landscape')
    set(fig_num,'PaperPositionMode','manual')
    set(fig_num,'PaperUnit','centimeters ')
    set(fig_num,'PaperPosition',[0.63452 0.63452 28.408 19.715])
end
if( subplot_rows >= 0 | subplot_cols >= 0 )
    subplot(subplot_rows,subplot_cols,subplot_fig1);
end
    
hold off
for i=1:n_c
    x = c_x1{i} - c_x_offset1{i};
    y = c_y1{i} - c_y_offset1{i};
    plot(x,y ...
        ,'LineStyle',c_line_type1{i} ...
        ,'LineWidth',c_line_size1{i} ...
        ,'Color',c_color1{i} ...
        ,'Marker',c_marker_type1{i} ...
        ,'MarkerSize',c_marker_size1{i} ...
        )
    grid on
    hold on
end    
if( length(x_lab_title) > 0 )
    xlabel(x_lab_title);
end
if( length(y_lab_title) > 0 )
    ylabel(y_lab_title);
end
if( length(top_title) > 0 )
    title(top_title);
end
    
if(set_legend ~= 0)
    legend(c_legend1);
end
if( set_xlim ~= 0 )
    xlim(val_xlim);
end
if( set_ylim ~= 0 )
    ylim(val_ylim);
end

if( strcmp(class(c_bot_title),'cell') & length(c_bot_title) > 0)

    
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
