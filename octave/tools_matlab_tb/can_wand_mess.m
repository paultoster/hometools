function [pbot] = can_wand_mess(ctl)
% Liest eine ASCII-Messung von Canlyser ein und wandelt in eine Vektoren
% orientierte Struktur pbot. Schreibt die mess-struktur und die pbot-Struktur in ein
% gesonderes Unterverzeichnis als mat-File
% 
% Dabei wird das dbc-File eingelesen, wenn nicht als mat-File vorhanden,
% wird auch gewndelt
%
% Wenn die Messstruktur bereits in mat gespeichert, wird diese eingelesen
%
% ctl.dbc_file      char/cell   DBC-Filename
% ctl.mess_dir      char/cell   Es werden alle Pfade und Unterpfade
%                               durchscannt und asc-Messfiles in Mat format gewndelt
%                               a) die ASCII Messung direkt jede Botschaft nacheinander mit
%                               allen Signalen und Infos aus dem dbc-File in 
%                               asciifilename_mess.mat (Struktur mess siehe can_mess_read1.m)
%                               b) Daraus wird die struktur pbot generiert,
%                               dh. Die Signale werden pro Botschaft zu
%                               einem Vektor und dem dazugehörigen
%                               Zeitvektor gebildet (siehe
%                               can_mess_pbot_aufbereiten2.m) und in
%                               asciifilename_mess.mat gespeichert
%
% ctl.mess_file     char/cell   Es werden einzelen Files gewandelt
% ctl.dspace_format_flag double Die Messung wrd äquidistant gewandelt und
%                               in dSpace-Format gespeichert
% ctl.sort_flag                 eingelesene Botschaften nach Namen sortieren,
%                               ansonsten ist nach Hex-Identifier sortiert

% Voreinstellung
%==========================================================================
%==========================================================================

% dSpace-Format
if( ~isfield(ctl,'dspace_format_flag') )
    dspace_format_flag = 0;
else
    dspace_format_flag = ctl.dspace_format_flag;
end

% sort-Flag
if( ~isfield(ctl,'sort_flag') )
    sort_flag = 0;
else
    sort_flag = ctl.sort_flag;
end

% dbc-File
if( ~isfield(ctl,'dbc_file') )
    file = 'a';
    ctl.dbc_file = {};
    
    while( length(file) > 0 )
        [file,path]=uigetfile('*.dbc','Vector dbc-Datei auswählen');
        if file ~= 0
            ctl.dbc_file{length(ctl.dbc_file)+1} = [path, file];
        end
        
    end
    if( length(ctl.dbc_file) == 0 )
        pbot = 0;
        return
    end
end
if( ischar(ctl.dbc_file) )
    ctl.dbc_file = {ctl.dbc_file};
end
for id = 1:length(ctl.dbc_file)
    if( ~exist(ctl.dbc_file{id},'file') )
        warning('Angegebenes dbc_file: <%s> existiert nicht',ctl.dbc_file)
        return
    end
end

% mess_dir
if( isfield(ctl,'mess_dir') )
    
    if( ischar(ctl.mess_dir) )
        
        ctl.mess_dir = {ctl.mess_dir};
    end
    
    if( iscell(ctl.mess_dir) )
    
        for imd = 1:length(ctl.mess_dir)
        
            %  Files aus Pfad und Unterpfad sammeln
            file_liste = {};
            file_liste = can_wand_mess_suche_asc_files(ctl.mess_dir{imd},file_liste);
        
            for ifl = 1:length(file_liste)
            
                pbot(ifl) = can_mess_wand(ctl.dbc_file,file_liste{ifl},dspace_format_flag,sort_flag);
            end
        end
    end
end

% mess_file
if( isfield(ctl,'mess_file') )
    
    if( ischar(ctl.mess_file) )
        
        ctl.mess_file = {ctl.mess_file};
    end
    if( iscell(ctl.mess_file) )
        for imf = 1:length(ctl.mess_file)
                    
            pbot = can_mess_wand(ctl.dbc_file,ctl.mess_file{imf},dspace_format_flag);        
        end
    end
end



function    f_liste = can_wand_mess_suche_asc_files(c_path,f_liste)
%
% Sucht gewndelte Files *_pbot.mat
if( ~iscell(c_path) )
    c_path = {c_path};
end

for ipath = 1:length(c_path)
    
    path = c_path{ipath};
    
    if( ~exist(path,'dir') )
        error('can_wand_mess_suche_asc_files: Der Pfad %s existiert nicht',path);
    end
    
    %Pfad nach Files durchsuchen
    s_liste = suche_files_f(path,'asc');

    for is = 1:length(s_liste)
            
        f_liste{length(f_liste)+1} = s_liste(is).full_name;
        
    end
    
    cp = suche_dir(path);
    
    if( length(cp) > 0 )
        for i=1:length(cp)
           f_liste = can_vergleich_suche_pbot_files(cp{i},f_liste);
        end
    end
end

