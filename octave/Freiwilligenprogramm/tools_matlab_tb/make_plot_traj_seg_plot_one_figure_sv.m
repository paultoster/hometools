%==========================================================================
%  Plaot vvec over svec
%==========================================================================
function    q = make_plot_traj_seg_plot_one_figure_sv(seg,nseg,q)
  q.fig_num       = q.fig_num + 1;
  q.nplo          = q.nplo + 1;
  
  plo.h_figure    = p_figure(q.fig_num,q.dina4,'onePlotSV',1);
  plo.clegText    = {};
  plo.h_axes(1)   = subplot(1,1,1);
  
  % plot with legend
  for iseg=q.iseg0:q.iseg1
    
    plo = make_plot_traj_seg_plot_figure_sv_seg(plo,seg,iseg,q);
    
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
 
  legend(plo.clegText,'Location','NorthEastOutside')
  
  % plot with out legend
  for iseg=q.iseg0:q.iseg1
    
    plo = make_plot_traj_seg_plot_figure_wol_sv_seg(plo,seg,iseg,q);
    
  end
  
    
  xlabel('s [m]')
  ylabel('v [km/h]')
  
  grid on

  if( q.axisEqual )
    axis('equal');
  end
  
  q.plo(q.nplo) = plo;

end
function plo = make_plot_traj_seg_plot_figure_sv_seg(plo,seg,iseg,q)
  
  % Trajektorien der Haupt Achse
  for itraj=1:seg(iseg).ntraj
    if(  check_val_in_struct(seg(iseg).traj(itraj),q.Axle,'struct',1,0) ...
      && check_val_in_struct(seg(iseg).traj(itraj).(q.Axle),'sdistvec','num',1,0) ...
      && check_val_in_struct(seg(iseg).traj(itraj),'vvec','num',1,0) ...
      )
      plo = make_plot_traj_seg_plot_figure_sv_seg_traj(plo,iseg,seg(iseg).traj(itraj),q.Axle,q);
    end
  end

  % EgoPos
  for iegoPos=1:seg(iseg).negoPos
    plo = make_plot_traj_seg_plot_figure_sv_seg_egoPos(plo,iseg,seg(iseg).egoPos(iegoPos),q.Axle,q);
  end
  
  % waypoint
  for iwaypoint=1:seg(iseg).nwaypoint
    plo = make_plot_traj_seg_plot_figure_sv_seg_waypoint(plo,iseg,seg(iseg).waypoint(iwaypoint),q);
  end
end
function  plo = make_plot_traj_seg_plot_figure_sv_seg_traj(plo,iseg,traj,Axle,q)

    set_plot_standards
    
    % line
    if( ~isfield(plo,'line') )
      plo.line = struct([]);
    end
    nline = length(plo.line)+1;
    plo.line(nline).h = ...
      line('Parent'        ,plo.h_axes(1) ...
          ,'XData'         ,traj.(Axle).sdistvec  ...
          ,'YData'         ,traj.vvec*3.6 ...
          ,'Color'         ,PlotStandards.Farbe{nline} ...
          ,'LineWidth'     ,1 ...
          ,'LineStyle'     ,'-' ...
          ,'Marker'        ,'o' ...
          ,'MarkerSize'    ,10 ...
          ,'Visible'       ,'on');
        
   % legend
   tt = sprintf('%s%i',traj.(Axle).legText,iseg);
   plo.clegText = cell_add(plo.clegText,tt);
  
end

