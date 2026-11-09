% $JustDate:: 15.11.05  $, $Revision:: 3 $ $Author:: Tftbe1    $
function s_duh = duh_daten_plot_config_erstellen_f(s_duh)
%
% Konfiguration erstellen
%
%

% Standards fürs plotten setzen:
set_plot_standards

%================================================================================================
% Anzahl der Figuren
%================================================================================================
% s_frage.c_comment{1} = 'Peakfilter: aus diff(data) wird die Standardabweichung (std) bestimmt';
% s_frage.c_comment{2} = '            Peak wird erkannt, wenn die differenz > faktor*std ist';
% s_frage.c_comment{3} = sprintf(' alter Peakfilterfaktor: %g',s_duh.s_einstell.peak_filt_std_fac);
clear s_frage
s_frage.frage     = 'Wieviele Plot-Bilder (Figuren) sollen erstellt werden';
s_frage.prot      = 1;
s_frage.command   = 'number_of_figures';
s_frage.type      = 'double';
s_frage.min       = 1;
s_frage.default   = 1;

[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);

if( ~okay )
    return
end

n_figure = floor(value);

for i_fig = 1:n_figure
    
    
	% Kurzname geben
	%===============
    clear s_frage
	s_frage.frage     = 'Kurzname für Figure geben (leer:kein Kurzname)';
	s_frage.prot      = 1;
	s_frage.command   = 'short_name';
	s_frage.type      = 'char';
	s_frage.default   = '';
	
	[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( ~okay ),return,end
    if( length(value) == 0 )        
        s_fig(i_fig).short_name     = '';
    else
        s_fig(i_fig).short_name     = value;
    end
    
    % Format
    %========
    clear s_frage
    s_frage.c_liste        = PlotStandards.format_names;
    s_frage.c_name         = PlotStandards.format_names;
    s_frage.frage          = 'Format auswählen';
    s_frage.command        = 'format';
    s_frage.single         = 1;

    [okay,i,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( ~okay ),return, end
    s_fig(i_fig).format = PlotStandards.format_names{i};
    
    
	% Anzahl Reihen
	%===============
    clear s_frage
	s_frage.frage     = 'Wieviele Plots übereinander (Zeilen)';
	s_frage.prot      = 1;
	s_frage.command   = 'rows';
	s_frage.type      = 'double';
	s_frage.default   = 1;
	
	[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( ~okay ),return,end
    s_fig(i_fig).rows = floor(value);

	% Anzahl Spalten
	%===============
    clear s_frage
	s_frage.frage     = 'Wieviele Plots nebeneinander (Spalten)';
	s_frage.prot      = 1;
	s_frage.command   = 'cols';
	s_frage.type      = 'double';
	s_frage.default   = 1;
	
	[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    
    if( ~okay ),return,end
    s_fig(i_fig).cols = floor(value);
    
    
    for i_plot=1:s_fig(i_fig).cols*s_fig(i_fig).rows
        
		% Titel geben
		%===============
        clear s_frage
        s_frage.c_comment{1} = sprintf('Plotbild-Nr. %i',i_plot);
		s_frage.frage        = 'Titel für Plot geben (leer:keinen Titel)';
		s_frage.prot         = 1;
		s_frage.command      = 'title';
		s_frage.type         = 'char';
		s_frage.default      = '';
		
		[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        if( ~okay ),return,end
        if( length(value) == 0 )        
            s_fig(i_fig).s_plot(i_plot).title     = '';
        else
            s_fig(i_fig).s_plot(i_plot).title     = value;
        end
        
        % Fußtitel
        %=========
        clear s_frage
        s_frage.c_liste        = PlotStandards.bot_title_names;
        s_frage.c_name         = PlotStandards.bot_title_names;
        s_frage.frage          = 'Fusstitel auswählen (klein gedruckt)';
        s_frage.command        = 'bot_title';
        s_frage.single         = 1;
	
        [okay,i,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        if( ~okay ),return, end
        s_fig(i_fig).s_plot(i_plot).bot_title = s_frage.c_name{i};
        
        
        % Legende
        %=========
        clear s_frage
        s_frage.c_liste        = PlotStandards.legend_choice;
        s_frage.c_name         = PlotStandards.legend_choice;
        s_frage.frage          = 'Legendentyp auswählen';
        s_frage.command        = 'legend_choice';
        s_frage.single         = 1;
	
        [okay,i,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        if( ~okay ),return, end
        s_fig(i_fig).s_plot(i_plot).legend_choice = s_frage.c_name{i};
    
        % Grid
        %=========
        clear s_frage
        s_frage.comment   = 'Soll Grid erstellt werden';
        s_frage.command   = 'grid_set';
        s_frage.prot      = 1;
        s_frage.default   = 1;
        s_frage.def_value = 1; % ja
        
        [flag,s_duh.s_prot,s_duh.s_remote] = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        s_fig(i_fig).s_plot(i_plot).grid_set = flag;
        
        % xlim_set
        %=========
        clear s_frage
        s_frage.comment   = 'Soll x-Achse limitiert werden';
        s_frage.command   = 'xlim_set';
        s_frage.prot      = 1;
        s_frage.default   = 1;
        s_frage.def_value = 0; % no
        
        [flag,s_duh.s_prot,s_duh.s_remote] = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        s_fig(i_fig).s_plot(i_plot).xlim_set = flag;
                    
     	% xmin
		%===============
        clear s_frage
		s_frage.frage     = 'minimaler x-Wert';
		s_frage.prot      = 1;
		s_frage.command   = 'xmin';
		s_frage.type      = 'double';
		s_frage.default   = 1;
		
		[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        if( ~okay ),return,end
        s_fig(i_fig).s_plot(i_plot).xmin = value;
               
     	% xmax
		%===============
        clear s_frage
		s_frage.frage     = 'maximaler x-Wert';
		s_frage.prot      = 1;
		s_frage.command   = 'xmax';
		s_frage.type      = 'double';
		s_frage.default   = 1;
		
		[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        if( ~okay ),return,end
        s_fig(i_fig).s_plot(i_plot).xmax = value;
        
        % ylim_set
        %=========
        clear s_frage
        s_frage.comment   = 'Soll y-Achse limitiert werden';
        s_frage.command   = 'ylim_set';
        s_frage.prot      = 1;
        s_frage.default   = 1;
        s_frage.def_value = 0; % no
        
        [flag,s_duh.s_prot,s_duh.s_remote] = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        s_fig(i_fig).s_plot(i_plot).ylim_set = flag;
                    
     	% ymin
		%===============
        clear s_frage
		s_frage.frage     = 'minimaler y-Wert';
		s_frage.prot      = 1;
		s_frage.command   = 'ymin';
		s_frage.type      = 'double';
		s_frage.default   = 1;
		
		[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        if( ~okay ),return,end
        s_fig(i_fig).s_plot(i_plot).ymin = value;
               
     	% ymax
		%===============
        clear s_frage
		s_frage.frage     = 'maximaler y-Wert';
		s_frage.prot      = 1;
		s_frage.command   = 'ymax';
		s_frage.type      = 'double';
		s_frage.default   = 1;
		
		[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        if( ~okay ),return,end
        s_fig(i_fig).s_plot(i_plot).ymax = value;
    
		% xlabel geben
		%===============
        clear s_frage
        s_frage.c_comment{1} = sprintf('Plotbild-Nr. %i',i_plot);
		s_frage.frage        = 'Label an x-Achse geben (leer:keinen label)';
		s_frage.prot         = 1;
		s_frage.command      = 'xlabel';
		s_frage.type         = 'char';
		s_frage.default      = '';
		
		[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        if( ~okay ),return,end
        if( length(value) == 0 )        
            s_fig(i_fig).s_plot(i_plot).x_label     = '';
        else
            s_fig(i_fig).s_plot(i_plot).x_label     = value;
        end
    
		% ylabel geben
		%===============
        clear s_frage
        s_frage.c_comment{1} = sprintf('Plotbild-Nr. %i',i_plot);
		s_frage.frage        = 'Label an y-Achse geben (leer:keinen label)';
		s_frage.prot         = 1;
		s_frage.command      = 'ylabel';
		s_frage.type         = 'char';
		s_frage.default      = '';
		
		[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        if( ~okay ),return,end
        if( length(value) == 0 )        
            s_fig(i_fig).s_plot(i_plot).y_label     = '';
        else
            s_fig(i_fig).s_plot(i_plot).y_label     = value;
        end
    
    
        % data_set
        %=========
        clear s_frage
        s_frage.comment   = 'Sollen Daten geplottet werden';
        s_frage.command   = 'data_set';
        s_frage.prot      = 1;
        s_frage.default   = 1;
        s_frage.def_value = 1; % yes
        
        [flag,s_duh.s_prot,s_duh.s_remote] = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);
        
        s_fig(i_fig).s_plot(i_plot).data_set = flag;
        
        if( flag ) % Daten ja
            
            if( s_duh.n_data ==  0 )
                warning('Keine Daten wurden zum auswählen eingeladen');
                return
            end
            
            % Liste mit Vektorennamen erstellen
            %==================================
			for i=1:s_duh.n_data
                c_arr            = fieldnames(s_duh.s_data(i).d);
                s_set(i).c_names = {c_arr{1:length(c_arr)}};
			end
			[s_erg] = str_count_names_f(s_set,1);
			for i= 1:length(s_erg)
                c_liste{i} = sprintf('%s (%g x)',s_erg(i).name,s_erg(i).n);
                c_name{i}  = s_erg(i).name;
			end
            
			% Anzahl der Plotdaten
			%======================
            clear s_frage
			s_frage.frage     = sprintf('Wieviele Grafen (Datensätze) sollen sollen in Plotbild %i Figure %i erstellt werden',i_plot,i_fig);
			s_frage.prot      = 1;
			s_frage.command   = 'number_of_datas';
			s_frage.type      = 'double';
			s_frage.min       = 1;
			s_frage.default   = 1;
			
			[okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( ~okay ),return,end
            s_fig(i_fig).s_plot(i_plot).n_data = floor(value);
            
            for i_d=1:s_fig(i_fig).s_plot(i_plot).n_data
                
                % ndim
                %=========
                clear s_frage
                s_frage.frage     = sprintf('Plotgraf %i: Soll eindimensional (y_vec) oder zweidimensional (x_vec,y_vec) geplottet werden',i_d);
                s_frage.command   = 'ndim';
                s_frage.prot      = 1;
                s_frage.type      = 'double';
                s_frage.default   = 2;
                s_frage.min       = 1;
                s_frage.max       = 2;
                
                [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( ~okay ),return,end
                s_fig(i_fig).s_plot(i_plot).s_data(i_d).ndim = floor(value);
                    
                
                if( s_fig(i_fig).s_plot(i_plot).s_data(i_d).ndim == 2 )
                    
                
                    % x-Vektor
                    %=========
                    clear s_frage
                    s_frage.c_liste        = c_liste;
                    s_frage.c_name         = c_name;
					          s_frage.frage          = sprintf('Plotgraf %i: x-Vektor: Datennamen aus Liste auswählen (n mal vorhanden) ?',i_d);
					          s_frage.command        = 'x_vec_name';
                    s_frage.single         = 1;
                    s_frage.prot_name      = 1;
                    s_frage.sort_list      = 1;

                    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                    
                    if( ~okay ),return,end
                    s_fig(i_fig).s_plot(i_plot).s_data(i_d).x_vec_name = c_name{selection};
                
                    % x_offset
                    %=========
                    clear s_frage
                    s_frage.frage     = sprintf('Plotgraf %i: Offset x-Vektor',i_d);
                    s_frage.command   = 'x_offset';
                    s_frage.prot      = 1;
                    s_frage.type      = 'double';
                    s_frage.default   = 0;
                    
                    [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                    
                    s_fig(i_fig).s_plot(i_plot).s_data(i_d).x_offset = value;

                    % x_faktor
                    %=========
                    clear s_frage
                    s_frage.frage     = sprintf('Plotgraf %i: Faktor x-Vektor',i_d);
                    s_frage.command   = 'x_factor';
                    s_frage.prot      = 1;
                    s_frage.type      = 'double';
                    s_frage.default   = 1;
                    
                    [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                    
                    s_fig(i_fig).s_plot(i_plot).s_data(i_d).x_factor = value;
                    
                end
    
                % y-Vektor
                %=========
                clear s_frage
                s_frage.c_liste        = c_liste;
                s_frage.c_name         = c_name;
                s_frage.frage          = sprintf('Plotgraf %i: y-Vektor: Datennamen aus Liste auswählen (n mal vorhanden) ?',i_d);
                s_frage.command        = 'y_vec_name';
                s_frage.single         = 1;
                s_frage.prot_name      = 1;
                s_frage.sort_list      = 1;

                [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( ~okay ),return,end
                s_fig(i_fig).s_plot(i_plot).s_data(i_d).y_vec_name = c_name{selection};
            
                % y_offset
                %=========
                clear s_frage
                s_frage.frage     = sprintf('Plotgraf %i: Offset y-Vektor',i_d);
                s_frage.command   = 'y_offset';
                s_frage.prot      = 1;
                s_frage.type      = 'double';
                s_frage.default   = 0;
                
                [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( ~okay ),return,end
                s_fig(i_fig).s_plot(i_plot).s_data(i_d).y_offset = value;
                
                % y_faktor
                %=========
                clear s_frage
                s_frage.frage     = sprintf('Plotgraf %i: Faktor y-Vektor',i_d);
                s_frage.command   = 'y_factor';
                s_frage.prot      = 1;
                s_frage.type      = 'double';
                s_frage.default   = 1;
                
                [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( ~okay ),return,end
                s_fig(i_fig).s_plot(i_plot).s_data(i_d).y_factor = value;
                
                % n_start
                %=========
                clear s_frage
                s_frage.frage     = sprintf('Plotgraf %i: erster zu plotender Index (n_start)',i_d);
                s_frage.command   = 'n_start';
                s_frage.prot      = 1;
                s_frage.type      = 'double';
                s_frage.default   = 1;
                
                [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( ~okay ),return,end
                s_fig(i_fig).s_plot(i_plot).s_data(i_d).n_start = floor(value);
               
                % n_end
                %=========
                clear s_frage
                s_frage.frage     = sprintf('Plotgraf %i: letzter zu plotender Index (n_end==-1:letzter Wert)',i_d);
                s_frage.command   = 'n_end';
                s_frage.prot      = 1;
                s_frage.type      = 'double';
                s_frage.default   = -1;
                
                [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( ~okay ),return,end
                s_fig(i_fig).s_plot(i_plot).s_data(i_d).n_end = floor(value);
    
                % line_size
                %==========
                clear s_frage
                s_frage.frage     = sprintf('Plotgraf %i: Linienestärke (0.5,1,1.5,...)',i_d);
                s_frage.command   = 'line_size';
                s_frage.prot      = 1;
                s_frage.type      = 'double';
                s_frage.default   = 1;
                
                [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( ~okay ),return,end
                s_fig(i_fig).s_plot(i_plot).s_data(i_d).line_size = value;
    
    
                % line_color
                %===========
                clear s_frage
                s_frage.c_liste        = PlotStandards.color_names;
                s_frage.c_name         = PlotStandards.color_names;
                s_frage.frage          = sprintf('Plotgraf %i: linienfarbe aus Liste auswählen ?',i_d);
                s_frage.command        = 'line_color_name';
                s_frage.single         = 1;
                s_frage.prot_name      = 1;

        				[okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( ~okay ),return,end
                s_fig(i_fig).s_plot(i_plot).s_data(i_d).line_color_name = s_frage.c_name{selection};
                
            end
        end
    end
end

% Konfigurationsfile festlegen
%=============================

s_frage.comment        = 'm-File für Plotkonfiguratiosdatei (z.B. plot_config_xyz.m)';
s_frage.command        = 'pconf_file';
s_frage.prot           = 1;
s_frage.file_spec      = '*.pconf';
s_frage.start_dir      = s_duh.s_einstell.main_work_dir;
s_frage.file_number    = 1;
s_frage.put_file       = 1;

[okay,c_filename,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
if( ~okay ),return,end

okay = duh_plot_config_file_erstellen(c_filename{1},s_fig);
if( ~okay ),return,end

        

