function q = make_plot_traj_seg_plot_each_figure_sv(seg,nseg,q)

  nend = min(nseg,q.plotNMax);
  
  for iseg = 1:nend
    
    q.fig_num       = q.fig_num + 1;
    q.nplo          = q.nplo+1;

    clear plo
    plo.h_figure    = p_figure(q.fig_num,q.dina4,sprintf('PlotSV_%i',iseg));
    plo.clegText    = {};
    plo.h_axes(1)   = subplot(1,1,1);
  
    
    plo = make_plot_traj_seg_plot_figure_sv_seg(plo,seg,iseg,q);
    
  
    legend(plo.clegText,'Location','NorthEastOutside')
    
    % plot with out legend  
    plo = make_plot_traj_seg_plot_figure_wol_sv_seg(plo,seg,iseg,q);
    
    xLimits = get(gca,'XLim');  
    yLimits = get(gca,'YLim'); 
    
    xText = xLimits(1) + (xLimits(2)-xLimits(1)) * 0.15;
    yText = yLimits(2) - (yLimits(2)-yLimits(1)) * 0.15;
    dy    = (yLimits(2)-yLimits(1)) * 0.025;
    text(xText,yText,sprintf('tstart = %f s',seg(iseg).tStart));
    text(xText,yText-dy,sprintf('tend = %f s',seg(iseg).tEnd));
  
    xlabel('s [m]')
    ylabel('v [m/s]')
  
    grid on

    if( q.axisEqual )
      axis('equal');
    end
    
    q.plo(q.nplo) = plo;
  end
  
end

    
