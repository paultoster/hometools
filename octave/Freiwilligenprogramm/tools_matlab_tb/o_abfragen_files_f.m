function  [okay,c_filenames,s_prot,s_remote] = o_abfragen_files_f(s_frage,s_prot,s_remote);
%
% [okay,c_filenames,s_prot,s_remote] = o_abfragen_files_f(s_frage,s_prot,s_remote);
%
% Abfrage auf ein file für Eingabe und Ausgabe mit gui
%
% s_frage       Struktur mit Abfragewerten:
% s_frage.comment=string    Kommentar(string) für die Abfrage oder (s_ce.frage)
% s_frage.command=string    Text mit einem Kommmandowort für Protokoll und
%                           remote-Auswertung
% s_frage.prot=1/0          Soll protokolliert werden/nicht protokolliert
%                           werden
% s_frage.file_spec='*.xyz' File-Spezifikation oder auch '*.jpg;*.tiff'
% s_frage.start_dir=string  Verzeichnisangabe von wo die Abfrage im
%                           Explorer startet
% s_frage.file_number=Wert  Anzahl der Dateien, die ausgesucht werden, wenn
%                           nicht angegeben, werden beliebige Anzahl ausgewählt (bis cancel)
% s_frage.put_file=1/0      Soll Datei für Ausgabe gefunden werden / Datei
%                           zum Einlesen (default Datei zum einlesen)
% s_frage.put_file_name     Vorschlag für name
% s_frage.file_number       = 0 beliebig viele 
%                           = n n-Filese
%
% s_prot        Enthält Struktur für Protokollausgabe (siehe
%               o_protokoll_f.m)
%
% s_remote      Struktur mit den remote eingaben, wenn nicht vorhanden oder
%               keine Struktur dann ignorieren (siehe o_remote_f.m)
%
%
okay = 1;
c_filenames = {};
prot_flag = 1;
remote_flag = 1;
debug_fid = 0;
put_file    = 0;
start_dir = '.';
file_spec = '*.*';
file_ext  = '';
file_number = 0;
put_file = 0;
file_vorschlag = '';

set_old_dir = 0;

if( nargin == 0 )
    comment = 'Wähle Dateien aus';
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
        if( ~isfield(s_frage,'comment') && ~isfield(s_frage,'frage') )
            comment = 'Wähle Dateien aus';
        elseif( isfield(s_frage,'comment') )
            comment = s_frage.comment;
        else
            comment = s_frage.frage;
        end
        if( ~isfield(s_frage,'start_dir') )
            start_dir = '.';
        else
            start_dir = s_frage.start_dir;
        end
        if( ~isfield(s_frage,'file_spec') )
            file_spec = '*.*';
        else
            file_spec = s_frage.file_spec;
            i0=max(strfind(file_spec,'.'));
            if( length(i0) > 0 & i0 < length(file_spec) )
                file_ext = file_spec(i0+1:length(file_spec));
            end
        end
        if( ~isfield(s_frage,'file_number') )
            file_number = 0;
        else
            file_number = s_frage.file_number;
        end        
        if( ~isfield(s_frage,'put_file') )
            put_file = 0;
        else
            put_file = s_frage.put_file;
        end
        
        if( put_file && isfield(s_frage,'put_file_name') )
            file_vorschlag = s_frage.put_file_name;
        end
        
    else
         prot_flag = 0;
         comment   = 'Wähle Dateien aus';
    end
end

if( file_number <= 0 )
    comment = [comment,' (cancel:end)'];
else
    comment = sprintf('%s (%i files)',comment,file_number);
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
    end_flag = 0;
    icount   = 0;

    while( ~end_flag )
        [ok_flag,s_remote,line,remote_command,c_value,c_type] = o_remote_f(s_remote);
        if( ok_flag == 0 | (ok_flag == 2 & icount == 0 )  )
            remote_flag = 0;
            end_flag = 1;
        else
            if( (length(remote_command) == 0) )
                if( icount == 0 )
                    remote_flag = 0;
                end
                end_flag = 1;
                
            elseif( strcmp(c_type{1},'char') & strcmp(remote_command,command)  )
                icount = icount + 1;
                c_filenames{icount} = char(c_value{1});
            else
                [ok_flag,s_remote] = o_remote_f(s_remote,2);
                end_flag = 1;
            end
        end
    end
    
    if( icount == 0 )
        remote_flag = 0;
        a=sprintf('\no_files_abfragen_f:Der remote_command <%s> aus Zeile %i in Datei <%s> \n',remote_command,line,s_remote.file);
        o_ausgabe_f(a,debug_fid);
        a=sprintf('entspricht nicht dem gesuchten command <%s>:\n',command);
        o_ausgabe_f(a,debug_fid);
    end
end

if( ~remote_flag )
    end_flag = 0;
    icount   = 0;
    
    if( ~strcmp(start_dir,'.') && exist(start_dir,'dir') )
        old_dir     = pwd;
        set_old_dir = 1;
        dir_command = ['cd ''',start_dir,''''];
        eval(dir_command);
    end

    while( ~end_flag )
        if( put_file )
            [file,pathname]=uiputfile(file_spec,comment,file_vorschlag);
        else
            [file,pathname]=uigetfile(file_spec,comment);
        end
        
        if file==0
           end_flag = 1;
        else
           icount = icount+1;
           c_filenames{icount} = [pathname, file];   
           dir_command = ['cd ''',pathname,''''];
           eval(dir_command);
           
           if( (file_number > 0) & (icount >= file_number) )
               end_flag = 1;
           end
        end
            
    end
    
    if( ~strcmp(start_dir,'.') && set_old_dir )
        dir_command = ['cd ''',old_dir,''''];
        eval(dir_command);
    end
    if( icount == 0 )
        okay = 0;
    end
end

if( okay  & put_file)
    for i=1:icount
        
        if( length(strfind(char(c_filenames{i}),'.')) == 0 & length(file_ext) > 0)
            c_filenames{i} = [char(c_filenames{i}),'.',file_ext];
        end
    end
end

if( prot_flag & okay )
    for i=1:icount
        s_prot.command = command;
        s_prot.val     = char(c_filenames{i});
        s_prot = o_protokoll_f(3,s_prot);
    end
end


    