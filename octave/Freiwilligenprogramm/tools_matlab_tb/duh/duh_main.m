% $JustDate:: 31.03.05  $, $Revision:: 1 $ $Author:: Admin     $
% $JustDate:: 31 $, $Revision:: 1 $ $Author:: Admin     $
% duh_main: Daten im Format d (data), u (unit) h (header) einlesen, bearbeiten und ausgeben
%
% duh               Datenstruktur:
% s_duh.start_dir                               Startverzeichnis 
% s_duh.post_command_run                        Flag ob nachträglich
%                                               commands abgearbeitet werden soll (Problem mit global)
% s_duh.c_post_command                          cell-array mit
%                                               post-commands (wird mit eval ausgeführt)
% s_duh.resolved_data                           Aufgelöster Datensatz
%
% Struktur s_duh:
% Einstell:
% s_duh.s_einstell.main_work_dir                Hauptarbeitsverzeichnis
% s_duh.s_einstell.c_datalyser_prc_file{i}      Liste mit prc-Files zum
%                                               Einlesen von Datalyserdaten
% s_duh.s_einstell.c_pos_signal_list{i}         Liste mit Signalnamen zum
%                                               positivem filtern
% s_duh.s_einstell.c_neg_signal_list{i}         Liste mit Signalnamen zum
%                                               negativem filtern
% s_duh.s_einstell.debug_info_in_prot           Debuginfo in Protokollfile
%                                               schreiben
% s_duh.s_einstell.peak_filt_std_fac             Faktor zur Bestimmung von
%                                               peaks in Messung, gibt an bei
%                                               wievielmal die differenz ausserhalb der
%                                               Standradabweichung liegen
%                                               soll, damit ein peak
%                                               erkanntwird
% s_duh.s_einstell.c_my_func_file{i}            Files für die Auswertung
%                                               eines Datensatzes mit
%                                               fester Struktur: z.B
%                                               c_my_func_file{1} =
%                                               'C:\projekt\my_calc.m';
%                                               Aufruf in Matlab: 
%                                               [d,u,h] = my_calc(d,u,h);
% s_duh.s_einstell.res_file_name{i}             Files für die Ergebnisse aus Analyse
%                                               eines Datensatzes mit
%                                               Aufruf in Matlab: 
%                                               [d,u,h] = my_calc(d,u,h);
% Remote:
% s_duh.remote_flag                             Flag ob mit remote
%                                               gestartet ist
%                                               % s_duh.s_remote.file                           Name des Command files (*.rem) aus *.prot
%                                               abzuleiten
% s_duh.s_remote.command                        alle Commands in einem cell-array
% s_duh.s_remote.type                           Typ des commands
%                                               =1  command-wert ohne Zuweisung
%                                               =2  command-wert mit Zuweisung
% s_duh.s_remote.icom                           aktueller Index Command
%
% s_duh.n_plot                                  Anzahl der Plot-Diagramme
% s_duh.s_fig(i),i=1:s_duh.n_plot               Struktur mit Plotinhalt
%
% DAtenbereich
% s_duh.n_data                  Anzahl DAtensatz
% s_duh.s_data(i)                 iter Datensatz
% s_duh.s_data(i).file            Datenfilename
% s_duh.s_data(i).name            Name für Datensatz aus Datenfilename
%                                 extrahiert
% s_duh.s_data(i).c_prc_files     Protokoll-Files
% s_duh.s_data(i).d               Datenstruktur mit Vektoren (möglichst als
%                               erstes Zeit-Vektor) ähnlich dem
%                               diaread-Format
% s_duh.s_data(i).u               Unitstruktur zur Datenstruktur entsprechend
% s_duh.s_data(i).h             Cell-Array mit Kommentaren (z.B. Header)
%
% Extra control:                mögliche Steuerung von duh_main von aussen:
% 
% s_duh_ectrl.new         = 1               neue s_duh-Struktur auf jeden Fall anlegen
% s_duh_ectrl.old         = 1               alte s_duh-Struktur nutzen 
% s_duh_ectrl.pick_duh    = 1               Nimmt duh-Struktur auf, wenn vorhanden
% s_duh_ectrl.remote      = 'filename.m'    remote-File das sofort
%                                           abgearbeitet wird oder
% s_duh_ectrl.remote{i}   = 'Befehl'        Befehle in einem cell-array das
%                                           abgearbeitet wird. Die Befehle
%                                           entsprechen den Zeilenbefehlen
%                                           aus dem Protokoll


% Abfrage der extra control struktur:
if( exist('s_duh_ectrl','var') )
    
    if( ~isfield(s_duh_ectrl,'new') )
        s_duh_ectrl.new = 0;
    end
    if( ~isfield(s_duh_ectrl,'old') )
        s_duh_ectrl.old = 0;
    end
    if( ~isfield(s_duh_ectrl,'pick_duh') )
        s_duh_ectrl.pick_duh = 0;
    end
    if( ~isfield(s_duh_ectrl,'remote') )
        s_duh_ectrl.remote = '';
    end
else
    s_duh_ectrl.new = 0;
    s_duh_ectrl.old = 0;
    s_duh_ectrl.pick_duh = 0;
    s_duh_ectrl.remote = '';
end

% extra control: Neue Struktur anlegen
if( s_duh_ectrl.new )
    clear s_duh
end

if( exist('s_duh','var') & ~s_duh_ectrl.old )
    s_frage.comment  = 'Soll die bereits angelegte Struktur gelöscht werden';
    s_frage.prot     = 0;
    s_frage.default = 1;
    s_frage.def_value  = 1;
%    duh_flag = o_abfragen_jn_f(s_frage);
    if( o_abfragen_jn_f(s_frage) )
        clear s_duh
    end
    clear s_frage
end
    
% neue Struktur s_duh anlegen
if( ~exist('s_duh','var') ) 

    % Verzeichnis in dem duh gestartet wird
    s_duh.start_dir = pwd;
        
    % Postcommand run Asuführen eines Commands auf der Oberfläche
    s_duh.post_command_run = 0;
    s_duh.c_post_command   = {};
    
    % Aufgelöste Datenstruktur
    s_duh.resolved_data_names = {};
    
    % Einstellungen laden, wenn vorhanden
    s_duh = duh_einstellung_f(s_duh,0);
    
    % remote-Einstellung
    s_duh.s_remote.run_flag = 0;
    % Protokoll
    s_duh.s_prot = o_protokoll_f(0,'duh.prot');
    % soll Ausgabe ins Protokoll
    if( s_duh.s_einstell.debug_info_in_prot )
        s_duh.s_prot.debug_fid = s_duh.s_prot.fid;
    else
        s_duh.s_prot.debug_fid = 0;
    end
    
    % Output
    s_duh.s_output.file = s_duh.s_einstell.res_file;
    s_duh.s_output.fid  = 0;
    
    % Plotten
    s_duh.n_plot     = 0;
    s_duh.s_fig      = 0;
    
    % Daten
    s_duh.n_data = 0;
%     s_duh.s_data(1).d.a         = 0;
%     s_duh.s_data(1).u.a         = '';
    s_duh.s_data(1).d           = [];
    s_duh.s_data(1).u           = [];
    s_duh.s_data(1).h           = {};
    s_duh.s_data(1).file        = '';
    s_duh.s_data(1).name        = '';
    s_duh.s_data(1).c_prc_files = {};
    
    %workspace variablen
    s_duh.workspace_structs = {};
    s_duh.workspace_vec = {};

else
    % Protokoll
    s_duh.s_prot = o_protokoll_f(-1,'duh.prot');
    % Verzeichnis in dem duh gestartet wird
    s_duh.start_dir = pwd;

end

% extra control: duh-Struktur aufnehmen, wenn [d,u,h] vorhanden
if( s_duh_ectrl.pick_duh )
    
    if( exist('d','var') && isstruct(d) )        
        if( exist('u','var') && isstruct(u) )
            if( exist('h','var') && iscell(h) )
                [okay,s_data] = duh_pick_duh_f(d,u,h);
            else
                [okay,s_data] = duh_pick_duh_f(d,u,'pickup');
            end
        else
            [okay,s_data] = duh_pick_duh_f(d,0,'pickup');
        end
        
        if( okay )
            s_duh.n_data                 = s_duh.n_data+1;
            
            s_duh.s_data(s_duh.n_data).d = s_data.d;
            s_duh.s_data(s_duh.n_data).u = s_data.u;
            s_duh.s_data(s_duh.n_data).h = s_data.h;
            s_duh.s_data(s_duh.n_data).file        = 'no_file';
            if( exist('name','var') && ischar(name) )
                s_duh.s_data(s_duh.n_data).name        = name;
            else
                s_duh.s_data(s_duh.n_data).name        = 'intern';
            end
        end
    end
end

% extra control: angegebenes Remote-File abarbeiten
if( ~isempty(s_duh_ectrl.remote) )
    
    if( ischar(s_duh_ectrl.remote) && ~exist(s_duh_ectrl.remote,'file') ) %Fileangabe
        fprintf('\n\n File <%s> existiert nicht ',s_duh_ectrl.remote);
    else
        [okay_flag,s_duh.s_remote] = o_remote_f(s_duh_ectrl.remote);
        if( ~okay_flag )
            error('Remote file <%s> konnte nicht gestartet werden',s_duh_ectrl.remote);
        else
            s_duh.s_remote.run_flag = 1;
        end
    end
end

% clear extra control
clear s_duh_ectrl

duh_end_flag = 0;
while( ~duh_end_flag )
    
    if( s_duh.s_prot.fid > 0 )
        s_duh.s_prot = o_protokoll_f(4,s_duh.s_prot);
    end
    
    s_duh.command = '';
    % Parameterreihenfolge: Nummer,Protokollierungs_flag,command für Protokoll,Kommentar
	s_duh_verzweig = o_abfragen_verzweigung_liste_erstellen_f ...
                 (0,'start_remote'         ,'remote-Datei starten (kopiertes prot-File)' ...
                 ,1,'modify_preference'    ,'Einstellung/Konfiguration ändern' ...
                 ,1,'data_read'            ,'Daten lesen' ...
                 ,1,'data_organize'        ,'Daten organisieren/anzeigen' ...
                 ,1,'data_calc_dataset'    ,'Daten bearbeiten (gesamter Datensatz/Kanäle)' ...
                 ,1,'data_calc_charac'     ,'Daten auswerten (Kennzahlen/Vergleich)' ...
                 ,1,'data_write'           ,'Daten speichern' ...
                 ,1,'data_plot'            ,'Daten plotten' ...
                 ,1,'data_transform'       ,'Daten wandeln/analysieren' ...
                 );
    
    [duh_end_flag,duh_option,s_duh.s_prot,s_duh.s_remote] = o_abfragen_verzweigung_f(s_duh_verzweig,s_duh.s_prot,s_duh.s_remote);
    clear s_duh_verzweig
    if( ~duh_end_flag )
        switch duh_option
            case 0 % Ende
                duh_end_flag = 1;
                
            case 1 % Remote-Datei starten
                [s_duh] = duh_remote_starten_f(s_duh);
                
            case 2 % Einstellung
                s_duh = duh_einstellung_f(s_duh,1);
                
            case 3 % Daten einlesen
                
                % Workspace auf passende Strukturen, Vektoren abscannen
                who_struct = whos();
                
                % Variable leeren
                s_duh.workspace_structs = {};
                s_duh.workspace_vec = {};
                
                for i=1:length(who_struct)
                    
                    dim = who_struct(i).size(1)*who_struct(i).size(2);
                    
                    if( strcmp(who_struct(i).class,'struct') && dim > 0 )

                        found_struct = 0;
                        command= sprintf('cnames = fieldnames(%s);',who_struct(i).name);
                        try
                            eval(command);
                        catch ME
                            ME.stack
                        end
                        for j=1:length(cnames)
                            command= sprintf('flag = isnumeric(%s(1).%s);',who_struct(i).name,cnames{j});
                            try
                                eval(command);
                            catch ME
                                ME.stack
                            end
                            
                            if( flag )
                                found_struct = 1;
                                break;
                            end
                        end
                        if( found_struct )
                            s_duh.workspace_structs{length(s_duh.workspace_structs)+1}=who_struct(i).name;
                        end
                    elseif( strcmp(who_struct(i).class,'double') && dim > 0 )
                        command= sprintf('[nrow234,ncol234] = size(%s);',who_struct(i).name);
                        eval(command);
                        if( (nrow234 == 1 && ncol234 > 1) || (ncol234 == 1 && nrow234 > 1))
                            s_duh.workspace_vec{length(s_duh.workspace_vec)+1}=who_struct(i).name;
                        end                            
                        
                    end
                end
                clear who_struct found_struct nrow234 ncol234
                s_duh = duh_daten_einlesen_f(s_duh);
            case 4 % Daten organisiieren
                s_duh = duh_daten_organisieren_f(s_duh);
            case 5 % Daten bearbeiten
                s_duh = duh_daten_bearbeiten_f(s_duh);
            case 6 % Daten bearbeiten
                s_duh = duh_daten_bearbeiten_kennzahlen_f(s_duh);
            case 7 % Daten speichern
                s_duh = duh_daten_speichern_f(s_duh);
            case 8 % Daten plotten
                s_duh = duh_daten_plotten_f(s_duh);
            case 9 % Daten wandeln
                s_duh = duh_daten_wandeln_f(s_duh);
                
        end
        % Post command Run
        if( s_duh.post_command_run )
            for i_duh_main=1:length(s_duh.c_post_command)            
	            fprintf('%s\n',char(s_duh.c_post_command{i_duh_main}));
                eval(char(s_duh.c_post_command{i_duh_main}));
            end
            s_duh.post_command_run = 0;
            s_duh.c_post_command = {};
        end
    end
        
end

% Zurücksetzen auf start-Verzeichnis
duh_command = ['cd ''',s_duh.start_dir,''''];
eval(duh_command);

% Einstellungen speichern
duh_einstellung_f(s_duh,2);

% Protokoll beenden
s_duh.s_prot = o_protokoll_f(1,s_duh.s_prot);

clear duh_liste duh_option duh_end_flag duh_command iduh_main
    
fprintf('\nEnde --- duh_main ---\n');
    