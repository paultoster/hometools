function [pbot] = can_mess_wand(dbc_file,mess_file,dspcae_format_flag,sort_flag)
% Liest eine ASCII-Messung von Canlyser ein und wandelt in eine Vektoren
% orientierte Struktur pbot. Schreibt die mess-struktur und die pbot-Struktur in ein
% gesonderes Unterverzeichnis als mat-File
% 
% Dabei wird das dbc-File eingelesen, wenn nicht als mat-File vorhanden,
% wird auch gewndelt
%
% Wenn die Messstruktur bereits in mat gespeichert, wird diese eingelesen
%
% dbc_file         char        Das DBC-File
% mess_file        char        Name des Messfiles
%
% dspace_format_flag    double wenn 1 wird zusätzlich pbot in das
%                       dSapce-Format gewandelt, um alle Daten aquvidistant zu haben
% sort_flag             eingelesene Botschaften nach Namen sortieren,
%                       ansonsten ist nach Hex-Identifier sortiert

% Voreinstellung
%==========================================================================
%==========================================================================
if( ~exist('dbc_file','var') )
    file = 'a';
    dbc_file = {};
    
    while( length(file) > 0 )
        [file,path]=uigetfile('*.dbc','Vector dbc-Datei auswählen');
        if file ~= 0
            dbc_file{length(dbc_file)+1} = [path, file];
        end
        
    end
end

if( ~exist('mess_file','var') )
    [file,path]=uigetfile('*.asc','Messdatei *.asc Datei auswählen');
    if file==0
        pbot = 0;
        return
    end
    mess_file=[path, file];
end

if( ~exist('dspcae_format_flag','var' ) )
    dspcae_format_flag = 0;
end

if( ~exist('sort_flag','var' ) )
    sort_flag = 0;
end

s_mess = str_get_pfe_f(mess_file);


ctl.mess_file           = mess_file;
ctl.name                = s_mess.name;
%ctl.save_dir            = [s_mess.dir,s_mess.name,'\'];
ctl.save_dir            = [s_mess.dir];

ctl.mess_mat_file        = [ctl.save_dir,ctl.name,'_mess.mat'];
ctl.pbot_mat_file        = [ctl.save_dir,ctl.name,'_pbot.mat'];
ctl.dbot_mat_file        = [ctl.save_dir,ctl.name,'_dbot.mat'];

% Pfad zum Speichern erstellen
%=============================
if( ~exist(ctl.save_dir,'dir') )
    mkdir(ctl.save_dir);
end

% Daten bearbeiten
%==========================================================================
%==========================================================================

%dbc-Struktur
%============
dbc = can_read_dbc(dbc_file,sort_flag);

% mess-struktur
%=================
flag = exist(ctl.pbot_mat_file,'file');
if( ~flag | (flag & ~dspcae_format_flag) )
if( exist(ctl.mess_mat_file,'file') )
    tic
    fprintf('-> mess-mat-einlesen<%s>\n',ctl.mess_mat_file);
    command = ['load ',ctl.mess_mat_file];
    eval(command);
    fprintf('<- mess-mat-einlesen\n');
    toc
else
    tic
    fprintf('-> mess-struct-erstellen<%s>\n',mess_file);
    mess = can_mess_read_asc(mess_file);
    fprintf('<- mess-struct-erstellen\n');
    toc
    tic
%     fprintf('-> mess-mat-speichern\n');
%     command=['save ',ctl.mess_mat_file,' mess'];
%     eval(command);
%     fprintf('<- mess-mat-speichern\n');
    toc
end
end

% pbot-struktur
%=================
if( exist(ctl.pbot_mat_file,'file') & dspcae_format_flag )
    tic
    fprintf('-> pbot-mat-einlesen<%s>\n',ctl.pbot_mat_file);
    command = ['load ',ctl.pbot_mat_file];
    eval(command);
    fprintf('<- pbot-mat-einlesen\n');
    toc
else
    tic
    fprintf('-> pbot-struct-erstellen<%s>\n',ctl.pbot_mat_file);
    pbot = can_mess_pbot_aufbereiten2(mess,dbc);
    fprintf('<- pbot-struct-erstellen\n');
    fprintf('-> pbot-mat-speichern\n');
    command=['save ',ctl.pbot_mat_file,' pbot'];
    eval(command);
    fprintf('<- pbot-mat-speichern\n');
    toc
end

% dSpace-Format
%==============
if( dspcae_format_flag )
    tic
    fprintf('-> dSpace-Datenstruktur dbot-struct-erstellen<%s>\n',ctl.dbot_mat_file);
    dbot = can_mess_dbot_aufbereiten(pbot);
    fprintf('<- dSpace-struct-erstellen\n');
    fprintf('-> dbot-mat-speichern\n');
    command=['save ',ctl.dbot_mat_file,' dbot'];
    eval(command);
    pbot = dbot;
    fprintf('<- dbot-mat-speichern\n');
    toc
end
