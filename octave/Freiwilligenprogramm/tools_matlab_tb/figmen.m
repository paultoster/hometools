function figmen(arg1,arg2)
%FIGMEN  Button-Menü der derzeit offenen Grafikfenster zum Anklicken
%	Erzeugen des Menüs: 
%          Aufruf ohne Argumente.
%       oder
%         figmen(customtitle,customcommand)
%         Der Custom-Button kann mit einer beliebigen Funktion belegt
%         werden, z.B. Aufruf eines M-Files zum Plotten neuer Daten.
%
%       Bei wiederholtem Aufruf (bzw. Button 'update menu'): Update des
%       Menüs, d.h. nur für jedes aktuell offene Grafikfenster gibt es einen
%       Button. 
%
%       Mit den 'hide'-Buttons kann man einzelne oder alle Grafikfenster in
%       den Zustand 'invisible' versetzen (iconify geht leider nicht). Mit
%       den Zahlen-Buttons macht man sie entsprechend wieder sichtbar.
%

% E. Kloppenburg 1996/1997/1998


  customtitle = [];
  customcommand = [];

  if nargin == 0
    task = 'initialize';
  end

  if nargin == 1
    task = arg1;
  end

  if nargin == 2
    task = 'initialize';
    customtitle = arg1;
    customcommand = arg2;
  end


  if strcmp(task,'initialize')
  % Initialize
    MaxFigure_max = 80;
    MaxFigure_min = 60;

    fhandles = sort(get_fig_numbers);
    nhandles = length(fhandles);

    if( nhandles < MaxFigure_min )
        MaxFigure = MaxFigure_min;
    elseif( nhandles > MaxFigure_max )
        MaxFigure = MaxFigure_max;
    else
        MaxFigure = ceil(nhandles/2)*2;
    end

    % vorhandenes Figure-Menü wiederverwenden
    h = findobj('tag','FIGMEN');
    if isempty(h)
      % neue Figure
      ver = version;
      if( strcmp(ver(1:2),'5.') || strcmp(ver(1:2),'6.') ) 
        % In Matlab 5 und 6 keine Integer-Handle, damit man nicht reinplottet.
        h = figure('IntegerHandle','off', ...
      'MenuBar', 'none');
      else      
        % Matlab 4
        h = figure('NextPlot', 'new');
      end      

      % Tag setzen zum wiederverwenden, Titel
      set(h,'tag','FIGMEN', ...
    'name','figmen',...
    'NumberTitle','off')

      % ggfs Default-Customtitle und Customcommand wählen
      if isempty(customtitle)
        customtitle = 'custom-button';
        customcommand = ...
         ['help figmen; '...
    'fprintf(''Kein benutzerdefiniertes Kommando spezifiziert\7\n'');'];
      end

    else
      % altes Menu wiederverwenden
      h = h(1);
      figure(h)

      % aber alle Buttons erstmal löschen
      clf

      % alte Position merken zum beibehalten
      figpos = get(h,'position');
      posx = figpos(1);
      posy = figpos(2);
      hei = figpos(4);
      olposy = posy+hei; % Position der linken oberen Ecke soll beibehalten
                         % werden.

      if isempty(customtitle)
        % kein Titel angegeben->customtitle und customcommand aus UserData holen
        tmp=get_user_data_figmen(gcf);
        customtitle=deblank(tmp(1,:));
        customcommand=tmp(2,:);
      end

    end

    % customtitle und customcommand in UserData merken
    set_user_data_figmen(gcf,char(customtitle,customcommand));

    % F"ur FIGMEN-Figure keinen Button:
    fhandles(find(fhandles==h)) = [];

    % Button- und Figure-Groesse
    screensize = get(0,'screensize');
    screenheight = screensize(4);
    if( length(fhandles) <= MaxFigure/2 )

      buthei = min(30,(screenheight-26)/(length(fhandles)+6));
      figwid = 200;%85; % geht wohl nicht schmaler
      fighei = buthei*(length(fhandles)+6);
      delposx = figwid;
    else

      buthei = min(30,(screenheight-26)/(MaxFigure/2+6));
      figwid = 200;%85; % geht wohl nicht schmaler
      fighei = buthei*(MaxFigure/2+6);
      delposx = figwid*2;

    end
    % Figure-Position
    if exist('posx')
      % alte Position der linken oberen Ecke beibehalten (fighei kann sich
      % aendern)
      posy = olposy-fighei;
    else
      % Anfangsposition (in Pixel): linke obere Ecke des Bildschirms
      posx = 0+5;
      posy = screenheight-26-fighei;
    end

    set(h,'Position',[posx posy delposx fighei]);

    i = 0;
    for i1 = 1:length(fhandles);


        text = get(fhandles(i1),'Name');
        if( ~strcmp(text(1:min(6,length(text))),'veDYNA') ) % Ausschluß von bestimmten Fenstern
            i = i+1;
            if( i > MaxFigure ) % Anzahl auf 100 begrenzen
                break;
            end
            if( length(text) == 0 )
                text = num2str(fhandles(i));
            end
            if( i <= MaxFigure/2 )
                posx_hbut = 0.0;
                posy_hbut = fighei-buthei*i;
            else
                posx_hbut = figwid;
                posy_hbut = fighei-buthei*(i-MaxFigure/2);
            end
            hbut = uicontrol('Style', 'Push', ...
                   'Position', [posx_hbut posy_hbut figwid/2 buthei], ...
                   'String', text, ...
               'Callback', [' figmen figure(', num2str(fhandles(i1)), ')']);
    %		Ich weiss es nicht mehr genau, aber folgende Variante habe wohl
    %		deswegen nicht gewaehlt, weil danach gcf auf der FIGMEN-figure
    %		steht.
    %  	     'Callback', ['figure(', num2str(fhandles(i)), ')']);
          set(hbut,'units','normalized') % wegen resize

        % Buttons, um die Figures wieder loszuwerden ('visible off'. Iconification
        % waere besser, geht aber nicht in Matlab 4.2.)    
            if( i <= MaxFigure/2 )
                posx_hbut = figwid/2;
                posy_hbut = fighei-buthei*i;
            else
                posx_hbut = figwid+figwid/2;
                posy_hbut = fighei-buthei*(i-MaxFigure/2);
            end
          hbut = uicontrol('Style', 'Push', ...
                   'Position', [posx_hbut posy_hbut figwid/2 buthei], ...
                   'String', 'hide', ...
               'Callback', [' figmen ''set(',  ...
             num2str(fhandles(i1)), ',''''vis'''',''''off'''')''']);
          set(hbut,'units','normalized') % wegen resize
      end
    end

    % fuer alle Figures visibility off
      hbut = uicontrol('Style', 'Push', ...
               'Position', [0 5*buthei figwid buthei], ...
               'String', 'hide all', ...
           'Callback', 'figmen hideall'); 
      set(hbut,'units','normalized') % wegen resize

    % alle Figures *und* figmen Fenster visible off
      hbut = uicontrol('Style', 'Push', ...
               'Position', [0 4*buthei figwid buthei], ...
               'String', 'hide all + menu', ...
                'Callback', 'figmen hideall_menu'); 
      set(hbut,'units','normalized') % wegen resize

    % alle Figures *und* figmen Fenster visible off
      hbut = uicontrol('Style', 'Push', ...
               'Position', [0 3*buthei figwid buthei], ...
               'String', 'close all + menu', ...
           'Callback', 'figmen closeall_menu'); 
      set(hbut,'units','normalized') % wegen resize

   % Update-Button
      hbut = uicontrol('Style', 'Push', ...
               'Position', [0 2*buthei figwid buthei], ...
               'String', 'update menu', ...
               'Callback', 'figmen initialize');
      set(hbut,'units','normalized') % wegen resize

    % Benutzerdefinierter Button
      hbut = uicontrol('Style', 'Push', ...
               'Position', [0 1*buthei figwid buthei], ...
               'String', customtitle, ...
               'Callback', ['clear functions; ', customcommand]);
      set(hbut,'units','normalized') % wegen resize

   % PrintPS-Button
      hbut = uicontrol('Style', 'Push', ...
               'Position', [0 0*buthei figwid buthei], ...
               'String', 'print ', ...
               'Callback', 'figmen print_pdf');
      set(hbut,'units','normalized') % wegen resize

  elseif strcmp(task,'hideall')
    % Action: alle Fenster ausser dem Figure-Menu invisible machen 
    % (iconify geht nicht)
    % Erstmal provisorische Aenderung: auch Menue-Fenster invisible. Bekommt
    % man ja mit >>figmen wieder.

    for h = get(0,'ch')', 
      if ~strcmp(get(h,'tag'), 'FIGMEN'),
        set(h,'vis','off')
      end
    end

  elseif strcmp(task,'hideall_menu')
    % Action: alle Fenster ausser dem Figure-Menu invisible machen 
    % (iconify geht nicht)
    % Erstmal provisorische Aenderung: auch Menue-Fenster invisible. Bekommt
    % man ja mit >>figmen wieder.

    for h = get(0,'ch')', 
      %if ~strcmp(get(h,'tag'), 'FIGMEN'),
        set(h,'vis','off')
      %end
    end

  elseif strcmp(task,'closeall_menu')
    % Action: alle Fenster ausser dem Figure-Menu invisible machen 
    % (iconify geht nicht)
    % Erstmal provisorische Aenderung: auch Menue-Fenster invisible. Bekommt
    % man ja mit >>figmen wieder.

    for h = get(0,'ch')', 
      %if ~strcmp(get(h,'tag'), 'FIGMEN'),
      %  set(h,'vis','off')
      text = get(h,'Name');
      if( ~strcmp(text(1:min(6,length(text))),'veDYNA') ) % Ausschluß von bestimmten Fenstern
          close(h)
      end
      %end
    end

  elseif strcmp(task,'print_pdf')
    % Action: alle Fenster ausser dem Figure-Menu invisible machen 
    % (iconify geht nicht)
    % Erstmal provisorische Aenderung: auch Menue-Fenster invisible. Bekommt
    % man ja mit >>figmen wieder.
    
    s_frage.c_liste{1} = 'fig';
    s_frage.c_liste{2} = 'pdf';
    s_frage.c_liste{3} = 'bmp';
    s_frage.c_liste{4} = 'emf';
    s_frage.c_liste{5} = 'png';
    s_frage.c_liste{6} = 'eps';
    
    s_frage.single     = 1;
    
    s_frage.frage      = 'Welches Format';
    
    [okay,selection] = o_abfragen_listbox_f(s_frage);
    
    if( okay )
      
      selct_format = s_frage.c_liste{selection(1)};

      fhandles = sort(get_fig_numbers);


      directory = pwd; 
      % command = ['disp ''print postscript in dir=',directory,''''];
      command = ['disp ''saveas ',selct_format,' in dir=',directory,''''];
      eval(char(command))
      ifiles = 0;
      pdf_file_name_list = {};
      for i = 1:length(fhandles);

        h = fhandles(i); 
        if ~strcmp(get(h,'tag'), 'FIGMEN')

  %         figure(h)
  %         print_command=['print -dpsc2 -f',num2str(h),' figure',num2str(h),'.ps'];
  %         disp_command=['disp ''print -dpsc2 -f',num2str(h),' figure',num2str(h),'.ps'''];
  %         eval(char(disp_command))
  %         eval(char(print_command))

            file_name = sprintf('figure%s.%s',num2str(h,'%2.2i'),selct_format);
            saveas(h,file_name,selct_format);
            fprintf('%s: %s\n',selct_format,file_name);
            if( strcmp(selct_format,'pdf') )
              ifiles = ifiles+1;
              pdf_file_name_list{ifiles} = fullfile(pwd,file_name);
            end
        end
      end
      if( ifiles > 0 )
        okay = collect_pdf(1,pdf_file_name_list);
      end
      % command = ['disp ''print postscript Ende'''];
      command = ['disp ''saveas  Ende'''];
      eval(char(command))

    end
  else
    % Action: direct im Callback codiert  

    eval(task)

  end
end
function data = get_user_data_figmen(fid)
% Userdaten aus Figure/Diagramm holen
% scr ist Kennzeichnung gegenüber anderen Daten von anderen Programmen
  FH = get(fid,'userdata');
  
  if(  ~isempty(FH) && isfield(FH,'figmen') )
    data = FH.figmen;
  else
    data = [];
  end
  return
end
function set_user_data_figmen(fid,data)
% Userdaten in Figure/Diagramm schreiben
% scr ist Kennzeichnung gegenüber anderen Daten von anderen Programmen
  FH = get(fid,'userdata');
  
  FH.figmen = data;
  
  set(fid,'userdata',FH);
  return
end
