%
% Wird von pltmen aus gesteuert.
% Controlstruktur:
%
% pltmen_ctrl.fig                       struct       Struktur mit DAten zu einer figure
% pltmen_ctrl.fig(i).name               char         Name des Diagramma
% pltmen_ctrl.fig(i).h                  double       handle der figure
% pltmen_ctrl.fig(i).n                  double       Anzahl der Vektoren
% pltmen_ctrl.fig(i).data               struct       Vektorbeschreibung
% pltmen_ctrl.fig(i).data(j).x_vec_name char        x-Vektorname
% pltmen_ctrl.fig(i).data(j).y_vec_name char        y-Vektorname
% pltmen_ctrl.fig(i).data(j).h          char        hanlde der plootlinie

% pltmen_ctrl.select_struct_name    char        Selektierte Struktur aus dem Workspace, aus
%                                               der geplottet wird, Wenn keine Struktur selektiert ist
%                                               dann pltmen_ctrl.select_struct_name = ''
%
%
global pltmen_ctrl_select_struct_name
global pltmen_ctrl_x_vec_name   
global pltmen_h0

set_plot_standards

if( ~exist('pltmen_ctrl','var') )
    pltmen_ctrl.fig        = [];
    pltmen_ctrl.i_fig      = 0;
    pltmen_ctrl.select_struct_name = '';
    pltmen_ctrl.x_vec      =  [];
    pltmen_ctrl.x_vec_name = '';
    pltmen_ctrl.zaf_flag   = 0;
    
    if( length(pltmen_ctrl_select_struct_name) > 0 )
        
        % Strukturname prüfen
        pltmen_whos = whos;
        pltmen_flag = 0;
        for pltmen_i=1:length(pltmen_whos)
            
            if( strcmp(pltmen_whos(pltmen_i).name,pltmen_ctrl_select_struct_name) )
                pltmen_ctrl.select_struct_name = pltmen_ctrl_select_struct_name;
                pltmen_flag = 1;
                break
            end
        end
        if( pltmen_flag == 0 )
            msgbox(sprintf('pltmen: Struktur <%s> konnte im Workspace nicht gefunden weren',pltmen_ctrl_select_struct_name));
        end
        pltmen_ctrl_select_struct_name = '';
                
        if( length(pltmen_ctrl.select_struct_name) > 0 & length(pltmen_ctrl_x_vec_name) > 0 )
            
            eval(['pltmen_flag = isfield(',pltmen_ctrl.select_struct_name,',''',pltmen_ctrl_x_vec_name,''');']);
            
            if( pltmen_flag )
                eval(['pltmen_ctrl.x_vec = ',pltmen_ctrl.select_struct_name,'.',pltmen_ctrl_x_vec_name,';']);            
                [pltmen_n,pltmen_m] = size(pltmen_ctrl.x_vec);
                if( pltmen_n >= pltmen_m )
                    pltmen_ctrl.x_vec = pltmen_ctrl.x_vec(:,1);
                else
                    pltmen_ctrl.x_vec = pltmen_ctrl.x_vec(1,:)';
                end
                pltmen_ctrl.x_vec_name = [pltmen_ctrl.select_struct_name,'.',pltmen_ctrl_x_vec_name];
            else
                msgbox(sprintf('pltmen: X-Vektor: <%s> konnte nicht in Struktur <%s> gefunden weren',pltmen_ctrl_x_vec_name,pltmen_ctrl_select_struct_name));
            end
        end
        pltmen_ctrl_x_vec_name = '';
    end

end


switch pltmen_task

    case 'select_figure'
    
        pltmen_liste = {'new figure','new portrait','new landscape'};

        for i=1:length(pltmen_ctrl.fig)
            pltmen_liste{length(pltmen_liste)+1} = pltmen_ctrl.fig(i).name;
        end
        [pltmen_select,pltmen_okay]=listdlg('PromptString','Option auswählen' ...
                             ,'ListString',pltmen_liste ...
                             ,'SelectionMode','single'...
                             ,'ListSize',[200 200] ...
                             );

        if( pltmen_okay )

            n = length(pltmen_ctrl.fig);
            switch pltmen_select 
                case {1,2,3}

                    pltmen_ctrl.fig(n+1).name = ['Diagramm',num2str(n+1)];
                    pltmen_ctrl.fig(n+1).type = pltmen_select-1;
                    pltmen_ctrl.fig(n+1).h    = p_figure(-1,pltmen_ctrl.fig(n+1).type ...
                                                        ,pltmen_ctrl.fig(n+1).name);
                    pltmen_ctrl.fig(n+1).data = struct([]); 
                    pltmen_ctrl.fig(n+1).n    = 0; 
                    pltmen_ctrl.i_fig         = n+1;

                otherwise
                    figure( pltmen_ctrl.fig(pltmen_select-3).h );
                    pltmen_ctrl.i_fig  = pltmen_select-3;
            end
        end


    case 'select_struct'
        
        if( length(pltmen_ctrl.select_struct_name) > 0 ) % strukturname zurücksetzen
            
            pltmen_ctrl.select_struct_name = '';
            msgbox('pltmen: Die ausgewählte struktur ist gelöscht, um einen neue Struktur auszuwählen, erneut button auswählen')

            break;
        end

        % Workspace auflisten
        pltmen_whos = whos;
        pltmen_liste = {};

        % Liste mit den Strukturen, die nicht mit pltmen_ anfangen auflisten
        for pltmen_i=1:length(pltmen_whos)

            pltmen_n=min(length(pltmen_whos(pltmen_i).name),7);
            if ~strcmp('pltmen_',pltmen_whos(pltmen_i).name(1:pltmen_n))

                if strcmp(pltmen_whos(pltmen_i).class,'struct')         

                    pltmen_liste{length(pltmen_liste)+1} = pltmen_whos(pltmen_i).name;
                end
            end
        end

        % Liste auf einen Wert abfragen
        [pltmen_select,pltmen_okay] = listdlg('PromptString','Lege eine Struktur fest, mit du plotten willst',...
                                              'SelectionMode','single', ... 
                                              'ListSize',[300,300],...
                                              'ListString',pltmen_liste);
        if pltmen_okay


            pltmen_ctrl.select_struct_name = pltmen_liste{pltmen_select};

        end

    case 'select_x_vec'
        
        
        if( length(pltmen_ctrl.x_vec) > 0 ) % x-Auswahl zurücksetzen
            
            pltmen_ctrl.x_vec = [];
            
            msgbox('pltmen: Die x-Vektor Auswahl ist gelöscht, um einen neuen X-Vektor auszuwählen, erneut button auswählen')

            break;
        end
        
        if( length(pltmen_ctrl.select_struct_name) > 0 ) % Zugewiesene Struktur verwenden
            
            pltmen_select_old = eval(pltmen_ctrl.select_struct_name);
            pltmen_name_old   = pltmen_ctrl.select_struct_name;
            [pltmen_select_cell,pltmen_select_names,pltmen_okay,pltmen_back] = select_item_from_var( ...
                                                                  eval(pltmen_ctrl.select_struct_name) ...
                                                                 ,pltmen_ctrl.select_struct_name ...
                                                                 ,0 ... % back_flag
                                                                 ,'Wähle Größe aus' ...
                                                                 ,1 ... %single flag
                                                                 ,[300, 300] ... %listsize
                                                                 ,1 ... % no_char_flag
                                                                 );
        else  % aus Workspace Vektor suchen
            
            % Workspace auflisten
            pltmen_whos = whos;
            pltmen_liste = {};
            pltmen_select_cell  = {};
            pltmen_select_names = {};
            pltmen_names = {};

            % Liste mit den Variablen, die nicht mit pltmen_ anfangen und keine char sind auflisten
            for pltmen_i=1:length(pltmen_whos)

                pltmen_n=min(length(pltmen_whos(pltmen_i).name),7);
                if ~strcmp('pltmen_',pltmen_whos(pltmen_i).name(1:pltmen_n))

                    if( isnumeric(eval(pltmen_whos(pltmen_i).name)) )
            
                        [pltmen_n,pltmen_m] = size(eval(pltmen_whos(pltmen_i).name));
                        pltmen_liste{length(pltmen_liste)+1} = [pltmen_whos(pltmen_i).name,'(double ',num2str(pltmen_n),'x',num2str(pltmen_n),')'];
                        pltmen_names{length(pltmen_liste)} = pltmen_whos(pltmen_i).name;
            
                    elseif( isstruct(eval(pltmen_whos(pltmen_i).name)) )
 
                        pltmen_liste{length(pltmen_liste)+1} = [pltmen_whos(pltmen_i).name,'(struct)'];
                        pltmen_names{length(pltmen_liste)} = pltmen_whos(pltmen_i).name;
        
                    elseif( iscell(eval(pltmen_whos(pltmen_i).name)) )
            
                        pltmen_liste{length(pltmen_liste)+1} = [pltmen_whos(pltmen_i).name,'(cell)'];
                        pltmen_names{length(pltmen_liste)} = pltmen_whos(pltmen_i).name;
                    end
                end
        
            end
            [pltmen_select,pltmen_okay] = listdlg('PromptString',  'Wähle Größe aus' ...
                           ,'SelectionMode', 'single' ... 
                           ,'ListSize',      [300,300] ...
                           ,'ListString',    pltmen_liste ...
                           );

            if( pltmen_okay )
                
                pltmen_select_cell{1} = eval(pltmen_names{pltmen_select(1)});
                
                pltmen_select_names{1} = pltmen_names{pltmen_select(1)};
            end
        end
        
        if( ~pltmen_okay )
            break;
        end
        
        pltmen_back = 0;

        while( 1 ) % Solange keine Vektor gefunden:


            if( ~pltmen_okay ) % Abbruch

                break;

            elseif( pltmen_back ) % zurückspringen

                pltmen_select_cell{1}  = pltmen_select_old;
                pltmen_select_names{1} = pltmen_name_old;

            elseif( isnumeric(pltmen_select_cell{1}) ) % einen Vektor gefunden

                [pltmen_n,pltmen_m] = size(pltmen_select_cell{1});
                if( pltmen_n >= pltmen_m )
                    pltmen_ctrl.x_vec = pltmen_select_cell{1}(:,1);
                else
                    pltmen_ctrl.x_vec = pltmen_select_cell{1}(1,:)';
                end
                pltmen_ctrl.x_vec_name = pltmen_select_names{1};
                break;
            end
            pltmen_select_old = pltmen_select_cell{1} ;
            pltmen_name_old   = pltmen_select_names{1};
            [pltmen_select_cell,pltmen_select_names,pltmen_okay,pltmen_back] = select_item_from_var ...
                                                             (pltmen_select_cell{1} ...
                                                             ,pltmen_select_names{1} ...
                                                             ,1 ... % back_flag
                                                             ,'Wähle Größe aus' ...
                                                             ,1 ... %single flag
                                                             ,[300, 300] ... %listsize
                                                             ,1 ... % no_char_flag
                                                             );
        end
                        
    case 'plot_y_vec'
                
        if( length(pltmen_ctrl.select_struct_name) > 0 ) % Zugewiesene Struktur verwenden
            
            pltmen_select_old = eval(pltmen_ctrl.select_struct_name);
            pltmen_name_old   = pltmen_ctrl.select_struct_name;
            [pltmen_select_cell,pltmen_select_names,pltmen_okay,pltmen_back] = select_item_from_var( ...
                                                                  eval(pltmen_ctrl.select_struct_name) ...
                                                                 ,pltmen_ctrl.select_struct_name ...
                                                                 ,0 ... % back_flag
                                                                 ,'Wähle Größe aus' ...
                                                                 ,1 ... %single flag
                                                                 ,[300, 300] ... %listsize
                                                                 ,1 ... % no_char_flag
                                                                 );
        else  % aus Workspace Vektor suchen
            
            % Workspace auflisten
            pltmen_whos = whos;
            pltmen_liste = {};
            pltmen_select_cell  = {};
            pltmen_select_names = {};
            pltmen_names = {};

            % Liste mit den Variablen, die nicht mit pltmen_ anfangen und keine char sind auflisten
            for pltmen_i=1:length(pltmen_whos)

                pltmen_n=min(length(pltmen_whos(pltmen_i).name),7);
                if ~strcmp('pltmen_',pltmen_whos(pltmen_i).name(1:pltmen_n))

                    if( isnumeric(eval(pltmen_whos(pltmen_i).name)) )
            
                        [pltmen_n,pltmen_m] = size(eval(pltmen_whos(pltmen_i).name));
                        pltmen_liste{length(pltmen_liste)+1} = [pltmen_whos(pltmen_i).name,'(double ',num2str(pltmen_n),'x',num2str(pltmen_n),')'];
                        pltmen_names{length(pltmen_liste)} = pltmen_whos(pltmen_i).name;
            
                    elseif( isstruct(eval(pltmen_whos(pltmen_i).name)) )
 
                        pltmen_liste{length(pltmen_liste)+1} = [pltmen_whos(pltmen_i).name,'(struct)'];
                        pltmen_names{length(pltmen_liste)} = pltmen_whos(pltmen_i).name;
        
                    elseif( iscell(eval(pltmen_whos(pltmen_i).name)) )
            
                        pltmen_liste{length(pltmen_liste)+1} = [pltmen_whos(pltmen_i).name,'(cell)'];
                        pltmen_names{length(pltmen_liste)} = pltmen_whos(pltmen_i).name;
                    end
                end
        
            end
            [pltmen_select,pltmen_okay] = listdlg('PromptString',  'Wähle Größe aus' ...
                           ,'SelectionMode', 'single' ... 
                           ,'ListSize',      [300,300] ...
                           ,'ListString',    pltmen_liste ...
                           );

            if( pltmen_okay )
                
                pltmen_select_cell{1} = eval(pltmen_names{pltmen_select(1)});
                
                pltmen_select_names{1} = pltmen_names{pltmen_select(1)};
            end
        end
        
        if( ~pltmen_okay )
            break;
        end
        
        pltmen_back = 0;
        
        while( 1 ) % Solange keine Vektor gefunden:


            if( ~pltmen_okay ) % Abbruch

                break;

            elseif( pltmen_back ) % zurückspringen

                pltmen_select_cell{1}  = pltmen_select_old;
                pltmen_select_names{1} = pltmen_name_old;

            elseif( isnumeric(pltmen_select_cell{1}) ) % einen Vektor gefunden

                [pltmen_n,pltmen_m] = size(pltmen_select_cell{1});
                if( pltmen_n >= pltmen_m )
                    pltmen_y_vec = pltmen_select_cell{1}(:,1);
                else
                    pltmen_y_vec = pltmen_select_cell{1}(1,:)';
                end
                pltmen_y_vec_name = pltmen_select_names{1};
                
                % An die figure-Struktur übergeben
                if( pltmen_ctrl.i_fig == 0 )

                    pltmen_ctrl.fig(1).name = ['Diagramm',num2str(1)];
%                    pltmen_ctrl.fig(1).h    = p_figure(-1,0,pltmen_ctrl.fig(1).name);
                    pltmen_ctrl.fig(1).h    = figure;
                    pltmen_ctrl.fig(1).n    = 0;
                    pltmen_ctrl.i_fig       = 1;
                end
                
                if( length(pltmen_ctrl.x_vec) == 0 )
                    
                    pltmen_x_vec      = [1:1:length(pltmen_y_vec)]';
                    pltmen_x_vec_name = 'Index';
                else
                    pltmen_x_vec      = pltmen_ctrl.x_vec(1:min(length(pltmen_ctrl.x_vec),length(pltmen_y_vec)));
                    pltmen_x_vec_name = pltmen_ctrl.x_vec_name;
                end
                
                pltmen_n                 = pltmen_ctrl.fig(pltmen_ctrl.i_fig).n+1;

                % Plotten
                figure(pltmen_ctrl.fig(pltmen_ctrl.i_fig).h)
                pltmen_h                 = plot(pltmen_x_vec,pltmen_y_vec ...
                                               ,'Color',PlotStandards.Farbe{pltmen_n} ...
                                               ,'LineWidth',1.2 ...
                                               );
                hold on
                grid on

                % Daten an struktur übergeben
                clear pltmen_data

                
%                pltmen_ctrl.fig(pltmen_ctrl.i_fig).data(pltmen_n).x_vec      = pltmen_x_vec;
                pltmen_ctrl.fig(pltmen_ctrl.i_fig).data(pltmen_n).x_vec_name = pltmen_x_vec_name;
%                pltmen_ctrl.fig(pltmen_ctrl.i_fig).data(pltmen_n).y_vec      = pltmen_y_vec;
                pltmen_ctrl.fig(pltmen_ctrl.i_fig).data(pltmen_n).y_vec_name = pltmen_y_vec_name;
                pltmen_ctrl.fig(pltmen_ctrl.i_fig).data(pltmen_n).h          = pltmen_h;

                
                pltmen_ctrl.fig(pltmen_ctrl.i_fig).n = pltmen_n;
                
                % Legende plotten
                
                clear pltmen_leg
                for i=1:pltmen_n
                    
                    pltmen_leg{i} = str_change_f(pltmen_ctrl.fig(pltmen_ctrl.i_fig).data(i).y_vec_name ...
                                                ,'_',' ');
                end
                legend(pltmen_leg)
                
                % zaf
                if( pltmen_ctrl.zaf_flag ) % Zoomen            
                    zaf('set');
                end
        
                
                break;
            end
            pltmen_select_old = pltmen_select_cell{1} ;
            pltmen_name_old   = pltmen_select_names{1};
            [pltmen_select_cell,pltmen_select_names,pltmen_okay,pltmen_back] = select_item_from_var ...
                                                             (pltmen_select_cell{1} ...
                                                             ,pltmen_select_names{1} ...
                                                             ,1 ... % back_flag
                                                             ,'Wähle Größe aus' ...
                                                             ,1 ... %single flag
                                                             ,[300, 300] ... %listsize
                                                             ,1 ... % no_char_flag
                                                             );
        end

    case 'delete_line'
        
        if( pltmen_ctrl.i_fig == 0 )
            msgbox('pltmen: Es ist keine Plotfigure ausgewählt oder vorhanden')
            break;
        end

        if( length(pltmen_ctrl.fig(pltmen_ctrl.i_fig).data) == 0 )
            msgbox(sprintf('pltmen: Es ist keine Daten für Plotfigure <%> vorhanden',pltmen_ctrl.fig(pltmen_ctrl.i_fig).name))
            break;
        end
        
        
        pltmen_liste = {};
        for i=1:length(pltmen_ctrl.fig(pltmen_ctrl.i_fig).data)
        
            pltmen_liste{i} = pltmen_ctrl.fig(pltmen_ctrl.i_fig).data(i).y_vec_name;
        end
        [pltmen_select,pltmen_okay]=listdlg('PromptString','Welchen Vektor löschen' ...
                             ,'ListString',pltmen_liste ...
                             ,'SelectionMode','multiple'...
                             ,'ListSize',[200 200] ...
                             );

        if( pltmen_okay )
            
            figure(pltmen_ctrl.fig(pltmen_ctrl.i_fig).h)
            pltmen_data = pltmen_ctrl.fig(pltmen_ctrl.i_fig).data;
            % Linie löschen
            for i=1:length(pltmen_select)
                
                pltmen_id = pltmen_select(i);
                delete(pltmen_data(pltmen_id).h)
            end
            % Daten löschen
            for i=1:length(pltmen_select)
                if( pltmen_id == 1 )
                    pltmen_data = pltmen_data(2:length(pltmen_data));
                elseif( pltmen_id == length(pltmen_data))
                    pltmen_data = pltmen_data(1:pltmen_id-1);
                else
                    pltmen_data = [pltmen_data(1:plrmen_id-1),pltmen_data(pltmen_id+1:length(pltmen_data))];
                end
            end
            pltmen_n = length(pltmen_data);
            pltmen_ctrl.fig(pltmen_ctrl.i_fig).data = pltmen_data;
            
            % Legende plotten

            clear pltmen_leg
            for i=1:pltmen_n

                    pltmen_leg{i} = str_change_f(pltmen_ctrl.fig(pltmen_ctrl.i_fig).data(i).y_vec_name ...
                                                ,'_',' ');
            end
            legend(pltmen_leg)
        end
                    
    case 'close_fig'
        
        pltmen_liste = {};

        for i=1:length(pltmen_ctrl.fig)
            pltmen_liste{length(pltmen_liste)+1} = pltmen_ctrl.fig(i).name;
        end
        [pltmen_select,pltmen_okay]=listdlg('PromptString','Welche Figur soll gelöscht werden' ...
                             ,'ListString',pltmen_liste ...
                             ,'SelectionMode','multiple'...
                             ,'ListSize',[200 200] ...
                             );

        if( pltmen_okay )

            n = length(pltmen_ctrl.fig);
            for i=1:length(pltmen_select)
                close(pltmen_ctrl.fig(pltmen_select(i)-1).h);
            end
            clear pltmen_data
            pltmen_n = 0;
            for i=1:n
                pltmen_flag = 1;
                for j=1:length(pltmen_select)

                    if( i == pltmen_select(j)-1 )
                        pltmen_flag = 0;
                        break;
                    end
                end

                if( pltmen_flag )
                    pltmen_n = pltmen_n+1;
                    pltmen_data(pltmen_n) = pltmen_ctrl.fig(i);
                end
            end
            pltmen_ctrl.fig = pltmen_data;
            
                
        end
        
    case 'abbruch'
   
        close(pltmen_h0)
    case 'exit'
   
        close(pltmen_h0)
        
       dummy_abcdef=who('pltmen_*');
       for i=1:length(dummy_abcdef)
          dummy_ghijkl=sprintf('clear  %s;',dummy_abcdef{i});
          eval(char(dummy_ghijkl));
       end
       clear dummy_abcdef;
       clear dummy_ghijkl;
       
    case 'zaf_set'
        
        if( pltmen_ctrl.zaf_flag ) % Zurücksetzen
            
            zaf('del');
            pltmen_ctrl.zaf_flag = 0;
        else
            zaf('set');
            pltmen_ctrl.zaf_flag = 1;
        end
    case 'logsave'
        
        pltmen_name = inputdlg('Name des Datenfiles ohne extension');
        
        if( length(pltmen_name) > 0 ) % kein cancel
            eval(['save ',pltmen_name{1},'_pltmen.mat pltmen_ctrl'])
        end
        
    case 'logload'
        
        [FileName,PathName] = uigetfile('*_pltmen.mat','Select the Mat-file as pltmen-logfile');
        
        if( FileName )
        
            pltmen_s = load([PathName,'\',FileName]);
            
            for i=1:length(pltmen_s.pltmen_ctrl.fig)
                
               % Neue Figur
                pltmen_n = length(pltmen_ctrl.fig)+1;
                if( pltmen_n == 1 )
                    pltmen_ctrl.fig           = pltmen_s.pltmen_ctrl.fig(i);
                else
                    pltmen_ctrl.fig(pltmen_n) = pltmen_s.pltmen_ctrl.fig(i);
                end
                
                pltmen_ctrl.fig(pltmen_n).h    = p_figure(-1 ...
                                     ,pltmen_ctrl.fig(pltmen_n).type ...
                                     ,pltmen_ctrl.fig(pltmen_n).name);
                pltmen_ctrl.i_fig              = pltmen_n;

                % Alle Vektoren:
                plotmen_m = 0;
                clear pltmen_data
                clear pltmen_leg
                for j=1:pltmen_s.pltmen_ctrl.fig(i).n
                    
                    
                    pltmen_y_vec = [];    
                    try
                        pltmen_y_vec = eval(pltmen_s.pltmen_ctrl.fig(i).data(j).y_vec_name);
                        [pltmen_n1,pltmen_m1] = size(pltmen_y_vec);
                        if( pltmen_n1 >= pltmen_m1 )
                            pltmen_y_vec = pltmen_y_vec(:,1);
                        else
                            pltmen_y_vec = pltmen_y_vec(1,:)';
                        end
                        
                    end

                    pltmen_x_vec = [];
                    if( strcmp('Index',pltmen_s.pltmen_ctrl.fig(i).data(j).x_vec_name) )
                        
                        pltmen_x_vec = [1:1:length(pltmen_y_vec)]';
                    else
                        try
                            pltmen_x_vec = eval(pltmen_s.pltmen_ctrl.fig(i).data(j).x_vec_name);                                                
                            [pltmen_n1,pltmen_m1] = size(pltmen_x_vec);
                            if( pltmen_n1 >= pltmen_m1 )
                                pltmen_x_vec = pltmen_x_vec(:,1);
                            else
                                pltmen_x_vec = pltmen_x_vec(1,:)';
                            end
                        end
                    end            
                                            
                    if( length(pltmen_x_vec) > 0 & length(pltmen_y_vec) > 0 )
                        
                        plotmen_m               = plotmen_m+1;
                        pltmen_data(pltmen_m).x_vec_name ...
                                                = pltmen_s.pltmen_ctrl.fig(i).data(j).x_vec_name;
                        pltmen_data(pltmen_m).y_vec_name ...
                                                = pltmen_s.pltmen_ctrl.fig(i).data(j).y_vec_name;
                                            
                        pltmen_x_vec            = ... 
                                  pltmen_x_vec(1:min(length(pltmen_x_vec),length(pltmen_y_vec)));
                        pltmen_data(pltmen_m).h = plot(pltmen_x_vec,pltmen_y_vec ...
                                                      ,'Color',PlotStandards.Farbe{pltmen_m} ...
                                                      ,'LineWidth',1.2);
                        hold on
                        grid on
                        pltmen_leg{pltmen_m}    = str_change_f(pltmen_data(pltmen_m).y_vec_name,'_',' ');
                    
                    end
                end
                
                if( length(pltmen_leg) > 0 )
                    legend(pltmen_leg)
                end
                
                pltmen_ctrl.fig(pltmen_n).data = pltmen_data(pltmen_m);
                pltmen_ctrl.fig(pltmen_n).n    = pltmen_m;
                
                
            end            
        end

        pltmen_ctrl.x_vec_name = pltmen_s.pltmen_ctrl.x_vec_name;                    
        pltmen_ctrl.x_vec      = pltmen_s.pltmen_ctrl.x_vec;                    
        pltmen_ctrl.zaf_flag   = pltmen_s.pltmen_ctrl.zaf_flag;                    

        % zaf
        if( pltmen_ctrl.zaf_flag ) % Zoomen            
            zaf('set');
        end

       
    otherwise
       fprintf('Falsche Task task= %s',pltmen_task)
end
