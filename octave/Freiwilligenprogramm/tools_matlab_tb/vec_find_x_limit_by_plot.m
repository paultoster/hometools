function [found,x0,x1] = vec_find_x_limit_by_plot(type,var0,var1,var2)
%
% [found,i0,i1] = vec_find_x_limit_by_plot(0,yvec[,yvecname])
% [found,i0,i1] = vec_find_x_limit_by_plot(0,{yvec0,yvec1,...}[,{yvecname0,yvecname1,...}])
% [found,x0,x1] = vec_find_x_limit_by_plot(1,xvec,yvec[,yvecname])
% [found,x0,x1] = e_data_find_x_limit_by_plot(1,xvec,{yvec0,yvec1,...}[,{yvecname0,yvecname1,...}])
% [found,x0,x1] = e_data_find_x_limit_by_plot(1,{xvec0,xvec1,...},{yvec0,yvec1,...}[,{yvecname0,yvecname1,...}])
%
%   Eingabe der Limit x0, x1 oder  i0,i1 über plot mit den ausgewählten Signalen
%  Parameterliste:
%  0,yvec[,yvecname]                                            Plot plot(yvec)                            Auswahl i0,i1
%  0,{yvec0,yvec1,...}[,{yvecname0,yvecname1,...}]              Plot plot(yvec0,yvec1,...)                 Auswahl i0,i1
%  xvec,yvec                      Plot plot(xvec,yvec)                       Auswahl x0,x1
%  xvec,{yvec0,yvec1,...}         Plot plot(xvec,yvec0,xvec,yvec1,...)       Auswahl x0,x1
  
  set_plot_standards
  found = 0;
  x0 = 0.;
  x1 = 0.;
  
  if( type >= 1 )
    
    type = 1;
    
    if( iscell(var1) )
      cyvec = var1;
    elseif( isnumeric(var1) )
      cyvec = {var1};
    else
      error('Error_%s: zweites Argumet von type=1 muss numerischer Vektor oder cellarray mit numerischen Vektoren sein sein',mfilename);
    end
    
    n = length(cyvec);

    if( iscell(var0) )
      cxvec = var0; 
    elseif( isnumeric(var0) )
      cxvec = {var0};
    else
      error('Error_%s: erstes Argumet von type=1 muss numerischer Vektor sein',mfilename);
    end
    for i= length(cxvec)+1:n
      cxvec{i} = cxvec{length(cxvec)};
    end
    
    if( exist('var2','var') )
      if( iscell(var2) )
        cyvecname = var2;
      elseif( ischar(var2) )
        cyvecname = {var2};
      else
        cyvecname = {};
      end
    else
      cyvecname = {};
    end
    for i= length(cyvecname)+1:n
      cyvecname{i} = '';
    end
  else
    type = 0;
    if( iscell(var0) )
      cyvec = var0;
    elseif( isnumeric(var0) )
      cyvec = {var0};
    else
      error('Error_%s: erstes Argumet von einem muss numerischer Vektor oder cellarray mit numerischen Vektoren sein sein',mfilename);
    end
    
    n = length(cyvec);
    
    if( exist('var1','var') )
      if( iscell(var1) )
        cyvecname = var1;
      elseif( ischar(var1) )
        cyvecname = {var1};
      else
        cyvecname = {};
      end
    else
      cyvecname = {};
    end
    for i= length(cyvecname)+1:n
      cyvecname{i} = '';
    end
  end    
  
  
  iplot = p_figure(-1,1);
  for i=1:n
    hold on
    if( type == 1 )
      plot(cxvec{i},cyvec{i},'Color',PlotStandards.Farbe{i})
    else
      plot(cyvec{i},'Color',PlotStandards.Farbe{i})
    end
    hold off
  end
  grid on
  legend(cyvecname,'Location','NorthOutside')
  hold on
  fprintf('klicke Anfang und Ende für Star- und Endindex an \n')
  
  [x,~,but] = ginput(1);
  if( but == 1 )
    x0 = x;    
    for i=1:n
      if( type == 1 )
        index=such_index(cxvec{i},x0);
        plot(cxvec{i}(index),cyvec{i}(index),'go')
      else
        index = min(length(cyvec{i},max(1,round(x0))));
        plot(cyvec{i}(index),'go')
      end
    end
    [x,~,but] = ginput(1);
    if( but == 1 )
      x1 = x;
      for i=1:n
        if( type == 1 )
          index=such_index(cxvec{i},x1);
          plot(cxvec{i}(index),cyvec{i}(index),'go')
        else
          index = min(length(cyvec{i},max(1,round(x1))));
          plot(cyvec{i}(index),'go')
        end
      end
      pause(0.2)
      if( x0 > x1 )
       xi = x0;
       x0 = x1;
       x1 = xi;
      end
      if( type == 0 )
        x0 = min(length(cyvec{i},max(1,round(x0))));
        x1 = min(length(cyvec{i},max(1,round(x1))));
      end
      found = 1;
    end
  end  
  hold off
  close(iplot);

end

