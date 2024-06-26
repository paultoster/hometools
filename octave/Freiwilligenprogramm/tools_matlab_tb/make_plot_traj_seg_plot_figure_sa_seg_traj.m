function  plo = make_plot_traj_seg_plot_figure_sa_seg_traj(plo,iseg,traj,Axle,q)

    set_plot_standards
    
    % line
    if( ~isfield(plo,'line') )
      plo.line = struct([]);
    end
    nline = length(plo.line)+1;
    plo.line(nline).h = ...
      line('Parent'        ,plo.h_axes(1) ...
          ,'XData'         ,traj.(Axle).sdistvec ...
          ,'YData'         ,traj.avec ...
          ,'Color'         ,PlotStandards.Farbe{nline} ...
          ,'Marker'        ,'o' ...
          ,'MarkerSize'    ,10 ...
          ,'Visible'       ,'on');
        
   % legend
   tt = sprintf('%s%i',traj.(Axle).legText,iseg);
   plo.clegText = cell_add(plo.clegText,tt);
  
end
