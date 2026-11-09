function s_duh = duh_daten_plotten_simple_f(s_duh)
%
% Daten enfach plotten
%
%

% Standards fürs plotten setzen:
set_plot_standards

% Datennsätze auswählen

for i= 1:s_duh.n_data
    s_frage.c_liste{i} = sprintf('%s (%s)',s_duh.s_data(i).name,s_duh.s_data(i).h{1});
end

s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
s_frage.command        = 'data_set';
s_frage.single         = 0;

[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( ~okay )
    return
end
data_set_select = selection;

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
end
    
s_frage.frage          = sprintf('y-Vektor(n) aus %g Datensätze auswählen (n mal vorhanden) ?',length(data_set_select));
s_frage.command        = 'data_names';
s_frage.single         = 0;
s_frage.prot_name      = 1;

%[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listboxsort_f(s_frage,s_duh.s_prot,s_duh.s_remote);

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

% Plotten starten

% Zuerst figmen-Box setzen
figmen

% Auswahl selection einzeln plotten:


    
n         = length(selection);
i         = 1;
icount    = 1;
ifigcount = 0;
nfigcount = ncols*nrows;
if( nfigcount == 1 )
    idina4 = 0;
else
    if( nrows > ncols )
        idina4 = 1;
    else
        idina4 = 2;
    end
end
if( length(data_set_select) == 1 && nfigcount > 1 )
    ilengend_set = 0;
else
    ilengend_set = 1;
end

while(i)
%for i=1:length(selection)

    % Liste mit den selktierten Datenblöcke
    clear s_index_liste
    icount = 0;
    for j=1:length(data_set_select)
        c_arr = fieldnames(s_duh.s_data(data_set_select(j)).d);
        index = str_find_vec_f(c_arr,s_erg(selection(i)).name,1);
        if( index > 0 )
            icount = icount+1;
            s_index_liste(icount).index = index;
            s_index_liste(icount).index_x = index_x_vec(j);
            s_index_liste(icount).idata = data_set_select(j);
        end
    end
    
    
    
    if( length(s_index_liste) > 0 )
        
        if( ifigcount == nfigcount )
            
            ifigcount = 1;
        else
            ifigcount = ifigcount + 1;
        end
            
            

        % Bezeichnung für x-Achse
        x_unit = '';
        for j=1:length(s_index_liste)
            c_arr  = fieldnames(s_duh.s_data(s_index_liste(j).idata).d);
            x_unit1 = getfield(s_duh.s_data(s_index_liste(j).idata).u,c_arr{s_index_liste(j).index});
            if( length(x_unit1) > 0 )
                x_unit = x_unit1;
                break
            end
        end
        x_label_name = [c_arr{s_index_liste(1).index_x},' ',x_unit];
        
        % Bezeichnung für y-Achse
        y_unit = '';
        for j=1:length(s_index_liste)
            c_arr  = fieldnames(s_duh.s_data(s_index_liste(j).idata).d);
            y_unit1 = getfield(s_duh.s_data(s_index_liste(j).idata).u,c_arr{s_index_liste(j).index});
            if( length(y_unit1) > 0 )
                y_unit = y_unit1;
                break
            end
        end
        y_label_name = [s_erg(selection(i)).name,' ',y_unit];
        
        if( ifigcount == 1 )
            % figure-Struktur füllen
            s_fig.fig_num = 0;                                 % automatische Nummerierung
            s_fig.short_name_set = 1;                          % Kurzname wird mit figmen angezeigt
            s_fig.short_name = s_erg(selection(i)).name;       % Kurzname
            s_fig.dina4 = idina4;                                   % kein Format
            s_fig.rows = nrows;                                    % Anzahl subplot Zeilen
            s_fig.cols = ncols;                                    % Anzahl subplot Reihen
        end
        % Erstes Plotbild
        s_fig.s_plot(ifigcount).grid_set = 1;                      % grid
        s_fig.s_plot(ifigcount).legend_set = ilengend_set;                    % legende schreiben (wird mit s_data übergeben)
        s_fig.s_plot(ifigcount).bot_title_set = 1;                 % Zusatztitle unten klein (wird mit s_data übergeben)
        s_fig.s_plot(ifigcount).title_set = 1;                     % Titel setzen
        s_fig.s_plot(ifigcount).title = s_erg(selection(i)).name;  % Titel
        s_fig.s_plot(ifigcount).x_label_set = 1;                      % x-Achesnbezeichnung
        s_fig.s_plot(ifigcount).x_label = x_label_name;
        s_fig.s_plot(ifigcount).y_label_set = 1;                      % y-Achesnbezeichnung
        s_fig.s_plot(ifigcount).y_label = y_label_name;
        s_fig.s_plot(ifigcount).xlim_set = 0;                         % Limietierung x-Achse
        s_fig.s_plot(ifigcount).ylim_set = 0;                         % Limietierung y-Achse
        s_fig.s_plot(ifigcount).data_set = 1;                         % Daten werden geplottet
        
        for j=1:length(s_index_liste)
            
            
            s_fig.s_plot(ifigcount).bot_title{j*2-1} = s_duh.s_data(s_index_liste(j).idata).file;
            s_fig.s_plot(ifigcount).bot_title{j*2}   = s_duh.s_data(s_index_liste(j).idata).h{1};
            
            s_fig.s_plot(ifigcount).s_data(j).ndim     = 2;           % zweidim-Plot
            s_fig.s_plot(ifigcount).s_data(j).n_start  = 0;            % Startindex (0 erster Wert)
            s_fig.s_plot(ifigcount).s_data(j).n_end    = 0;           % endindex (0 letzter Wert)
            s_fig.s_plot(ifigcount).s_data(j).x_offset = 0;           % X-Offset wird abgezogen
            s_fig.s_plot(ifigcount).s_data(j).y_offset = 0;           % Y-Offset wird abgezogen

            c_arr  = fieldnames(s_duh.s_data(s_index_liste(j).idata).d);
            
            s_fig.s_plot(ifigcount).s_data(j).x_vec     = getfield(s_duh.s_data(s_index_liste(j).idata).d,c_arr{s_index_liste(j).index_x});
            s_fig.s_plot(ifigcount).s_data(j).y_vec     = getfield(s_duh.s_data(s_index_liste(j).idata).d,s_erg(selection(i)).name);
            s_fig.s_plot(ifigcount).s_data(j).line_type = PlotStandards.Ltype{1};
            s_fig.s_plot(ifigcount).s_data(j).line_size = PlotStandards.Lsize{2};
            s_fig.s_plot(ifigcount).s_data(j).line_color = PlotStandards.Farbe{j};
            s_fig.s_plot(ifigcount).s_data(j).marker_type = PlotStandards.Mtype0;
            s_fig.s_plot(ifigcount).s_data(j).marker_size = PlotStandards.Msize{1};
            
            s_fig.s_plot(ifigcount).s_data(j).legend = s_duh.s_data(s_index_liste(j).idata).name;
        end
    end
    
    if( ifigcount == nfigcount || i == n ) 
        [handle,okay] = plot_f(s_fig);
        % zoom all figure für aktuellen plot
        zaf('setact_silent')
        % scroll measurementfür aktuellen plot
        scm('setact_silent')
        clear s_fig
    end
    
    i = i + 1;
    if( i > n )
        i = 0;
    end
end

figmen
