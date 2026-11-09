function scroll_meas(mode)
%
% scroll_meas
%
% mode = 'init'     Initialisieren
%        'update'   Graphen zählen updaten
%
% user_data-Beschreibung (In dem scroll-Fenster (fig_scroll) werden
% Daten gespeichert
% S.set              Scroll ist gesetzt
% S.type             'master' Scroll-Fenster
%                    ('child'  zu scrollendes Fenster)
% S.nP                           Anzahl der Scroll-Punkte
% S.iP                           aktueller Scrollpunkt
% S.nF                           Anzahl der Scroll-Graphen
% S.SF(i).fig                    handle für die Figure
% S.SF(i).nD                     Anzahl Diagramme
% S.SF(i).SD(j).diag             handle für das Diagramm
% S.SF(i).SD(j).xt               Text linke Ecke für y-Wert
% S.SF(i).SD(j).yt               Text untere Ecke für y-Wert
% S.SF(i).SD(j).dxt              Abstand nach links für Text
% S.SF(i).SD(j).dyt              Abstand nach oben für Text
% S.SF(i).SD(j).h_text           uicontrol-id für den Diagrammtext
% S.SF(i).SD(j).nL               Anzahl echter Linien
% S.SF(i).SD(j).SL(k).line       handle für den Graphen
% S.SF(i).SD(j).SL(k).line_color handle für den Graphen
% S.SF(i).SD(j).SL(k).x_ch_line  Handle der crosshair-Linie x
% S.SF(i).SD(j).SL(k).y_ch_line  Handle der crosshair-Linie y
% S.SF(i).SD(j).SL(k).xe         Text linke Ecke für y-Wert
% S.SF(i).SD(j).SL(k).ye         Text unter Ecke für y-Wert
% S.SF(i).SD(j).SL(k).dye        Abstand nach oben für Text

% S.slider          handle für Slider
% S.slider_text     handle für Text neben Slider
% S.neu_button      handle für Neu-Button
% S.end_button      handle für End-Button
%
% 1. Sammelt alle Diagramme, die eine Achse haben und gleichlange Vektoren
% haben (es wird nach der Mehrzahl gesucht)
% 
fig_num = 300;          % Standrad-Nummer für Scroll-Fenster

if( ~exist('mode','var') ) % default
  mode = 'init';
end

% Das Scroll-Fenster suchen oder neu anlegen
%-------------------------------------------
fig_scroll = scroll_meas_search_make_scroll_figure(fig_num);

if( isa(fig_scroll,'matlab.ui.Figure') )
  if( fig_scroll.Number == 0 )
    error('scroll_meas: ScrollFigure konnte nicht erstellt werden');
  end
else
  if( ~fig_scroll )
    error('scroll_meas: ScrollFigure konnte nicht erstellt werden');
  end
end

switch( lower(mode) )
  case {'init','update'}
    % Auswahl der Diagramme und Grafen machen
    %----------------------------------------
    [okay,S] = scroll_meas_search_graphs(fig_scroll);
    if( ~okay )
      error('scroll_meas: keine Graphen gefunden, um einen Slider zu generieren');
    end
    
    [okay,S]  = scroll_meas_set_crosshairs(fig_scroll,100,S);
    
    % Slider anlegen
    %---------------
    [okay,S]=scroll_meas_make_slider(fig_scroll,S);
    
  otherwise
    fprintf('scroll_meas:   Unknown method. mode = <%>\n',mode)    
    
end
  
end
function fig_scroll = scroll_meas_search_make_scroll_figure(fig_num)
% Das Scroll-Fenster suchen oder neu anlegen
%-------------------------------------------
  fig_scroll = 0;
  fig_list = get_fig_numbers;
  found = 0;
  for i=length(fig_list):-1:1
    if( strcmp(get(fig_list(i),'Tag'),'scroll_meas') )
      S = get_user_data_scr(fig_list(i));
      if(  ~isempty(S) ...
        && isfield(S,'set') && S.set ...
        && isfield(S,'type') && strcmp(S.type,'master') ...
        )
        found = 1;
        fig_scroll     = fig_list(i);
        break;
      end
    end
  end
  if( ~found )
    while( find_val_in_vec(fig_list,fig_num,0.1) > 0.5 )
        fig_num = fig_num + 1;
    end
    fig_scroll = figure(fig_num);
    S.set        = 1;
    S.type       = 'master';
    S.iP         = 1;
    S.fig_scroll = fig_scroll;
    set_user_data_scr(fig_scroll,S);    
    set(fig_scroll,'Tag','scroll_meas'),
  end
  position = get(fig_scroll,'Position');
  position(1) = 50;
  position(2) = 50;
  set(fig_scroll,'Position',position),
  %screensize = get(0,'screensize');

end
function [okay,S] = scroll_meas_search_graphs(fig_scroll)
% Auswahl der Diagramme und Grafen machen
%----------------------------------------
% Search Graphs with majority has same length
% and store to user_data
  okay = 0;
  S    = [];
  % Alle Figuren nach Diagramm und Linie durchsuchen
  %-------------------------------------------------
  nF = 0;
  fig_list = get_fig_numbers;
  for i=length(fig_list):-1:1
    if( ~strcmp(get(fig_list(i),'Tag'),'scroll_meas') )
      
      % vorher Prüfen und löschen
      SF = get_user_data_scr(fig_list(i));
      if( ~isempty(SF) && (fig_list(i) == SF.fig) )
        scroll_meas_clear_figure(SF);
      end
      clear SF
      
      [ok,SFF]=search_graphs_figure(fig_list(i));
      if( ok )
        nF = nF + 1;
        SF(nF) = SFF;
        okay = 1;
      end
    end
  end

  if( ~okay )
    fprintf('scroll_meas: Es gibt keine Diagramme zum scrollen\n');
    return
  end

  % Die Linien mit mehrheitlicher gleicher Länge suchen
  %----------------------------------------------------
  z = [];
  for i=1:nF
    for j=1:SF(i).nD
      for k=1:SF(i).SD(j).nL
        z = [z,SF(i).SD(j).SL(k).nP];
      end
    end
  end
  [n_list,xbar] = shistc(z,1.);
  [n,i] = max(n_list);
  nP_choose = xbar(i);
  
  if( nP_choose <= 1 )
    error('scroll_meas:scroll_meas_search_graphs:error: Die ausgewählten Linien (Mehrheit) hat nur np=%i Punkte (zu wenig)',nP_choose);
  end


  [okay,SF]=scroll_meas_search_graphs_list_choose(SF,nP_choose);

  S = get_user_data_scr(fig_scroll);
  S.nP  = nP_choose;
  S.nF = length(SF);
  S.SF = SF;
  if( S.nF == 0 )
    okay = 0;
    return
  end
  clear SF
  for i=1:S.nF
    for j=1:S.SF(i).nD
      x_rng = get(S.SF(i).SD(j).diag,'Xlim');
      y_rng = get(S.SF(i).SD(j).diag,'Ylim');
      % X-Wert Anzeige
      S.SF(i).SD(j).h_text = uicontrol('Style','text' ...
                           , 'Parent',S.SF(i).fig ...
                           , 'Units','normalized' ...
                           , 'Position',[0.1,0.1,0.1,0.1] ...
                           , 'BackgroundColor',[0.95,0.95,0.95] ...
                           );

      for k=1:S.SF(i).SD(j).nL

        % crosshair anlegen
        S.SF(i).SD(j).SL(k).x_ch_line = line('Parent',S.SF(i).SD(j).diag,'XData',x_rng,'YData',[y_rng(1),y_rng(1)]);
        set(S.SF(i).SD(j).SL(k).x_ch_line,'Color',S.SF(i).SD(j).SL(k).line_color,'LineStyle',':','Tag','x_ch_line');
        S.SF(i).SD(j).SL(k).y_ch_line = line('Parent',S.SF(i).SD(j).diag,'XData',[x_rng(1),x_rng(1)],'YData',y_rng);
        set(S.SF(i).SD(j).SL(k).y_ch_line,'Color',S.SF(i).SD(j).SL(k).line_color,'LineStyle',':','Tag','y_ch_line');
        % y-Werte Anzeige
        S.SF(i).SD(j).SL(k).line_text = uicontrol('Style','text' ...
                                      , 'Parent',S.SF(i).fig ...
                                      , 'Units','normalized' ...
                                      , 'Position',[S.SF(i).SD(j).SL(k).xe,S.SF(i).SD(j).SL(k).ye,1.0-S.SF(i).SD(j).SL(k).xe,S.SF(i).SD(j).SL(k).dye] ...
                                      ,'BackgroundColor',S.SF(i).SD(j).SL(k).line_color ...
                                      ,'ForegroundColor',[1.-S.SF(i).SD(j).SL(k).line_color(1),1.-S.SF(i).SD(j).SL(k).line_color(2),1.-S.SF(i).SD(j).SL(k).line_color(3)] ...
                                      );
        S.SF(i).SD(j).SL(k).line_text_h = get(S.SF(i).SD(j).SL(k).line_text,'FontSize');

      end
      set(S.SF(i).SD(j).diag,'Xlim',x_rng);
      set(S.SF(i).SD(j).diag,'Ylim',y_rng);
    end
  end
      
  % Position der Textfelder bestimmen 
  S.SF = scroll_meas_calc_xe_ye(S.SF);
  for i=1:length(S.nF)
    for j=1:S.SF(i).nD
      [xt,yt,dxt,dyt] = search_graphs_xt_yt(S.SF(i).SD(j),10,get(S.SF(i).fig,'Position'));
      S.SF(i).SD(j).xt  = xt;
      S.SF(i).SD(j).yt  = yt;
      S.SF(i).SD(j).dxt = dxt;
      S.SF(i).SD(j).dyt = dyt;
    end
  end
  %  Userdata in Scroll-Fenster 
  set_user_data_scr(fig_scroll,S);
  %  Userdata in alle Linien-Fenster 
  for i=1:S.nF
    set_user_data_scr(S.SF(i).fig,S.SF(i));
  end
end
function [okay,SF]=scroll_meas_search_graphs_list_choose(SFF,np)
  okay = 0;
  nF   = 0;
  for i=1:length(SFF)
    [ok,S] = scroll_meas_search_graphs_list_choose_d(SFF(i).SD,np);
    if( ok )
      okay = 1;
      nF        = nF+1;
      SF(nF).SD = S;
      SF(nF).nD = length(S);
      SF(nF).fig = SFF(i).fig;
      
    end
  end
  if( ~okay )
    SF   = [];
  end
end
function [okay,SD]=scroll_meas_search_graphs_list_choose_d(SDD,np)
  okay = 0;
  nD   = 0;
  for j=1:length(SDD)
    [ok,S] = scroll_meas_search_graphs_list_choose_l(SDD(j).SL,np);
    if( ok )
      okay = 1;
      nD   = nD+1;
      SD(nD).SL = S;
      SD(nD).nL     = length(S);
      SD(nD).diag   = SDD(j).diag;
      SD(nD).xt     = SDD(j).xt;
      SD(nD).yt     = SDD(j).yt;
      SD(nD).dxt    = SDD(j).dxt;
      SD(nD).dyt    = SDD(j).dyt;
      SD(nD).h_text = SDD(j).h_text;
    end
  end
  if( ~okay )
    SD   = [];
  end
end
function [okay,SL]=scroll_meas_search_graphs_list_choose_l(SLL,nP)
  okay = 0;
  nL   = 0;
  for k=1:length(SLL)
    if( SLL(k).nP == nP )
      okay = 1;
      nL   = nL+1;
      SL(nL) = SLL(k);
    end
  end
  if( ~okay )
    SL   = [];
  end
end
function [okay,S]  = scroll_meas_set_crosshairs(fig_scroll,iP,S)
  okay = 1;
  if( ~exist('S','var') )
    S = get_user_data_scr(fig_scroll);
    if( ~isempty(S) || ~isfield(S,'set') )
      okay = scroll_meas_search_graphs(fig_scroll);
      if( ~okay )
        error('scroll_meas_set_crosshairs: keine Graphen gefunden, um einen Slider zu generieren');
      end
    end
  end
  
  iP = min(max(1,iP),S.nP);
  
  % Text
  S.SF = scroll_meas_calc_xe_ye(S.SF);
  
  % Alle Graphen durchgehen
  %------------------------
  for i=1:S.nF
    for j=1:S.SF(i).nD
      
      x_rng  = get(S.SF(i).SD(j).diag,'Xlim');
      y_rng  = get(S.SF(i).SD(j).diag,'Ylim');
      
      for k=1:S.SF(i).SD(j).nL
    
        x_data = get(S.SF(i).SD(j).SL(k).line,'XData');
        y_data = get(S.SF(i).SD(j).SL(k).line,'YData');
        % nP     = min(length(x_data),length(y_data));
       x0     = x_data(iP);
       y0     = y_data(iP);

       % crosshair setzen
       set(S.SF(i).SD(j).SL(k).x_ch_line,'XData',x_rng,'YData',[y0,y0]);
       set(S.SF(i).SD(j).SL(k).y_ch_line,'XData',[x0,x0],'YData',y_rng);
       % y-Wert anzeigen
       %a = [S.SF(i).SD(j).SL(k).xe,S.SF(i).SD(j).SL(k).ye,1.0-S.SF(i).SD(j).SL(k).xe,S.SF(i).SD(j).SL(k).dye]
       set(S.SF(i).SD(j).SL(k).line_text,'Position',[S.SF(i).SD(j).SL(k).xe,S.SF(i).SD(j).SL(k).ye,1.0-S.SF(i).SD(j).SL(k).xe,S.SF(i).SD(j).SL(k).dye]);
       set(S.SF(i).SD(j).SL(k).line_text,'String',num2str(y0));
      end
      
      set(S.SF(i).SD(j).diag,'Xlim',x_rng);
      set(S.SF(i).SD(j).diag,'Ylim',y_rng);
      
      % x-Wert anzeigen
      xtext = num2str(x0);
      [xt,yt,dxt,dyt] = search_graphs_xt_yt(S.SF(i).SD(j),length(xtext),get(S.SF(i).fig,'Position'));
      S.SF(i).SD(j).xt  = xt;
      S.SF(i).SD(j).yt  = yt;
      S.SF(i).SD(j).dxt = dxt;
      S.SF(i).SD(j).dyt = dyt;
      set(S.SF(i).SD(j).h_text,'Position',[S.SF(i).SD(j).xt,S.SF(i).SD(j).yt,S.SF(i).SD(j).dxt*length(xtext),S.SF(i).SD(j).dyt]);
      set(S.SF(i).SD(j).h_text,'String',xtext);
    end
  end
    
end
function [okay,S] = scroll_meas_make_slider(fig_scroll,S)
  okay = 1;
  if( ~exist('S','var') )
    S = get_user_data_scr(fig_scroll);
  end
  if( isempty(S) || ~isfield(S,'nP') )
    okay = scroll_meas_search_graphs(fig_scroll);
    if( ~okay )
      error('scroll_meas_make_slider: keine Graphen gefunden, um einen Slider zu generieren');
    end
  end

  % Slider
  %-------
  x0 = 0.01;
  y0 = 0.01;
  dx = 0.8;
  dy = 0.06;
  dxb = 0.05;
  dyb = 0.05;
  if( isfield(S,'slider') )
    
    set(S.slider,'Max',S.nP);
    %set(S.slider,'Min',1);
    set(S.slider,'Value',1);
    %set(S.slider,'Units','normalized');
    %set(S.slider,'Position',[0.05 0.01 0.85 0.075]);
    set(S.slider,'SliderStep',[1/S.nP 1]);
    %
    set(S.slider_text,'String','');
    %
    set(S.end_button,'Backgroundcolor',[1,1,1]);
    %
    set(S.index_button,'Backgroundcolor',[1,1,1]);
  else
    S.slider = uicontrol('Style','slider' ...
                        ,'Parent',fig_scroll ...
                        ,'Max',S.nP ...
                        ,'Min',1 ...
                        ,'Value',1 ...
                        ,'Units','normalized' ...
                        ,'Position',[x0,y0,dx,dy] ...
                        ,'SliderStep',[1/S.nP 1] ...               
                        ,'Callback',@scroll_meas_slider_cb);
    S.slider_text = uicontrol('Style','text' ...
                             ,'Parent',fig_scroll ...
                             ,'Units','normalized' ...
                             ,'Position',[x0+dx,y0,1.0-(x0+dx),dy] ...
	                           ,'Backgroundcolor',[1,1,1] ...
                             );
    S.neu_button = uicontrol('Style','pushbutton' ...
                             ,'Parent',fig_scroll ...
                             ,'Units','normalized' ...
                             ,'Position',[x0,y0+dy,dxb,dyb] ...
                             ,'String','n' ...
	                           ,'Backgroundcolor',[1,1,1] ...
                             ,'Callback',@scroll_meas_neu_cb ...
                             );
    S.end_button = uicontrol('Style','pushbutton' ...
                             ,'Parent',fig_scroll ...
                             ,'Units','normalized' ...
                             ,'Position',[x0+dxb,y0+dy,dxb,dyb] ...
                             ,'String','e' ...
	                           ,'Backgroundcolor',[1,1,1] ...
                             ,'Callback',@scroll_meas_end_cb ...
                             );
    S.index_button = uicontrol('Style','pushbutton' ...
                              ,'Parent',fig_scroll ...
                              ,'Units','normalized' ...
                              ,'Position',[x0+2*dxb,y0+dy,dxb,dyb] ...
                              ,'String','i' ...
	                            ,'Backgroundcolor',[1,1,1] ...
                              ,'Callback',@scroll_meas_index_cb ...
                              );
    S.traj_button = uicontrol('Style','pushbutton' ...
                              ,'Parent',fig_scroll ...
                              ,'Units','normalized' ...
                              ,'Position',[x0+3*dxb,y0+dy,dxb,dyb] ...
                              ,'String','t' ...
	                            ,'Backgroundcolor',[1,1,1] ...
                              ,'Callback',@plot_traj_cb ...
                              );
  end  
  set_user_data_scr(S.slider,S);
  set_user_data_scr(S.index_button,S);
  set_user_data_scr(S.end_button,S);
  set_user_data_scr(S.neu_button,S);
  set_user_data_scr(S.traj_button,S);
  set_user_data_scr(fig_scroll,S);
end
function scroll_meas_slider_cb(hObject,eventdata)
  
  S = get_user_data_scr(hObject);

  iP = round(get(hObject,'Value'));
  
  set(S.slider_text,'String',num2str(iP));
  
  [okay,S]  = scroll_meas_set_crosshairs(S.fig_scroll,iP,S);
  
  if( ~okay )
    error('scroll_meas_slider_cb: error in scroll_meas_set_crosshairs');
  end
  
  % S.iP in figure fig_scroll schreiben
  S1 = get_user_data_scr(S.fig_scroll);
  S1.iP = iP;
  set_user_data_scr(S.fig_scroll,S1);
  
end
function scroll_meas_index_cb(hObject,eventdata)

  S = get_user_data_scr(hObject);
  
  iP  = inputdlg(sprintf('Enter index (max %i)',S.nP),'',1,{'1'});
  
  iP = str2num(iP{1});
  
  if( ~isempty(iP) )
    
    [okay,S]  = scroll_meas_set_crosshairs(S.fig_scroll,iP,S); 
    
    
    set(S.slider_text,'String',num2str(iP));
    
    set(S.slider,'Value',iP);

  
    S1 = get_user_data_scr(S.fig_scroll);
    S1.iP = iP;
    set_user_data_scr(S.fig_scroll,S1);
  end
end
function plot_traj_cb(hObject,eventdata)

  S = get_user_data_scr(hObject);
  ip = min(S.nP,max(1,round(get(S.slider,'Value'))));
  [okay,t0] = plot_traj_get_first_time(S,ip);
  if( ~okay )
    error('plot_traj_cb: in first Diagram no Time could be detected')
  else
    [okay,errtext] = make_plot_traj_for_t0(t0,pwd);
    if( ~okay )
      error('plot_traj_cb: problem in make_plot_trajfor_t0: %s',errtext)
    end
  end
end
function [okay,t0] = plot_traj_get_first_time(S,ip)
  okay = 1;
  try
    n = length( S.SF(1).SD(1).SL(1).line.XData );
    if( ip > n )
      ip = n;
    end
    t0 = S.SF(1).SD(1).SL(1).line.XData(ip);
  catch
    t0 = 0.0;
    okay = 0;
  end
end
function scroll_meas_neu_cb(hObject,eventdata)

  scroll_meas('update')

  S = get_user_data_scr(hObject);
  
  set_user_data_scr(hObject,S);
  set_user_data_scr(S.slider,S);
  set_user_data_scr(S.end_button,S);
  set_user_data_scr(S.fig_scroll,S);
end

function scroll_meas_end_cb(hObject,eventdata)

  S = get_user_data_scr(hObject);
  
  for i=1:S.nF
    scroll_meas_clear_figure(S.SF(i));
    set_user_data_scr(S.SF(i).fig,[]);
  end
  
  S.nSF = 0;
  S.SF = [];
    
  set(hObject,'Backgroundcolor',[0,0,0]);

  set_user_data_scr(hObject,S);
  set_user_data_scr(S.slider,S);
  set_user_data_scr(S.neu_button,S);
  set_user_data_scr(S.fig_scroll,S);

end
function scroll_meas_clear_figure(SF)

  for j=1:SF.nD
    if( ishandle(SF.SD(j).h_text) )
      delete(SF.SD(j).h_text)
    end
    for k=1:SF.SD(j).nL 
      % figure(S.SF(i).fig);
      % set(S.SF(i).fig,'CurrentAxes',S.SG(i).diag);
      if ishandle(SF.SD(j).SL(k).x_ch_line)
        delete(SF.SD(j).SL(k).x_ch_line);
      end
      if ishandle(SF.SD(j).SL(k).y_ch_line)
        delete(SF.SD(j).SL(k).y_ch_line);
      end
      if( ishandle(SF.SD(j).SL(k).line_text) )
        delete(SF.SD(j).SL(k).line_text);
      end
    end
  end
  
end
function data = get_user_data_scr(fid)
% Userdaten aus Figure/Diagramm holen
% scr ist Kennzeichnung gegenüber anderen Daten von anderen Programmen
  FH = get(fid,'userdata');
  
  if(  ~isempty(FH) && isfield(FH,'scr') )
    data = FH.scr;
  else
    data = [];
  end
  return
end
function set_user_data_scr(fid,data)
% Userdaten in Figure/Diagramm schreiben
% scr ist Kennzeichnung gegenüber anderen Daten von anderen Programmen
  FH = get(fid,'userdata');
  
  FH.scr = data;
  
  set(fid,'userdata',FH);
  return
end
function SF = scroll_meas_calc_xe_ye(SF)

   
  % Erster Durchgang Position nach Graph bestimmen
  for i=1:length(SF)
    figsize    = get(SF(i).fig,'Position');
    for j=1:SF(i).nD
    
      % Diagrammgröße
      unit = get(SF(i).SD(j).diag,'Units');
      if( strcmp(unit,'normalized') )
        pos_diag = get(SF(i).SD(j).diag,'Position');
      else
        set(SF(i).SD(j).diag,'Units','normalized');
        pos_diag = get(SF(i).SD(j).diag,'Position');
        set(SF(i).SD(j).diag,'Units',unit);
      end
      
      x_rng = get(SF(i).SD(j).diag,'Xlim');
      y_rng = get(SF(i).SD(j).diag,'Ylim');
      
      % Liste zum Sortieren
      ye_liste = zeros(SF(i).SD(j).nL,1);     
      for k=1:SF(i).SD(j).nL

        x_data = get(SF(i).SD(j).SL(k).line,'XData');
        y_data = get(SF(i).SD(j).SL(k).line,'YData');

        nP = min(length(x_data),length(y_data));
        
        if( x_data(nP) > x_rng(2) )
          index = suche_index(x_data,x_rng(2));
        else
          index = nP;
        end
        index = max(1,index);
        ye_liste(k) = y_data(index);
        y_max = min(y_rng(2),max(y_rng(1),y_data(index)));

        % x-Position am ENde des Digramms
        SF(i).SD(j).SL(k).xe     = pos_diag(1)+pos_diag(3);
        % letzter y-Wert skaliert auf Ausschnitt
        yskal  = (y_max-y_rng(1))/(y_rng(2)-y_rng(1));
        % y-Position in der Höhe des letzten Punktes
        SF(i).SD(j).SL(k).ye  = pos_diag(2)+yskal*pos_diag(4);
        
        SF(i).SD(j).SL(k).dye = SF(i).SD(j).SL(k).line_text_h*2/figsize(4);
      end
      
      % Reihenfolge festlegen
      [y1,ind_liste] = sort(ye_liste); 
            
      % Restplatz am Diagramm
      drest = pos_diag(4) - SF(i).SD(j).SL(1).dye * SF(i).SD(j).nL;
      if( drest <= 0.0 )
        SF(i).SD(j).SL(ind_liste(1)).ye = pos_diag(2)+drest;
        for m = 2:SF(i).SD(j).nL
          SF(i).SD(j).SL(ind_liste(m)).ye = SF(i).SD(j).SL(ind_liste(m-1)).ye + SF(i).SD(j).SL(ind_liste(m-1)).dye;
        end
      else
        % Sortieren
        for m=2:SF(i).SD(j).nL
          k = ind_liste(m);  
          for mm=1:m-1
            kk = ind_liste(mm);         
            if( (SF(i).SD(j).SL(k).ye >= SF(i).SD(j).SL(kk).ye) && (SF(i).SD(j).SL(k).ye < SF(i).SD(j).SL(kk).ye+SF(i).SD(j).SL(kk).dye) )

              SF(i).SD(j).SL(k).ye = SF(i).SD(j).SL(kk).ye+SF(i).SD(j).SL(kk).dye+0.001;

            elseif( (SF(i).SD(j).SL(k).ye < SF(i).SD(j).SL(kk).ye) && (SF(i).SD(j).SL(k).ye+SF(i).SD(j).SL(k).dye >= SF(i).SD(j).SL(kk).ye) )

              SF(i).SD(j).SL(k).ye = SF(i).SD(j).SL(kk).ye-SF(i).SD(j).SL(kk).dye-0.001;
            end
          end
        end
        
        % Rest nach unten
        drest = SF(i).SD(j).SL(ind_liste(1)).ye - pos_diag(2);
        if( drest < 0.0 )
          SF(i).SD(j).SL(ind_liste(1)).ye = pos_diag(2);
          for m=2:SF(i).SD(j).nL
            if( SF(i).SD(j).SL(ind_liste(m)).ye < SF(i).SD(j).SL(ind_liste(m-1)).ye + SF(i).SD(j).SL(ind_liste(m-1)).dye )
              SF(i).SD(j).SL(ind_liste(m)).ye = SF(i).SD(j).SL(ind_liste(m-1)).ye + SF(i).SD(j).SL(ind_liste(m-1)).dye;
            else
              break;
            end
          end
        end
        
        % Rest nach oben 
        drest = SF(i).SD(j).SL(ind_liste(SF(i).SD(j).nL)).ye + SF(i).SD(j).SL(ind_liste(SF(i).SD(j).nL)).dye - pos_diag(2) - pos_diag(4);
        if( drest > 0.0 )
          SF(i).SD(j).SL(ind_liste(SF(i).SD(j).nL)).ye = pos_diag(2) + pos_diag(4) - SF(i).SD(j).SL(ind_liste(SF(i).SD(j).nL)).dye;
          for m=SF(i).SD(j).nL-1:-1:1
            if( SF(i).SD(j).SL(ind_liste(m)).ye+SF(i).SD(j).SL(ind_liste(m)).dye > SF(i).SD(j).SL(ind_liste(m+1)).ye )
              SF(i).SD(j).SL(ind_liste(m)).ye = SF(i).SD(j).SL(ind_liste(m+1)).ye - SF(i).SD(j).SL(ind_liste(m)).dye;
            else
              break;
            end
          end
        end
      end  
    end
  end
end
