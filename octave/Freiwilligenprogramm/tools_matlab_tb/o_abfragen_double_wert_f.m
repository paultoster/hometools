function  [okay,value,s_prot,s_remote] = o_abfragen_wert_f(s_frage,s_prot,s_remote)
%
% [okay,value,s_prot,s_remote] = o_abfragen_wert_f(s_frage,s_prot,s_remote);
%
% Abfrage auf ein Verzeichnis mit gui
%
% s_frage.c_comment{i}      enthält Kommentar ohne Zeilenumbruch (Auswahlliste, etc.)
% s_frage.frage             Frage nach dem Wert
% s_frage.prot              Flag o protokolliert wird
% s_frage.command           Command für Protokoll
% s_frage.type              ='double' Wert eingeben (default)
%                           ='char'   String eingeben
% s_frage.min               Minimaler Wert (wenn nicht vorhanden infinit)
% s_frage.max               maximaler Wert (wenn nicht vorhanden infinit)
%
% s_prot        Enthält Struktur für Protokollausgabe
%
% s_remote      Struktur mit den remote eingaben, wenn nicht vorhanden oder
%               keine Struktur dann ignorieren
%Beispiel:
% clear s_frage
% s_frage.c_comment = {};
% s_frage.frage     = 'Bitte einen Wert eingeben';
% s_frage.prot      = 1;
% s_frage.command   = 'value_xy';
% s_frage.type      = 'double';
% s_frage.min       = 0;
% s_frage.max       = 10;
%
%
%
okay = 1;
c_comment = {};
frage     = '';
prot_flag = 1;
remote_flag = 1;
debug_fid = 0;
min_flag = 0;
max_flag = 0;
if( nargin == 0 )
    prot_flag = 0;
    remote_flag = 0;
    c_comment = {};
    frage = 'Wert eingeben';
else
    if( strcmp(class(s_frage),'struct') )
        if( ~isfield(s_frage,'prot') )
            prot_flag = 0;
        else
            prot_flag = s_frage.prot;
        end
        if( ~isfield(s_frage,'command') )
            prot_flag = 0;
            remote_flag = 0;
        else
            command = s_frage.command;
        end
        if( ~isfield(s_frage,'c_comment') )
            c_comment = {};
        else
            c_comment = s_frage.c_comment;
        end
        if( ~isfield(s_frage,'frage') )
            frage = 'Wert eingeben';
        else
            frage = s_frage.frage;
        end
        if( isfield(s_frage,'min') )
            min_val = s_frage.min;
            min_flag = 1;
        end
        if( isfield(s_frage,'max') )
            max_val = s_frage.max;
            max_flag = 1;
        end
        
    else
         prot_flag = 0;
         remote_flag = 0;
         c_comment = {};
         frage = 'Wert eingeben';
    end
end

if( nargin <= 1 )
    
    prot_flag = 0;
else
    if( ~strcmp(class(s_prot),'struct') )
        prot_flag = 0;
    else
        debug_fid = s_prot.debug_fid;
    end
end    
    
if( nargin <= 2 )
    
    remote_flag = 0;
else
    if( ~strcmp(class(s_remote),'struct') )
        remote_flag = 0;
    elseif( ~s_remote.run_flag )
        remote_flag = 0;
    end
end    


if( remote_flag )
    found_flag = 0;

    [ok_flag,s_remote,line,remote_command,c_value,c_type] = o_remote_f(s_remote);
    if( ~ok_flag  )
        remote_flag = 0;
        end_flag = 1;
    else
        if( strcmp(remote_command,command)  )
            
            if( strcmp(char(c_type),'double') )
                value = c_value{1};
                found_flag = 1;
            else
                a=sprintf('\no_abfragen_double_wert_f:Der wert <%s> zu command <%s> aus Zeile %i in Datei <%s> \n',char(c_value),remote_command,line,s_remote.file);
                o_ausgabe_f(a,debug_fid);
                a=printf('entspricht nicht dem gesuchten Typ <double>:\n');
                o_ausgabe_f(a,debug_fid);
            end                    
        end
    end
    
    if( found_flag == 0 )
        s_remote.run_flag = 0;
        remote_flag = 0;
        a=sprintf('\no_abfragen_double_wert_f:Der remote_command <%s> aus Zeile %i in Datei <%s> \n',remote_command,line,s_remote.file);
        o_ausgabe_f(a,debug_fid);
        a=sprintf('entspricht nicht dem gesuchten command <%s>:\n',command);
        o_ausgabe_f(a,debug_fid);
    end
end

if( ~remote_flag )
    while( 1 )
    
        a=sprintf('\n--------------------------------------------------------\n');
        o_ausgabe_f(a,debug_fid);
        for i=1:length(c_comment)
            a=sprintf('%s\n',c_comment{i});
            o_ausgabe_f(a,debug_fid);
        end
        a=sprintf('\n--------------------------------------------------------\n\n');
        o_ausgabe_f(a,debug_fid);
    
        dum = sprintf('%s : ',frage);
        value = input(dum,'s');
        a=sprintf('%s %s',dum,value);
        o_ausgabe_f(a,debug_fid,0);
        
        value = str2num(value);
        if( length(value) > 0 )
            value = value(1);
            break;
        end
    end
end

if( min_flag & value < min_val )
    value = min_val;
end
if( max_flag & value > max_val )
    value = max_val;
end

if( prot_flag & okay )
        s_prot.command = command;
        s_prot.val     = value;
        s_prot = o_protokoll_f(3,s_prot);
end


    