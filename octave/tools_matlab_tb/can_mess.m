function [okay,c_pbot] = can_mess(mess_file,c_pbot,mess,filt,ctl)
%
% Übernimmt oder liest pbot-Struktur ein (siehe can_mess_wand)
% filtert die Messung nach der Vorgabe und
% Gibt die Messgrößen
% als Plot, Word oder excel-Dokument aus
%
% save_dir          char        Enthält Verzeichnis in das die pbot-STrukur
%                               steht (wird bei Umwandlung der Messung
%                               erstellt)
% pbot              struct      gewandelte Struktur mit der zu behandelten Messung
%
% Filter
%=======
% filt.flag = 1         Filterung durchführen
%           = 0         keine Filterung
% 1. Filter Zeitdurchlass {untereSchranke0,obereSchranke0,untereSchranke1,obereSchranke1, ... } 
% filt.zeit_durchlass       = {0.0,10.0};
%
% 2. Filter Senderdurchlass {'Sender1','Sender2', ... } (Sendernamen kann
%                                                        ungenau
%                                                        geschrieben werden)
% filt.sender_durchlass     = {'Otto','Gateway_PQ35','Kombi_PQ35'};
%
% 3. Filter Botschaftsdurchlass {'Botschaftsname1','Botschaftsname2', ...}
%                          oder {'Identhex1','Identhex2',...} oder gemischt
%                          Botschaftsname kann ungenau geschrieben sein
%
% filt.bot_name_durchlass   = {'mMotor_1','mZAS_1'};
%
% 4. Filter Signalfilter (Botschaft muß im 1-3. Filter durchkommen)
%                        {{'Botschaftsname1','Signalname11',Signalname12',...}
%                        ,{'Botschaftsname2','Signalname21',Signalname22',...}}
%
% filt.bot_signal_durchlass = {{'mClima_1','CL1_Heizleist'}};
%
% 5. Filter Empfangsfilter (Botschaft muß im 1-4. Filter durchkommen)
%
% filt.empfang_durchlass = {'Otto'};
% Ausgabe
%========
%
% Plotausgabe
%
% ctl.plt.flag     = 0;              % Soll Plotasugabe erstellt werden
% ctl.plt.display  = 0;              % Sollen alle Grafiken gezeigt werden
% ctl.plt.save_fig = 1;              % Sollen Grafiken gespeichert werden
% ctl.plt.typ      = 'botschaft';    % 'botschaft': Für jede Botschaft werd n-Plotfenster generiert
                                     % 'vergleich': alle angegebenen
                                     % Botschafts-Strukltzuren pbot
% ctl.plt.nsubplot = 8;              % Anzahl Subplot in einer Grafik
%
%xls-Ausgabe
%
% ctl.xls.flag          = 0;         % Excel schreiben mit xlswrite()
% ctl.xls.width         = 40;            % Anzahl Zeichen für Kommentar
% ctl.plt.dina4    = 0;              % Format dina4 längs:1, quer:2, normal:0
%
% ctl.doc.flag          = 1;              % Ergebnis in Word speichern
% ctl.doc.vergleich     = 0;              % Vergleich mit zweiter Messung (pbot-Datei muß angegeben werden)
% ctl.doc.pbot1_file    = 'D:\projekte\hybrid\CAN_Messungen\Hybrid\GTI FSI\051104_2\CANWIN_Zuendungsstart_transponder_golf_plus11\CANWIN_Zuendungsstart_transponder_golf_plus11_pbot.mat'; 
%                                          % Matlab-Datei mit pbot-Struktur der zweiten Messung
% ctl.bot_dt.flag     = 1;               % Tabellenausgabe delta t auf die erste Botschaft identhex
% ctl.bot_dt.identhex = '10';            % 
% ctl.bot_dt.dt       = 0.1;
%
% ctl.pbot.flag     = 1;               % externe bearbeitung von pbot
okay = 1;
% Voreinstellung
%==========================================================================
%==========================================================================

if( ischar(mess_file) )
    ctl.mess_file            = {mess_file};
else
    ctl.mess_file            = mess_file;
end
 
nmess = length(ctl.mess_file);
for i=1:nmess
    mess_file = ctl.mess_file{i};
    
    if( ~exist(mess_file,'file') )
        tdum = sprintf('mess_file. <%s> existiert nicht (Ascii-File)',mess_file);
        sprintf(tdum);
    end

    s_file = str_get_pfe_f(mess_file);
    if( i == 1 )

        ctl.save_dir            = s_file.dir;
        ctl.name                = s_file.name;
        ctl.name                = str_cut_ae_f(ctl.name,'\');
    end
    ctl.mess_file{i}      = [s_file.dir,str_cut_ae_f(s_file.name,'\'),'.asc'];

    ctl.pbot_mat_file{i}  = fullfile(s_file.dir,[str_cut_ae_f(s_file.name,'\'),'_pbot.mat']);
    ctl.mess_mat_file{i}      = fullfile(s_file.dir,[str_cut_ae_f(s_file.name,'\'),'_mess.mat']);

    ctl.xls_file{i}            = [str_cut_ae_f(s_file.name,'\'),'.xls'];
    ctl.doc_file{i}            = [str_cut_ae_f(s_file.name,'\'),'.doc'];
end

if( ~isfield(ctl,'plt') )
    ctl.plt.flag = 0;
end
if( ~isfield(ctl,'xls') )
    ctl.xls.flag = 0;
end
if( ~isfield(ctl,'doc') )
    ctl.doc.flag = 0;
end
if( ~isfield(ctl,'bot_dt') )
    ctl.bot_dt.flag = 0;
end
if( ~isfield(ctl,'pbot') )
    ctl.pbot.flag = 0;
end
% Einstellung
%==========================================================================
%==========================================================================


% pbot-struktur
%=================
if( ctl.plt.flag | ctl.xls.flag | ctl.doc.flag | ctl.bot_dt.flag | ctl.pbot.flag )
    if( isstruct(c_pbot) ) % pbot einlesen
        c_pbot = {c_pbot};
    elseif( isnumeric(c_pbot) )
        c_pbot = {};
    end
    for i=1:nmess
        
        flag = 0;
        if( length(c_pbot) >= i )
            s_frage.comment   = ['Soll bestehende ',num2str(i),'.pbot-Struktur verwendet werden'];
            s_frage.default   = 1;
            s_frage.def_value = 'j';

            flag = o_abfragen_jn_f(s_frage);
        end
        if( ~flag )

            tic
            fprintf('-> pbot-mat-einlesen\n');
            command = ['load ',ctl.pbot_mat_file{i}];
            eval(command);
            fprintf('<- pbot-mat-einlesen\n');
            toc
            c_pbot{i} = pbot;
        end
        % Filter
        %=================
        if( filt.flag )
            tic
            fprintf('-> can_mess_filt_pbot()\n');
            c_pbot{i} = can_mess_filt_pbot(c_pbot{i},filt);
            fprintf('<- can_mess_filt_pbot()\n');
            toc
        end
    end
end

if( ctl.bot_dt.flag )
    flag = 0;
    if( isstruct(mess) ) % mess einlesen

        s_frage.comment   = 'Soll bestehende mess-Struktur verwendet werden';
        s_frage.default   = 1;
        s_frage.def_value = 'j';

        flag = o_abfragen_jn_f(s_frage);
    end
    if( ~flag )

        tic
        fprintf('-> mess-mat-einlesen\n');
        command = ['load ',ctl.mess_mat_file];
        eval(command);
        fprintf('<- mess-mat-einlesen\n');
        toc
    end
end    
% Ausgabe
% =========================================================================
% =========================================================================

% Plot ausgeben
%==============
if( ctl.plt.flag )
    tic
    fprintf('-> plt-ausgabe(pbot,plt)\n');
    can_mess_plot_ausgabe(c_pbot,ctl);
    fprintf('<- plt-ausgabe()\n');
    toc
end

% Excel ausgeben
%===============
if( ctl.xls.flag )
    tic
    fprintf('-> xls-ausgabe\n');
    can_mess_xls_ausgabe(c_pbot{1},ctl);
    fprintf('<- xls-ausgabe\n');
    toc
end

% ausgewertete Messung in Word ausgeben
%======================================
if( ctl.doc.flag )
    tic
    if( ctl.doc.vergleich )
        fprintf('-> doc-vergleichs-ausgabe\n');
        can_mess_doc_ausgabe_vergleich(c_pbot{1},ctl);
        fprintf('<- doc-vergleichs-ausgabe\n');
    else
        fprintf('-> doc-ausgabe\n');
        can_mess_doc_ausgabe(c_pbot{1},ctl);
        fprintf('<- doc-ausgabe\n');
    end
    toc
end

% Tabellenausgabe delta t auf die erste Botschaft identhex
%=========================================================
if( ctl.bot_dt.flag )
    tic
    fprintf('-> bot_dt-ausgabe\n');
    can_mess_bot_dt_ausgabe(mess,pbot,ctl);
    fprintf('<- bot_dt-ausgabe\n');
    toc
end

