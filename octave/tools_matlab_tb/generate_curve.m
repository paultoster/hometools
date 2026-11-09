%version 2 TBert/TZS/3052 20050204
%
% [x_val,y_val,s_i] =  generate_curve(s_i_inp)
% [x_val,y_val,s_i] =  generate_curve(s_i_inp,dt)
% [x_val,y_val,s_i] =  generate_curve(dt)
% [x_val,y_val]     =  generate_curve(Datname,dt)
%
% A) Generieren einer Kurve interactive
%
% - s_i_inp.build = 0 (oder nicht enthalten) => interactive EIngabe
%
%   - grafisch mit Maus-Klicken
%   - Kennwerte vorgeben für Sprung  und Sinus
%   - Speichern und Einladen der Kenndaten (*.ken)
%   - Editor aufrufen um Kenndaten zu editieren ( Daten müssen danach erneut eingeladen werden)
%
%
% Es die Abtastschrittweite dt vorgegeben werden
% entweder 
%   s_i.delta_t = 0.01;
%   [x_val,y_val,s_i] =  generate_curve(s_i)
% oder bei neuerstellen 
%   [x_val,y_val,s_i] =  generate_curve(dt)
% oder  
%   [x_val,y_val,s_i] =  generate_curve(s_i,dt)
%
% Es können weitere Größen vorgegeben werden
% 
% s_i.t_min = 0;        Für grafische eingabe t_min
% s_i.t_max = 0;        Für grafische eingabe t_miax
% s_i.y_min = 0;        Für grafische eingabe y_min
% s_i.y_max = 0;        Für grafische eingabe y_max
%
% s_i.x_name = 'Zeit'
% s_i.y_name = 'Strom'
% s_i.x_unit = 's'
% s_i.y_unit = 'A'
%
% Wenn Messungen verwendet werden soll:
%
% s_i.x_mess = [...]    Zeit/X-Vektor
% s_i.y_mess = [...]    Kennwerte
%
% Aufruf:
% [time,current,s_i] = generate_curve(s_i);
% 
% Bei wiedeholtem Aufruf kann die Struktur wieder übergeben werden.
% Damit kann an den aktuellen Kenndaten weiter gearbeitet werden
%
% [x_val,y_val]     =  generate_curve(Datname,dt)
% Kenndaten einladen und umsetzen, DAtei kann zuerst interactive
% gespeichert werden
% datname           Dateiname mit den generierten Kenndaten
% dt                Abtastweite, um Tabelle zu erstellen
%
% Verschieden Vorgaben
%
% Sinus ------------------------------------------------------------------
% s_i.build          = 1;         % Build-Flag
% s_i.dt_vorlauf     = 10.0;      % Vorlaufzeit
% s_i.dt_nachlauf    = 10.0;      % Nachlaufzeit
% s_i.y_vorlauf      = 0.0;       % Vorlaufwert
% s_i.t_sinus        = 10.0;      % gesamte Schwingzeit','ohne Vorlauf
% s_i.y_amp          = 10.0;      % Amplitude
% s_i.T_schwing      = 10.0;      % Schwinglänge','für eine Schwingung
% s_i.phi_phase      =  0.0;      % Phasenverschiebung sin(omega*t+phi)
% s_i.damp           =  0.0;      % Dämpfung','d = 0 keine dämpfung, < 0 aufklingend, > 0 abklingend
%
% [x_val,y_val]     =  generate_curve(s_i,dt)
% [x_val,y_val,s_i] =  generate_curve(s_i,dt)
%
% Trapez ------------------------------------------------------------------
% s_i.build          = 1;         % Build-Flag
% s_i.mode           = 'trapez';
% s_i.dt_vor_gesamt  = 10.0;      % Vorlaufzeit vor anzahl*Trapez
% s_i.dt_nach_gesamt = 10.0;      % Nachlaufzeit nach anzahl*Trapez
% s_i.dt_vorlauf     = 10.0;      % Vorlaufzeit
% s_i.dt_nachlauf    = 10.0;      % Nachlaufzeit
% s_i.y_vorlauf      = 0.0;       % Vorlaufwert
% s_i.y_nachlauf     = 0.0;       % Vorlaufwert
% s_i.grad_anstieg   = 10.0;      % Gradient Anstieg
% s_i.grad_abstieg   = 10.0;      % Gradient Abstieg
% s_i.y_amp          = 10.0;      % Amplitude
% s_i.dt_amp         = 10.0;      % Haltezeit
% s_i.anzahl         = 2;         % Wiederholung
% s_i.wechsel        = 1;         % 0: kein Wechsel, 1:Vorzeichenwechsel bei jedem 2. Trapez
% 
% [x_val,y_val]     =  generate_curve(s_i,dt)
% [x_val,y_val,s_i] =  generate_curve(s_i,dt)
%
% Step ------------------------------------------------------------------
% s_i.build          = 1;         % Build-Flag
% s_i.mode           = 'step';
% s_i.dt_vorlauf     = 0.1;       % Vorlaufzeit
% s_i.dt_step        = 0.01       % Stepzeit Zeit in der der step-wert ansteht
% s_i.dt_nachlauf    = 2;         % Nachlaufzeit','Der Abbauübergang liegt in der Nachlaufzeit'};
% s_i.y_vorlauf      = 0.0;       % Vorlaufwert',''};
% s_i.y_step         = 1.0;       % Stepwert'     ,''};
% s_i.y_nachlauf     = 10.0;      % Nachlaufwert',''};
% s_i.step_typ_auf   = 0;         % Typ Übergang Aufbau','=0: Sprung,n=1: e-Funktion,=2: Cosinus'};
% s_i.t_step_auf     = 0.1        % Zeitkonsante Aufbau','typ=1:3*tau;typ=2:Verschleifzeit'};
% s_i.step_typ_ab    = 0;         % Typ Übergang Abbau','=0: Sprung,n=1: e-Funktion,=2: Cosinus'};
% s_i.t_step_ab      = 0.1        % Zeitkonsante Abbau','typ=1:3*tau;typ=2:Verschleifzeit'};
% s_i.n_wiederhol    = 1;         % Wiederholrate',''};
%
% [x_val,y_val]     =  generate_curve(s_i,dt)
% [x_val,y_val,s_i] =  generate_curve(s_i,dt)
% 
% Plotten
% wenn build gesetzt, kann auch geplottet werden
% s_i.plot = 1;
%
function [x_val_out,y_val_out,s_i_out] =  generate_curve(s_i_inp,dt)
%
% input-Struktur
%
  build_flag       = 0;
  interactive_flag = 1;
  load_flag        = 0;
  if( nargin == 0  )

      s_i_inp.nixnutz = 0;

  else

      if( exist('s_i_inp','var') && ~exist('dt','var') )
        if( check_val_in_struct(s_i_inp,'delta_t','num',1) )
          dt = s_i_inp.delta_t;
        end
      end


      if( isstruct(s_i_inp) )
          if( isfield(s_i_inp,'build') && s_i_inp.build )
            build_flag       = 1;
            interactive_flag = 0;
            plot_flag        = 0;
          else
            interactive_flag = 1;
            plot_flag        = 1;
            build_flag       = 0;
          end
          if( isfield(s_i_inp,'interactive') && s_i_inp.interactive )
            interactive_flag = 1;
          end
          if( isfield(s_i_inp,'plot') )
            if( s_i_inp.plot )
              plot_flag = 1;
            else
              plot_flag = 0;
            end
          end
      elseif( isnumeric(s_i_inp) )
          interactive_flag = 1;
          dt = s_i_inp;
          s_i_inp.nixnutz = 0;
      elseif( ischar(s_i_inp) )
          interactive_flag = 0;
          load_flag        = 1;
          datname          = s_i_inp;
          clear s_i_inp
          if( ~exist(datname,'file') )
              error('Kenndatendatei: %s existiert nicht',datname)
          end
          s_i_inp.nixnutz = 0;
      else
          error(' Typ erste Parameter ist nicht korrekt')
      end
      if( interactive_flag )

          if( exist('dt','var') && isnumeric(dt) )
              s_i_inp.delta_t = dt;
          end
      else
          if( exist('dt','var') && isnumeric(dt) )
              s_i_inp.delta_t = dt;
          else
              error('2. Parameter mit dt fehlt')
          end
      end

  end

  s_i = s_i_inp;

  %=================================================================
  if( ~isfield(s_i,'t_min') )
      s_i.t_min = 0.0;
  end
  if( ~isfield(s_i,'t_max') )
      s_i.t_max = s_i.t_min + 10;
  end
  %=================================================================
  if( ~isfield(s_i,'y_min') )
      s_i.y_min = 0.0;
  end
  if( ~isfield(s_i,'y_max') )
      s_i.y_max = s_i.y_min + 10;
  end
  %=================================================================
  if( ~isfield(s_i,'delta_t' ) )

      val = input('Welche Abtastschrittweite soll eingestellt werden  :');

      if( val )
          s_i.delta_t = val;
      else
          error('generate_curve_error: ''delta_t'' ist null');
      end
  end
  %=================================================================
  if( ~isfield(s_i,'x_name') )
      s_i.x_name= 'x-Wert';
  end
  %=================================================================
  if( ~isfield(s_i,'y_name') )
      s_i.y_name= 'y-Wert';
  end
  %=================================================================
  if( ~isfield(s_i,'x_unit') )
      s_i.x_unit= '';
  end
  %=================================================================
  if( ~isfield(s_i,'y_unit') )
      s_i.y_unit= '';
  end
  %=================================================================                                                   
  if( ~isfield(s_i,'mode') )
      s_i.mode = 'none';
  end
  %=================================================================
  if( ~isfield(s_i,'x_kenn') )
      s_i.x_kenn= [];
  end
  %=================================================================
  if( ~isfield(s_i,'y_kenn') )
      s_i.y_kenn= [];
  end
  %=================================================================
  if( ~isfield(s_i,'x_mess') )
      s_i.x_mess= [];
  end
  %=================================================================
  if( ~isfield(s_i,'y_mess') )
      s_i.y_mess= [];
  end

  %
  % Initialisieren
  %
  s_i.n_kenn      = min(length(s_i.x_kenn),length(s_i.y_kenn));
  s_i.h           = 0;
  s_i.plot_xlabel = [s_i.x_name,' [',s_i.x_unit,']'];
  s_i.plot_ylabel = [s_i.y_name,' [',s_i.y_unit,']'];

  x_val = [];
  y_val = [];


  %------------------------------------------------------------------------
  % if( build_flag )
  %     [x_val,y_val,s_i] = generate_kennlinie_erstellen(s_i);
  %     if( s_i.plot )
  %       s_i = generate_plot_val(x_val,y_val,s_i);
  %     end
  % else
        
  if( interactive_flag || build_flag || plot_flag )
     run_flag = 1;
  else
      run_flag = 0;
  end
  while( run_flag )
        
    if( interactive_flag )

        choice = '';
        while( isempty(choice))
            fprintf('\n');
            disp('generate_curve:------------------------------------')
            disp(' ')
            disp(' 0: Beenden')
            disp(' 1: Einladen Kenndaten')
            disp(' 2: Speichern Kenndaten')
            disp(' 3: Editieren Kenndaten')
            disp(' 4: grafische Vorgabe')
            disp(' 5: Step-Vorgabe')
            disp(' 6: Sinus-Vorgabe')
            disp(' 7: Trapez-Vorgabe')
            disp(' 8: Sprung+PT1-Anstieg')
            disp(' 9: Messkurve verwenden')
            disp(' 10: Doppel-Trapez-Vorgabe')
            disp(' 20: Kurve erstellen')
            disp(' 21: Kurve erstellen und beenden')
            max_num = 21;
            choice = input('Aktion ? : ','s');
        end
        choice = floor(str2double(round(choice)));
        if( choice > max_num || choice < 0 )
            disp('Falsche Eingabe')
            choice = -1;
        else
            choice = max(min(floor(choice),max_num),0);
        end
    else % not interactive
      
      if( build_flag || plot_flag )
        choice = 21;
      else
        choice = 0;
      end
    end % interactive

    if( isfield(s_i,'h') )
        h_exist = get_fig_numbers;
        for i=1:length(h_exist)
            if( h_exist(i) == s_i.h )
                close(s_i.h);
                s_i.h = 0;
                break
            end
        end
    end

    switch choice
      case -1
      % Wiederholen
      case 0 % Beenden

        run_flag = 0;

        if( isempty(x_val) )
            fprintf('\n Es wurde keine Kurve generiert\n');
        end

      case 1 % Kennlinie laden

        s_i = generate_curve_load(s_i);

        if( strcmp(s_i.mode,'kennlinie') )

          plot(s_i.x_kenn,s_i.y_kenn,'g')
          axis([min(min(s_i.x_kenn),s_i.t_min) ...
              ,max(max(s_i.x_kenn),s_i.t_max) ...
              ,min(min(s_i.y_kenn),s_i.y_min) ...
              ,max(max(s_i.y_kenn),s_i.y_max) ...
              ]);
          xlabel(s_i.plot_xlabel)
          ylabel(s_i.plot_ylabel)
          grid on
          hold off
        end    
      case 2 % Kennlinie speichern

        if( strcmp(s_i.mode,'kennlinie') ...
          || strcmp(s_i.mode,'step') ...
          || strcmp(s_i.mode,'sinus') ...
          || strcmp(s_i.mode,'trapez') ...
          || strcmp(s_i.mode,'sprungPT1') ...
          || strcmp(s_i.mode,'doppel_trapez') ...
          )

            s_i = generate_curve_save(s_i);
        elseif( strcmp(s_i.mode,'mess') )
            s_i = generate_curve_mess(s_i,2); % Messwerte in Kennlinie wandeln
            s_i = generate_curve_save(s_i);
        end

      case 3 % Kennlinie editieren

        [filename, pathname]=uigetfile('*.ken','Datei zum Editieren auswählen');

        if( filename ~= 0 )

            command = ['edit ',pathname,filename];
            eval(command);
        end

      case 4 % Neue Kennlinie grafisch eingeben

        s_i = generate_curve_graf(s_i);

      case 5 % Step

        s_i = generate_curve_step(s_i,1); % Kennwerte eingeben
        s_i = generate_curve_step(s_i,2); % Kennwerte darstellen

      case 6 % Sinus

        s_i = generate_curve_sinus(s_i,1); % Kennwerte eingeben
        s_i = generate_curve_sinus(s_i,2); % Kennwerte darstellen

      case 7 % Trapez

        s_i = generate_curve_trapez(s_i,1); % Kennwerte eingeben
        s_i = generate_curve_trapez(s_i,2); % Kennwerte darstellen

      case 8 % PT1

        s_i = generate_curve_sprung_PT1(s_i,1); % Kennwerte eingeben
        s_i = generate_curve_sprung_PT1(s_i,2); % Kennwerte darstellen
      case 9 % Messkurve

        if( (isempty(s_i.x_mess)) || (isempty(s_i.y_mess))  )
            fprintf('\n Es wurden keine Messwerte übergeben');
        else
            s_i = generate_curve_mess(s_i,1); % Messwerte darstellen
        end

      case 10 % Doppel-Trapez

        s_i = generate_curve_doppel_trapez(s_i,1); % Kennwerte eingeben
        s_i = generate_curve_doppel_trapez(s_i,2); % Kennwerte darstellen

      case {20,21} % Kurve erstellen
        %

        [x_val,y_val,s_i] = generate_kennlinie_erstellen(s_i);

        if( plot_flag )
          if( ~isempty(x_val) && length(x_val) == length(y_val) )
            s_i = generate_plot_val(x_val,y_val,s_i);
          else
           fprintf('\n Es sind keine Kennwerte eigegeben');
          end
        end
        if( choice == 21 )
            run_flag = 0;
        end
    end
  end

  if( load_flag )
    s_i = generate_curve_load(s_i,datname);
    [x_val,y_val,s_i] = generate_kennlinie_erstellen(s_i);
  end



  if( nargout > 0 )
    x_val_out = x_val;
  end
  if( nargout > 1 )
    y_val_out = y_val;
  end
  if(nargout > 2 )
    s_i_out = s_i;
  end    
end
%
%================== generate_curve_load =========================================
%
function  s_i = generate_curve_load(s_i,filename)

    if( ~exist('filename','var') )

        [filename, pathname]=uigetfile('*.ken','Datei auswählen');
    else
        pathname = '';
    end
	
	if( filename ~= 0 )                
        fid = fopen([pathname,filename],'r');
        
        if( fid < 0 )
            fprintf('File %s could not be openend',[pathname,filename]);
        else
                
            text = fscanf(fid,'%c');
            c_text = generate_curve_c_text(text);
            
            if( strcmp(c_text{1},'kennlinie') )
                
                s_i.mode = c_text{1};
                
                s_i.x_kenn = [];
                s_i.y_kenn = [];
                s_i.n_kenn = 0;
                for i=2:length(c_text)
                    
                    if( ~isempty(c_text{i}) )
                        
                        [t1,t2] = strtok(c_text{i},',');
                        t2      = strtok(t2,',');
                        
                        t1 = str_cut_e_f(t1,' ');
                        t1 = str_cut_a_f(t1,' ');
                        
                        s_i.x_kenn = [s_i.x_kenn;str2double(t1)];
                        s_i.y_kenn = [s_i.y_kenn;str2double(t2)];
                    end
                end
                
                s_i.n_kenn = length(s_i.x_kenn);
            elseif( strcmp(c_text{1},'step') )
                
                s_i = generate_curve_step(s_i,5,c_text); % Kennwerte auslesen
                
            elseif( strcmp(c_text{1},'sinus') )
                
                s_i = generate_curve_sinus(s_i,5,c_text); % Kennwerte auslesen
                
            elseif( strcmp(c_text{1},'trapez') )
                
                s_i = generate_curve_trapez(s_i,5,c_text); % Kennwerte auslesen

            elseif( strcmp(c_text{1},'sprungPT1') )
                
                s_i = generate_curve_sprung_PT1(s_i,5,c_text); % Kennwerte auslesen
                
            elseif( strcmp(c_text{1},'doppel_trapez') )
                
                s_i = generate_curve_doppel_trapez(s_i,5,c_text); % Kennwerte auslesen

            end
        end
	end
end  
%
%================== generate_curve_save =========================================
%
function  s_i = generate_curve_save(s_i)

mode = s_i.mode;

if( strcmp(mode,'none') )
    
    fprintf('Keine Kennlinie erstellt oder geladen')
else

    [filename, pathname] = uiputfile('*.ken', 'Sichere Kennlinie');
    if( filename ~= 0 )                
        if( ~contains(filename,'.') )
            s_i.filename_save  = [pathname,filename,'.ken'];
        else
            s_i.filename_save  = [pathname,filename];
        end
        
    
       
        if( strcmp(mode,'kennlinie') )
	
            x_kenn = s_i.x_kenn;
            y_kenn = s_i.y_kenn;
	
            if( (isempty(x_kenn)) || (isempty(y_kenn)) )
            
                fprintf('(length(x_kenn) == 0) | (length(y_kenn) == 0) Keine Kennlinie erstellt oder geladen')
            else
             
                fid = fopen([s_i.filename_save],'w');
                fprintf(fid,'%s\n',mode');
                for i=1:min(length(x_kenn),length(y_kenn))
                    
                    fprintf(fid,'%g     ,     %g\n',x_kenn(i),y_kenn(i));
                end
                fclose(fid);    
            end
            
        elseif( strcmp(mode,'step') )
            
            s_i = generate_curve_step(s_i,4); % Kennwerte speichern
            
        elseif( strcmp(mode,'sinus') )
            
            s_i = generate_curve_sinus(s_i,4); % Kennwerte speichern
            
        elseif( strcmp(mode,'trapez') )
            
            s_i = generate_curve_trapez(s_i,4); % Kennwerte speichern
            
        elseif( strcmp(mode,'sprungPT1') )
            
            s_i = generate_sprung_PT1(s_i,4); % Kennwerte speichern
            
        elseif( strcmp(mode,'doppel_trapez') )
            
            s_i = generate_curve_doppel_trapez(s_i,4); % Kennwerte speichern
            
        end
    end
     
end         
end     
%
%================== generate_curve_graf =========================================
%
function   s_i = generate_curve_graf(s_i)
 
    %------------------------------------------------------------------------
    run_flag = 1;
    max_num  = 2;
    while( run_flag )
    
        if( isempty(s_i.x_kenn) || isempty(s_i.y_kenn) )
          choice = '1';
        else
          choice = '';
        end
        while( isempty(choice))
            disp('graf:------------------------------------')
            disp(' ')
            disp(' 0: Beenden')
            disp(' 1: neue Kennlinie')
            disp(' 2: Kennlinie modifizieren')            
            choice = input('Aktion ? : ','s');
        end
        choice = floor(str2double(choice));
        choice = max(min(floor(choice),max_num),0);
    
    
        switch choice
            case 0 % ende
                run_flag = 0;
                
            case 1 % neue Kennlinie
                
                run_flag = 0;
               s_i.mode = 'kennlinie';
                s_i.h=figure;

                axis([s_i.t_min s_i.t_max s_i.y_min s_i.y_max]);
                xlabel(s_i.plot_xlabel)
                ylabel(s_i.plot_ylabel)
                grid on 
                hold on
        
                s_i.x_kenn = [];
                s_i.y_kenn = [];
                s_i.n_kenn = 0;

                %
                % Werte eingeben
                %
                but = 1;
                while but == 1
                    [xi,yi,but] = ginput(1);
                    if but == 1
                        plot(xi,yi,'go','era','back') 
                        s_i.n_kenn = s_i.n_kenn + 1;
                        text(xi,yi,[' ' int2str(s_i.n_kenn)],'era','back');

                        s_i.x_kenn = [s_i.x_kenn;xi];
                        s_i.y_kenn = [s_i.y_kenn;yi];
                    end  
                end

                [s_i.x_kenn,s_i.y_kenn] = generate_curve_proof(s_i.x_kenn,s_i.y_kenn);
    
                %
                % Kontrolplot
                plot(s_i.x_kenn,s_i.y_kenn)
                
    
        
            case 2 % Kennlinie grafisch modifizieren

                run_flag = 0;
                if( ~strcmp(s_i.mode,'kennlinie') ...
                  || (s_i.n_kenn == 0) ...
                  || (isempty(s_i.x_kenn)) ...
                  || (isempty(s_i.y_kenn)) ...
                  )
        
                    fprintf('Keine Kennlinie erstellt oder geladen\n')
                    fprintf('\n mode = %s\n',s_i.mode);
                    fprintf('\n n_kenn = %f\n',s_i.n_kenn);
                else

                    s_i.h=figure;

                    %
                    % Werte eingeben
                    %
                    but = 1;
                    while but == 1
        
                        plot(s_i.x_kenn,s_i.y_kenn,'r-')
                        axis([min(min(s_i.x_kenn),s_i.t_min) ...
                             ,max(max(s_i.x_kenn),s_i.t_max) ...
                             ,min(min(s_i.y_kenn),s_i.y_min) ...
                             ,max(max(s_i.y_kenn),s_i.y_max) ...
                             ]);
                        xlabel(s_i.plot_xlabel)
                        ylabel(s_i.plot_ylabel)
                        grid on
                        hold on
                        for i=1:s_i.n_kenn
                            plot(s_i.x_kenn(i),s_i.y_kenn(i),'ro','era','back')
                        end

                        [xi,yi,but] = ginput(1);

                        if but == 1                    

                            % neuen wert einfügen
                            if( xi > max(max(s_i.x_kenn),s_i.t_max) ) 
                    
                    
                                answer  = inputdlg({[s_i.plot_xlabel,' :'],[s_i.plot_ylabel,' :']} ...
                                                  ,['Neuen ',num2str(s_i.n_kenn+1),'. Wert eingeben'] ...
                                                  ,1 ...
                                                  ,{num2str(s_i.x_kenn(s_i.n_kenn)+1),num2str(s_i.y_kenn(s_i.n_kenn))} ...
                                                  );
                                if( ~isempty(answer) )              
                                    s_i.n_kenn = s_i.n_kenn + 1;
                                    s_i.x_kenn(s_i.n_kenn) = str2double(answer{1});
                                    s_i.y_kenn(s_i.n_kenn)   = str2double(answer{2});
                                end    
                                
                            % wert modifizieren
                            else 
                    
                                % Suche den kleinensten Abstand
                                dr = ones(s_i.n_kenn,1)*100000000;
                                for i=1:s_i.n_kenn
                                    dr(i) = sqrt( ((s_i.x_kenn(i)-xi)/(s_i.t_max-s_i.t_min))^2 ...
                                    + ((s_i.y_kenn(i)-yi)/(s_i.y_max-s_i.y_min))^2 ...
                                    );                                
                                end
                
                                [~,i0] = min(dr);
                
                                if( i0 > 0 && i0 <= s_i.n_kenn )

                                    answer  = inputdlg({[s_i.plot_xlabel,' :'],[s_i.plot_ylabel,' :']} ...
                                                      ,[num2str(i0),'. Wert modifizieren'] ...
                                                      ,1 ...
                                                      ,{num2str(s_i.x_kenn(i0)),num2str(s_i.y_kenn(i0))} ...
                                                      );
                                      
                                    if( ~isempty(answer) )
                                        if( isempty(answer{1}) || isempty(answer{2}) )
                                
                                            if( i0 == 1 )
                                                s_i.x_kenn = s_i.x_kenn(i0+1:s_i.n_kenn);
                                                s_i.y_kenn   = s_i.y_kenn(i0+1:s_i.n_kenn);
                                            elseif( i0 == n_g )
                                                s_i.x_kenn = s_i.x_kenn(1:s_i.n_kenn-1);
                                                s_i.y_kenn = s_i.y_kenn(1:s_i.n_kenn-1);
                                            else
                                                s_i.x_kenn = [s_i.x_kenn(1:i0-1);s_i.x_kenn(i0+1:s_i.n_kenn)];
                                                s_i.y_kenn   = [s_i.y_kenn(1:i0-1);s_i.y_kenn(i0+1:s_i.n_kenn)];
                                            end
                                            s_i.n_kenn     = s_i.n_kenn - 1;
                                        else
                                            s_i.x_kenn(i0) = str2double(answer{1});
                                            s_i.y_kenn(i0)   = str2double(answer{2});
                                        end
                                    end
                        
                                end
                            end
                                          
                         end 
                        hold off
                    end
                end
        end
    end
end
%
%================== generate_curve_step =========================================
%
function   [s_i,x_val,y_val] = generate_curve_step(s_i,option,c_text)
%
% option == 1 : generiere neue werte für Kurve (abfragen)
% option == 2 : zeigt Werte der Kurve an
% option == 3 : Kurve berechnen
% option == 4 : Kennwerte speichern
% option == 5 : Kennwerte auslesen aus c_text
%
x_val = [];
y_val = [];
s_i.mode='step';
%           
c_arr{1} = {'dt_vorlauf'   ,s_i.x_unit  ,'Vorlaufzeit',''};
c_arr{2} = {'dt_step'      ,s_i.x_unit  ,'Stepzeit' ,'Zeit in der der step-wert ansteht'};
c_arr{3} = {'dt_nachlauf'  ,s_i.x_unit  ,'Nachlaufzeit','Der Abbauübergang liegt in der Nachlaufzeit'};
c_arr{4} = {'y_vorlauf'    ,s_i.y_unit  ,'Vorlaufwert',''};
c_arr{5} = {'y_step'       ,s_i.y_unit  ,'Stepwert'     ,''};
c_arr{6} = {'y_nachlauf'   ,s_i.y_unit  ,'Nachlaufwert',''};
c_arr{7} = {'step_typ_auf' ,''          ,'Typ Übergang Aufbau','=0: Sprung,n=1: e-Funktion,=2: Cosinus'};
c_arr{8} = {'t_step_auf'   ,s_i.x_unit  ,'Zeitkonsante Aufbau','typ=1:3*tau;typ=2:Verschleifzeit'};
c_arr{9} = {'step_typ_ab'  ,''          ,'Typ Übergang Abbau','=0: Sprung,n=1: e-Funktion,=2: Cosinus'};
c_arr{10}= {'t_step_ab'    ,s_i.x_unit  ,'Zeitkonsante Abbau','typ=1:3*tau;typ=2:Verschleifzeit'};
c_arr{11}= {'n_wiederhol'  ,''          ,'Wiederholrate',''};
    


if( option == 1 )
    
    %
    % 
    %------------------------------------------------------------
    for i=1:length(c_arr)
        
        if( isfield(s_i,c_arr{i}{1}) )
            t_val = num2str(s_i.(c_arr{i}{1}));
        else
            t_val = '';
        end
        
        switch(i)
            case {1,2,3,4,5,6,7,9,11}    

                s_i.(c_arr{i}{1}) = generate_curve_ask_val(c_arr{i},t_val);
            case {8,10}
                
                % t_aufbau
                if( s_i.(c_arr{i-1}{1}) > 0.5 )

                    s_i.(c_arr{i}{1}) = generate_curve_ask_val(c_arr{i},t_val);
                else
                    s_i.(c_arr{i}{1}) = 0;
                end
        end

    end
    
elseif( option == 2 )
    
    fprintf('\n');
    fprintf('\ns_i.build          = 0/1;         %% Build-Flag');
    fprintf('\ns_i.mode           = ''step'';');

    for i=1:length(c_arr)       
        %fprintf('\n%-20s [%-10s] : %g %s',c_arr{i}{1},c_arr{i}{2},s_i.(c_arr{i}{1}),c_arr{i}{3});
        fprintf('\ns_i.%s = %g; %% [%s] %s',c_arr{i}{1},s_i.(c_arr{i}{1}),c_arr{i}{2},c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf('  (%s)',c_arr{i}{4});
        end
    end
    
elseif( option == 3 ) % Kurve bestimmen
    
    delta_t = s_i.delta_t;
    
    x0 = 0;
    x1 = x0+abs(s_i.(c_arr{1}{1}));
    x2 = x1+abs(s_i.(c_arr{2}{1}));
    x3 = x2+abs(s_i.(c_arr{3}{1}));
    
    n = abs(s_i.(c_arr{11}{1}));
    
    y0 = s_i.(c_arr{4}{1});
    y1 = s_i.(c_arr{5}{1});
    y2 = s_i.(c_arr{6}{1});
    
    typ1 = max(0,s_i.(c_arr{7}{1}));
    T1 = max(0.00000001,abs(s_i.(c_arr{8}{1})));

    typ2 = max(0,s_i.(c_arr{9}{1}));
    T2 = max(0.00000001,abs(s_i.(c_arr{10}{1})));
    
    x = x0:delta_t:x3;
    x = x';
    y = x*0;
    y10 = 0;
    for i=1:length(x)
        
        if( x(i) < x1 )
            
            y(i) = y0;
            y10  = y0;
        elseif( x(i) < x2 )
            
            if( typ1 < 0.5 )
                
                y(i) = y1;
            elseif( typ1 < 1.5 )
                
                y(i) = y0+(y1-y0)*(1.0-exp((x1-x(i))/(T1/3)));
            else
                
                if( x(i) < x1+T1 )
                    y(i) = y0+(y1-y0)*0.5*(1.0-cos((x(i)-x1)*pi/T1));
                else
                    y(i) = y1;
                end
            end
            y10 = y(i);
        else
            
            if( typ2 < 0.5 )
                
                y(i) = y2;
            elseif( typ2 < 1.5 )
                
                y(i) = y10+(y2-y10)*(1.0-exp((x2-x(i))/(T2/3)));
            else

                if( x(i) < x2+T2 )
                    y(i) = y10+(y2-y10)*0.5*(1.0-cos((x(i)-x2)*pi/T2));
                else
                    y(i) = y2;
                end
            end
        end
    end
    
    x_val = x;
    y_val = y;
    nxy   = length(x);
    
    i = 1;
    
    while( i < n )        
        x_val = [x_val; x(2:nxy)+x_val(length(x_val))]; %#ok<AGROW>
        y_val = [y_val; y(2:nxy)]; %#ok<AGROW>
        i = i+1;
    end
                
elseif( option == 4 )
    
    fid = fopen([s_i.filename_save],'w');
    fprintf(fid,'%s\n',s_i.mode');
    for i=1:length(c_arr) 
        fprintf(fid,'%%               %s\n',c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf(fid,'%%               (%s)\n',c_arr{i}{4});
        end
        fprintf(fid,'%s = %g\n',c_arr{i}{1},s_i.(c_arr{i}{1}));
    end
    fclose(fid);    
                    
elseif( option == 5 )
    
    for i=1:length(c_text)
        
        [t1,t2] = strtok(c_text{i},'=');
         t2      = strtok(t2,'=');

         t1      = str_cut_ae_f(t1,' ');
         t2      = str_cut_ae_f(t2,' ');
         
         
         for j=1:length(c_arr)
             
             if( strcmp(c_arr{j}{1},t1) )
                 
                 s_i.(c_arr{j}{1}) = str2double(t2);
             end
         end
     end
     
     % Prüfen
     %
     for i=1:length(c_arr)
         
         if( ~isfield(s_i,c_arr{i}{1}) )
             
             s_i.(c_arr{i}{1}) = 1;
         end
     end    
end
end
%================== generate_curve_sinus =========================================
%
function   [s_i,x_val,y_val] = generate_curve_sinus(s_i,option,c_text)
%
% option == 1 : generiere neue werte für Kurve (abfragen)
% option == 2 : zeigt Werte der Kurve an
% option == 3 : Kurve berechnen
% option == 4 : Kennwerte speichern
% option == 5 : Kennwerte auslesen aus c_text
%
x_val = [];
y_val = [];
s_i.mode='sinus';
%           
c_arr{1} = {'dt_vorlauf'   ,s_i.x_unit  ,'Vorlaufzeit',''};
c_arr{2} = {'dt_nachlauf'  ,s_i.x_unit  ,'Nachlaufzeit',''};
c_arr{3} = {'t_sinus'     ,s_i.x_unit  ,'gesamte Schwingzeit','ohne Vorlauf'};
c_arr{4} = {'y_vorlauf'    ,s_i.y_unit  ,'Vorlaufwert',''};
c_arr{5} = {'y_amp'        ,s_i.y_unit  ,'Amplitude',''};
c_arr{6} = {'T_schwing'    ,s_i.x_unit  ,'Schwinglänge','für eine Schwingung'};
c_arr{7} = {'phi_phase'    ,'grad'      ,'Phasenverschiebung' ,'sin(omega*t+phi'};
c_arr{8} = {'damp'         ,'-'         ,'Dämpfung','d = 0 keine dämpfung, < 0 aufklingend, > 0 abklingend'};
    



if( option == 1 ) % neue werte generieren
    
    %
    % 
    %------------------------------------------------------------
    for i=1:length(c_arr)
        
        if( isfield(s_i,c_arr{i}{1}) )
            t_val = num2str(s_i.(c_arr{i}{1}));
        else
            t_val = '';
        end
        
        s_i.(c_arr{i}{1}) = generate_curve_ask_val(c_arr{i},t_val);

    end
    
elseif( option == 2 )
    
    fprintf('\n');
    for i=1:length(c_arr)       
        fprintf('\n%-20s [%-10s] : %g %s',c_arr{i}{1},c_arr{i}{2},s_i.(c_arr{i}{1}),c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf('\n%60s(%s)',' ',c_arr{i}{4});
        end
    end
    
elseif( option == 3 ) % Kurve bestimmen
    
    if( ~isfield(s_i,'delta_t') )
      error('s_i.delta_t muss bestimt sein');
    end
    for i=1:length(c_arr)       
        if( ~isfield(s_i,c_arr{i}{1}) )
            error('s_i.%s muss bestimt sein',c_arr{i}{1});
        end
    end
    
    
    delta_t = s_i.delta_t;
    
    x0 = 0;
    x1 = x0+s_i.(c_arr{1}{1});
    y0 = s_i.(c_arr{4}{1});

    x2    = x1+s_i.(c_arr{3}{1});
    x3    = x2+s_i.(c_arr{2}{1});
    y_amp = s_i.(c_arr{5}{1});
    
    T     = max(0.0000001,abs(s_i.(c_arr{6}{1})));
    phi   = s_i.(c_arr{7}{1})/180*pi;
    
    omega = 2*pi/T;
    
    D = s_i.(c_arr{8}{1});    

    d = omega*D;
    
    x = x0:delta_t:x3;
    x = x';
    y = x*0;
    yy  = 0;
    
    for i=1:length(x)
        
        if( x(i) < x1 )
            
            y(i) = y0;
            yy   = y(i);
        elseif( x(i) <= x2 )
            
            y(i) = y0 + y_amp * sin((x(i)-x1)*omega+phi) * exp(-d*x(i));
            yy   = y(i);
        else
            y(i) = yy;
        end
            
    end
    
    x_val = x;
    y_val = y;
                
elseif( option == 4 )
    
    fid = fopen([s_i.filename_save],'w');
    fprintf(fid,'%s\n',s_i.mode');
    for i=1:length(c_arr) 
        fprintf(fid,'%%               %s\n',c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf(fid,'%%               (%s)\n',c_arr{i}{4});
        end
        fprintf(fid,'%s = %g\n',c_arr{i}{1},s_i.(c_arr{i}{1}));
    end
    fclose(fid);    
                    
elseif( option == 5 )
    
    for i=1:length(c_text)
        
        [t1,t2] = strtok(c_text{i},'=');
         t2      = strtok(t2,'=');

         t1      = str_cut_ae_f(t1,' ');
         t2      = str_cut_ae_f(t2,' ');
         
         for j=1:length(c_arr)
             
             if( strcmp(c_arr{j}{1},t1) )
                 
                 s_i.(c_arr{j}{1}) = str2double(t2);
             end
         end
     end
     
     % Prüfen
     %
     for i=1:length(c_arr)
         
         if( ~isfield(s_i,c_arr{i}{1}) )
             
             s_i.(c_arr{i}{1}) = 1;
         end
     end    
end
end
%================== generate_curve_trapez =========================================
%
function   [s_i,x_val,y_val] = generate_curve_trapez(s_i,option,c_text)
%
% option == 1 : generiere neue werte für Kurve (abfragen)
% option == 2 : zeigt Werte der Kurve an
% option == 3 : Kurve berechnen
% option == 4 : Kennwerte speichern
% option == 5 : Kennwerte auslesen aus c_text
%
x_val = [];
y_val = [];
s_i.mode='trapez';
%           
c_arr{1}  = {'dt_vorlauf'   ,s_i.x_unit  ,'Vorlaufzeit des Trapez',''};
c_arr{2}  = {'dt_nachlauf'  ,s_i.x_unit  ,'Nachlaufzeit des Trapez',''};
c_arr{3}  = {'dt_amp'        ,s_i.x_unit  ,'Haltezeit des Trapez',''};
c_arr{4}  = {'grad_anstieg'     ,[s_i.y_unit,'/s']  ,'Gradient Anstieg Trapez',''};
c_arr{5}  = {'grad_abstieg'     ,[s_i.y_unit,'/s']  ,'Gradient Abstieg Trapez',''};
c_arr{6}  = {'y_vorlauf'     ,s_i.y_unit  ,'Vorlaufwert',''};
c_arr{7}  = {'y_nachlauf'    ,s_i.y_unit  ,'Nachlaufwert',''};
c_arr{8}  = {'y_amp'         ,s_i.y_unit  ,'Amplitude Trapez',''};
c_arr{9}  = {'dt_vor_gesamt' ,s_i.x_unit  ,'Vorlaufzeit vor anzahl*Trapez',''};
c_arr{10} = {'dt_nach_gesamt',s_i.x_unit  ,'Nachlaufzeit nach anzahl*Trapez',''};
c_arr{11} = {'anzahl'         ,s_i.y_unit  ,'Anzahl der Trapeze hintereinander',''};
c_arr{12} = {'wechsel'         ,s_i.y_unit  ,'0: kein Wechsel, 1:Vorzeichenwechsel bei jedem 2. Trapez',''};
 



if( option == 1 ) % neue werte generieren
    
    %
    % 
    %------------------------------------------------------------
    for i=1:length(c_arr)
        
        if( isfield(s_i,c_arr{i}{1}) )
            t_val = num2str(s_i.(c_arr{i}{1}));
        else
            t_val = '';
        end
        
        s_i.(c_arr{i}{1}) = generate_curve_ask_val(c_arr{i},t_val);

    end
    
elseif( option == 2 )
    
    fprintf('\n');
    for i=1:length(c_arr)       
        fprintf('\n%-20s [%-10s] : %g %s',c_arr{i}{1},c_arr{i}{2},s_i.(c_arr{i}{1}),c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf('\n%60s(%s)',' ',c_arr{i}{4});
        end
    end
    
elseif( option == 3 ) % Kurve bestimmen
    
    % defaultwerte
    if( ~isfield(s_i,'dt_vor_gesamt') )
        s_i.dt_vor_gesamt = 0.0;
    end
    if( ~isfield(s_i,'dt_nach_gesamt') )
        s_i.dt_nach_gesamt = 0.0;
    end
    if( ~isfield(s_i,'wechsel') )
        s_i.wechsel = 0;
    end
    if( ~isfield(s_i,'anzahl') )
        s_i.anzahl = 1;
    end
    
    if( ~isfield(s_i,'delta_t') )
      error('s_i.delta_t muss bestimt sein');
    end
    for i=1:length(c_arr)       
        if( ~isfield(s_i,c_arr{i}{1}) )
            error('s_i.%s muss bestimt sein',c_arr{i}{1});
        end
    end
    
    delta_t = s_i.delta_t;
    
    x_anf  = s_i.(c_arr{9}{1});
    x_end  = s_i.(c_arr{10}{1});
    anzahl  = s_i.(c_arr{11}{1});
    wechsel = s_i.(c_arr{12}{1});
    
    
    y0 = s_i.(c_arr{6}{1});
    y1 = s_i.(c_arr{6}{1});

    y2 = s_i.(c_arr{8}{1});
    y3 = s_i.(c_arr{8}{1});
    
    y4 = s_i.(c_arr{7}{1});
    %y5 = s_i.(c_arr{7}{1});
    
    dydx_auf =  abs(s_i.(c_arr{4}{1}));
    dydx_ab  =  abs(s_i.(c_arr{5}{1}));
    
    x0 = 0;
    x1 = x0+s_i.(c_arr{1}{1});

    x2    = x1+(y2-y1)/max(0.00001,abs(dydx_auf));
    x3    = x2+s_i.(c_arr{3}{1});

    x4    = x3-(y4-y3)/max(0.00001,abs(dydx_ab));
    x5    = x4+s_i.(c_arr{2}{1});
    
%    [x0,x1,x2,x3,x4,x5]
%    [y0,y1,y2,y3,y4,y5]

    x = x0:delta_t:x5;
    x = x';
    y = x*0;
    n = length(x);
    for i=1:n
        
        if( x(i) < x1 )
            
            y(i) = y0;
        elseif( x(i) <= x2 )
            
            y(i) = y1 + (y2-y1)/(x2-x1)*(x(i)-x1);
        elseif( x(i) <= x3 )
            
            y(i) = y3;
        elseif( x(i) <= x4 )
            
            y(i) = y3 + (y4-y3)/(x4-x3)*(x(i)-x3);
        else
            y(i) = y4;
        end
            
    end

    if( wechsel )
      y0 = s_i.(c_arr{6}{1});
      y1 = s_i.(c_arr{6}{1});

      y2 = s_i.(c_arr{6}{1})-(s_i.(c_arr{8}{1})-s_i.(c_arr{6}{1}));
      y3 = s_i.(c_arr{6}{1})-(s_i.(c_arr{8}{1})-s_i.(c_arr{6}{1}));

      y4 = s_i.(c_arr{7}{1});
      %y5 = s_i.(c_arr{7}{1});

        yw = x*0;
        for i=1:n
          if( x(i) < x1 )

              yw(i) = y0;
          elseif( x(i) <= x2 )

              yw(i) = y1 + (y2-y1)/(x2-x1)*(x(i)-x1);
          elseif( x(i) <= x3 )

              yw(i) = y3;
          elseif( x(i) <= x4 )

              yw(i) = y3 + (y4-y3)/(x4-x3)*(x(i)-x3);
          else
              yw(i) = y4;
          end

        end
    end
    
    % gesamtverlauf
    %==============
    
    % Vorlauf
    %--------
    xx = 0.0:delta_t:x_anf;
    xx = xx';
    yy = xx*0+y(1);
    
    for i = 1:anzahl
        
        if( wechsel && is_even_value(i) )
          xx = [xx;x(2:length(x))+xx(length(xx))]; %#ok<AGROW>
          yy = [yy;yw(2:length(yw))]; %#ok<AGROW>
        else
          xx = [xx;x(2:length(x))+xx(length(xx))]; %#ok<AGROW>
          yy = [yy;y(2:length(y))]; %#ok<AGROW>
        end
    end
    
    xx1 = delta_t:delta_t:x_end;
    xxx = xx(length(xx))+xx1';
    xx = [xx;xxx];
    yy = [yy;xxx*0+yy(length(yy))];
 
    x_val = xx;
    y_val = yy;
                
elseif( option == 4 )
    
    fid = fopen([s_i.filename_save],'w');
    fprintf(fid,'%s\n',s_i.mode');
    for i=1:length(c_arr) 
        fprintf(fid,'%%               %s\n',c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf(fid,'%%               (%s)\n',c_arr{i}{4});
        end
        fprintf(fid,'%s = %g\n',c_arr{i}{1},s_i.(c_arr{i}{1}));
    end
    fclose(fid);    
                    
elseif( option == 5 )
    
    for i=1:length(c_text)
        
        [t1,t2] = strtok(c_text{i},'=');
         t2      = strtok(t2,'=');
         
         t1      = str_cut_ae_f(t1,' ');
         t2      = str_cut_ae_f(t2,' ');
         
         for j=1:length(c_arr)
             
             if( strcmp(c_arr{j}{1},t1) )
                 
                 s_i.(c_arr{j}{1}) = str2double(t2);
             end
         end
     end
     
     % Prüfen
     %
     for i=1:length(c_arr)
         
         if( ~isfield(s_i,c_arr{i}{1}) )
             
             s_i.(c_arr{i}{1}) = 1;
         end
     end    
end
end
%================== generate_curve_sprung_PT1 =========================================
%
function   [s_i,x_val,y_val] = generate_curve_sprung_PT1(s_i,option,c_text)
%
% option == 1 : generiere neue werte für Kurve (abfragen)
% option == 2 : zeigt Werte der Kurve an
% option == 3 : Kurve berechnen
% option == 4 : Kennwerte speichern
% option == 5 : Kennwerte auslesen aus c_text
%
x_val = [];
y_val = [];
s_i.mode='sprungPT1';
%           
c_arr{1} = {'dt_vorlauf'   ,s_i.x_unit  ,'Vorlaufzeit',''};
c_arr{2} = {'dt_nachlauf'  ,s_i.x_unit  ,'Nachlaufzeit',''};
c_arr{3} = {'dx_amp1'       ,[s_i.x_unit]  ,'98% PT1-Zeit',''};
c_arr{4} = {'dx_amp2'        ,s_i.x_unit  ,'Haltezeit',''};
c_arr{5} = {'y_vorlauf'    ,s_i.y_unit  ,'Vorlaufwert',''};
c_arr{6} = {'y_nachlauf'    ,s_i.y_unit  ,'Nachlaufwert',''};
c_arr{7} = {'y_amp1'        ,s_i.y_unit  ,'Sprungamplitude',''};
c_arr{8} = {'y_amp2'        ,s_i.y_unit  ,'Amplitude Gesamt',''};
    



if( option == 1 ) % neue werte generieren
    
    %
    % 
    %------------------------------------------------------------
    for i=1:length(c_arr)
        
        if( isfield(s_i,c_arr{i}{1}) )
            t_val = num2str(s_i.(c_arr{i}{1}));
        else
            t_val = '';
        end
        
        s_i.(c_arr{i}{1}) = generate_curve_ask_val(c_arr{i},t_val);

    end
    
elseif( option == 2 )
    
    fprintf('\n');
    for i=1:length(c_arr)       
        fprintf('\n%-20s [%-10s] : %g %s',c_arr{i}{1},c_arr{i}{2},s_i.(c_arr{i}{1}),c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf('\n%60s(%s)',' ',c_arr{i}{4});
        end
    end
    
elseif( option == 3 ) % Kurve bestimmen
    
    
    delta_t = s_i.delta_t;
        
    y0 = s_i.(c_arr{5}{1});
    y1 = s_i.(c_arr{7}{1});

    y2 = s_i.(c_arr{8}{1});
    y3 = s_i.(c_arr{6}{1});
        
    x0 = 0;
    x1 = x0+s_i.(c_arr{1}{1});

    x2    = x1+s_i.(c_arr{3}{1});
    x3    = x2+s_i.(c_arr{4}{1});

    x4    = x3+s_i.(c_arr{2}{1});
    
%    [x0,x1,x2,x3,x4]
%    [y0,y1,y2,y3,y4]
    x = x0:delta_t:x4;
    x = x';
    y = x*0;
    
    for i=1:length(x)
        
        if( x(i) < x1 )
            
            y(i) = y0;
        elseif( x(i) <= x2 )
            
            y(i) = y1 + (y2-y1)*(1.0-exp(-(x(i)-x1)/(x2-x1)*3));
        elseif( x(i) <= x3 )
            
            y(i) = y(i-1);
        else
            y(i) = y3;
        end
            
    end
    
    x_val = x;
    y_val = y;
                
elseif( option == 4 )
    
    fid = fopen([s_i.filename_save],'w');
    fprintf(fid,'%s\n',s_i.mode');
    for i=1:length(c_arr) 
        fprintf(fid,'%%               %s\n',c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf(fid,'%%               (%s)\n',c_arr{i}{4});
        end
        fprintf(fid,'%s = %g\n',c_arr{i}{1},s_i.(c_arr{i}{1}));
    end
    fclose(fid);    
                    
elseif( option == 5 )
    
    for i=1:length(c_text)
        
        [t1,t2] = strtok(c_text{i},'=');
         t2      = strtok(t2,'=');
         
         t1      = str_cut_ae_f(t1,' ');
         t2      = str_cut_ae_f(t2,' ');
         
         for j=1:length(c_arr)
             
             if( strcmp(c_arr{j}{1},t1) )
                 
                 s_i.(c_arr{j}{1}) = str2double(t2);
             end
         end
     end
     
     % Prüfen
     %
     for i=1:length(c_arr)
         
         if( ~isfield(s_i,c_arr{i}{1}) )
             
             s_i.(c_arr{i}{1}) = 1;
         end
     end    
end
end
%================== generate_curve_mess =========================================
%
function   [s_i,x_val,y_val] = generate_curve_mess(s_i,option)
%
% option == 1 : zeigt Messwerte an
% option == 2 : Messwerte in Kennlinie wandeln
% option == 3 : Kurve berechnen
%
x_val = [];
y_val = [];
s_i.mode='mess';
[nx,mx] = size(s_i.x_mess);
if( nx < mx )
    s_i.x_mess = s_i.x_mess';
    nx = mx;
end
[ny,my] = size(s_i.y_mess);
if( ny < my )
    s_i.y_mess = s_i.y_mess';
    ny = my;
end

n = min(nx,ny);
s_i.x_mess = s_i.x_mess(1:n,1);
s_i.y_mess = s_i.y_mess(1:n,1);
if( option == 1 ) % neue werte generieren
    
    %
    % 
    %------------------------------------------------------------
    
    s_i.h = figure;
	plot(s_i.x_mess,s_i.y_mess,'r')
    axis([min(min(s_i.x_mess),s_i.t_min) ...
        ,max(max(s_i.x_mess),s_i.t_max) ...
        ,min(min(s_i.y_mess),s_i.y_min) ...
        ,max(max(s_i.y_mess),s_i.y_max) ...
        ]);
             
    xlabel(s_i.plot_xlabel)
    ylabel(s_i.plot_ylabel)
    title('eingegebene Messwerte')
             
    grid on
	hold off
elseif( option == 2 )
    
    
    
    
    s_i.x_kenn = s_i.x_mess;
    s_i.y_kenn = s_i.y_mess;
    s_i.mode   = 'kennlinie';
elseif( option == 3 )
    
				x_val = s_i.x_mess(1):s_i.delta_t:s_i.x_mess(length(s_i.x_mess));
        x_val =  x_val';
							
                % physikalische Werte interpolieren
				y_val = interp1(s_i.x_mess,s_i.y_mess,x_val,'linear','extrap');
end
end
%================== generate_curve_doppel_trapez =========================================
%
function   [s_i,x_val,y_val] = generate_curve_doppel_trapez(s_i,option,c_text)
%
% option == 1 : generiere neue werte für Kurve (abfragen)
% option == 2 : zeigt Werte der Kurve an
% option == 3 : Kurve berechnen
% option == 4 : Kennwerte speichern
% option == 5 : Kennwerte auslesen aus c_text
%
x_val = [];
y_val = [];
s_i.mode='doppel_trapez';
%           
c_arr{1} = {'dt_vorlauf'   ,s_i.x_unit  ,'Vorlaufzeit',''};
c_arr{2} = {'dt_nachlauf'  ,s_i.x_unit  ,'Nachlaufzeit',''};
c_arr{3} = {'dx_amp1'      ,s_i.x_unit  ,'1. Haltezeit',''};
c_arr{4} = {'dx_amp2'      ,s_i.x_unit  ,'2. Haltezeit',''};
c_arr{5} = {'dx_amp3'      ,s_i.x_unit  ,'3. Haltezeit',''};
c_arr{6} = {'grad1'        ,[s_i.y_unit,'/s']  ,'1. Gradient (Anstieg)',''};
c_arr{7} = {'grad2'        ,[s_i.y_unit,'/s']  ,'2. Gradient (Anstieg)',''};
c_arr{8} = {'grad3'        ,[s_i.y_unit,'/s']  ,'3. Gradient (Abstieg)',''};
c_arr{9} = {'grad4'        ,[s_i.y_unit,'/s']  ,'4. Gradient (Abstieg)',''};
c_arr{10} = {'y_vorlauf'    ,s_i.y_unit  ,'Vorlaufwert',''};
c_arr{11} = {'y_nachlauf'    ,s_i.y_unit  ,'Nachlaufwert',''};
c_arr{12} = {'y_amp1'        ,s_i.y_unit  ,'1. Amplitude',''};
c_arr{13} = {'y_amp2'        ,s_i.y_unit  ,'2. Amplitude',''};
c_arr{14} = {'y_amp3'        ,s_i.y_unit  ,'3. Amplitude',''};
    



if( option == 1 ) % neue werte generieren
    
    %
    % 
    %------------------------------------------------------------
    for i=1:length(c_arr)
        
        if( isfield(s_i,c_arr{i}{1}) )
            t_val = num2str(s_i.(c_arr{i}{1}));
        else
            t_val = '';
        end
        
        s_i.(c_arr{i}{1}) = generate_curve_ask_val(c_arr{i},t_val);

    end
    
elseif( option == 2 ) % zeigt Werte der Kurve an
    
    fprintf('\n');
    for i=1:length(c_arr)       
        fprintf('\n%-20s [%-10s] : %g %s',c_arr{i}{1},c_arr{i}{2},s_i.(c_arr{i}{1}),c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf('\n%60s(%s)',' ',c_arr{i}{4});
        end
    end
    
elseif( option == 3 ) % Kurve bestimmen
    
    
    delta_t = s_i.delta_t;
    
    y0 = s_i.(c_arr{10}{1});
    y1 = s_i.(c_arr{10}{1});

    y2 = s_i.(c_arr{12}{1});
    y3 = s_i.(c_arr{12}{1});
    
    y4 = s_i.(c_arr{13}{1});
    y5 = s_i.(c_arr{13}{1});
    
    y6 = s_i.(c_arr{14}{1});
    y7 = s_i.(c_arr{14}{1});
    
    y8 = s_i.(c_arr{11}{1});
    y9 = s_i.(c_arr{11}{1});
    
    dydx1 =  s_i.(c_arr{6}{1});
    dydx2 =  s_i.(c_arr{7}{1});
    dydx3 =  s_i.(c_arr{8}{1});
    dydx4 =  s_i.(c_arr{9}{1});
    
    x0 = 0;
    x1 = x0+s_i.(c_arr{1}{1});

    x2    = x1+abs(y2-y1)/max(0.00001,abs(dydx1));
    x3    = x2+s_i.(c_arr{3}{1});
    if( y2-y1 >= 0 )
        dydx1 = abs(dydx1);
    else
        dydx1 = -abs(dydx1);
    end

    x4    = x3+abs(y4-y3)/max(0.00001,abs(dydx2));
    x5    = x4+s_i.(c_arr{4}{1});
    if( y4-y3 >= 0 )
        dydx2 = abs(dydx2);
    else
        dydx2 = -abs(dydx2);
    end

    x6    = x5+abs(y6-y5)/max(0.00001,abs(dydx3));
    x7    = x6+s_i.(c_arr{5}{1});
    if( y6-y5 >= 0 )
        dydx3 = abs(dydx3);
    else
        dydx3 = -abs(dydx3);
    end

    x8    = x7+abs(y8-y7)/max(0.00001,abs(dydx4));
    x9    = x8+s_i.(c_arr{2}{1});    
    if( y8-y7 >= 0 )
        dydx4 = abs(dydx4);
    else
        dydx4 = -abs(dydx4);
    end
    
    % [x0,x1,x2,x3,x4,x5,x6,x7,x8,x9]
    % [y0,y1,y2,y3,y4,y5,y6,y7,y8,y9]
    x = x0:delta_t:x9;
    x = x';
    y = x*0;
    
    for i=1:length(x)
        
        if( x(i) < x1 )
            
            y(i) = y0;
        elseif( x(i) <= x2 )
            
            y(i) = y1 + dydx1*(x(i)-x1);            
        elseif( x(i) <= x3 )
            
            y(i) = y3;
        elseif( x(i) <= x4 )
            
            y(i) = y3 + dydx2*(x(i)-x3);
        elseif( x(i) <= x5 )
            y(i) = y5;

        elseif( x(i) <= x6 )
            
            y(i) = y5 + dydx3*(x(i)-x5);
        elseif( x(i) <= x7 )
            
            y(i) = y7;
        elseif( x(i) <= x8 )
            
            y(i) = y7 + dydx4*(x(i)-x7);
        else
            
            y(i) = y9;
        end
            
    end
    
    x_val = x;
    y_val = y;
                
elseif( option == 4 ) % Kennwerte speichern
    
    fid = fopen([s_i.filename_save],'w');
    fprintf(fid,'%s\n',s_i.mode');
    for i=1:length(c_arr) 
        fprintf(fid,'%%               %s\n',c_arr{i}{3});
        if( length(c_arr{i}) > 3 && ~isempty(c_arr{i}{4}) )
            fprintf(fid,'%%               (%s)\n',c_arr{i}{4});
        end
        fprintf(fid,'%s = %g\n',c_arr{i}{1},s_i.(c_arr{i}{1}));
    end
    fclose(fid);    
                    
elseif( option == 5 ) % Kennwerte auslesen aus c_text
    
    for i=1:length(c_text)
        
        [t1,t2] = strtok(c_text{i},'=');
         t2      = strtok(t2,'=');
         
         t1      = str_cut_ae_f(t1,' ');
         t2      = str_cut_ae_f(t2,' ');
         
         for j=1:length(c_arr)
             
             if( strcmp(c_arr{j}{1},t1) )
                 
                 s_i.(c_arr{j}{1}) = str2double(t2);
             end
         end
     end
     
     % Prüfen
     %
     for i=1:length(c_arr)
         
         if( ~isfield(s_i,c_arr{i}{1}) )
             
             s_i.(c_arr{i}{1}) = 1;
         end
     end    
end
end
%
%================== generate_curve_proof =========================================
%
function [x_kenn,y_kenn] = generate_curve_proof(x_kenn,y_kenn)
            
            %
            % Prüft ob, Zeitwerte aufsteigend:
            %
            is_not_monoton = 1;
            while( is_not_monoton )
                is_not_monoton = 0;
                i=2;
                n = length(x_kenn);
                while i <= n
   
                    if( abs(x_kenn(i)-x_kenn(i-1)) < 0.000001 ) % Wert rauswerfen
       
                        if( i < n )
                            x_kenn = [x_kenn(1:i-1);x_kenn(i+1:n)];
                            y_kenn   = [y_kenn(1:i-1);y_kenn(i+1:n)];
                        else
                            x_kenn = x_kenn(1:i-1);
                            y_kenn = y_kenn(1:i-1);
                        end
                        n = n -1;
                    elseif( x_kenn(i) < x_kenn(i-1) ) % is not monoton
                        is_not_monoton = 1;
                        
                        x_dum = x_kenn(i);
                        y_dum = y_kenn(i);
                        x_kenn(i) = x_kenn(i-1);
                        y_kenn(i) = y_kenn(i-1);
                        x_kenn(i-1) = x_dum;
                        y_kenn(i-1) = y_dum;
                        break;
                    else
                        i = i + 1;
                    end
                end
            end
end
%
%================== generate_curve_c_text =========================================
%
function c_text = generate_curve_c_text(text)

c_text = {};

iz = 1;
c_text{iz} = '';
i  = 1;
while( i <= length(text) )
        
    if( double(text(i)) ~= 13 && double(text(i)) ~= 10  )
        
        c_text{iz} = [c_text{iz},text(i)];
        
    else % neue Zeile
        
        iz = iz+1;
        c_text{iz} = '';
        if( (double(text(i)) == 13) && (double(i+1) == 10) )
            i = i+1;
        end
        
    end
    
    i = i+1;
end
%
% Kommentar % eliminieren
%
for i=1:length(c_text)
    
    i0 = min(strfind(c_text{i},'%'));
    if( ~isempty(i0)  )
        if( i0 == 1 )
            c_text{i} = '';
        else
            c_text{i} = c_text{i}(1:i0);
        end
    end
end
%
% leere Zeilen rausschmeißen
%
i = 1;
c_text1 = c_text;
c_text = {};
for i1=1:length(c_text1)
    if( ~isempty(c_text1{i1}) )
        c_text{i} = c_text1{i1}; %#ok<AGROW>
        i = i+1;
    end
end
end
%
%================== generate_curve_ask_val =========================================
%
function val = generate_curve_ask_val(c_arr,default)

% c_arr={name,unit,comment,beschreibung}

if( ~isempty(c_arr) )
    name = c_arr{1};
else
    name = 'dum';
end
if( length(c_arr) > 1 )
    unit = c_arr{2};
else
    unit = '';
end
if( length(c_arr) > 2 )
    comment = c_arr{3};
else
    comment = 'Wert eingeben';
end
if( length(c_arr) > 3 )
    beschreib = c_arr{4};
else
    beschreib = '';
end

if( nargin < 2 )
    default = '';
end

fprintf('\n%s :\n',comment);
if( ~isempty(beschreib) )    
    fprintf('(%s)\n',beschreib);
end

if( ~isempty(default) )
    val = input([name,' [',unit,'] def:<',default,'> :'],'s');
else
    val = input([name,' [',unit,']  :'],'s');
end

if( isempty(val) )
    val = default;
end

val = str2double(val);
end
%
%================== generate_kennlinie_erstellen =========================================
%
function  [x_val,y_val,s_i] = generate_kennlinie_erstellen(s_i)
x_val = [];
y_val = [];
% Kennlinie in delta_t erstellen in x_val,y_val
% grafische Kennlinie
if( strcmp(s_i.mode,'kennlinie') )
  
  if( ~isfield(s_i,'n_kenn') || (s_i.n_kenn == 0) )
    s_i = generate_curve_graf(s_i);
  end

  %
  % Vektor mit delta_t-Rasterung
  %
  x_val = s_i.x_kenn(1):s_i.delta_t:s_i.x_kenn(s_i.n_kenn);
  x_val = x_val';

  % physikalische Werte interpolieren
  y_val = interp1(s_i.x_kenn,s_i.y_kenn,x_val,'linear','extrap');

elseif( strcmp(s_i.mode,'step') )

   [s_i,x_val,y_val] = generate_curve_step(s_i,3);

elseif( strcmp(s_i.mode,'sinus') )

   [s_i,x_val,y_val] = generate_curve_sinus(s_i,3);

elseif( strcmp(s_i.mode,'trapez') )

   [s_i,x_val,y_val] = generate_curve_trapez(s_i,3);

elseif( strcmp(s_i.mode,'sprungPT1') )

   [s_i,x_val,y_val] = generate_curve_sprung_PT1(s_i,3);
elseif( strcmp(s_i.mode,'mess') )

   [s_i,x_val,y_val] = generate_curve_mess(s_i,3);

elseif( strcmp(s_i.mode,'doppel_trapez') )

   [s_i,x_val,y_val] = generate_curve_doppel_trapez(s_i,3);

end
end
%
%================== generate_plot_val =========================================
%

function  s_i = generate_plot_val(x_val,y_val,s_i)
                
                delta_t = sum(diff(x_val))/length(diff(x_val));
                xp_val = x_val(2:length(x_val));
                yp_val = diff(y_val)/delta_t;
                
                s_i.h = figure;
                subplot(2,1,1)
				plot(x_val,y_val,'r')
%                 axis([min(min(x_val),s_i.t_min) ...
%                     ,max(max(x_val),s_i.t_max) ...
%                     ,min(min(y_val),s_i.y_min) ...
%                     ,max(max(y_val),s_i.y_max) ...
%                     ]);
                         
                xlabel(s_i.plot_xlabel)
                ylabel(s_i.plot_ylabel)
                title('Die aufbereitete Kennlinie')
                         
                grid on
				hold off
                
                subplot(2,1,2)
				plot(xp_val,yp_val,'b')
%                 axis([min(min(x_val),s_i.t_min) ...
%                     ,max(max(x_val),s_i.t_max) ...
%                     ,min(min(y_val),s_i.y_min) ...
%                     ,max(max(y_val),s_i.y_max) ...
%                     ]);
                         
                xlabel(s_i.plot_xlabel)
                ylabel('')
                title('Ableitung der Kennlinie')
                         
                grid on
				hold off
end