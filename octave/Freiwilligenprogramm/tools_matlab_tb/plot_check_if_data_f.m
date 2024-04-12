function found_flag = plot_check_if_data_f(s_fig)
% found = plot_check_if_data_f(s_fig)
% Checkt, ob Daten im Plot enthalten sind
found_flag = 0;
for ifig = 1:length(s_fig)
  if( isfield(s_fig(ifig),'s_plot') )
    for iplot=1:length(s_fig(ifig).s_plot)
      if( isfield(s_fig(ifig).s_plot(iplot),'s_data') )
        for idata=1:length(s_fig(ifig).s_plot(iplot).s_data)
          
          if( s_fig.s_plot(iplot).s_data(idata).ndim > 0 )
            found_flag = 1;
            return;
          end
        end
      end
    end
  end
end