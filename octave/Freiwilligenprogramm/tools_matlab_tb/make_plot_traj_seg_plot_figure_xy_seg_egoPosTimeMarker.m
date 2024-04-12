function plo = make_plot_traj_seg_plot_figure_xy_seg_egoPosTimeMarker(plo,iseg,egoPos,Axle,q)

    set_plot_standards
    
    % line
    if( ~isfield(plo,'line') )
      plo.line = struct([]);
    end
    nline = length(plo.line)+1;
%     % find line
%     iline = 0;
%     for i=1:length(plo.line)
%       xdata = get(plo.line(i).h,'XData')';
%       flag_true = vec_compare(xdata,egoPos.(Axle).xvec + egoPos.(Axle).offsetX,0.005);
%       if( flag_true )
%         ydata = get(plo.line(i).h,'YData')';
%         flag_true = vec_compare(ydata,egoPos.(Axle).yvec + egoPos.(Axle).offsetY,0.005);
%         if( flag_true )
%           iline = i;
%           break;
%         end
%       end
%     end
%     if( ~iline )
%       iline = nline;
%     end
    
    [xvec,yvec,tvec] = make_plot_traj_seg_plot_figure_xy_seg_egoPosTimeMarker_get(egoPos,Axle,q.markerEgoDeltaTime);
    
    plo.line(nline).h = ...
      line('Parent'        ,plo.h_axes(1) ...
          ,'XData'         ,xvec ...
          ,'YData'         ,yvec ...
          ,'Color'         ,PlotStandards.Mschwarz ...
          ,'LineWidth'     ,egoPos.(Axle).lineWidth ...
          ,'LineStyle'     ,'none' ...
          ,'Marker'        ,q.markerEgoTime ...
          ,'MarkerSize'    ,20 ...
          ,'Visible'       ,'on');
        
  if( ~isfield(plo,'text') )
    plo.text = [];
  end
  ntext = length(plo.text);
  for i=1:length(tvec)
    ntext = ntext+1;
    plo.text(ntext) = text('Parent',  plo.h_axes(1) ...
                          ,'Position', [double(xvec(i)),double(yvec(i))] ...
                          ,'String',   sprintf(' %10.2f s',tvec(i)) ...
                          ,'FontSize', 12 ...
                          ,'Color',    PlotStandards.Mschwarz);
  end
     
end
