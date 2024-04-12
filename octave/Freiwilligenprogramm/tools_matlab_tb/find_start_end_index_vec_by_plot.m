function [okay,i0,i1]=find_start_end_index_vec_by_plot(vec,titname)
%
% [okay,i0,i1]=find_start_end_index_vec_by_plot(vec,[titname])
% 
% Vektor wird geplottet, Start- und Endindex anklicken
% cvec ist ein cellaray mit Vektoren
%
% mehrere Vektoren als SpaltenVektoren
% [vec1,vec2,vec3...]
%
% okay = 1 gut
% i0     Startindex
% i1     Endindex
  okay = 0;
  i0   = 0;
  i1   = 0;
  [n,m] = size(vec);
  if( n <= 1 )
    error('Vektor für Start-Ende zu suchen zu klein length(vec)=%i',n);
  end
  if( ~exist('titname','var') )
    titname = '';
  end
  iplot = figure();
  
  [n,m] = size(vec);
  
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
  grid on
  hold on
  fprintf('klicke Anfang und Ende für Star- und Endindex an \n')
  
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
    [x,y,but] = ginput(1);
    if( but == 1 )
      i1 = round(x);
      if( i1 <= 0 )
        i1 = 1;
      elseif( i1 > n )
        i1 = n;
      end
      for ii=1:m
        plot(i1,vec(i1,ii),'go','era','back')
      end
      pause(0.2)
      if( i0 > i1 )
       ii = i0;
       i0 = i1;
       i1 = ii;
      end
      okay = 1;
    end
  end  
  hold off
  close(iplot);
end


