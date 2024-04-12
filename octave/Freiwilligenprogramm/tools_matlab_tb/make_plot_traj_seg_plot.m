function   [q,seg,nseg]    = make_plot_traj_seg_plot(q,seg,nseg,t0)
%
  q.t0 = t0;
  [q.iseg0,q.iseg1,q.iseg_t0] = make_plot_traj_seg_plot_find_segment(q,seg,nseg,t0);
  
  if( q.iseg0 == 0 )
    error('es konnte keine Trajektorie im Zeitraum gefunden werden')
  end
  
  q = make_plot_traj_seg_plot_one_figure(seg,nseg,q);
  
  figmen
    
end
function q = make_plot_traj_seg_plot_one_figure(seg,nseg,q)
  
  q = make_plot_traj_seg_plot_one_figure_xy(seg,nseg,q);
  
  if( q.plot_vel_over_s )
    q = make_plot_traj_seg_plot_one_figure_sv(seg,nseg,q);
  end
  if( q.plot_acc_over_s )
    q = make_plot_traj_seg_plot_one_figure_sa(seg,nseg,q);
  end
end
function [iseg0,iseg1,iseg_t0] = make_plot_traj_seg_plot_find_segment(q,seg,nseg,t0)

  if( t0 < seg(1).tStart )
    iseg0 = 1;
    iseg1 = 1;
    iseg_t0 = 0;
  elseif( t0 > seg(nseg).tEnd )
    iseg0 = nseg;
    iseg1 = nseg;
    iseg_t0 = 0;
  else
    iseg0 = 0;
    for i=1:nseg    
      if( (t0 >= seg(i).tStart) && (t0 < seg(i).tEnd) )
        iseg0 = i;
        iseg_t0 = i;
        break;
      end
    end
    if( iseg0 == 0 )
      iseg0 = 0;
      iseg1 = 0;
      iseg_t0 = 0;
    else
      n2 = floor(q.numOfTraj/2);
      if( iseg0 > n2 )
        iseg0 = iseg0 - n2;
      else
        iseg0 = 1;
      end
      
      if( iseg0 + q.numOfTraj -1 > nseg )
        iseg1 = nseg;
      else
        iseg1 = iseg0 + q.numOfTraj -1;
      end
    end
  end
end