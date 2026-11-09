function plo = make_plot_traj_seg_plot_figure_xy_seg(plo,seg,iseg,q)
  
  % Recording
  if( check_val_in_struct(q,'recording' ,'struct',1,0) )
      plo = plot_recording_plot_figure_xy_seg(plo,q);
  end

  % Trajektorien
  for itraj=1:seg(iseg).ntraj
    if(  check_val_in_struct(seg(iseg).traj(itraj),q.Axle,'struct',1,0) ... 
      && check_val_in_struct(seg(iseg).traj(itraj).(q.Axle),'xvec','num',1,0) ...
      && check_val_in_struct(seg(iseg).traj(itraj).(q.Axle),'yvec','num',1,0) ...
      )
      plo = make_plot_traj_seg_plot_figure_xy_seg_traj(plo,iseg,seg(iseg).traj(itraj),q.Axle,q);
    end
    if( ~strcmp(q.Axle,q.AxleOA) && check_val_in_struct(seg(iseg).traj(itraj),q.AxleOA,'struct',1,0) )
      plo = make_plot_traj_seg_plot_figure_xy_seg_traj(plo,iseg,seg(iseg).traj(itraj),q.AxleOA,q);
    end
  end

  % EgoPos
  for iegoPos=1:seg(iseg).negoPos
    if( check_val_in_struct(seg(iseg).egoPos(iegoPos),q.Axle,'struct',1,0) )
      plo = make_plot_traj_seg_plot_figure_xy_seg_egoPos(plo,iseg,seg(iseg).egoPos(iegoPos),q.Axle,q);
    end
    if( ~strcmp(q.Axle,q.AxleOA) && check_val_in_struct(seg(iseg).egoPos(iegoPos),q.AxleOA,'struct',1,0) )
      plo = make_plot_traj_seg_plot_figure_xy_seg_egoPos(plo,iseg,seg(iseg).egoPos(iegoPos),q.AxleOA,q);
    end
  end
  
  % waypoint
  for iwaypoint=1:seg(iseg).nwaypoint
    plo = make_plot_traj_seg_plot_figure_xy_seg_waypoint(plo,iseg,seg(iseg).waypoint(iwaypoint),q);
  end
  
end
