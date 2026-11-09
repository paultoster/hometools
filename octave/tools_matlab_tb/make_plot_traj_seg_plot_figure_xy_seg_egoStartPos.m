function plo = make_plot_traj_seg_plot_figure_xy_seg_egoStartPos(plo,iseg,egoPos,Axle,q)

    set_plot_standards
    
    % line
    if( ~isfield(plo,'line') )
      plo.line = struct([]);
    end
    nline = length(plo.line)+1;
    % find line
    iline = 0;
    for i=1:length(plo.line)
      xdata = get(plo.line(i).h,'XData')';
      flag_true = vec_compare(xdata,egoPos.(Axle).xvec + egoPos.(Axle).offsetX,0.005);
      if( flag_true )
        ydata = get(plo.line(i).h,'YData')';
        flag_true = vec_compare(ydata,egoPos.(Axle).yvec + egoPos.(Axle).offsetY,0.005);
        if( flag_true )
          iline = i;
          break;
        end
      end
    end
    if( ~iline )
      iline = nline;
    end
    
    plo.line(nline).h = ...
      line('Parent'        ,plo.h_axes(1) ...
          ,'XData'         ,egoPos.(Axle).xvec(1) + egoPos.(Axle).offsetX ...
          ,'YData'         ,egoPos.(Axle).yvec(1) + egoPos.(Axle).offsetY ...
          ,'Color'         ,PlotStandards.Farbe{iline} ...
          ,'LineWidth'     ,egoPos.(Axle).lineWidth ...
          ,'LineStyle'     ,'none' ...
          ,'Marker'        ,q.markerEgoPosStart ...
          ,'MarkerSize'    ,20 ...
          ,'Visible'       ,'on');
end
