function s_duh = duh_daten_plot_einfache_config_erstellen_f(s_duh)
%
% Konfiguration erstellen
%
%

% Standards fürs plotten setzen:
set_plot_standards

% Name der Plotsequenz
%=====================
clear s_frage

s_frage.frage   = 'Name der Plotsequenz, die jetzt erstellt wird';
s_frage.command = 'plotname';
s_frage.type    = 'char';

[okay,plotname,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

% Datennsatz auswählen

for i= 1:s_duh.n_data
    s_frage.c_liste{i} = sprintf('%s (%s)',s_duh.s_data(i).name,s_duh.s_data(i).h{1});
end

s_frage.frage          = 'Datensatz auswählen ?';
s_frage.command        = 'data_set';
s_frage.single         = 1;

[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( ~okay )
    return
end
data_set_select = selection;

set_new_plot = 1;
i_fig        = 0;
while(set_new_plot)

    i_fig = i_fig +1;
    
    % x-Vektor aussuchen
    %===================
    clear s_frage
    s_frage.comment    = 'Soll ein spezieller x-Vektor ausgewählt werden (default erster vektor)';
    s_frage.prot       = 1;
    s_frage.command    = 'special_x_vec_flag';
    s_frage.default    = 1;
    s_frage.def_value  = 0;

    [special_x_flag,s_duh.s_prot,s_duh.s_remote]  = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);

    for i = 1:length(data_set_select)
        index_x_vec(i) = 1; % Default immer erster Vektor
    end
    if( special_x_flag )

            % x-Vektor für alle auswählen
            %----------------------------
            clear s_frage s_set
            for i=1:length(data_set_select)
                c_arr            = fieldnames(s_duh.s_data(data_set_select(i)).d);
                s_set(i).c_names = {c_arr{1:length(c_arr)}};
            end
            [s_erg] = str_count_names_f(s_set,1);
            for i= 1:length(s_erg)
                s_frage.c_liste{i} = sprintf('%s (%g x)',s_erg(i).name,s_erg(i).n);
                s_frage.c_name{i}  = s_erg(i).name;
            end

            s_frage.frage          = sprintf('X-Vektor aus %g Datensätze auswählen (n mal vorhanden) ?',length(data_set_select));
            s_frage.command        = 'xdata_name';
            s_frage.single         = 1;
            s_frage.prot_name      = 1;
						s_frage.sort_list      = 1;
						
            [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

            % Prüfen und Index setzen
            %------------------------
            for  i=1:length(data_set_select)

                % ist vorhanden
                if( isfield(s_duh.s_data(data_set_select(i)).d,s_frage.c_name{selection(1)}) )

                    for j=1:length(s_set(i).c_names)

                        if( strcmp(s_frage.c_name{selection(1)},s_set(i).c_names{j}) )

                            index_x_vec(i) = j;
                            break;
                        end
                    end

                % ist nicht vorhanden, nochmal abfragen
                else

                    clear s_frage1
                    c_arr            = fieldnames(s_duh.s_data(data_set_select(i)).d);
                    s_frage1.c_liste = c_arr;
                    s_frage1.c_name  = c_arr;

                    s_frage1.frage          = sprintf('X-Vektor aus %iten Datensatz auswählen ?',data_set_select(i));
                    s_frage1.single         = 1;
                    s_frage1.prot_name      = 0;
										s_frage.sort_list      = 1;
										
                    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage1,s_duh.s_prot,s_duh.s_remote);

                    if( ~okay )
                        return
                    end
                    index_x_vec(i) = selection(1);
                end
            end




    end

    clear s_frage

    for i=1:length(data_set_select)
        c_arr            = fieldnames(s_duh.s_data(data_set_select(i)).d);
        if( special_x_flag )
            s_set(i).c_names = {c_arr{1:length(c_arr)}};
        else
            s_set(i).c_names = {c_arr{2:length(c_arr)}};
        end
    end
    [s_erg] = str_count_names_f(s_set,1);
    for i= 1:length(s_erg)
        s_frage.c_liste{i} = sprintf('%s (%g x)',s_erg(i).name,s_erg(i).n);
        s_frage.c_name{i}  = s_erg(i).name;
        plot_name_list{i}  = s_erg(i).name;
    end
 
    % y-Vektoren auswählen
    s_frage.frage          = sprintf('y-Vektor(n) für Plotbild einzeln aus %g Datensätze auswählen OK: geht weiter Cancel:Ende  ?',length(data_set_select));
    s_frage.command        = 'data_names';
    s_frage.prot_name      = 1;

    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listboxsort_f(s_frage,s_duh.s_prot,s_duh.s_remote);

    if( isempty(selection) )
        return
    end
    
    
    n_total = length(selection);    

    % Anzahl Figur-Zeilen
    %
    clear s_frage

    s_frage.frage   = 'Anzahl der Plotzeilen';
    s_frage.command = 'nrow';
    s_frage.type    = 'double';
    s_frage.default = 1;

    [okay,nrows,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

    if( ~okay )
        return
    end

    % Anzahl Figur-Spalten
    %
    clear s_frage

    s_frage.frage   = 'Anzahl der Plotspalten';
    s_frage.command = 'ncol';
    s_frage.type    = 'double';
    s_frage.default = 1;

    [okay,ncols,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

    % Dateiname
    filename = [plotname,'.pconf'];

    s_fig(i_fig).short_name     = [plotname,num2str(i_fig)];
     
    if( nrows == 1 && ncols == 1 )        
        s_fig(i_fig).format = PlotStandards.format_names{1}; %default
    elseif( nrows > ncols )
        s_fig(i_fig).format = PlotStandards.format_names{2}; %portrait
    else
        s_fig(i_fig).format = PlotStandards.format_names{3}; %landscape
    end
    s_fig(i_fig).rows   = nrows;
    s_fig(i_fig).cols   = ncols;
     
    nplots = nrows * ncols;
    
    if( nplots == 1 )
        n_data = n_total;
        n_plot = 1;
    else
        n_data = 1;
        n_plot = n_total;
    end
    i_total = 0;
    for i_plot = 1:n_plot
        for i_data=1:n_data
           
            i_total = i_total+1;
            s_fig(i_fig).s_plot(i_plot).title     = plot_name_list{selection(i_total)};
            s_fig(i_fig).s_plot(i_plot).bot_title = PlotStandards.bot_title_names{1};
            s_fig(i_fig).s_plot(i_plot).legend_choice = PlotStandards.legend_choice{2};
           
            s_fig(i_fig).s_plot(i_plot).grid_set = 1;        
        
            s_fig(i_fig).s_plot(i_plot).xlim_set = 0;                    
            s_fig(i_fig).s_plot(i_plot).xmin = 0;               
            s_fig(i_fig).s_plot(i_plot).xmax = 1;
            s_fig(i_fig).s_plot(i_plot).ylim_set = 0;                    
            s_fig(i_fig).s_plot(i_plot).ymin = 0;               
            s_fig(i_fig).s_plot(i_plot).ymax = 1;

            s_fig(i_fig).s_plot(i_plot).x_label     = '';
            s_fig(i_fig).s_plot(i_plot).y_label     = '';
           
            s_fig(i_fig).s_plot(i_plot).data_set = 1;
            
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).ndim = 2;
            
            c_arr = fieldnames(s_duh.s_data(data_set_select(1)).d);        
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).x_vec_name = c_arr{index_x_vec(1)};            
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).x_offset   = 0.0;
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).x_factor   = 1.0;
            
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).y_vec_name = plot_name_list{selection(i_total)};
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).y_offset = 0.0;
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).y_factor = 1.0;
            
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).n_start = 1;
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).n_end   = -1;
            
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).line_size = 1;
            s_fig(i_fig).s_plot(i_plot).s_data(i_data).line_color_name = PlotStandards.color_names{i_total};
            s_fig(i_fig).s_plot(i_plot).n_data = n_data;
        end
    end
    
    % wieteres Plotbild
    %===================
    clear s_frage
    s_frage.comment    = 'Soll ein ein weiteres Plotbild erstellt werden';
    s_frage.prot       = 1;
    s_frage.command    = 'continue_flag';
    s_frage.default    = 1;
    s_frage.def_value  = 1;

    [set_new_plot,s_duh.s_prot,s_duh.s_remote]  = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
end

okay = duh_plot_config_file_erstellen(filename,s_fig);
if( ~okay ),return,end


% Plot erstellen
%===================
clear s_frage
s_frage.comment    = 'Soll der Plot gleicherstellt werden';
s_frage.prot       = 1;
s_frage.command    = 'plot_now_flag';
s_frage.default    = 1;
s_frage.def_value  = 0;

[plot_now_flag,s_duh.s_prot,s_duh.s_remote]  = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);


if( plot_now_flag )
            
        % Plotnummer
        %===========
        if( get(0,'ch') )
            s_duh.n_plot = floor(max(get(0,'ch')));       
        else
            s_duh.n_plot = 0;
        end
        
        %Plotkonfiguration einlesen
        %==========================
        clear s_fig
        fid = fopen(filename,'r');
        if( fid <= 0 )
            warning('File %s konnte nicht geöffnet werden',filename)
            okay = 0;
            return
        end

        while 1
            tline = fgetl(fid);
            % Breche ab wenn Ende erreicht
            if ~ischar(tline)
                break
            end
            if( str_find_f(tline,' ','vn') )
                eval(tline)
            end
        end
        fclose(fid);
        
        % plot ausführen
        %===============
        if( exist('s_fig','var') & strcmp(class(s_fig),'struct') )
            
            for j=1:length(s_fig)
                
                [okay,s_duh] = duh_plot_mit_config_file(s_duh,s_fig(j),data_set_select);
                if( ~okay )
                    return
                end
                % crosshair-subplots
                %-------------------
                chs

            end            
            
        end
    end
    
    % zoom all figures
    %-----------------
    zaf
    % figure menu
    %------------
    figmen
    
end


        

