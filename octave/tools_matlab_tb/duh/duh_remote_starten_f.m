function   s_duh = duh_remote_starten_f(s_duh)

run_flag = 1;
while( run_flag )
    [filename, pathname] = uigetfile('*.rem', 'Pick an rem-file(Remote-File) for automatic command input (copy prot to rem)');
    
    if isequal(filename,0) || isequal(pathname,0)
        fprintf('\n Kein remote-Datei ausgewählt\n')
        run_flag = 0;
    else
        file =fullfile(pathname, filename);
        if( ~exist(file,'file') )
            fprintf('\n\n File <%s> existiert nicht ',file);
        else
            [okay_flag,s_duh.s_remote] = o_remote_f(file);
            if( ~okay_flag )
                dum = sprintf('Remote file <%s> konnte nicht gestartet werden');
                error('duh_remote_starten:file not started',dum);
            else
                s_duh.s_remote.run_flag = 1;
            end
            run_flag = 0;
        end
    end
end

