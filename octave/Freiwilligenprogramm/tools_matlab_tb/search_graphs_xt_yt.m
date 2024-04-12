function [xt,yt,dxt,dyt] = search_graphs_xt_yt(SD,ltext,figsize)
%
% Beste Position des Textes mit
% SD.h_text = uicontrol('Style','text' ...
%                      , 'Parent',S.SF(i).fig ...
%                      , 'Units','normalized' ...
%                      , 'Position',[0,0,0,0] ...
%                      , 'BackgroundColor',[0.95,0.95,0.95] ...
%                      );
% erstellt
% ltext                Länge des Textes
% figsize              figure-größe mit get(SF.fig,'Position') bestimmen
%
% Text dann mit 
% set(SD.h_text,'Position',[SD.xt,SD.yt,SD.dxt*length(xtext),SD.dyt]);
% setzen
% und mit
% if( ishandle(SD.h_text) ),delete(SD.h_text);end
% löschen

  % Diagrammgröße
  unit = get(SD.diag,'Units');
  if( strcmp(unit,'normalized') )
    pos_diag = get(SD.diag,'Position');
  else
    set(SD.diag,'Units','normalized');
    pos_diag = get(SD.diag,'Position');
    set(SD.diag,'Units',unit);
  end

  x_rng = get(SD.diag,'Xlim');
  y_rng = get(SD.diag,'Ylim');

  d = zeros(SD.nL,4);
  % y-Werte bei x_rng berechnen
  for k=1:SD.nL

    x_data = get(SD.SL(k).line,'XData');
    y_data = get(SD.SL(k).line,'YData');

    % linker Rand
    index = suche_index(x_data,x_rng(1),'====');
    index = max(1,index);
    x0 = x_data(index);
    y0 = y_data(index);
    % rechter Rand
    index=suche_index(x_data,x_rng(2));
    index = max(1,index);
    x1 = x_data(index);
    y1 = y_data(index);

    d(k,1) = sqrt((x_rng(1)-x0)^2+(y_rng(1)-y0)^2); 
    d(k,2) = sqrt((x_rng(1)-x0)^2+(y_rng(2)-y0)^2); 
    d(k,3) = sqrt((x_rng(2)-x1)^2+(y_rng(1)-y1)^2); 
    d(k,4) = sqrt((x_rng(2)-x1)^2+(y_rng(2)-y1)^2); 
  end

  dd = ones(4,1)*max(max(d));
  for k=1:SD.nL
    for kk=1:4
      if( d(k,kk) < dd(kk) )
        dd(kk) = d(k,kk);
      end
    end
  end
  [dmax,imax]=max(dd);
  try
    x_text_h = get(SD.h_text,'FontSize');
    dyt  = x_text_h * 2.0 / figsize(4);
    dxt  = x_text_h * 2.0 / figsize(3);
  catch
    dyt  = 0.05;
    dxt  = 0.025;
  end
  if( imax == 1 )
    xt = pos_diag(1);
    yt = pos_diag(2);
  elseif( imax == 2 )
    xt = pos_diag(1);
    yt = pos_diag(2)+pos_diag(4)-dyt;
  elseif( imax == 3 )
    xt = pos_diag(1)+pos_diag(3)-dxt*ltext;
    yt = pos_diag(2);
  else
    xt = pos_diag(1)+pos_diag(3)-dxt*ltext;
    yt = pos_diag(2)+pos_diag(4)-dyt;
  end
    
end
