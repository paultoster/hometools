function [dbc,mess,cal,calf,pbot] = can_mess_main(dbc_file,mess_file,dbc,mess,cal,calf,pbot,filt,ctl)
% Liest dbc-File
% Liest Messung (nur asci-File aus Canalyser
% Schreibt Botschaft mit Signalen stepweise raus
% oder als Grafik oder in Word mit Grafik oder Excel ohne Grafik
% bearbeitung:
%
% Beschreibung switches
%
% ctl.dbc_switch        Struktur mit Inhalt des dbc-Files, d.h Beschreibung
%                       der Botschaften
% ctl.mess_switch       Aus Ascii-Messung wird diese Struktur erstellt
% ctl.cal_switch        Mit dbc-File ausgewertete Messung (aber immernoch
%                       tabellarisch)
% ctl.calf_switch       Nach Filterregel gefilterte cal-Struktur
% ctkl.pbot_switch      Struktur aus calf umgestellt auf Vektoren für
%                       Plotausgabe
% Switchwerte    = 1;   vorhandene Struktur dbc übernehmen
%                = 2;   Matlab-File für dbc-Struktur einladen (wenn schon erstellt)
%                = 3;   Struktur erstellen
%                = 4;   nichts machen, da nicht benötigt oder schon vorhanden (im Workspace)
%
% Filter
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
% Tabellenausgabe
% ctl.tab.flag      = 0;      % Soll Ausgabe Tabellenfile erstellt werden
% ctl.tab.tline     = 0;      % Orginalbotschaft anzeigen
% ctl.tab.botschaft = 1;      % Botschaft aufbereiten
% ctl.tab.signal    = 1;      % Signale aufbereiten
% Plotausgabe
% ctl.plt.flag     = 0;              % Soll Plotasugabe erstellt werden
% ctl.plt.display  = 0;              % Sollen alle Grafiken gezeigt werden
% ctl.plt.save_fig = 1;              % Sollen Grafiken gespeichert werden
% ctl.plt.typ      = 'botschaft';    % botschaft: Für jede Botschaft werd n-Plotfenster generiert
% ctl.plt.nsubplot = 8;              % Anzahl Subplot in einer Grafik
% ctl.plt.empfang_liste = {'Otto','Gateway_PQ35','Kombi_PQ35'}; % Nur diese Empfänger werden angezeigt
%
%xls-Ausgabe
% ctl.xls.flag          = 0;         % Excel schreiben mit xlswrite()
% ctl.xls.empfang_liste = {'Otto','Gateway_PQ35','Kombi_PQ35'}; % Nur diese Empfänger werden angezeigt
% ctl.xls.width         = 40;            % Anzahl Zeichen für Kommentar
%
% ctl.doc.flag         = 1;              % Ergebnis in Word speichern

% Voreinstellung
%==========================================================================
%==========================================================================
s = str_get_pfe_f(mess_file);
ctl.mess_file           = mess_file;
ctl.name                = s.name;
ctl.save_dir            = [s.dir,s.name,'\'];
s = str_get_pfe_f(dbc_file);
ctl.dbc_mat_file        = [s.dir,s.name,'.mat'];
ctl.mess_mat_file       = [ctl.save_dir,ctl.name,'_mess.mat'];
ctl.cal_mat_file        = [ctl.save_dir,ctl.name,'_cal.mat'];
ctl.calf_mat_file       = [ctl.save_dir,ctl.name,'_calf.mat'];
ctl.pbot_mat_file       = [ctl.save_dir,ctl.name,'_pbot.mat'];

ctl.tab_file            = [ctl.save_dir,ctl.name,'.tab'];
ctl.xls_file            = [ctl.save_dir,ctl.name,'.xls'];
ctl.doc_file            = [ctl.save_dir,ctl.name,'.doc'];

% Pfad zum Speichern erstellen
%=============================
if( ~exist(ctl.save_dir,'dir') )
    mkdir(ctl.save_dir);
end

% Einstellung
%==========================================================================
%==========================================================================

% dbc
%----
if( ~isfield(ctl,'dbc_switch') )
    error('dbc_switch nicht gesetzt');
end
% mess
%-----
if( ~isfield(ctl,'mess_switch') )
    error('dbc_switch nicht gesetzt');
end
% cal
%-----
if( ~isfield(ctl,'cal_switch') )
    error('dbc_switch nicht gesetzt');
end
% calf
%-----
if( ~isfield(ctl,'calf_switch') )
    error('dbc_switch nicht gesetzt');
end
% pbot
%-----
if( ~isfield(ctl,'pbot_switch') )
    error('dbc_switch nicht gesetzt');
end
% Daten bearbeiten
%==========================================================================
%==========================================================================

%dbc-Struktur
%============
if( ctl.dbc_switch == 2 ) % dbc einlesen
    tic
    fprintf('-> dbc-mat-einlesen\n');
    command = ['load ',ctl.dbc_mat_file];
    eval(command);
    fprintf('<- dbc-mat-einlesen\n');
    toc
elseif( ctl.dbc_switch == 3 ) % dbc erstellen
    tic
    fprintf('-> dbc-mat-erstellen\n');
    dbc = can_read_dbc(dbc_file);
    fprintf('<- dbc-mat-erstellen()\n');
    toc
    tic
    fprintf('-> dbc-mat-speichern\n');
    command=['save ',ctl.dbc_mat_file,' dbc'];
    eval(command);
    fprintf('<- dbc-mat-speichern()\n');
    toc
end

% mess-struktur
%=================
if( ctl.mess_switch == 2 ) % mess einlesen
    tic
    fprintf('-> mess-mat-einlesen\n');
    command = ['load ',ctl.mess_mat_file];
    eval(command);
    fprintf('<- mess-mat-einlesen\n');
    toc
elseif( ctl.mess_switch == 3 ) % mess erstellen
    tic
    fprintf('-> mess-struct-erstellen\n');
    mess = can_mess_read(mess_file);
    fprintf('<- mess-struct-erstellen\n');
    toc
    tic
    fprintf('-> mess-mat-speichern\n');
    command=['save ',ctl.mess_mat_file,' mess'];
    eval(command);
    fprintf('<- mess-mat-speichern\n');
    toc
end

% cal-struktur
%=================
if( ctl.cal_switch == 2 ) % cal einlesen
    tic
    fprintf('-> cal-mat-einlesen\n');
    command = ['load ',ctl.cal_mat_file];
    eval(command);
    fprintf('<- cal-mat-einlesen\n');
    toc
elseif( ctl.cal_switch == 3 ) % cal erstellen
    tic
    fprintf('-> cal-struct-erstellen\n');
    cal = can_mess_calc(mess,dbc);
    fprintf('<- cal-struct-erstellen\n');
    toc
    tic
    fprintf('-> cal-mat-speichern\n');
    command=['save ',ctl.cal_mat_file,' cal'];
    eval(command);
    fprintf('<- cal-mat-speichern\n');
    toc
end

% calf-struktur
%=================
if( ctl.calf_switch == 2 ) % calf einlesen
    tic
    fprintf('-> calf-mat-einlesen\n');
    command = ['load ',ctl.calf_mat_file];
    eval(command);
    fprintf('<- calf-mat-einlesen\n');
    toc
elseif( ctl.calf_switch == 3 ) % calf erstellen
    tic
    fprintf('-> calf-struct-erstellen\n');
    calf = can_mess_filt_bot(cal,dbc,filt);
    fprintf('<- calf-struct-erstellen()\n');
    toc
    tic
    fprintf('-> calf-mat-speichern\n');
    command=['save ',ctl.calf_mat_file,' calf'];
    eval(command);
    fprintf('<- calf-mat-speichern()\n');
    toc
end

% pbot-struktur
%=================
if( ctl.pbot_switch == 2 ) % pbot einlesen
    tic
    fprintf('-> pbot-mat-einlesen\n');
    command = ['load ',ctl.pbot_mat_file];
    eval(command);
    fprintf('<- pbot-mat-einlesen\n');
    toc
elseif( ctl.pbot_switch == 3 ) % pbot erstellen
    tic
    fprintf('-> pbot-struct-erstellen\n');
    pbot = can_mess_pbot_aufbereiten(calf,dbc);
    fprintf('<- pbot-struct-erstellen\n');
    toc
    tic
    fprintf('-> pbot-mat-speichern\n');
    command=['save ',ctl.pbot_mat_file,' pbot'];
    eval(command);
    fprintf('<- pbot-mat-speichern\n');
    toc
end

% Ausgabe
% =========================================================================
% =========================================================================

% Tabelle ausgeben
%=================
if( ctl.tab.flag )
    tic
    fprintf('-> tab-ausgabe\n');
    can_mess_tab_ausgabe(calf,ctl);
    fprintf('<- tab-ausgabe\n');
    toc
end

% Plot ausgeben
%==============
if( ctl.plt.flag )
    tic
    fprintf('-> plt-ausgabe(pbot,plt)\n');
    can_mess_plot_ausgabe(pbot,ctl);
    fprintf('<- plt-ausgabe()\n');
    toc
end

% Excel ausgeben
%===============
if( ctl.xls.flag )
    tic
    fprintf('-> xls-ausgabe\n');
    can_mess_xls_ausgabe(pbot,ctl);
    fprintf('<- xls-ausgabe\n');
    toc
end

% ausgewertete Messung in Word ausgeben
%======================================
if( ctl.doc.flag )
    tic
    if( ctl.doc.vergleich )
        fprintf('-> doc-vergleichs-ausgabe\n');
        can_mess_doc_ausgabe_vergleich(pbot,ctl);
        fprintf('<- doc-vergleichs-ausgabe\n');
    else
        fprintf('-> doc-ausgabe\n');
        can_mess_doc_ausgabe(pbot,ctl);
        fprintf('<- doc-ausgabe\n');
    end
    toc
end
