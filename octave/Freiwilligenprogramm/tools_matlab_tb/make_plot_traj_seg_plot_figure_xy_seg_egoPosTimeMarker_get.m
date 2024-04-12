function [xvec,yvec,tvec] = make_plot_traj_seg_plot_figure_xy_seg_egoPosTimeMarker_get(egoPos,Axle,deltaTime)

  xvec = egoPos.(Axle).xvec(1) + egoPos.(Axle).offsetX;
  yvec = egoPos.(Axle).yvec(1) + egoPos.(Axle).offsetY;
  tvec = egoPos.time(1);
  
  t0   = ceil(egoPos.time(1)/deltaTime)*deltaTime;
  
  i = 2;
  
  while(i < egoPos.nvec)
    if( egoPos.time(i)  >= t0 )
      xvec = [xvec;egoPos.(Axle).xvec(i) + egoPos.(Axle).offsetX];
      yvec = [yvec;egoPos.(Axle).yvec(i) + egoPos.(Axle).offsetY];
      tvec = [tvec;egoPos.time(i)];
      t0   = t0 + deltaTime;
    end
    i = i+1;
  end
      xvec = [xvec;egoPos.(Axle).xvec(end) + egoPos.(Axle).offsetX];
      yvec = [yvec;egoPos.(Axle).yvec(end) + egoPos.(Axle).offsetY];
      tvec = [tvec;egoPos.time(end)];
end

