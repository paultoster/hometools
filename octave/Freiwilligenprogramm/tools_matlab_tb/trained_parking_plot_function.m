function q = trained_parking_plot_function(record,path,q)
%
% plot functions
%
  if( ~check_val_in_struct(record,'n','num',1) )
    
    record.okay = 0;
    
  end
  if( ~check_val_in_struct(path,'nsec','num',1) )
    
    path.okay = 0;
    
  end
  %==========================================================================
  % figure
  %==========================================================================
  % x-y-Plot
  %=========
  q.fig_num          = p_figure(-1,2);
  q.clegText         = {};
  q.i_axes           = 1;
  q.h_axes(q.i_axes) = subplot(1,1,1);


  if( record.okay ),q = plot_function_record_xy(q,record,q.i_axes);end
  if( path.okay ),  q = plot_function_path_xy(q,path,q.i_axes);end

  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' x [m]')
  ylabel(' y [m]')

  legend(q.clegText);
  zaf('forbid')
  %==========================================================================
  % figure
  %==========================================================================
  % x-s, ...-Plot
  %=========
  q.fig_num          = p_figure(-1,2);
  q.clegText         = {};
  q.i_axes           = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,1);
  itype = 1; % x-Vec
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' x [m]')

  % y-s, ...-Plot
  %=========
  q.clegText = {};
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,2);
  itype = 4; % y-Vec
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end
  
  legend(q.clegText);
  q.clegText = {};
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' y [m]')

  % yaw-s, ...-Plot
  %=========
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,3);
  itype = 7; % yaw
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);

  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' yaw [deg]')

  %==========================================================================
  % figure
  %==========================================================================
  % vel-s, ...-Plot
  %=========
  q.fig_num  = p_figure(-1,2);
  q.clegText = {};
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,1);
  itype = 8; % vel
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' vel [km/h]')

  % yaw-tangens-s, ...-Plot
  %=======================
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,2);
  q.clegText = {};
  itype = 9; % yaw-tangens
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' yawtangens [deg]')

  % kappa-s, ...-Plot
  %=======================
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,3);
  q.clegText = {};
  itype = 10; % kappa
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' kappa [1/m]')

  %==========================================================================
  % figure
  %==========================================================================
  % x-s, ...-Plot
  %=========
  q.fig_num          = p_figure(-1,2);
  q.clegText         = {};
  q.i_axes           = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,1);
  itype = 1; % x-Vec
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end
  
  legend(q.clegText);
  
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' x [m]')

  % dxds-s, ...-Plot
  %=========
  q.clegText = {};
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,2);
  itype = 2; % 
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  q.clegText = {};
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' dx/ds [m/m]')

  % d2xds2-s, ...-Plot
  %=========
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,3);
  itype = 3; %
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);

  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' d2x/ds2 [m/m/m]')

  %=======================================================
  % figure
  %==========================================================================
  % y-s, ...-Plot
  %=========
  q.fig_num          = p_figure(-1,2);
  q.clegText         = {};
  q.i_axes           = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,1);
  itype = 4; % y-Vec
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' y [m]')

  % dyds-s, ...-Plot
  %=========
  q.clegText = {};
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,2);
  itype = 5; % 
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  q.clegText = {};
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' dy/ds [m/m]')

  % d2yds2-s, ...-Plot
  %=========
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(3,1,3);
  itype = 6; %
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end
  
  legend(q.clegText);

  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' d2y/ds2 [m/m/m]')


  %==========================================================================
  % figure
  %==========================================================================
  % ds-s, ...-Plot
  %=========
  q.fig_num          = p_figure(-1,2);
  q.clegText         = {};
  q.i_axes           = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(4,1,1);
  itype = 12; % ds-Vec
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' ds [m]')

  % time-s, ...-Plot
  %=========
  q.clegText = {};
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(4,1,2);
  itype = 14; % 
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  q.clegText = {};
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' frict [-]')

  % frict-s, ...-Plot
  %=========
  q.clegText = {};
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(4,1,3);
  itype = 15; % 
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end

  legend(q.clegText);
  q.clegText = {};
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' frictProb [-]')
  
  % frictProb-s, ...-Plot
  %=============
  q.clegText = {};
  q.i_axes   = q.i_axes + 1;
  q.h_axes(q.i_axes) = subplot(4,1,4);
  itype = 16; % 
  if( record.okay ),q = plot_function_record_sf(q,record,q.i_axes,itype);end
  if( path.okay ),  q = plot_function_path_sf(q,path,q.i_axes,itype);end
  legend(q.clegText);
  q.clegText = {};
  set(q.h_axes(q.i_axes),'XGrid','on');
  set(q.h_axes(q.i_axes),'YGrid','on');

  xlabel(' s [m]')
  ylabel(' frictProb [-]')

  figmen
  zaf('set_silent') 
  
end
function q = plot_function_record_xy(q,record,i_axes)
  set_plot_standards
  dx = 0;
  for j=1:record.nsec
    q.line_record_xy(j)  = line('Parent'      ,q.h_axes(i_axes) ...
                               ,'XData'      ,record.secvec(j).xRAvec+dx ...
                               ,'YData'      ,record.secvec(j).yRAvec ...
                               ,'Color'      ,PlotStandards.Mrot ...
                               ,'LineWidth'  ,1 ...
                               ,'LineStyle'  ,'-' ...
                               ,'Marker'     ,'o' ...
                               ,'MarkerSize' ,5 ...
                               ,'Visible'    ,'on');
    dx = dx +20;
    q.clegText = cell_add(q.clegText,sprintf('record%i',j));
  end
end
function q = plot_function_record_sf(q,record,i_axes,k)
%
% k = 1      xvec
%     2      dxds
%     3      d2xds2
%     4      yvec
%     5      dyds
%     6      d2yds2
%     7      yaw
%     8      vel
%     9      yawtangens
%    10      kappa
%    11      dy_record
%    12      ds
%    13      vel
%    14      time
%    15      frict
%    16      frictProb
  set_plot_standards
    
    for j=1:record.nsec
      if( k == 1 )
        yvec = record.secvec(j).xRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)xRAvec%i',j));
      elseif( k == 2 )
        yvec = record.secvec(j).dxdsRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)dxdsRAvec%i',j));
      elseif( k == 3 )
        yvec = record.secvec(j).d2xds2RAvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)d2xds2RAvec%i',j));
      elseif( k == 4 )
        yvec = record.secvec(j).yRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)yRAvec%i',j));
      elseif( k == 5 )
        yvec = record.secvec(j).dydsRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)dydsRAvec%i',j));
      elseif( k == 6 )
        yvec = record.secvec(j).d2yds2RAvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)d2yds2RAvec%i',j));
      elseif( k == 7 )
        yvec = record.secvec(j).yawvec*180/pi;
        q.clegText = cell_add(q.clegText,sprintf('(record)yawvec%i',j));
      elseif( k == 8 )
        yvec = record.secvec(j).velvec*3.6;
        q.clegText = cell_add(q.clegText,sprintf('(record)velvec%i',j));
      elseif( k == 9 )
        yvec = record.secvec(j).yawtangensvec*180/pi;
        q.clegText = cell_add(q.clegText,sprintf('(record)yawtangensRAvec%i',j));
      elseif( k == 10 )
        yvec = record.secvec(j).kappaRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)kappaRAvec%i',j));
      elseif( k == 11 )
        yvec = record.secvec(j).dy_record;
        q.clegText = cell_add(q.clegText,sprintf('(record)dy_record%i',j));
      elseif( k == 12 )
        yvec = record.secvec(j).dsRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)dsRAvec%i',j));
      elseif( k == 13 )
        yvec = record.secvec(j).velvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)velvec%i',j));
      elseif( k == 14 )
        yvec = record.secvec(j).timevec;
        q.clegText = cell_add(q.clegText,sprintf('(record)timevec%i',j));
      elseif( k == 15 )
        yvec = record.secvec(j).frictvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)frictvec%i',j));
      else
        yvec = record.secvec(j).frictProbvec;
        q.clegText = cell_add(q.clegText,sprintf('(record)frictProbvec%i',j));
      end
      q.line_record_sxy(j)  = line('Parent'   ,q.h_axes(i_axes) ...
                             ,'XData'      ,record.secvec(j).svec ...
                             ,'YData'      ,yvec ...
                             ,'Color'      ,PlotStandards.Mrot ...
                             ,'LineWidth'  ,1 ...
                             ,'LineStyle'  ,'-' ...
                             ,'Marker'     ,'.' ...
                             ,'MarkerSize' ,5 ...
                             ,'Visible'    ,'on');

    end
end

function q = plot_function_path_xy(q,path,i_axes)
  set_plot_standards
  for j=1:path.nsec
    q.line_path_xy(j)  = line('Parent'      ,q.h_axes(i_axes) ...
                           ,'XData'      ,path.secvec(j).xRAvec ...
                           ,'YData'      ,path.secvec(j).yRAvec ...
                           ,'Color'      ,PlotStandards.Mgruen ...
                           ,'LineWidth'  ,1 ...
                           ,'LineStyle'  ,'-' ...
                           ,'Marker'     ,'x' ...
                           ,'MarkerSize' ,5 ...
                           ,'Visible'    ,'on');

    q.clegText = cell_add(q.clegText,sprintf('path%i',j));
  end
end
function q = plot_function_path_sf(q,path,i_axes,k)
%
% k = 1      xvec
%     2      dxds
%     3      d2xds2
%     4      yvec
%     5      dyds
%     6      d2yds2
%     7      yaw
%     8      vel
%     9      yawtangens
%    10      kappa
%    11      dy_record
%    12      ds
%    13      vel
%    14      time
%    15      frict
%    16      frictProb
  set_plot_standards
    
    for j=1:path.nsec
      if( k == 1 )
        yvec = path.secvec(j).xRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)xRAvec%i',j));
      elseif( k == 2 )
        yvec = path.secvec(j).dxdsRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)dxdsRAvec%i',j));
      elseif( k == 3 )
        yvec = path.secvec(j).d2xds2RAvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)d2xds2RAvec%i',j));
      elseif( k == 4 )
        yvec = path.secvec(j).yRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)yRAvec%i',j));
      elseif( k == 5 )
        yvec = path.secvec(j).dydsRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)dydsRAvec%i',j));
      elseif( k == 6 )
        yvec = path.secvec(j).d2yds2RAvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)d2yds2RAvec%i',j));
      elseif( k == 7 )
        yvec = path.secvec(j).yawvec*180/pi;
        q.clegText = cell_add(q.clegText,sprintf('(path)yawvec%i',j));
      elseif( k == 8 )
        yvec = path.secvec(j).velvec*3.6;
        q.clegText = cell_add(q.clegText,sprintf('(path)velvec%i',j));
      elseif( k == 9 )
        yvec = path.secvec(j).yawtangensRAvec*180/pi;
        q.clegText = cell_add(q.clegText,sprintf('(path)yawtangensRAvec%i',j));
      elseif( k == 10 )
        yvec = path.secvec(j).kappaRAvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)kappaRAvec%i',j));
      elseif( k == 11 )
        yvec = path.secvec(j).dy_record;
        q.clegText = cell_add(q.clegText,sprintf('(path)dy_record%i',j));
      elseif( k == 12 )
        [~,ds,~]     = vek_2d_s_ds_alpha(path.secvec(j).xRAvec,path.secvec(j).yRAvec);
        yvec = ds;
        q.clegText = cell_add(q.clegText,sprintf('(path)dsRAvec%i',j));
      elseif( k == 13 )
        yvec = path.secvec(j).velvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)velvec%i',j));
      elseif( k == 14 )
        yvec = path.secvec(j).timevec;
        q.clegText = cell_add(q.clegText,sprintf('(path)timevec%i',j));
      elseif( k == 15 )
        yvec = path.secvec(j).frictvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)frictvec%i',j));
      elseif( k == 16 )
        yvec = path.secvec(j).frictProbvec;
        q.clegText = cell_add(q.clegText,sprintf('(path)frictProbvec%i',j));
      end
      q.line_path_sxy(j)  = line('Parent'   ,q.h_axes(i_axes) ...
                             ,'XData'      ,path.secvec(j).sRAvec ...
                             ,'YData'      ,yvec ...
                             ,'Color'      ,PlotStandards.Mgruen ...
                             ,'LineWidth'  ,1 ...
                             ,'LineStyle'  ,'-' ...
                             ,'Marker'     ,'.' ...
                             ,'MarkerSize' ,5 ...
                             ,'Visible'    ,'on');

    end
    
end