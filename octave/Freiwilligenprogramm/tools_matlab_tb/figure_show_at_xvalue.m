function [okay,p] = figure_show_at_xvalue(p,xvalue,ccolor)
%
% okay = figure_show_at_index(p,xvalueo,color)
%
% okay = figure_show_at_index(p,xvalueo)
%
% Für horizontal und vertikale Linien zu setzen
%   p = figure_add_axis_val(p,hfig,haxis,xvec,yec)
%   p = figure_add_axis_val(p,hfig,haxis)
% Für Vektoren zu plotten Vektor mit cellarrays übergeben
%  p = figure_add_axis_val(p,hfig,haxis,xvec,yec)
% Zeichnet eine Figure (xfigure,yfigure) zum jeweiligen Index mit
% Koordinaten xvec(index) = xvalue,yvec(index),yawvec(index)
%  p = figure_add_axis_val(p,hfig,haxis,xvec,yvec,hline,ccolor,yawvec,xfigure,yfigure)
%
%
%     setzt für eine x-yplotlinie die Achsenwert
%
%       p(i).type      'i'   Am Index wird Balken gesetzt
%                      'v'   vektor plotten am index
%       p(i).hfig      handle figure
%       p(i).haxis     handle axis
%       p(i).hxline    []
%       p(i).hyline    []
%       p(i).hline
%       p(i).linestyle 'none','-', '..', ':', ...   nur p(i).type = 'v'
%       p(i).writeindex 0,1    nur p(i).type = 'v'
%       p(i).marker    'none','*', '+', '<', ...    nur p(i).type = 'v'
%       p(i).xvec      x-Vektor
%       p(i).yvec      y-Vektor
%       p(i).yawvec    yaw-angle-Vektor [rad];
%       p(i).xfigure   Figur;
%       p(i).yfigure   ;
%
%  index => xvec(index)
%
%  ccolor => {r g b}
  use_marker = 1;
  okay = 1;
  n = length(p);
  
  if( ~exist('ccolor','var') )
    ccolor = [];
  end

  for i=1:n
    
    if( i == 33 )
      a = 0;
    end

    if( p(i).type == 'i' )
      if( isempty(p(i).hline) )
        hdata = get(p(i).haxis, 'Children'); %handles to low-level graphics objects in axes
        for (idd=1:size(hdata,1))
          objType = get(hdata(idd), 'Type'); %type of low-level graphics object
          if( strcmp(objType,'line') )
            p(i).hline = [p(i).hline;hdata(idd)];
          end
        end
      end
      % Linie  löschen
      %===========================
      if( ~isempty(p(i).hxline) )
        for k=1:length(p(i).hxline)
          delete(p(i).hxline(k));
        end
      end
      p(i).hxline = [];

      if( ~isempty(p(i).hyline) )
        for k=1:length(p(i).hyline)
          delete(p(i).hyline(k));
        end
      end
      p(i).hyline = [];

      for j=1:length(p(i).hline)

        xdata = get(p(i).hline(j), 'XData'); %data from low-level grahics objects
        ydata = get(p(i).hline(j), 'YData');
        if( isempty(ccolor) )
          ccc = get(p(i).hline(j), 'Color');
        else
          ccc = ccolor;
        end
       
        if( ~isempty(xdata) && ~isempty(ydata) )
          index = such_index(xdata,xvalue);
          
          x_rng = get(p(i).haxis,'Xlim');
          y_rng = get(p(i).haxis,'Ylim');

          xv_x = [xdata(index),xdata(index)];
          yv_x = y_rng;
          xv_y = x_rng;
          yv_y = [ydata(index),ydata(index)];
          
          if( use_marker )
            p(i).hxline(j) = line('Parent',p(i).haxis,'XData',xdata(index),'YData',ydata(index),'Color',ccc,'LineStyle','none','Marker','+','MarkerSize',20,'Tag','x_line');
            p(i).hyline(j) = line('Parent',p(i).haxis,'XData',xdata(index),'YData',ydata(index),'Color',ccc,'LineStyle','none','Marker','+','MarkerSize',20,'Tag','y_line');
          else

            % Linie setzen
            p(i).hxline(j) = line('Parent',p(i).haxis,'XData',xv_x,'YData',yv_x,'Color',ccc,'LineStyle','-','Tag','x_line');
            % Linie setzen
            p(i).hyline(j) = line('Parent',p(i).haxis,'XData',xv_y,'YData',yv_y,'Color',ccc,'LineStyle','-','Tag','y_line');

          end
        end
      end
    elseif( p(i).type == 'v' && ~isempty(p(i).xvec) )
      if( ~isempty(p(i).hline) )
        for ii=1:length(p(i).hline)
          delete(p(i).hline(ii));
        end
        p(i).hline = [];
      end
      index = such_index(p(i).xvec1,xvalue);
      if( ~isempty(p(i).xvec{index}) )
          if( isempty(p(i).color) )
            ccc = [0 0 0];
          else
            ccc = p(i).color;
          end
          % Linie setzen
          if( ~check_val_in_struct(p(i),'linestyle','char',1) )
            p(i).linestyle = '-';
          end
          if( ~check_val_in_struct(p(i),'marker','char',1) )
            p(i).marker = 'none';
          end
          iline = 1;
          p(i).hline(iline) = line('Parent',p(i).haxis ...
                              ,'XData',p(i).xvec{index} ...
                              ,'YData',p(i).yvec{index} ...
                              ,'Color',ccc ...
                              ,'LineStyle',p(i).linestyle ...
                              ,'Marker',p(i).marker ...
                              ,'Tag','xy');
                       

          if( ~check_val_in_struct(p(i),'writeindex','num',1) ) 
            p(i).writeindex = 0;
          end
          if( p(i).writeindex )
            x_rng = get(p(i).haxis,'Xlim');
            y_rng = get(p(i).haxis,'Ylim');
            
            delta_x = abs(x_rng(2)-x_rng(1))/100.;
            delta_y = abs(y_rng(2)-y_rng(1))/100.;
            figure(p(i).hfig);
            for ii=1:length(p(i).xvec{index})
              iline = iline + 1;
              p(i).hline(iline) = text(p(i).xvec{index}(ii)+delta_x,p(i).yvec{index}(ii)+delta_y,num2str(ii));
            end
            a = 0;
          else
            iline = iline + 1;
            p(i).hline(iline) = line('Parent',p(i).haxis ...
                                ,'XData',p(i).xvec{index}(1) ...
                                ,'YData',p(i).yvec{index}(1) ...
                                ,'Color',ccc ...
                                ,'Marker','*');
          end
      end
    else % p(i).type = 'f';
      % löschen wenn index == 0
      if( index < 1 )
        if( ~isempty(p(i).hline) )
          for ii=1:length(p(i).hline)
            delete(p(i).hline(ii));
          end
          p(i).hline = [];
        end
      else
        index = max(1,min(index,length(p(i).xvec)));
        if( isempty(p(i).color) )
          ccc = [0 0 0];
        else
          ccc = p(i).color;
        end
        [xout,yout] = vek_2d_drehen(p(i).xfigure,p(i).yfigure,p(i).yawvec(index),1);
        xout = xout + p(i).xvec(index);
        yout = yout + p(i).yvec(index);
        hline = line('Parent',p(i).haxis ...
                    ,'XData',xout ...
                    ,'YData',yout ...
                    ,'Color',ccc ...
                    ,'EraseMode','normal' ...
                    ,'Tag','figure');
        
       p(i).hline = [p(i).hline;hline];
    end
  end
end

