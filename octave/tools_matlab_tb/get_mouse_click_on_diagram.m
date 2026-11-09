function [x,y,okay] = get_mouse_click_on_diagram(ifig,n,write_text,plot_flag,pcolor)
%
% [x,y,okay] = get_mouse_click_on_diagram(ifig,n[,write_text,plot_flag,pcolor])
%
% ifig        figure number for example gcf for current figure
% n           < 1   count up tille right button is used
%             > 0   n-values to get
% write_text  Text der angezigt wird und wieder gelöscht wird
% plot_flag   0/1 Punkt soll gezeichnet werden (default: 0)
% pcolor      Farbe (default [0,0,0] schwarz)
%
% x(n)        x-values
% y(n)        y-values
% okay        = 1   okay
%             = 0   abborted by right button
%
  if( ~exist('write_text','var') )
    write_text = '';
  end
  if( ~exist('plot_flag','var') )
    plot_flag = 0;
  end
  if( ~exist('pcolor','var') )
    pcolor = [0,0,0];
  end
  figure(ifig)

  lwrite_text = length(write_text);
  if( lwrite_text > 0 )
    [okay,SF]=search_graphs_figure(ifig);
    if( ~okay )
      error('Der angegeben handle für die Figure kann nicht gelesen werden')
    end
    SF.SD(1).h_text = uicontrol('Style','text' ...
                               , 'Parent',SF.fig ...
                               , 'Units','normalized' ...
                               , 'Position',[0.0,0.0,0.0,0.0] ...
                               , 'BackgroundColor',[0.95,0.95,0.95] ...
                               );
   [xt,yt,dxt,dyt] = search_graphs_xt_yt(SD,lwrite_text,get(SF.fig,'Position'));
   set(SF.SD(1).h_text,'Position',[xt,yt,dxt*lwrite_xtext,dyt],'String',write_text);
  end
  x    = [];
  y    = [];
  okay = 1;
  if( n > 0 )
    for i = 1:n
      [xi,yi,but] = ginput(1);
      if( but > 1 )
        okay = 0;
        if( lwrite_text > 0 )
          delete(SF.SD(1).h_text)
        end
        return;
      elseif( plot_flag )
        hold on
        plot(xi,yi,'Color',pcolor,'Marker','o','era','back')
        hold off
      end
      x = [x;xi];
      y = [y;yi];
    end
  else
    but = 1;
    while( but == 1 )
      [xi,yi,but] = ginput(1);
      if( but > 1 )
        if( lwrite_text > 0 )
          delete(SF.SD(1).h_text)
        end
        return;
      elseif( plot_flag )
        hold on
        plot(xi,yi,'Color',pcolor,'Marker','o','era','back')
        hold off
      end
      x = [x;xi];
      y = [y;yi];
    end
  end    
  if( lwrite_text > 0 )
    delete(SF.SD(1).h_text)
  end  
end

