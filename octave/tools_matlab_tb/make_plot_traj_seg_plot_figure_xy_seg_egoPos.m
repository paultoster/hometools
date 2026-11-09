function  plo = make_plot_traj_seg_plot_figure_xy_seg_egoPos(plo,iseg,egoPos,Axle,q)

    set_plot_standards
    
    % line
    if( ~isfield(plo,'line') )
      plo.line = struct([]);
    end
    nline = length(plo.line)+1;
    
    % wenn zu wenige Punkte dann Marker setzten, damit zu sehen
    %----------------------------------------------------------
    if( strcmp(egoPos.(Axle).marker,'none') && length(egoPos.(Axle).xvec) < 3 )
      egoPos.(Axle).marker = '*';
    end
    
    plo.line(nline).h = ...
      line('Parent'        ,plo.h_axes(1) ...
          ,'XData'         ,egoPos.(Axle).xvec + egoPos.(Axle).offsetX ...
          ,'YData'         ,egoPos.(Axle).yvec + egoPos.(Axle).offsetY ...
          ,'Color'         ,PlotStandards.Farbe{nline} ...
          ,'LineWidth'     ,egoPos.(Axle).lineWidth ...
          ,'LineStyle'     ,egoPos.(Axle).lineStyle ...
          ,'Marker'        ,egoPos.(Axle).marker ...
          ,'MarkerSize'    ,max(1,egoPos.(Axle).marker_size + egoPos.(Axle).marker_size_di * (iseg-1)) ...
          ,'Visible'       ,'on');
        
   % legend
   tt = sprintf('%s%i',egoPos.(Axle).legText,iseg);
   if( (abs(egoPos.(Axle).offsetX) > 0.0005) || (abs(egoPos.(Axle).offsetY) > 0.0005) )
     tt = sprintf('%s(%5.2f,%5.2f)',tt,egoPos.(Axle).offsetX,egoPos.(Axle).offsetY);
   end
   plo.clegText = cell_add(plo.clegText,tt);
  
end
