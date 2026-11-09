% $JustDate:: 15.11.05  $, $Revision:: 2 $ $Author:: Tftbe1    $
function s_duh = duh_einstellung_laden_f(s_duh,type)

if( type == 0 ) % Einstellungsdatei einladen
    
    % Struktur nullen
    % s_einstell = 0;

    % Einstellung einladen 
    main_dir = s_duh.start_dir;
    % wenn Einstellungsfile im Verzeichnis existiert
    if( exist('.\duh.pref','file' ) )

        % Öffne Datei
        fid = fopen('duh.pref','r');    
        if( fid > 0 )
   
            m = 0;
            n = 0;
            nd = 0;
            na = 0;
            % Lese Zeilenweise ein
            while 1
                tline = fgetl(fid);
                % Breche ab wenn Ende erreicht
                if ~ischar(tline)
                    break
                end
                % Nehme alles bis zum Kommentarzeichen
                str_line = strtok(tline,'%');
                
                % Wenn nicht leer
                if( length(str_line) > 0 )
                    
                    % Nimm alles bis zum =-Zeichen in str_c den Rest in str_v
                    [str_c,str_v] = strtok(str_line,'=');
                    str_v = str_cut_a_f(str_v,'=');
                    
                    % Bereinige Anfang und Ende um Leerzeichen
                    str_c = str_cut_ae_f(str_c,' ');
                    str_v = str_cut_ae_f(str_v,' ');
                    
                    % Wenn beide strings etwas enthalten
                    if( length(str_c) > 0 & length(str_v) > 0 )
                        
                        % Suche nach dem command-string und übergebe
                        % den Value str_v
                        if( strcmp(str_c,'main_work_dir') )
                            
                            if( exist(str_v,'dir') )
                                s_einstell.main_work_dir = str_v;
                            else
                                s_einstell.main_work_dir = pwd;
                            end
                            
                        elseif( strcmp(str_c,'measure_dir') )
                            
                            if( exist(str_v,'dir') )
                                s_einstell.measure_dir = str_v;
                            else
                                s_einstell.measure_dir = pwd;
                            end
                            
                        elseif( strcmp(str_c,'carmaker_project_dir') )
                            
                            if( exist(str_v,'dir') )
                                s_einstell.carmaker_project_dir = str_v;
                            else
                                s_einstell.carmaker_project_dir = pwd;
                            end
                            
                        elseif( strcmp(str_c,'c_datalyser_prc_file') )
                            if( strcmp(str_v,'{}') )
                                s_einstell.c_datalyser_prc_file = {};
                            else
                                m = m+1;
                                s_einstell.c_datalyser_prc_file{m} = str_v;
                            end
                        elseif( strcmp(str_c,'c_pos_signal_list') )
                            if( strcmp(str_v,'{}') )
                                s_einstell.c_pos_signal_list = {};
                            else
                                m = m+1;
                                s_einstell.c_pos_signal_list{m} = str_v;
                            end
                        elseif( strcmp(str_c,'c_neg_signal_list') )
                            if( strcmp(str_v,'{}') )
                                s_einstell.c_neg_signal_list = {};
                            else
                                m = m+1;
                                s_einstell.c_neg_signal_list{m} = str_v;
                            end
                        elseif( strcmp(str_c,'datalyser_a2l_file') )
                            if( strcmp(str_v,'') )
                                s_einstell.datalyser_a2l_file = ''
                            else
                                s_einstell.datalyser_a2l_file = str_v;
                            end
                        elseif( strcmp(str_c,'debug_info_in_prot') )
                            if( str_v(1) == '1' | ...
                                str_v(1) == 'j' | str_v(1) == 'J' | ...
                                str_v(1) == 'y' | str_v(1) == 'Y' )
                            
                                s_einstell.debug_info_in_prot = 1;
                            else
                                s_einstell.debug_info_in_prot = 0;
                            end
                        elseif( strcmp(str_c,'peak_filt_std_fac') )
                            s_einstell.peak_filt_std_fac = str2num(str_v);
                        elseif( strcmp(str_c,'c_my_func_file') )
                            if( strcmp(str_v,'{}') )
                                s_einstell.c_my_func_file = {};
                            else
                                n = n+1;
                                s_einstell.c_my_func_file{n} = str_v;
                            end
                        elseif( strcmp(str_c,'c_analyse_func_file') )
                            if( strcmp(str_v,'{}') )
                                s_einstell.c_analyse_func_file = {};
                            else
                                na = na+1;
                                s_einstell.c_analyse_func_file{na} = str_v;
                            end
                        elseif( strcmp(str_c,'res_file') )
                            if( strcmp(str_v,'') )
                                s_einstell.res_file = '';
                            else
                                s_einstell.res_file = str_v;
                            end
                        elseif( strcmp(str_c,'c_dbc_file') )
                            if( strcmp(str_v,'{}') )
                                s_einstell.c_dbc_file = {};
                            else
                                nd = nd+1;
                                s_einstell.c_dbc_file{nd} = str_v;
                            end
                            
                        end
                    end                    
                end
            end
            
            % Schliesse Datei
            fclose(fid);
        else
            error('duh_einstellung_laden_f:error',' file <duh_einstell.dat> kann nnicht geöffnet werden\n');            
        end
    else
        s_einstell.a = 0;
    end
	
	% Prüfe ob  alle einstellungen gesetzt sind:
	if( ~isfield(s_einstell,'main_work_dir') )
        s_einstell.main_work_dir = main_dir;
	end
	if( ~isfield(s_einstell,'measure_dir') )
        s_einstell.measure_dir = main_dir;
	end
	if( ~isfield(s_einstell,'carmaker_project_dir') )
        s_einstell.carmaker_project_dir = main_dir;
	end
	if( ~isfield(s_einstell,'c_datalyser_prc_file') )
        s_einstell.c_datalyser_prc_file = {};
	end
	if( ~isfield(s_einstell,'c_pos_signal_list') )
        s_einstell.c_pos_signal_list = {};
	end
	if( ~isfield(s_einstell,'c_neg_signal_list') )
        s_einstell.c_neg_signal_list = {};
	end
	if( ~isfield(s_einstell,'datalyser_a2l_file') )
        s_einstell.datalyser_a2l_file = '';
	end
	if( ~isfield(s_einstell,'debug_info_in_prot') )
        s_einstell.debug_info_in_prot = 0;
	end
	if( ~isfield(s_einstell, 'peak_filt_std_fac') )
        s_einstell.peak_filt_std_fac = 3;
	end
	if( ~isfield(s_einstell,'c_my_func_file') )
        s_einstell.c_my_func_file = {};
	end
	if( ~isfield(s_einstell,'c_analyse_func_file') )
        s_einstell.c_analyse_func_file = {};
	end
	if( ~isfield(s_einstell,'res_file') )
        s_einstell.res_file = 'result.dat';
	end
	if( ~isfield(s_einstell,'c_dbc_file') )
        s_einstell.c_dbc_file = {};
	end

    s_duh.s_einstell = s_einstell;
    
elseif( type == 1 ) % Einstellung ändern

	s_duh.command = '';
	s_liste = o_abfragen_verzweigung_liste_erstellen_f ...
                 (1,'main_dir'  ,       'Hauptarbeitsverzeichnis festlegen' ...
                 ,1,'meas_dir'  ,       'Verzeichnis für Messungen festlegen' ...
                 ,1,'carmaker_project_dir',       'ProjektVverzeichnis für CarMaker Simulation festlegen' ...
                 ,1,'debug_prot',       'Debugausgabe in Protokoll' ...
                 ,1,'prc_files' ,       'Datalyser-Protokoll festlegen' ...
                 ,1,'pos_filt_list' ,   'positive Signalfilterliste anlegen' ...
                 ,1,'a2l_file'  ,       'Datalyser-asap-File festlegen' ...
                 ,1,'peak_filt_fac',    'Peakfilterfaktor ändern' ...
                 ,1,'my_func_files',    'eigene m-Files mit der Struktur [d,u,h]=file_name(d,u,h) bestimmen' ...
                 ,1,'analyse_func_files',    'eigene m-Files zur Auswertung mit der Struktur [comment]=file_name(d,u,h,file) bestimmen' ...
                 ,1,'res_file',         'Ergebnisdateiname bestimmen' ...
                 ,1,'dbc_files',        'dbc-File für Canalyserdaten festlegen' ...
                 );

   s_liste = o_abfragen_verzweigung_liste_erstellen_f ...
                 (1,'main_dir'            ,       'Hauptarbeitsverzeichnis festlegen' ...
                 ,1,'meas_dir'            ,       'Verzeichnis für Messungen festlegen' ...
                 ,1,'carmaker_project_dir',       'ProjektVerzeichnis für CarMaker Simulation festlegen' ...
                 ,1,'debug_prot'          ,       'Debugausgabe in Protokoll' ...
                 ,1,'prc_files'           ,       'Datalyser-Protokoll festlegen' ...
                 ,1,'pos_filt_list'       ,       'positive Signalfilterliste anlegen (zum reinnehmen)' ...
                 ,1,'neg_filt_list'       ,       'negative Signalfilterliste anlegen (zum rausnehmen)' ...
                 );
	[end_flag,option,s_duh.s_prot,s_duh.s_remote] = o_abfragen_verzweigung_f(s_liste,s_duh.s_prot,s_duh.s_remote);
	
	if( end_flag )
       return;
	end
	
	switch option
        case 1 % Hauptverzeichnis festlegen
            
            s_frage.comment   = 'Hauptverzeichnis festlegen';
            s_frage.command   = 'main_work_dir';
            s_frage.prot      = 1;
            s_frage.start_dir = s_duh.start_dir;
            [okay,c_dirname,s_duh.s_prot,s_duh.s_remote] = o_abfragen_dir_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                s_duh.s_einstell.main_work_dir = c_dirname{1};
            end
        case 2 % Messverzeichnis festlegen
            
            s_frage.comment   = 'Messverzeichnis festlegen';
            s_frage.command   = 'measure_dir';
            s_frage.prot      = 1;
            s_frage.start_dir = s_duh.start_dir;
            [okay,c_dirname,s_duh.s_prot,s_duh.s_remote] = o_abfragen_dir_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                s_duh.s_einstell.measure_dir = c_dirname{1};
            end
        case 3 % ProjektVerzeichnis festlegen
            
            s_frage.comment   = 'ProjektVerzeichnis festlegen';
            s_frage.command   = 'carmaker_project_dir';
            s_frage.prot      = 1;
            s_frage.start_dir = s_duh.start_dir;
            [okay,c_dirname,s_duh.s_prot,s_duh.s_remote] = o_abfragen_dir_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                s_duh.s_einstell.carmaker_project_dir = c_dirname{1};
            end
        case 4 % debug_info
            s_frage.comment = 'Debuginfo (Ausgabe) in Protokoll schreiben';
            s_frage.command = 'debug_info_in_prot';
            s_frage.prot    = 1;
            s_frage.default = 1;
            if( s_duh.s_einstell.debug_info_in_prot )
                s_frage.def_value = 0; % nein
            else
                s_frage.def_value = 1; % ja
            end
            [flag,s_duh.s_prot,s_duh.s_remote] = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( s_duh.s_einstell.debug_info_in_prot )
                      s_duh.s_prot.debug_fid = s_duh.s_prot.fid;
            else
                      s_duh.s_prot.debug_fid = 0;
            end
        case 5 % Datalyser-Protokoll festlegen
                
            s_frage.comment   = 'Datalyser standard prc-Files auswählen';
            s_frage.command   = 'datalyser_prc_files';
            s_frage.prot      = 1;
            s_frage.file_spec ='*.prc';
            s_frage.start_dir = s_duh.start_dir;
            s_frage.file_number    = 0;
            
            [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                for i=1:length(c_filenames)
                    s_duh.s_einstell.c_datalyser_prc_file{i} = c_filenames{i};
                end
            end
        case {6,7} % Positive/negative Signalliste zum ausfiltern anlegen
            if( s_duh.n_data == 0 )
                if( ~s_duh.s_remote.run_flag )
                    input('Keine Daten vorhanden um Signalliste zu erstellen','s')
                end
            else
                for i= 1:s_duh.n_data
                    s_frage.c_liste{i} = sprintf('%s(%s)',s_duh.s_data(i).name,s_duh.s_data(i).h{1});
                end

                s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
                s_frage.command        = 'data_set';
                s_frage.single         = 0;

                [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

                clear s_frage
                for i=1:length(selection)
                    c_arr            = fieldnames(s_duh.s_data(selection(i)).d);
                    s_set(i).c_names = {c_arr{1:length(c_arr)}};
                end
                [s_erg] = str_count_names_f(s_set,1);
                for i= 1:length(s_erg)
                    s_frage.c_liste{i} = sprintf('%s (%g x)',s_erg(i).name,s_erg(i).n);
                    s_frage.c_name{i}  = s_erg(i).name;
                end

                s_frage.frage          = sprintf('Signale aus %g Datensätze auswählen (n mal vorhanden) ?',length(selection));
                s_frage.command        = 'data_names';
                s_frage.single         = 0;
                s_frage.prot_name      = 1;

                %[okay,sig_select,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                [okay,sig_select,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listboxsort_f(s_frage,s_duh.s_prot,s_duh.s_remote);
                
                if( okay )

                    if( option == 5 )
                    
                        s_duh.s_einstell.c_pos_signal_list = {};
                        for i= 1:length(sig_select)

                            s_duh.s_einstell.c_pos_signal_list{i} = s_frage.c_name{sig_select(i)};
                        end
                    else
                        s_duh.s_einstell.c_neg_signal_list = {};
                        for i= 1:length(sig_select)

                            s_duh.s_einstell.c_neg_signal_list{i} = s_frage.c_name{sig_select(i)};
                        end
                    end
                end
            end            
        case 8 % Datalyser-asap File festlegen
                
            s_frage.comment   = 'Datalyser2 standard a2l-Files auswählen';
            s_frage.command   = 'datalyser_a2l_file';
            s_frage.prot      = 1;
            s_frage.file_spec ='*.a2l';
            s_frage.start_dir = s_duh.start_dir;
            s_frage.file_number    = 1;
            
            [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                    s_duh.s_einstell.datalyser_a2l_file = c_filenames{1};
            end
        case 9 % peakfilter faktor
			clear s_frage
			s_frage.c_comment{1} = 'Peakfilter: aus diff(data) wird die Standardabweichung (std) bestimmt';
			s_frage.c_comment{2} = '            Peak wird erkannt, wenn die differenz > faktor*std ist';
            s_frage.c_comment{3} = sprintf(' alter Peakfilterfaktor: %g',s_duh.s_einstell.peak_filt_std_fac);
			s_frage.frage     = 'Faktor für Peakfilter';
			s_frage.prot      = 1;
			s_frage.command   = 'peak_filt_std_fac';
			s_frage.type      = 'double';
			s_frage.min       = 0;
	
            [okay,value,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                s_duh.s_einstell.peak_filt_std_fac = value;
            end
        case 10 % eigene m-Files mit der Struktur [d,u,h]=file_name(d,u,h) bestimmen
                
            s_frage.comment   = 'm-File (my_func.m) für eigene Auswertung bestimmen (Interface zwingend [d,u,h]=my_func(d,u,h)';
            s_frage.command   = 'my_func_files';
            s_frage.prot      = 1;
            s_frage.file_spec = '*.m';
            s_frage.start_dir = s_duh.start_dir;
            s_frage.file_number    = 0;
            
            [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                s_duh.s_einstell.c_my_func_file={};
                for i=1:length(c_filenames)
                    s_duh.s_einstell.c_my_func_file{i} = c_filenames{i};
                end
            end

        case 11 % eigene m-Files mit der Struktur [comment]=file_name(d,u,h,file) bestimmen
                
            s_frage.comment   = 'm-File (my_func.m) für eigene Auswertung bestimmen (Interface zwingend [comment]=my_func(d,u,h,file)';
            s_frage.command   = 'analyse_func_files';
            s_frage.prot      = 1;
            s_frage.file_spec = '*.m';
            s_frage.start_dir = s_duh.start_dir;
            s_frage.file_number    = 0;
            
            [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                s_duh.s_einstell.c_analyse_func_file={};
                for i=1:length(c_filenames)
                    s_duh.s_einstell.c_analyse_func_file{i} = c_filenames{i};
                end
            end
	
        case 12 % Ergenisdateiname bestimmen
                
            s_frage.comment   = 'Ergebnisdateinamen bestimmen';
            s_frage.command   = 'res_file';
            s_frage.prot      = 1;
            s_frage.file_spec = '*.*';
            s_frage.start_dir = s_duh.start_dir;
            s_frage.file_number    = 1;
            
            [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                s_duh.s_einstell.c_my_func_file ={};
                s_duh.s_einstell.res_file       = c_filenames{1};
            end
	
        case 13 % dbc-File        
            
            s_frage.comment   = 'dbc-File für Canalyser-Messungen-Auswertung festlegen';
            s_frage.command   = 'dbc_files';
            s_frage.prot      = 1;
            s_frage.file_spec = '*.dbc';
            s_frage.start_dir = s_duh.start_dir;
            s_frage.file_number    = 0;
            
            [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);
            
            if( okay )
                s_duh.s_einstell.c_dbc_file={};
                for i=1:length(c_filenames)
                    s_duh.s_einstell.c_dbc_file{i} = c_filenames{i};
                end
            end
	end
elseif( type == 2 ) % Einstellung abspeichern
    
    s_einstell = s_duh.s_einstell;

	fid = fopen('duh.pref','w');
	
	if( fid > 0 )
        
        % main_work_dir
        fprintf(fid,'main_work_dir = %s\n',char(s_einstell.main_work_dir));

        % measure_dir
        fprintf(fid,'measure_dir = %s\n',char(s_einstell.measure_dir));

        % carmaker_project_dir
        fprintf(fid,'carmaker_project_dir = %s\n',char(s_einstell.carmaker_project_dir));
            
        % c_datalyser_prot_file
        n = length(s_einstell.c_datalyser_prc_file);
        if( n == 0 )
            fprintf(fid,'c_datalyser_prc_file = {}\n');
        else
            for i=1:n
                fprintf(fid,'c_datalyser_prc_file = %s\n',s_einstell.c_datalyser_prc_file{i});
            end
        end
        
        % c_pos_signal_list
        n = length(s_einstell.c_pos_signal_list);
        if( n == 0 )
            fprintf(fid,'c_pos_signal_list = {}\n');
        else
            for i=1:n
                fprintf(fid,'c_pos_signal_list = %s\n',s_einstell.c_pos_signal_list{i});
            end
        end

        % c_neg_signal_list
        n = length(s_einstell.c_neg_signal_list);
        if( n == 0 )
            fprintf(fid,'c_neg_signal_list = {}\n');
        else
            for i=1:n
                fprintf(fid,'c_neg_signal_list = %s\n',s_einstell.c_neg_signal_list{i});
            end
        end
        
        fprintf(fid,'datalyser_a2l_file = %s\n',s_duh.s_einstell.datalyser_a2l_file);
        
        % debug_info_in_prot
        if( s_einstell.debug_info_in_prot )
            fprintf(fid,'debug_info_in_prot = 1\n');
        else
            fprintf(fid,'debug_info_in_prot = 0\n');
        end
	
        % Faktor for peak-filter
        fprintf(fid,'peak_filt_std_fac = %g\n',s_einstell.peak_filt_std_fac);
        
        % c_my_func_file
        n = length(s_einstell.c_my_func_file);
        if( n == 0 )
            fprintf(fid,'c_my_func_file = {}\n');
        else
            for i=1:n
                fprintf(fid,'c_my_func_file = %s\n',s_einstell.c_my_func_file{i});
            end
        end

        % c_analyse_func_file
        n = length(s_einstell.c_analyse_func_file);
        if( n == 0 )
            fprintf(fid,'c_analyse_func_file = {}\n');
        else
            for i=1:n
                fprintf(fid,'c_analyse_func_file = %s\n',s_einstell.c_analyse_func_file{i});
            end
        end

        fprintf(fid,'res_file = %s\n',s_duh.s_einstell.res_file);

        % c_dbc_file
        n = length(s_einstell.c_dbc_file);
        if( n == 0 )
            fprintf(fid,'c_dbc_file = {}\n');
        else
            for i=1:n
                fprintf(fid,'c_dbc_file = %s\n',s_einstell.c_dbc_file{i});
            end
        end
        
        fclose(fid);
	end

end

