function [okay,SF]=search_graphs_figure(fig)
%
% [okay,SF]=search_graphs_figure(fig);
%
% fig                          Liste mit figure ID 
%                              fig_list = get_fig_numbers; z.B.
% SF(i).fig                    handle für die Figure
% SF(i).nD                     Anzahl Diagramme
% SF(i).SD(j).diag             handle für das Diagramm
% SF(i).SD(j).xt               Text linke Ecke für y-Wert
% SF(i).SD(j).yt               Text untere Ecke für y-Wert
% SF(i).SD(j).dxt              Abstand nach links für Text
% SF(i).SD(j).dyt              Abstand nach oben für Text
% SF(i).SD(j).h_text           uicontrol-id für den Diagrammtext
% SF(i).SD(j).nL               Anzahl echter Linien
% SF(i).SD(j).SL(k).line       handle für den Graphen
% SF(i).SD(j).SL(k).line_color handle für den Graphen
% SF(i).SD(j).SL(k).x_ch_line  Handle der crosshair-Linie x
% SF(i).SD(j).SL(k).y_ch_line  Handle der crosshair-Linie y
% SF(i).SD(j).SL(k).xe         Text linke Ecke für y-Wert
% SF(i).SD(j).SL(k).ye         Text unter Ecke für y-Wert
% SF(i).SD(j).SL(k).dye        Abstand nach oben für Text
  okay = 0;
  for i=1:length(fig)

    nD = 0;
    diag_list = get(fig(i),'children');
    for j=length(diag_list):-1:1
      [ok,S] = search_graphs_diagram(diag_list(j));
      if( ok )
        nD           = nD + 1;
        SF(i).fig    = fig(i);
        SF(i).nD     = nD;
        SF(i).SD(nD) = S;
      
        okay      = 1;
      end
    end
  end
  if( ~okay )
    SF   = [];
  end
end
function [okay,SD]=search_graphs_diagram(diag)
  okay = 0;
  if(  strcmp(get(diag,'type'),'axes') ...
    && ~strcmp(get(diag,'Tag'),'legend') ...
    )
    line_list = findobj(diag,'Type','line');
    nL = 0;
    for k=length(line_list):-1:1
      [ok,S] = search_graphs_line(line_list(k));
      if( ok )
        nL = nL + 1;
        SD.nL     = nL;
        SD.diag   = diag;
        SD.SL(nL) = S;
        SD.xt     = 0.0;
        SD.yt     = 0.0;
        SD.dxt    = 0.025;
        SD.dyt    = 0.05;
        SD.h_text = 0;
        okay = 1;
      end
    end
  end
  if( ~okay )
    SD   = [];
  end
end
function [okay,SL]=search_graphs_line(line_item)
  okay = 0;
  tag = get(line_item,'Tag');
  if( ~strcmp(tag,'x_ch_line') && ~strcmp(tag,'y_ch_line') )
    x_data = get(line_item,'XData');
    y_data = get(line_item,'YData');
    SL.line       = line_item;
    SL.line_color = get(line_item,'Color');
    SL.nP         = min(length(x_data),length(y_data));
    % Crosshair linie
    SL.x_ch_line  = 0;   
    SL.y_ch_line  = 0;
    % y-TExtkoordinaten
    SL.xe         = 0.;
    SL.ye         = 0.;
    SL.dye        = 0.05;
    SL.line_text  = 0;
    SL.line_text_h= 0;
    
    okay = 1;
  end
  if( ~okay )
    SL   = [];
  end
end
