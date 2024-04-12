% $JustDate:: 15.11.05  $, $Revision:: 3 $ $Author:: Tftbe1    $
function s_duh = duh_daten_plot_config_ausfuehren_f(s_duh)
%
% Konfiguration ausf�hren
%
%

% Konfigurationsfile ausw�hlen
%=============================

s_frage.comment        = 'Plotkonfigurations-pconf-File(s)ausw�hlen';
s_frage.command        = 'pconf_file';
s_frage.prot           = 1;
s_frage.file_spec      = '*.pconf';
s_frage.start_dir      = s_duh.s_einstell.main_work_dir;
s_frage.file_number    = 0;

[okay,c_filenames,s_duh.s_prot,s_duh.s_remote] = o_abfragen_files_f(s_frage,s_duh.s_prot,s_duh.s_remote);


% Datenns�tze ausw�hlen
if( okay )
    for i= 1:s_duh.n_data
        s_frage.c_liste{i} = sprintf('%s (%s)',s_duh.s_data(i).name,s_duh.s_data(i).h{1});
    end

    s_frage.frage          = 'Datensa(e)tz(e) ausw�hlen ?';
    s_frage.command        = 'data_set';
    s_frage.single         = 0;

    [okay,selection,s_duh.s_prot,s_duh.s_remote] = o_abfragen_listbox_f(s_frage,s_duh.s_prot,s_duh.s_remote);
end

if( okay )
    for i=1:length(c_filenames)
        
        

        % Filename �bergeben
        %===================
        filename = char(c_filenames{i});
        
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
            warning('File %s konnte nicht ge�ffnet werden',filename)
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
        
        % plot ausf�hren
        %===============
        if( exist('s_fig','var') & strcmp(class(s_fig),'struct') )
            
            for j=1:length(s_fig)
                
                [okay,s_duh] = duh_plot_mit_config_file(s_duh,s_fig(j),selection);
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
        
