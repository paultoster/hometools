function q = make_plot_traj_seg_plot_each_figure_xy(seg,nseg,q)

  for iseg = 1:nseg
    
    if( iseg <= q.plotNMax )

      q.fig_num       = q.fig_num + 1;
      q.nplo          = q.nplo + 1;

      clear plo
      plo.h_figure    = p_figure(q.fig_num,q.dina4,sprintf('PlotXY_%i',iseg));
      plo.clegText    = {};
      plo.h_axes(1)   = subplot(1,1,1);

      % plot with legend
      plo = make_plot_traj_seg_plot_figure_xy_seg(plo,seg,iseg,q);


      legend(plo.clegText,'Location','NorthEastOutside')

      % plot with out legend  
      plo = make_plot_traj_seg_plot_figure_wol_xy_seg(plo,seg,iseg,q);

      xLimits = get(gca,'XLim');  
      yLimits = get(gca,'YLim'); 

      xText = xLimits(1) + (xLimits(2)-xLimits(1)) * 0.15;
      yText = yLimits(2) - (yLimits(2)-yLimits(1)) * 0.15;
      dy    = (yLimits(2)-yLimits(1)) * 0.025;
      text(xText,yText,sprintf('tstart = %f s',seg(iseg).tStart));
      text(xText,yText-dy,sprintf('tend = %f s',seg(iseg).tEnd));

      xlabel('x [m]')
      ylabel('y [m]')

      grid on

      if( q.axisEqual )
        axis('equal');
      end

      q.plo(q.nplo) = plo;
    end
  end
end

    
%     q.fig_numXY   = q.fig_num;
%     nend                      = q.nseg;
%     
%     if( q.numberSPlot )
%       q.nplotS = 0;
%       for i=1:q.numberSPlot
%         q.fig_num                       = q.fig_num + 1;
%         q.fig_numS(i)                   = q.fig_num;
%         q.nplotS                        = q.nplotS + 1;
%         q.plotS(q.nplotS).h_plotS    = p_figure(q.fig_numS,q.dina4,'onePlotS');
%         q.plotS(q.nplotS).clegTextS  = {};
%         q.plotS(q.nplotS).h_axes(1)  = subplot(3,1,1);
%       end
%     end
%     if( q.numberSVelPlot )
%       q.nplotSV = 1;
%       q.fig_num                       = q.fig_num + 1;
%       q.fig_numSV(i)                  = q.fig_num;
%       q.nplotSV                        = q.nplotS + 1;
%       q.plotSV(q.nplotSV).h_plotSV    = p_figure(q.fig_numSV,q.dina4,'onePlotS');
%       q.plotSV(q.nplotSV).clegTextS  = {};
%       q.plotSV(q.nplotSV).h_axes(1)  = subplot(3,1,1);
%     end
%   
% 
%     
%   else
%     nend          = min(q.nseg,q.p.plotNMax);
%     q.nplot       = nend;
%     if( q.numberSPlot )
%       q.nplotS    = min(q.nseg,q.p.plotNMax);
%     end
%   end
%   
%   for iseg = 1:nend
% 
%     % jedes Segment ein Plot
%     if( ~q.p.oneFigure ) 
%       q.fig_num   = q.fig_num + 1;
%       q.fig_numXY   = q.fig_num;
%            
%       q.plot(iseg).h_plot    = p_figure(q.fig_numXY,q.dina4,sprintf('seg%i',iseg)); 
%       q.plot(iseg).clegText  = {};
%       q.plot(iseg).h_axes(1) = subplot(1,1,1);
%       iplot                  = iseg;
%       
%     else
%       q.plot(1).clegText = {};
%       iplot              = 1;
%       
%     end
%     
%     % Trajektorie
%     %======================================================================
%     for itraj = 1:length(q.seg(iseg).traj)
%       [q] = make_plot_traj_seg_plot_mane_line_traj(q,iseg,itraj,iplot); 
%       if( itraj == 1 )
%         [q] = make_plot_traj_seg_plot_mane_line_traj_time_text(q,iseg,itraj,iplot);
%       end
%     end
%     if( (q.p.numOfTraj > 1) && (q.p.traj_minp.flagPlot || q.p.traj_sinp.flagPlot || q.p.traj_sraw.flagPlot || q.p.traj_straj.flagPlot) )      
%       title('index 1 is new trajectory')
%     end
%     % vehPose
%     %======================================================================
%     if( q.seg(iseg).vehPose.flagPlot )
%       [q] = make_plot_traj_seg_plot_mane_line_pose(q,iseg,'vehPose',iplot); 
%     end
%     % vehPoseRA
%     %======================================================================
%     if( q.seg(iseg).vehPoseRA.flagPlot )
%       [q] = make_plot_traj_seg_plot_mane_line_pose(q,iseg,'vehPoseRA',iplot); 
%     end
%     
%     % Intersection
%     %======================================================================
%     if( q.seg(iseg).actInter.flagPlot )
%       [q] = make_plot_traj_seg_plot_mane_line_pose(q,iseg,'actInter',iplot); 
%     end
%     
%     
%     % xlim/ylim
%     %======================================================================
%     if( ~q.p.oneFigure && q.p.limOverAll) 
%         xlim([q.p.limXMin,q.p.limXMax])
%         ylim([q.p.limYMin,q.p.limYMax])
%     end
%     
%     
%     % legend
%     %======================================================================
%     if( q.p.oneFigure ) 
%       legend(q.plot(iplot).clegText,'Location','NorthEastOutside')
%     else
%       legend(q.plot(iplot).clegText,'Location','NorthEastOutside')
%     end
%     
%     xlabel('x [m]')
%     ylabel('y [m]')
%     grid on
%     if( q.p.limOverAll )
%       xlim([q.p.limXMin,q.p.limXMax]);
%       ylim([q.p.limYMin,q.p.limYMax]);
%     end
%     if( q.p.axisEqual )
%       axis('equal');
%     end
%     
%     %======================================================================
%     % Über s-Plot
%     %======================================================================
%     iplotS = 0;
%     q.nplotS = 0;
%     q.plotS  = [];
%     for itrajS=1:q.numberSPlot
%       
%       if( ~q.p.oneFigure ) 
%         ii = mod(itrajS,3);
%         if( ii == 1 )
%           iplotS                     = iplotS + 1;
%           isubplotS                  = 1;
%           q.fig_num                  = q.fig_num + 1;
%           q.fig_numS(iplotS)         = q.fig_num;
%           q.plotS(iplotS).h_plotS    = p_figure(q.fig_numS(iplotS),q.dina4,sprintf('Sseg%i',iseg));
%         else
%           isubplotS                  = isubplotS + 1;
%         end
%         q.plotS(iplotS).clegText{isubplotS}  = {};
%         q.plotS(iplotS).h_axes(isubplotS)    = subplot(3,1,isubplotS);
%         q.nplotS = iplotS;
%       end
%     
%       [q] = make_plot_traj_seg_plot_mane_line_straj(q,iseg,itrajS,iplotS,isubplotS);
%       
%       % vehPose
%       %======================================================================
%       if( q.seg(iseg).vehPoseXS.flagPlot && strcmp(q.seg(iseg).straj(itrajS).name,'x') )
%         [q] = make_plot_traj_seg_plot_mane_line_pose_s(q,iseg,'vehPoseXS',iplotS,isubplotS); 
%       end
%       if( q.seg(iseg).vehPoseYS.flagPlot && strcmp(q.seg(iseg).straj(itrajS).name,'y') )
%         [q] = make_plot_traj_seg_plot_mane_line_pose_s(q,iseg,'vehPoseYS',iplotS,isubplotS); 
%       end
%     
%       % legend
%       %======================================================================
%       if( q.p.oneFigure ) 
%         legend(q.plotS(iplotS).clegText{isubplotS},'Location','NorthEastOutside')
%       else
%         legend(q.plotS(iplotS).clegText{isubplotS},'Location','NorthEastOutside')
%       end
%       
%       xlabel('s [m]')
%       if( ~isempty(q.seg(iseg).straj(itrajS).unit) )
%         ylabel(sprintf('[%s]',q.seg(iseg).straj(itrajS).unit))
%       end
%     
%       grid on
%       if( q.p.limOverAll )
%         xlim([q.p.limSMin,q.p.limSMax]);
%         ylim([q.p.limSTrajMin(itrajS),q.p.limSTrajMax(itrajS)]);
%       end
%             
%     end
%     
%     %======================================================================
%     % Über sv-Plot
%     %======================================================================
%     iplotSV = 0;
%     q.nplotSV = 0;
%     q.plotSV  = [];
%     for itrajSV=1:q.numberSVPlot
%       
%       if( ~q.p.oneFigure ) 
%         ii = mod(itrajSV,3);
%         if( ii == 1 )
%           iplotSV                    = iplotSV + 1;
%           isubplotSV                 = 1;
%           q.fig_num                  = q.fig_num + 1;
%           q.fig_numSV(iplotSV)       = q.fig_num;
%           q.plotSV(iplotSV).h_plotSV = p_figure(q.fig_numSV(iplotSV),q.dina4,sprintf('SVseg%i',iseg));
%         else
%           isubplotSV                  = isubplotSV + 1;
%         end
%         q.plotSV(iplotSV).clegText{isubplotSV}  = {};
%         q.plotSV(iplotSV).h_axes(isubplotSV)    = subplot(3,1,isubplotSV);
%         q.nplotSV = iplotSV;
%       end
%     
%       [q] = make_plot_traj_seg_plot_mane_line_svtraj(q,iseg,itrajSV,iplotSV,isubplotSV);
%       
%       % vehPose
%       %======================================================================
%       if( q.seg(iseg).vehPoseXS.flagPlot && strcmp(q.seg(iseg).svtraj(itrajSV).name,'x') )
%         [q] = make_plot_traj_seg_plot_mane_line_pose_sv(q,iseg,'vehPoseXS',iplotSV,isubplotSV); 
%       end
%       if( q.seg(iseg).vehPoseYS.flagPlot && strcmp(q.seg(iseg).svtraj(itrajSV).name,'y') )
%         [q] = make_plot_traj_seg_plot_mane_line_pose_sv(q,iseg,'vehPoseYS',iplotSV,isubplotSV); 
%       end
%     
%       % legend
%       %======================================================================
%       if( q.p.oneFigure ) 
%         legend(q.plotSV(iplotSV).clegText{isubplotSV},'Location','NorthEastOutside')
%       else
%         legend(q.plotSV(iplotSV).clegText{isubplotSV},'Location','NorthEastOutside')
%       end
%       
%       xlabel('s [m]')
%       if( ~isempty(q.seg(iseg).svtraj(itrajSV).unit) )
%         ylabel(sprintf('[%s]',q.seg(iseg).svtraj(itrajSV).unit))
%       end
%     
%       grid on
%       if( q.p.limOverAll )
%         xlim([q.p.limSMin,q.p.limSMax]);
%         ylim([q.p.limSTrajMin(itrajSV),q.p.limSTrajMax(itrajSV)]);
%       end
%             
%     end
%     % Senkrechtstriche für start ZeitPunkt
%     if( ~q.p.oneFigure )
%       for iplotS = 1:length(q.plotS)
%         for isubplotS = 1:length(q.plotS(iplotS).h_axes)
%           [q] = make_plot_traj_seg_plot_mane_line_straj_x0(q,iplotS,isubplotS);
%         end
%       end
%     end
%     % Senkrechtstriche für start ZeitPunkt
%     if( ~q.p.oneFigure )
%       for iplotSV = 1:length(q.plotSV)
%         for isubplotSV = 1:length(q.plotSV(iplotSV).h_axes)
%           [q] = make_plot_traj_seg_plot_mane_line_svtraj_x0(q,iplotSV,isubplotSV);
%         end
%       end
%     end
%     
%     if( q.p.oneFigure ) 
%       figure(q.plot(iplot).h_plot);
%     else
%       figure(q.plot(iplot).h_plot);
%     end
%     
%     if( q.p.pauseTime > 0.001 )
%       pause(q.p.pauseTime);
%     end
%     
%   end
%   
%   if( q.p.oneFigure && q.p.limOverAll) 
%     if( q.p.limOverAll )
%       xlim([q.p.limXMin,q.p.limXMax])
%       ylim([q.p.limYMin,q.p.limYMax])
%     end
%   end
% 
%   
%   if( ~q.p.oneFigure ) 
%     figmen
%   end
% end
% function q = make_plot_traj_seg_plot_set_limits(q)
% 
%   q.p.limXMin = 1e30;
%   q.p.limXMax = -1e30;
%   q.p.limYMin = q.p.limXMin;
%   q.p.limYMax = q.p.limXMax;
%   
%   for iseg = 1:min(q.nseg,q.p.plotNMax)
%     for itraj = 1:length(q.seg(iseg).traj)
%       if( ~isempty(q.seg(iseg).traj(itraj).xVec) )
%         q.p.limXMin = min(q.p.limXMin,min(q.seg(iseg).traj(itraj).xVec));
%         q.p.limXMax = max(q.p.limXMax,max(q.seg(iseg).traj(itraj).xVec));
%       end
%       if( ~isempty(q.seg(iseg).traj(itraj).yVec) )
%         q.p.limYMin = min(q.p.limYMin,min(q.seg(iseg).traj(itraj).yVec));
%         q.p.limYMax = max(q.p.limYMax,max(q.seg(iseg).traj(itraj).yVec));
%       end
%     end
%   end
%   
%   % Aufrunden auf Meter
%   q.p.limXMin = floor(q.p.limXMin);
%   q.p.limXMax = ceil(q.p.limXMax);
%   q.p.limYMin = floor(q.p.limYMin);
%   q.p.limYMax = ceil(q.p.limYMax);
% end
% function q = make_plot_traj_seg_plot_set_limits_S(q)
% 
%   q.p.limSMin = 1e30;
%   q.p.limSMax = -1e30;
%   
%   q.p.limSTrajMin = ones(length(q.seg(1).straj),1)*1e30;
%   q.p.limSTrajMax = ones(length(q.seg(1).straj),1)*(-1e30);
%   
%   for iseg = 1:min(q.nseg,q.p.plotNMax)
%     if( q.seg(iseg).vehPoseS.flag )
%       q.p.limSMin = min(q.p.limSMin,min(q.seg(iseg).vehPoseS.sVec));
%       q.p.limSMax = max(q.p.limSMax,max(q.seg(iseg).vehPoseS.sVec));
%     end
%     for j=1:length(q.seg(iseg).straj)
%       if( ~isempty(q.seg(iseg).straj(j).xVec) )
%         q.p.limSMin = min(q.p.limSMin,min(q.seg(iseg).straj(j).xVec));
%         q.p.limSMax = max(q.p.limSMax,max(q.seg(iseg).straj(j).xVec));
%       end
%       q.p.limSTrajMin(j) = min(q.p.limSTrajMin(j),min(q.seg(iseg).straj(j).yVec));
%       q.p.limSTrajMax(j) = max(q.p.limSTrajMax(j),max(q.seg(iseg).straj(j).yVec));
%       
%     end
%     
%   end
%   
%   % Aufrunden auf Meter
%   q.p.limSMin = floor(q.p.limSMin);
%   q.p.limSMax = ceil(q.p.limSMax);
% %   for j=1:length(q.seg(iseg).straj)
% %     q.p.limSTrajMin(j) = floor(q.p.limSTrajMin(j));
% %     q.p.limSTrajMax(j) = ceil(q.p.limSTrajMax(j));
% %   end
% end
% function  [q] = make_plot_traj_seg_plot_mane_line_traj(q,iseg,itraj,iplot)
% 
%   set_plot_standards
%   
%   % ein plotWindow
%   if( q.p.oneFigure )
%     
%     if( iseg == 1 )
%       q.plot(iplot).line_traj(itraj).h_line = [];
%     else
%       n = length(q.plot(iplot).line_traj(itraj).h_line);
%       for i = 1:n
%         delete(q.plot(iplot).line_traj(itraj).h_line(i));
%       end
%     end
%     n = min(iseg,q.p.numOfTraj);
%     for i=n:-1:1
%       iiseg = iseg - i + 1;
%       q.plot(iplot).line_traj(itraj).h_line(i) = line('Parent'   ,q.plot(iplot).h_axes(1) ...
%             ,'XData'         ,q.seg(iiseg).traj(itraj).xVec+q.seg(iiseg).traj(itraj).offsetX ...
%             ,'YData'         ,q.seg(iiseg).traj(itraj).yVec+q.seg(iiseg).traj(itraj).offsetY ...
%             ,'Color'         ,PlotStandards.Farbe{i} ...
%             ,'LineWidth'     ,q.seg(iiseg).traj(itraj).lineWidth ...
%             ,'LineStyle'     ,q.seg(iiseg).traj(itraj).lineStyle ...
%             ,'Marker'        ,q.seg(iiseg).traj(itraj).marker ...
%             ,'MarkerSize'    ,max(1,q.seg(iiseg).traj(itraj).marker_size + q.seg(iiseg).traj(itraj).marker_size_di * (i-1)) ...
%             ,'Visible'       ,'on');
%       tt = sprintf('%s%i',q.seg(iiseg).traj(itraj).legText,i);
%       if( (abs(q.seg(iiseg).traj(itraj).offsetX) > 0.0005) || (abs(q.seg(iiseg).traj(itraj).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).traj(itraj).offsetX,q.seg(iiseg).traj(itraj).offsetY);
%       end
%       q.plot(iplot).clegText = cell_add(q.plot(iplot).clegText,tt);
%     end
%     
%   % not one window
%   else
%     n = min(iseg,q.p.numOfTraj);
%     for i=n:-1:1
%       iiseg = iseg - i + 1;
%       q.plot(iplot).line_traj(itraj).h_line(i) = line ...
%                                       ('Parent'     ,q.plot(iplot).h_axes(1)...
%                                       ,'XData'      ,q.seg(iiseg).traj(itraj).xVec+q.seg(iiseg).traj(itraj).offsetX ...
%                                       ,'YData'      ,q.seg(iiseg).traj(itraj).yVec+q.seg(iiseg).traj(itraj).offsetY ...
%                                       ,'Color'      ,PlotStandards.Farbe{i} ...
%                                       ,'LineWidth'  ,q.seg(iiseg).traj(itraj).lineWidth ...
%                                       ,'LineStyle'  ,q.seg(iiseg).traj(itraj).lineStyle ...
%                                       ,'Marker'     ,q.seg(iiseg).traj(itraj).marker ...
%                                       ,'MarkerSize' ,max(1,q.seg(iiseg).traj(itraj).marker_size + q.seg(iiseg).traj(itraj).marker_size_di * (i-1)) ...
%                                       ,'Visible'    ,'on');
% 
%       tt = sprintf('%s%i',q.seg(iiseg).traj(itraj).legText,i);
%       if( (abs(q.seg(iiseg).traj(itraj).offsetX) > 0.0005) || (abs(q.seg(iiseg).traj(itraj).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).traj(itraj).offsetX,q.seg(iiseg).traj(itraj).offsetY);
%       end
%       q.plot(iplot).clegText = cell_add(q.plot(iplot).clegText,tt);
%             
%     end
%   end
% 
%       
% end
% % function  [q] = make_plot_traj_seg_plot_mane_line_traj_s(q,iseg,itraj,iplot)
% % 
% %   set_plot_standards
% %   
% %   % ein plotWindow
% %   if( q.p.oneFigure )
% %     
% %     if( iseg == 1 )
% %       q.plot(iplot).line_traj(itraj).h_line = [];
% %     else
% %       n = length(q.plot(iplot).line_traj(itraj).h_line);
% %       for i = 1:n
% %         delete(q.plot(iplot).line_traj(itraj).h_line(i));
% %       end
% %     end
% %     n = min(iseg,q.p.numOfTraj);
% %     for i=n:-1:1
% %       iiseg = iseg - i + 1;
% %       q.plot(iplot).line_traj(itraj).h_line(i) = line('Parent'   ,q.plot(iplot).h_axes(1) ...
% %             ,'XData'         ,q.seg(iiseg).traj(itraj).xVec+q.seg(iiseg).traj(itraj).offsetX ...
% %             ,'YData'         ,q.seg(iiseg).traj(itraj).yVec+q.seg(iiseg).traj(itraj).offsetY ...
% %             ,'Color'         ,PlotStandards.Farbe{i} ...
% %             ,'LineWidth'     ,q.seg(iiseg).traj(itraj).lineWidth ...
% %             ,'LineStyle'     ,q.seg(iiseg).traj(itraj).lineStyle ...
% %             ,'Marker'        ,q.seg(iiseg).traj(itraj).marker ...
% %             ,'MarkerSize'    ,max(1,q.seg(iiseg).traj(itraj).marker_size + q.seg(iiseg).traj(itraj).marker_size_di * (i-1)) ...
% %             ,'Visible'       ,'on');
% %       tt = sprintf('%s%i',q.seg(iiseg).traj(itraj).legText,i);
% %       if( (abs(q.seg(iiseg).traj(itraj).offsetX) > 0.0005) || (abs(q.seg(iiseg).traj(itraj).offsetY) > 0.0005) )
% %         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).traj(itraj).offsetX,q.seg(iiseg).traj(itraj).offsetY);
% %       end
% %       q.plot(iplot).clegText = cell_add(q.plot(iplot).clegText,tt);
% %     end
% %     
% %   % not one window
% %   else
% %     n = min(iseg,q.p.numOfTraj);
% %     for i=n:-1:1
% %       iiseg = iseg - i + 1;
% %       q.plot(iplot).line_traj(itraj).h_line(i) = line ...
% %                                       ('Parent'     ,q.plot(iplot).h_axes(1)...
% %                                       ,'XData'      ,q.seg(iiseg).traj(itraj).xVec+q.seg(iiseg).traj(itraj).offsetX ...
% %                                       ,'YData'      ,q.seg(iiseg).traj(itraj).yVec+q.seg(iiseg).traj(itraj).offsetY ...
% %                                       ,'Color'      ,PlotStandards.Farbe{i} ...
% %                                       ,'LineWidth'  ,q.seg(iiseg).traj(itraj).lineWidth ...
% %                                       ,'LineStyle'  ,q.seg(iiseg).traj(itraj).lineStyle ...
% %                                       ,'Marker'     ,q.seg(iiseg).traj(itraj).marker ...
% %                                       ,'MarkerSize' ,max(1,q.seg(iiseg).traj(itraj).marker_size + q.seg(iiseg).traj(itraj).marker_size_di * (i-1)) ...
% %                                       ,'Visible'    ,'on');
% % 
% %       tt = sprintf('%s%i',q.seg(iiseg).traj(itraj).legText,i);
% %       if( (abs(q.seg(iiseg).traj(itraj).offsetX) > 0.0005) || (abs(q.seg(iiseg).traj(itraj).offsetY) > 0.0005) )
% %         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).traj(itraj).offsetX,q.seg(iiseg).traj(itraj).offsetY);
% %       end
% %       q.plot(iplot).clegText = cell_add(q.plot(iplot).clegText,tt);
% %             
% %     end
% %   end
% % 
% %       
% % end
% function  [q] = make_plot_traj_seg_plot_mane_line_traj_time_text(q,iseg,itraj,iplot)
% 
%   set_plot_standards
%   % ein plotWindow
%   if( q.p.oneFigure )
%     
%     if( isfield(q.plot(iplot),'h_text_time') && ~isempty(q.plot(iplot).h_text_time) )
%       delete(q.plot(iplot).h_text_time)
%     end
%     x_pos           = q.seg(iseg).traj(itraj).xVec(1)+q.seg(iseg).traj(itraj).offsetX;
%     y_pos           = q.seg(iseg).traj(itraj).yVec(1)+q.seg(iseg).traj(itraj).offsetY;
%     
%     q.plot(iplot).h_text_time = text('Parent',   q.plot(iplot).h_axes(1)...
%                           ,'Position', [double(x_pos),double(y_pos)] ...
%                           ,'String',   sprintf('time = %f s',q.seg(iseg).tStart) ...
%                           ,'Color',    PlotStandards.Farbe{itraj});
%     
%   % not one window                                  
%   else
%     x_pos           = q.seg(iseg).traj(itraj).xVec(1)+q.seg(iseg).traj(itraj).offsetX;
%     y_pos           = q.seg(iseg).traj(itraj).yVec(1)+q.seg(iseg).traj(itraj).offsetY;
%     
%     q.plot(iplot).h_text_time = text('Parent',   q.plot(iplot).h_axes(1) ...
%                                     ,'Position', [double(x_pos),double(y_pos)] ...
%                                     ,'String',   sprintf('time = %f s',q.seg(iseg).tStart) ...
%                                     ,'Color',    PlotStandards.Farbe{itraj});
%   end
% end
% 
% function [q] = make_plot_traj_seg_plot_mane_line_straj(q,iseg,itrajS,iplotS,isubplotS)
% 
%   set_plot_standards
%   
%   % ein plotWindow
%   if( q.p.oneFigure )
%     
%     if( iseg == 1 )
%       q.plotS(iplotS).line_straj(itrajS).h_line = [];
%     else
%       n = length(q.plotS(iplotS).line_straj(itrajS).h_line);
%       for i = 1:n
%         delete(q.plotS(iplotS).line_straj(itrajS).h_line(i));
%       end
%     end
%     n = min(iseg,q.p.numOfSTraj);
%     for i=n:-1:1
%       iiseg = iseg - i + 1;
%       q.plotS(iplotS).line_straj(itrajS).h_line(i) = line('Parent'   ,q.plotS(iplotS).h_axes(isubplotS) ...
%             ,'XData'         ,q.seg(iiseg).straj(itrajS).xVec+q.seg(iiseg).straj(itrajS).offsetX ...
%             ,'YData'         ,q.seg(iiseg).straj(itrajS).yVec+q.seg(iiseg).straj(itrajS).offsetY ...
%             ,'Color'         ,PlotStandards.Farbe{i} ...
%             ,'LineWidth'     ,q.seg(iiseg).straj(itrajS).lineWidth ...
%             ,'LineStyle'     ,q.seg(iiseg).straj(itrajS).lineStyle ...
%             ,'Marker'        ,q.seg(iiseg).straj(itrajS).marker ...
%             ,'MarkerSize'    ,max(1,q.seg(iiseg).straj(itrajS).marker_size + q.seg(iiseg).straj(itrajS).marker_size_di * (i-1)) ...
%             ,'Visible'       ,'on');
%       tt = sprintf('%s%i',q.seg(iiseg).straj(itrajS).legText,i);
%       if( (abs(q.seg(iiseg).straj(itrajS).offsetX) > 0.0005) || (abs(q.seg(iiseg).straj(itrajS).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).straj(itrajS).offsetX,q.seg(iiseg).straj(itrajS).offsetY);
%       end
%       q.plotS(iplotS).clegText{isubplotS} = cell_add(q.plotS(iplotS).clegText{isubplotS},tt);
%     end
%     
%   % not one window
%   else
%     n = min(iseg,q.p.numOfTraj);
%     for i=n:-1:1
%       iiseg = iseg - i + 1;
%       q.plotS(iplotS).line_straj(itrajS).h_line(i) = line ...
%                                       ('Parent'     ,q.plotS(iplotS).h_axes(isubplotS)...
%                                       ,'XData'      ,q.seg(iiseg).straj(itrajS).xVec+q.seg(iiseg).straj(itrajS).offsetX ...
%                                       ,'YData'      ,q.seg(iiseg).straj(itrajS).yVec+q.seg(iiseg).straj(itrajS).offsetY ...
%                                       ,'Color'      ,PlotStandards.Farbe{i} ...
%                                       ,'LineWidth'  ,q.seg(iiseg).straj(itrajS).lineWidth ...
%                                       ,'LineStyle'  ,q.seg(iiseg).straj(itrajS).lineStyle ...
%                                       ,'Marker'     ,q.seg(iiseg).straj(itrajS).marker ...
%                                       ,'MarkerSize' ,max(1,q.seg(iiseg).straj(itrajS).marker_size + q.seg(iiseg).straj(itrajS).marker_size_di * (i-1)) ...
%                                       ,'Visible'    ,'on');
% 
%       tt = sprintf('%s%i',q.seg(iiseg).straj(itrajS).legText,i);
%       if( (abs(q.seg(iiseg).straj(itrajS).offsetX) > 0.0005) || (abs(q.seg(iiseg).straj(itrajS).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).straj(itrajS).offsetX,q.seg(iiseg).straj(itrajS).offsetY);
%       end
%       q.plotS(iplotS).clegText{isubplotS} = cell_add(q.plotS(iplotS).clegText{isubplotS},tt);
%             
%     end
%   end
% 
% end
% function [q] = make_plot_traj_seg_plot_mane_line_svtraj(q,iseg,itrajSV,iplotSV,isubplotSV)
% 
%   set_plot_standards
%   
%   % ein plotWindow
%   if( q.p.oneFigure )
%     
%     if( iseg == 1 )
%       q.plotSV(iplotSV).line_straj(itrajSV).h_line = [];
%     else
%       n = length(q.plotSV(iplotSV).line_svtraj(itrajSV).h_line);
%       for i = 1:n
%         delete(q.plotSV(iplotSV).line_svtraj(itrajSV).h_line(i));
%       end
%     end
%     n = min(iseg,q.p.numOfSVTraj);
%     for i=n:-1:1
%       iiseg = iseg - i + 1;
%       q.plotSV(iplotSV).line_svtraj(itrajSV).h_line(i) = line('Parent'   ,q.plotSV(iplotSV).h_axes(isubplotSV) ...
%             ,'XData'         ,q.seg(iiseg).svtraj(itrajSV).xVec+q.seg(iiseg).svtraj(itrajSV).offsetX ...
%             ,'YData'         ,q.seg(iiseg).svtraj(itrajSV).yVec+q.seg(iiseg).svtraj(itrajSV).offsetY ...
%             ,'Color'         ,PlotStandards.Farbe{i} ...
%             ,'LineWidth'     ,q.seg(iiseg).svtraj(itrajSV).lineWidth ...
%             ,'LineStyle'     ,q.seg(iiseg).svtraj(itrajSV).lineStyle ...
%             ,'Marker'        ,q.seg(iiseg).svtraj(itrajSV).marker ...
%             ,'MarkerSize'    ,max(1,q.seg(iiseg).svtraj(itrajSV).marker_size + q.seg(iiseg).svtraj(itrajSV).marker_size_di * (i-1)) ...
%             ,'Visible'       ,'on');
%       tt = sprintf('%s%i',q.seg(iiseg).svtraj(itrajSV).legText,i);
%       if( (abs(q.seg(iiseg).svtraj(itrajSV).offsetX) > 0.0005) || (abs(q.seg(iiseg).svtraj(itrajSV).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).svtraj(itrajSV).offsetX,q.seg(iiseg).svtraj(itrajSV).offsetY);
%       end
%       q.plotSV(iplotSV).clegText{isubplotSV} = cell_add(q.plotSV(iplotSV).clegText{isubplotSV},tt);
%     end
%     
%   % not one window
%   else
%     n = min(iseg,q.p.numOfTraj);
%     for i=n:-1:1
%       iiseg = iseg - i + 1;
%       q.plotSV(iplotSV).line_svtraj(itrajSV).h_line(i) = line ...
%                                       ('Parent'     ,q.plotSV(iplotSV).h_axes(isubplotSV)...
%                                       ,'XData'      ,q.seg(iiseg).svtraj(itrajSV).xVec+q.seg(iiseg).svtraj(itrajSV).offsetX ...
%                                       ,'YData'      ,q.seg(iiseg).svtraj(itrajSV).yVec+q.seg(iiseg).svtraj(itrajSV).offsetY ...
%                                       ,'Color'      ,PlotStandards.Farbe{i} ...
%                                       ,'LineWidth'  ,q.seg(iiseg).svtraj(itrajSV).lineWidth ...
%                                       ,'LineStyle'  ,q.seg(iiseg).svtraj(itrajSV).lineStyle ...
%                                       ,'Marker'     ,q.seg(iiseg).svtraj(itrajSV).marker ...
%                                       ,'MarkerSize' ,max(1,q.seg(iiseg).svtraj(itrajSV).marker_size + q.seg(iiseg).svtraj(itrajSV).marker_size_di * (i-1)) ...
%                                       ,'Visible'    ,'on');
% 
%       tt = sprintf('%s%i',q.seg(iiseg).svtraj(itrajSV).legText,i);
%       if( (abs(q.seg(iiseg).svtraj(itrajSV).offsetX) > 0.0005) || (abs(q.seg(iiseg).svtraj(itrajSV).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).svtraj(itrajSV).offsetX,q.seg(iiseg).svtraj(itrajSV).offsetY);
%       end
%       q.plotSV(iplotSV).clegText{isubplotSV} = cell_add(q.plotSV(iplotSV).clegText{isubplotSV},tt);
%             
%     end
%   end
% 
% end
% function  [q] = make_plot_traj_seg_plot_mane_line_pose(q,iseg,sname,iplot)
% 
%   set_plot_standards
%   
%   % ein plotWindow
%   if( q.p.oneFigure )
%     
%     if( iseg == 1 )
%       q.plot(iplot).(sname).h_line = [];
%     else
%       n = length(q.plot(iplot).(sname).h_line);
%       for i = 1:n
%         delete(q.plot(iplot).(sname).h_line(i));
%       end
%     end
%     
%     for i=1:min(iseg,q.p.numOfTraj)
%       iiseg = iseg - i + 1;
%       ccc   = q.seg(iiseg).(sname).ccolor{min(i,length(q.seg(iiseg).(sname).ccolor))};
%       q.plot(iplot).(sname).h_line(i) = line('Parent'   ,q.plot(iplot).h_axes(1) ...
%             ,'XData'         ,q.seg(iiseg).(sname).xVec+q.seg(iiseg).(sname).offsetX ...
%             ,'YData'         ,q.seg(iiseg).(sname).yVec+q.seg(iiseg).(sname).offsetY ...
%             ,'Color'         ,ccc ...
%             ,'LineWidth'     ,q.seg(iiseg).(sname).lineWidth ...
%             ,'LineStyle'     ,q.seg(iiseg).(sname).lineStyle ...
%             ,'Marker'        ,q.seg(iiseg).(sname).marker ...
%             ,'MarkerSize'    ,max(1,q.seg(iiseg).(sname).marker_size + q.seg(iiseg).(sname).marker_size_di * (i-1)) ...
%             ,'Visible'       ,'on');
%       tt = sprintf('%s%i',q.seg(iiseg).(sname).legText,i);
%       if( (abs(q.seg(iiseg).(sname).offsetX) > 0.0005) || (abs(q.seg(iiseg).(sname).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).(sname).offsetX,q.seg(iiseg).(sname).offsetY);
%       end
%       q.plot(iplot).clegText = cell_add(q.plot(iplot).clegText,tt);
%     end
%     
%   % not one window
%   else
%     n = min(iseg,q.p.numOfTraj);
%     for i=1:n
%       iiseg = iseg - i + 1;
%       ccc   = q.seg(iiseg).(sname).ccolor{min(i,length(q.seg(iiseg).(sname).ccolor))};
%       q.plot(iplot).(sname).h_line(i) = line ...
%                                       ('Parent'     ,q.plot(iplot).h_axes(1)...
%                                       ,'XData'      ,q.seg(iiseg).(sname).xVec+q.seg(iiseg).(sname).offsetX ...
%                                       ,'YData'      ,q.seg(iiseg).(sname).yVec+q.seg(iiseg).(sname).offsetY ...
%                                       ,'Color'      ,ccc ...
%                                       ,'LineWidth'  ,q.seg(iiseg).(sname).lineWidth ...
%                                       ,'LineStyle'  ,q.seg(iiseg).(sname).lineStyle ...
%                                       ,'Marker'     ,q.seg(iiseg).(sname).marker ...
%                                       ,'MarkerSize' ,max(1,q.seg(iiseg).(sname).marker_size + q.seg(iiseg).(sname).marker_size_di * (i-1)) ...
%                                       ,'Visible'    ,'on');
% 
%       tt = sprintf('%s%i',q.seg(iiseg).(sname).legText,i);
%       if( (abs(q.seg(iiseg).(sname).offsetX) > 0.0005) || (abs(q.seg(iiseg).(sname).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).(sname).offsetX,q.seg(iiseg).(sname).offsetY);
%       end
%       q.plot(iplot).clegText = cell_add(q.plot(iplot).clegText,tt);
%             
%     end
%   end
% 
%       
% end
% function  [q] = make_plot_traj_seg_plot_mane_line_pose_s(q,iseg,sname,iplotS,isubplot)
% 
%   set_plot_standards
%   
%   % ein plotWindow
%   if( q.p.oneFigure )
%     
%     if( iseg == 1 )
%       q.plotS(iplotS).(sname).h_line = [];
%     else
%       n = length(q.plotS(iplotS).(sname).h_line);
%       for i = 1:n
%         delete(q.plotS(iplotS).(sname).h_line(i));
%       end
%     end
%     
%     for i=1:min(iseg,q.p.numOfTraj)
%       iiseg = iseg - i + 1;
%       ccc   = q.seg(iiseg).(sname).ccolor{min(i,length(q.seg(iiseg).(sname).ccolor))};
%       q.plotS(iplotS).(sname).h_line(i) = line('Parent'   ,q.plotS(iplotS).h_axes(isubplot) ...
%             ,'XData'         ,q.seg(iiseg).(sname).xVec+q.seg(iiseg).(sname).offsetX ...
%             ,'YData'         ,q.seg(iiseg).(sname).yVec+q.seg(iiseg).(sname).offsetY ...
%             ,'Color'         ,ccc ...
%             ,'LineWidth'     ,q.seg(iiseg).(sname).lineWidth ...
%             ,'LineStyle'     ,q.seg(iiseg).(sname).lineStyle ...
%             ,'Marker'        ,q.seg(iiseg).(sname).marker ...
%             ,'MarkerSize'    ,max(1,q.seg(iiseg).(sname).marker_size + q.seg(iiseg).(sname).marker_size_di * (i-1)) ...
%             ,'Visible'       ,'on');
%       tt = sprintf('%s%i',q.seg(iiseg).(sname).legText,i);
%       if( (abs(q.seg(iiseg).(sname).offsetX) > 0.0005) || (abs(q.seg(iiseg).(sname).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).(sname).offsetX,q.seg(iiseg).(sname).offsetY);
%       end
%       q.plotS(iplotS).clegText{isubplot} = cell_add(q.plotS(iplotS).clegText{isubplot},tt);
%     end
%     
%   % not one window
%   else
%     n = min(iseg,q.p.numOfTraj);
%     for i=1:n
%       iiseg = iseg - i + 1;
%       ccc   = q.seg(iiseg).(sname).ccolor{min(i,length(q.seg(iiseg).(sname).ccolor))};
%       q.plotS(iplotS).(sname).h_line(i) = line ...
%                                       ('Parent'     ,q.plotS(iplotS).h_axes(isubplot)...
%                                       ,'XData'      ,q.seg(iiseg).(sname).xVec+q.seg(iiseg).(sname).offsetX ...
%                                       ,'YData'      ,q.seg(iiseg).(sname).yVec+q.seg(iiseg).(sname).offsetY ...
%                                       ,'Color'      ,ccc ...
%                                       ,'LineWidth'  ,q.seg(iiseg).(sname).lineWidth ...
%                                       ,'LineStyle'  ,q.seg(iiseg).(sname).lineStyle ...
%                                       ,'Marker'     ,q.seg(iiseg).(sname).marker ...
%                                       ,'MarkerSize' ,max(1,q.seg(iiseg).(sname).marker_size + q.seg(iiseg).(sname).marker_size_di * (i-1)) ...
%                                       ,'Visible'    ,'on');
% 
%       tt = sprintf('%s%i',q.seg(iiseg).(sname).legText,i);
%       if( (abs(q.seg(iiseg).(sname).offsetX) > 0.0005) || (abs(q.seg(iiseg).(sname).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).(sname).offsetX,q.seg(iiseg).(sname).offsetY);
%       end
%       q.plotS(iplotS).clegText{isubplot} = cell_add(q.plotS(iplotS).clegText{isubplot},tt);
%             
%     end
%   end
% 
%       
% end
% function  [q] = make_plot_traj_seg_plot_mane_line_pose_sv(q,iseg,svname,iplotSV,isubplot)
% 
%   set_plot_standards
%   
%   % ein plotWindow
%   if( q.p.oneFigure )
%     
%     if( iseg == 1 )
%       q.plotSV(iplotSV).(svname).h_line = [];
%     else
%       n = length(q.plotSV(iplotSV).(svname).h_line);
%       for i = 1:n
%         delete(q.plotSV(iplotSV).(svname).h_line(i));
%       end
%     end
%     
%     for i=1:min(iseg,q.p.numOfTraj)
%       iiseg = iseg - i + 1;
%       ccc   = q.seg(iiseg).(svname).ccolor{min(i,length(q.seg(iiseg).(svname).ccolor))};
%       q.plotSV(iplotSV).(svname).h_line(i) = line('Parent'   ,q.plotSV(iplotSV).h_axes(isubplot) ...
%             ,'XData'         ,q.seg(iiseg).(svname).xVec+q.seg(iiseg).(svname).offsetX ...
%             ,'YData'         ,q.seg(iiseg).(svname).yVec+q.seg(iiseg).(svname).offsetY ...
%             ,'Color'         ,ccc ...
%             ,'LineWidth'     ,q.seg(iiseg).(svname).lineWidth ...
%             ,'LineStyle'     ,q.seg(iiseg).(svname).lineStyle ...
%             ,'Marker'        ,q.seg(iiseg).(svname).marker ...
%             ,'MarkerSize'    ,max(1,q.seg(iiseg).(svname).marker_size + q.seg(iiseg).(svname).marker_size_di * (i-1)) ...
%             ,'Visible'       ,'on');
%       tt = sprintf('%s%i',q.seg(iiseg).(svname).legText,i);
%       if( (abs(q.seg(iiseg).(svname).offsetX) > 0.0005) || (abs(q.seg(iiseg).(svname).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).(svname).offsetX,q.seg(iiseg).(svname).offsetY);
%       end
%       q.plotSV(iplotS).clegText{isubplot} = cell_add(q.plotS(iplotS).clegText{isubplot},tt);
%     end
%     
%   % not one window
%   else
%     n = min(iseg,q.p.numOfTraj);
%     for i=1:n
%       iiseg = iseg - i + 1;
%       ccc   = q.seg(iiseg).(svname).ccolor{min(i,length(q.seg(iiseg).(svname).ccolor))};
%       q.plotS(iplotS).(svname).h_line(i) = line ...
%                                       ('Parent'     ,q.plotS(iplotS).h_axes(isubplot)...
%                                       ,'XData'      ,q.seg(iiseg).(svname).xVec+q.seg(iiseg).(svname).offsetX ...
%                                       ,'YData'      ,q.seg(iiseg).(svname).yVec+q.seg(iiseg).(svname).offsetY ...
%                                       ,'Color'      ,ccc ...
%                                       ,'LineWidth'  ,q.seg(iiseg).(svname).lineWidth ...
%                                       ,'LineStyle'  ,q.seg(iiseg).(svname).lineStyle ...
%                                       ,'Marker'     ,q.seg(iiseg).(svname).marker ...
%                                       ,'MarkerSize' ,max(1,q.seg(iiseg).(svname).marker_size + q.seg(iiseg).(svname).marker_size_di * (i-1)) ...
%                                       ,'Visible'    ,'on');
% 
%       tt = sprintf('%s%i',q.seg(iiseg).(svname).legText,i);
%       if( (abs(q.seg(iiseg).(svname).offsetX) > 0.0005) || (abs(q.seg(iiseg).(svname).offsetY) > 0.0005) )
%         tt = sprintf('%s(%5.2f,%5.2f)',tt,q.seg(iiseg).(svname).offsetX,q.seg(iiseg).(svname).offsetY);
%       end
%       q.plotS(iplotS).clegText{isubplot} = cell_add(q.plotS(iplotS).clegText{isubplot},tt);
%             
%     end
%   end
% 
%       
% end
% function [q] = make_plot_traj_seg_plot_mane_line_straj_x0(q,iplotS,isubplotS)
% 
%   
% %   dataObjs = get(q.plotS(iplotS).h_axes(isubplotS), 'Children'); 
% %   if( ~isempty(dataObjs) )
%   if( ~isempty(q.plotS(iplotS).line_straj(1).h_line) )
%     xdata    = get(q.plotS(iplotS).line_straj(1).h_line(1), 'XData'); 
%     ydata    = get(q.plotS(iplotS).h_axes(isubplotS),'ylim');
%     q.plotS(iplotS).h_cross_line(isubplotS) = line ...
%                                             ('Parent'     ,q.plotS(iplotS).h_axes(isubplotS)...
%                                             ,'XData'      ,[xdata(1),xdata(1)] ...
%                                             ,'YData'      ,ydata ...
%                                             ,'Color'      ,'k' ...
%                                             ,'LineWidth'  ,1 ...
%                                             ,'LineStyle'  ,'-' ...
%                                             ,'Marker'     ,'none' ...
%                                             ,'MarkerSize' ,10 ...
%                                             ,'Visible'    ,'on');
%   end
% %   end
% end
% function [q] = make_plot_traj_seg_plot_mane_line_svtraj_x0(q,iplotSV,isubplotSV)
% 
%   
% %   dataObjs = get(q.plotSV(iplotSV).h_axes(isubplotSV), 'Children'); 
% %   if( ~isempty(dataObjs) )
%   if( ~isempty(q.plotSV(iplotSV).line_straj(1).h_line) )
%     xdata    = get(q.plotSV(iplotSV).line_straj(1).h_line(1), 'XData'); 
%     ydata    = get(q.plotSV(iplotSV).h_axes(isubplotSV),'ylim');
%     q.plotSV(iplotSV).h_cross_line(isubplotSV) = line ...
%                                             ('Parent'     ,q.plotSV(iplotSV).h_axes(isubplotSV)...
%                                             ,'XData'      ,[xdata(1),xdata(1)] ...
%                                             ,'YData'      ,ydata ...
%                                             ,'Color'      ,'k' ...
%                                             ,'LineWidth'  ,1 ...
%                                             ,'LineStyle'  ,'-' ...
%                                             ,'Marker'     ,'none' ...
%                                             ,'MarkerSize' ,10 ...
%                                             ,'Visible'    ,'on');
%   end
% %   end
% end
