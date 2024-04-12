function plo = make_plot_traj_seg_plot_figure_wol_sv_seg(plo,seg,iseg,q)

  % plot EgoStartPos
  flag0 = 1;
  flag1 = 1;
  if( ~strcmp(q.markerEgoPosStart,'none') )
    for iegoPos=1:seg(iseg).negoPos
    if( flag0 && check_val_in_struct(seg(iseg).egoPos(iegoPos),q.Axle,'struct',1,0) )
      flag0 = 0;
      plo = make_plot_traj_seg_plot_figure_xy_seg_egoStartPos(plo,iseg,seg(iseg).egoPos(iegoPos),q.Axle,q);
    end
    if( flag1 && check_val_in_struct(seg(iseg).egoPos(iegoPos),q.AxleOA,'struct',1,0) )
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
   plo = make_plot_traj_seg_plot_figure_sv_seg_egoPosCross(plo,seg(iseg).egoPos(1),q.Axle,q);
  end

end
