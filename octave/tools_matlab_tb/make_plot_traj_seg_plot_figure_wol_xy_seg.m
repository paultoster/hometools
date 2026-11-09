function plo = make_plot_traj_seg_plot_figure_wol_xy_seg(plo,seg,iseg,q)

%     if( strcmp(egoPos.(Axle).marker,'none') && length(egoPos.(Axle).xvec) < 3 )
%       egoPos.(Axle).marker = '*';
%     end
%     
%     plo.line(nline).h = ...
%       line('Parent'        ,plo.h_axes(1) ...
%           ,'XData'         ,egoPos.(Axle).xvec + egoPos.(Axle).offsetX ...
%           ,'YData'         ,egoPos.(Axle).yvec + egoPos.(Axle).offsetY ...
%           ,'Color'         ,PlotStandards.Farbe{nline} ...
%           ,'LineWidth'     ,egoPos.(Axle).lineWidth ...
%           ,'LineStyle'     ,egoPos.(Axle).lineStyle ...
%           ,'Marker'        ,egoPos.(Axle).marker ...
%           ,'MarkerSize'    ,max(1,egoPos.(Axle).marker_size + egoPos.(Axle).marker_size_di * (iseg-1)) ...
%           ,'Visible'       ,'on');
  % plot EgoStartPos
  flag0 = 1;
  flag1 = 1;
  if( ~strcmp(q.markerEgoPosStart,'none') )
    for iegoPos=1:seg(iseg).negoPos
    if( flag0 && check_val_in_struct(seg(iseg).egoPos(iegoPos),q.Axle,'struct',1,0) )
      flag0 = 0;
      plo = make_plot_traj_seg_plot_figure_xy_seg_egoStartPos(plo,iseg,seg(iseg).egoPos(iegoPos),q.Axle,q);
    end
    if( ~strcmp(q.Axle,q.AxleOA) && flag1 && check_val_in_struct(seg(iseg).egoPos(iegoPos),q.AxleOA,'struct',1,0) )
      flag1 = 0;
      plo = make_plot_traj_seg_plot_figure_xy_seg_egoStartPos(plo,iseg,seg(iseg).egoPos(iegoPos),q.AxleOA,q);
    end
    end
  end
  % plot delta_t on Ego
  flag0 = 1;
  flag1 = 1;
  if( ~strcmp(q.markerEgoTime,'none') )
    for iegoPos=1:seg(iseg).negoPos
    if( flag0 && check_val_in_struct(seg(iseg).egoPos(iegoPos),q.Axle,'struct',1,0) )
      flag0 = 0;
      plo = make_plot_traj_seg_plot_figure_xy_seg_egoPosTimeMarker(plo,iseg,seg(iseg).egoPos(iegoPos),q.Axle,q);
    end
    if( flag1 && check_val_in_struct(seg(iseg).egoPos(iegoPos),q.AxleOA,'struct',1,0) )
      flag1 = 0;
      plo = make_plot_traj_seg_plot_figure_xy_seg_egoPosTimeMarker(plo,iseg,seg(iseg).egoPos(iegoPos),q.AxleOA,q);
    end
    end
  end
  
  % plot cross to vehicle pose
  if( iseg == q.iseg_t0 )
   plo = make_plot_traj_seg_plot_figure_xy_seg_egoPosCross(plo,seg(iseg).egoPos(1),q.Axle,q);
  end
end
