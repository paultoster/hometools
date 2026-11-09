function  [okay,s_duh] = duh_scan_daten_einlesen_f(s_duh)

go_on_flag = 1;
new_data_flag = 1;
image_file_read = 0;

if( s_duh.n_data > 0 )
    for i= 1:s_duh.n_data
        s_frage.c_liste{i} = sprintf('%s (%s)',s_duh.s_data(i).name,s_duh.s_data(i).h{1});
        s_frage.c_name{i}  = s_duh.s_data(i).name;
    end
    s_frage.c_liste{s_duh.n_data+1} = sprintf('%s (%s)','<neuer Datensatz>','');

    s_frage.frage          = 'Datensa(e)tz(e) auswählen ?';
    s_frage.command        = 'data_set';
    s_frage.single         = 1;

    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);

    if( ~okay )
        return
    end
    
    if( selection(1) < s_duh.n_data+1 )
        
        i_data = selection(1);
        d = s_duh.s_data(i_data).d;
        u = s_duh.s_data(i_data).u;
        h = s_duh.s_data(i_data).h;
    else
        i_data = s_duh.n_data+1;
    end
else
    i_data = s_duh.n_data+1;
end


while( go_on_flag )
    
    
    if( image_file_read )

        % weitere Datei
        clear s_frage
        s_frage.frage          = 'Soll eine neue Datei geöffnet werden ?';
        s_frage.command        = 'open_new_file';
        s_frage.default        = 1;
        s_frage.def_value      = 'n';
        s_frage.prot           = 1;

        [okay,s_duh.s_prot,s_duh.s_remote] = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);

        if( okay )
            image_file_read = 0;
        end
    end
    
    if( ~image_file_read )
        clear s_frage    
        s_frage.comment        = 'bitmap-File festlegen';
        s_frage.command        = 'bitmap_file';
        s_frage.prot           = 1;
        s_frage.file_spec      = '*.jpg;*.jpeg;*.tiff;*.tif;*.bmp;*.gif;*.png';
        s_frage.start_dir      = s_duh.start_dir;
        s_frage.file_number    = 1;

        [okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);

        if( ~okay )
            return
        end

        % Image einlesen
        image_val  = imread(c_filenames{1});

        % Neue Figure
        h_fig = figure;
        image(image_val);
        hold on
        
        image_file_read = 1;
    end

    % X-Vektor
    clear s_frage
    s_frage.frage          = 'Wie soll der Vektor auf der X-Achse heißen (oder default verwenden)?';
    s_frage.command        = 'scan_x_vec_name';
    s_frage.type           = 'char';
    s_frage.default        = 'x_vec';
    s_frage.prot           = 1;

    [okay,x_vec_name,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    if( ~okay )
        return
    end
    clear s_frage
    s_frage.frage          = sprintf('Wie soll Einheit von %s heißen (oder default verwenden)?',x_vec_name);
    s_frage.command        = 'scan_x_vec_unit';
    s_frage.type           = 'char';
    s_frage.default        = '-';
    s_frage.prot           = 1;

    [okay,x_vec_unit,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    if( ~okay )
        return
    end

    % Y-Vektor
    clear s_frage
    s_frage.frage          = 'Wie soll der Vektor auf der Y-Achse heißen (oder default verwenden)?';
    s_frage.command        = 'scan_y_vec_name';
    s_frage.type           = 'char';
    s_frage.default        = 'y_vec';
    s_frage.prot           = 1;

    [okay,y_vec_name,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    if( ~okay )
        return
    end
    clear s_frage
    s_frage.frage          = sprintf('Wie soll Einheit von %s heißen (oder default verwenden)?',y_vec_name);
    s_frage.command        = 'scan_y_vec_unit';
    s_frage.type           = 'char';
    s_frage.default        = '-';
    s_frage.prot           = 1;

    [okay,y_vec_unit,s_duh.s_prot,s_duh.s_remote] = o_abfragen_wert_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    if( ~okay )
        return
    end


    % Ab hier kein remote-Einscannen zulassen
    %========================================
    s_duh.s_remote.run_flag = 0;

    % Kurve einscannen
    %=================
    [scan_x,scan_y] = scan_daten_einlesen_kurve_lesen(h_fig);

    % Daten zuordnen
    %===============
    if( new_data_flag )
        s_duh.n_data = s_duh.n_data + 1;
    end
    
    d.(x_vec_name) = scan_x;
    d.(y_vec_name) = scan_y;

    u.(x_vec_name) = x_vec_unit;
    u.(y_vec_name) = y_vec_unit;    
    
    % weitere Kurven
    clear s_frage
    s_frage.frage          = 'Sollen weitere Kurven eingescannt werden ?';
    s_frage.command        = 'scan_again';
    s_frage.default        = 1;
    s_frage.def_value      = 'n';
    s_frage.prot           = 1;

    [okay,s_duh.s_prot,s_duh.s_remote] = o_abfragen_jn_f(s_frage,s_duh.s_prot,s_duh.s_remote);
    if( okay )
        go_on_flag = 1;
    else
        go_on_flag = 0;
    end
    
end


s_duh.s_data(i_data).d = d;
s_duh.s_data(i_data).u = u;

if( exist('h','var') )
    
    h{length(h)+1} = 'read-scan-curve';
else
    h{1} = 'read-scan-curve';
end
s_duh.s_data(i_data).h = h;

s_duh.s_data(i_data).file        = c_filenames{1};

s_file                                 = str_get_pfe_f(c_filenames{1});
s_duh.s_data(i_data).name        = s_file.name;

s_duh.s_data(i_data).c_prc_files = {};

s_duh.n_data = i_data;


