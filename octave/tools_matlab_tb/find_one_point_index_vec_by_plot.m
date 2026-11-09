function [okay,i0]=find_one_point_index_vec_by_plot(vec,titname,index_show)
%
% [okay,i0]=find_one_point_index_vec_by_plot(vec,titname)
% [okay,i0]=find_one_point_index_vec_by_plot(vec,titname,index_show)
% 
% Vektor wird geplottet, Einen Punkt anklicken
%
% index_show     kennzeichnet einen bestimmten Index
%
% mehrere Vektoren als SpaltenVektoren
% [vec1,vec2,vec3...]
%
% okay = 1 gut
% i0     Startindex
% i1     Endindex
  okay = 0;
  i0   = 0;
  [n,m] = size(vec);
  if( n <= 1 )
    error('Vektor für Start-Ende zu suchen zu klein length(vec)=%i',n);
  end
  
  if( ~exist('titname','var') )
    titname = '';
  end
  
  if( exist('index_show','var') )
    index_show_flag = 1;
  else
    index_show_flag = 0;
  end
  
  iplot = figure();
  
  [n,m] = size(vec);
  
  if( index_show_flag )
    if( (index_show < 1) ||(n < index_show) )
      warning('index_show passt nicht zu den Vektoren')
    end
  end
  
  set_plot_standards
  clegnames = {};
  for i=1:m
    if( i > 1 ), hold on; end
    clegnames = cell_add(clegnames,num2str(i));
    plot(vec(:,i),'Color',PlotStandards.Farbe{i});      
    if( i > 1 ), hold off; end
  end
  title(titname)
  legend(clegnames)
  if( index_show_flag )
    for i=1:m
      hold on
      plot(vec(index_show,i),'d','Color',PlotStandards.Farbe{i});      
      hold off
    end    
  end
  grid on
  hold on
  fprintf('klicke einen Punkt für Index an \n')
  
  [x,y,but] = ginput(1);
  if( but == 1 )
    i0 = round(x);
    if( i0 <= 0 )
      i0 = 1;
    elseif( i0 > n )
      i0 = n;
    end
    for ii=1:m
      plot(i0,vec(i0,ii),'go','era','back')
    end
    okay = 1;
  end  
  hold off
  close(iplot);
end


