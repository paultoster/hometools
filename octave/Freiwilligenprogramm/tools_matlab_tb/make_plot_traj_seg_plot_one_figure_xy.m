function q = make_plot_traj_seg_plot_one_figure_xy(seg,nseg,q)

  q.fig_num       = q.fig_num + 1;
  q.nplo          = q.nplo + 1;
  plo.h_figure    = p_figure(q.fig_num,q.dina4,'onePlotXY',1);
  plo.clegText    = {};
  plo.h_axes(1)   = subplot(1,1,1);
  
  % plot with legend
  if( check_val_in_struct(q,'recording' ,'struct',1,0) )
      plo = plot_recording_plot_figure_xy_seg(plo,q);
  end
  
  

  for iseg=q.iseg0:q.iseg1
    
    plo = make_plot_traj_seg_plot_figure_xy_seg(plo,seg,iseg,q);
    
    if( iseg == q.iseg0 )
      xLimits = get(gca,'XLim');  
      yLimits = get(gca,'YLim');  

      xText = xLimits(1) + (xLimits(2)-xLimits(1)) * 0.15;
      yText = yLimits(2) - (yLimits(2)-yLimits(1)) * 0.15;
      
      text(xText,yText,sprintf('tstart = %f s',seg(iseg).tStart));
    end
    if( iseg == q.iseg1 )
      
      xLimits = get(gca,'XLim');  
      yLimits = get(gca,'YLim');  

      xText = xLimits(1) + (xLimits(2)-xLimits(1)) * 0.15;
      yText = yLimits(2) - (yLimits(2)-yLimits(1)) * 0.15;
      dy    = (yLimits(2)-yLimits(1)) * 0.025;

      text(xText,yText-dy,sprintf('tend = %f s',seg(iseg).tEnd));
            
    end
    
  end
  
  if( isfield(q,'t0') )
    
      xLimits = get(gca,'XLim');  
      yLimits = get(gca,'YLim');  

      xText = xLimits(1) + (xLimits(2)-xLimits(1)) * 0.15;
      yText = yLimits(2) - (yLimits(2)-yLimits(1)) * 0.15;
      dy    = (yLimits(2)-yLimits(1)) * 0.025 * 2;

      text(xText,yText-dy,sprintf('t0   = %f s',q.t0));
    
  end
  
  xLimits = get(gca,'XLim');  
  yLimits = get(gca,'YLim');  

  xText = xLimits(1) + (xLimits(2)-xLimits(1)) * 0.15;
  yText = yLimits(2) - (yLimits(2)-yLimits(1)) * 0.15;
  dy    = (yLimits(2)-yLimits(1)) * 0.025 * 3;

  text(xText,yText-dy,sprintf('iseg = %i:%i',q.iseg0,q.iseg1));
  
  
  legend(plo.clegText,'Location','NorthEastOutside')
  
  % plot with out legend
  for iseg=q.iseg0:q.iseg1
    
    plo = make_plot_traj_seg_plot_figure_wol_xy_seg(plo,seg,iseg,q);
    
  end
  
    
  xlabel('x [m]')
  ylabel('y [m]')
  
  grid on

  if( q.axisEqual )
    axis('equal');
  end
  
  q.plo(q.nplo) = plo;

end

