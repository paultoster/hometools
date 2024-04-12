function plo = make_plot_traj_seg_plot_figure_sa_seg(plo,seg,iseg,q)
  
  % Trajektorien
  for itraj=1:seg(iseg).ntraj
    if( check_val_in_struct(seg(iseg).traj(itraj),q.Axle,'struct',1,0) )
      plo = make_plot_traj_seg_plot_figure_sa_seg_traj(plo,iseg,seg(iseg).traj(itraj),q.Axle,q);
    end
%     if( check_val_in_struct(seg(iseg).traj(itraj),q.AxleOA,'struct',1,0) )
%       plo = make_plot_traj_seg_plot_figure_sv_seg_traj(plo,iseg,seg(iseg).traj(itraj),q.AxleOA,q);
%     end
  end

  % EgoPos
  for iegoPos=1:seg(iseg).negoPos
    if( check_val_in_struct(seg(iseg).egoPos(iegoPos),q.Axle,'struct',1,0) )
      plo = make_plot_traj_seg_plot_figure_sa_seg_egoPos(plo,iseg,seg(iseg).egoPos(iegoPos),q.Axle,q);
    end
%     if( check_val_in_struct(seg(iseg).egoPos(iegoPos),q.AxleOA,'struct',1,0) )
%       plo = make_plot_traj_seg_plot_figure_sv_seg_egoPos(plo,iseg,seg(iseg).egoPos(iegoPos),q.AxleOA,q);
%     end
  end
  
  % waypoint
  for iwaypoint=1:seg(iseg).nwaypoint
    plo = make_plot_traj_seg_plot_figure_sa_seg_waypoint(plo,iseg,seg(iseg).waypoint(iwaypoint),q);
  end
end
