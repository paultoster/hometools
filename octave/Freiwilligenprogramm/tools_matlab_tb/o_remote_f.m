% $JustDate:: 15.11.05  $, $Revision:: 3 $ $Author:: Tftbe1    $
function [okay_flag,s_remote,zeile,command,c_values,c_types] = o_remote_f(s_remote,option)
%
% Protokollieren der Kommandos in der ablaufsteuerung
%
% Aufruf der Funktion:
% 1. Initilisierung:
%    [okay,s_remote] = o_remote_f(Dateiname);
%    [okay,s_remote] = o_remote_f(Dateiname,0);
%    Dateiname      Dateiname wird als string übergeben
%    s_remote       Struktur mit allen eingelesenen  Commands und Werten
% 2. Abruf eines commands:
%    [okay,s_remote,zeile,command,c_values,c_types] = o_remote_f(s_remote);
%    [okay,s_remote,zeile,command,c_values,c_types] = o_remote_f(s_remote,1);
%    okay           wenn 1 dann okay
%                   wenn 2 dann Ende der Liste erreicht
%    s_remote       Struktur aus Initialisierung
%    zeile          Aus welcher Zeile gelesen
%    command        Zugewiesener aktueller Commandwert
%    c_values       Zugewiesene Werte als cell-array
%    c_types        Welcher Typ von Wert 'no','double','char'
% 3. Einen command in der Liste zurücksetzen
%    [okay,s_remote] = o_remote_f(s_remote,2);
%    okay           wenn 1 dann okay
%    s_remote       Struktur aus Initialisierung
%
%
%
% Struktur s_remote
% s_remote.file             Name des Command files
% s_remote.command          alle Commands in einem cell-array
% s_remote.type             Typ des commands
%                           =1  command-wert ohne Zuweisung
%                           =2  command-wert mit Zuweisung
% s_remote.icom             aktueller Index Command

okay_flag = 1;
if( nargin == 1 )
    if( ischar(s_remote) )
        option = 0;
        dummy = s_remote;
        clear s_remote        
        s_remote.file = dummy;
    elseif( iscell(s_remote) )
        option = -1;
        c_text = s_remote;
        clear s_remote        
        s_remote.file = 'input cell-array';
    elseif( isstruct(s_remote) )
        option = 1;
    else
        fprintf('\n\n Aufruf s_remote = o_remote_f(filename) um ein remote-file zu laden\n');
        fprintf(' Aufruf [s_remote,command,c_values] = o_remote_f(s_remote) um Comand aus der Struktur zu bekommen\n');
    
        error('o_remote_f:wrong parameter','falscher Parameter übergeben');
    end
end

if( option > 2 )
    error('o_remote_f:wrong option','Option > 2');
end
    
if(  option == 0 | option == -1 ) % Datei öffnen oder cell-arrays einlesen        
    % Command initiallisieren
    s_remote.command = {};
    % Type initiallisieren
    s_remote.type    = [];
    % Command index nullen
    s_remote.icom    = 0;
    s_remote.zeile   = [];
    % run flag auf null setzen, muß vom aufrufenden Programm aktiv gesetzt
    % werden
    s_remote.run_flag = 0;
    
    fid  = 0;
    if( option == 0 )
        % wenn Remote-file im Verzeichnis vorhanden
        if( exist(s_remote.file,'file' ) )
	
            fid = fopen(s_remote.file,'r');
        
            if( fid < 0 )
                dum = sprintf('Datei <%s> konnte nicht geöffnet werden',s_remote.file);
                error('o_remote_f:open file',dum);
            end
        else
            dum = pwd;
            dum = sprintf('Datei <%s> konnte nicht im Verzeichnis <dum> gefunden werden',s_remote.file,dum);
            error('o_remote_f:exist file',dum);
        end
    else
        len_c_text = length(c_text);
    end    

    m = 0;
    izeile = 0;
    folge_flag = 0;
    % Lese Zeilenweise ein
    while 1
        izeile = izeile + 1;
        if( option == 0 )
            tline = fgetl(fid);
        else
            if( izeile <= len_c_text )
                tline = c_text{izeile};
            else
                tline = 0;
            end
        end
        
        if ~ischar(tline)
            s_remote.run_flag = 0;
            break
        end
        
        % Nehme alles bis zum Kommentarzeichen
        idum  = str_find_f(tline,'%','vs');
        if( idum == 1 )
            tline = '';
        elseif( idum > 1 )
            tline = tline(1:idum-1);
        end
        
        % Wenn nicht leer
        tline = str_cut_ae_f(tline,' ');
        if( length(tline) > 0 )
            
    
            % Folgezeile suchen
            idum = min(str_find_f(tline,'...','vs'));
            % command mit Folgezeile
            if( idum > 1 & ~folge_flag)
                    folge_flag = 1;
                    tline1 = [tline(1:idum-1)] ;
            % Folgezeile anhängen
            elseif( folge_flag )
                if( idum > 0 )
                    folge_flag = 1;
                    if( idum > 1 )
                        tline1 = [tline1,tline(1:idum-1)] ;
                    end
                else
                    folge_flag = 0;
                    tline1 = [tline1,tline] ;
                end
            else
                tline1 = tline;
            end
            
            if( ~folge_flag )
                tline = tline1;
                % Command-Strutur zerlegen
                if( tline(1) == '.' )
                    rest = tline;
                    while 1
                        [str,rest] = strtok(rest,'.');
                        if( (length(rest) == 0) & (length(str) == 0) )
                            break;
                        else
                            m = m+1;
                            s_remote.command{m} = str;
                            s_remote.type(m)    = 1;
                            s_remote.zeile(m)   = izeile;
                        end
                    end
                % Zuweisungsstruktur zerlegen
                elseif( strfind(tline,'=') )
                    
                    m = m+1;
                    s_remote.command{m} = tline;
                    s_remote.type(m)    = 2;
                    s_remote.zeile(m)   = izeile;
                % ansonsten
                else
                    
                    fprintf('Command <%s> aus file <%s> in Zeile %i konnte nicht zugeordnet werden\n', ...
                                  tline,s_remote.file,izeile);
                    error('o_remote_f:command not recog');
                end
            end
        end
    end
    if( fid > 0 )
        fclose(fid);
    end
    command = '';
    c_types = {};
elseif( option == 1 )

    s_remote.icom =  s_remote.icom + 1;
    if( s_remote.icom > length(s_remote.command) )
        zeile   = 0;
        command = '';
        c_values   = {};
        c_types    = {};
        okay_flag = 2;
        s_remote.run_flag = 0;

    % Command-struktur
    elseif( s_remote.type(s_remote.icom) == 1 )
        zeile   = s_remote.zeile(s_remote.icom);
        command = s_remote.command{s_remote.icom};
        c_values   = {};
        c_types{1} = 'no';
    elseif( s_remote.type(s_remote.icom) == 2 )
        
        zeile   = s_remote.zeile(s_remote.icom);
        dum     = s_remote.command{s_remote.icom};
        i       = str_find_f(dum,'=','vs');
        command = dum(1:i-1);
        command = str_cut_ae_f(command,' ');
        [c_values,c_types]  = o_remote_zerlegen_f( dum(i+1:length(dum)) );
    else
        okay_flag = 0;
         s_remote.run_flag = 0;
        zeile   = 0;
        command = '';
        c_values   = {};
        c_types    = {};
        
    end
% Befehl zurücksetzen d.h. einen Command zurück
elseif( option == 2 )
    if( s_remote.icom > 0 )
        s_remote.icom = s_remote.icom -1;
    end
end

function [c_values,c_types]  = o_remote_zerlegen_f(s_values);

le = length(s_values);
i = 0;
c_values = {};
c_types  = {};

vektor_flag = 0;
m = 0;
n = 0;

s_values = str_cut_ae_f(s_values,' ');
if( str_find_f(s_values,']''','vs') )
    trans_flag = 1;
else
    trans_flag = 0;
end
i0 = str_find_f(s_values,' ','vn');
i1 = str_find_f(s_values,'[','vs');
i2 = str_find_f(s_values,']','rs');
vec_found = 0;
if( i1 > 0 & i2 > 0 & i2 > i1 & i0 == i1 )
    s_values = s_values(i1+1:i2-1);
    vec_found = 1;
end

if( vec_found )
	rest1 = s_values;
	while 1
        [str1,rest1] = strtok(rest1,';');
        str1  = str_cut_ae_f(str1,' ');
        rest1 = str_cut_ae_f(rest1,' ');    
        if( (length(rest1) == 0) & (length(str1) == 0) )
            break;
        else
            n = n +1;
            rest = str1;
            while 1
                [str,rest] = strtok(rest,',');
                str  = str_cut_ae_f(str,' ');
                rest = str_cut_ae_f(rest,' ');    
                if( (length(rest) == 0) & (length(str) == 0))
                    break;
                else
                    m = m+1;
                    c_values{n,m} = str;
                    c_types{n,m}  = 'char';
                end
            end
        end
	end
else
  m = m+1;
  n = n+1;
  c_values{n,m} = s_values;
  c_types{n,m}  = 'char';
end

for i=1:n
    for j = 1:m
    
        if( ~strcmp(char(c_values{i,j}),'j') & length(str2num(char(c_values{i,j}))) > 0 )
        
            c_values{i,j} = str2num(char(c_values{i,j}));
            c_types{i,j}  = 'double';
        end
    end
end
        
if( trans_flag )
    c_values = c_values';
end