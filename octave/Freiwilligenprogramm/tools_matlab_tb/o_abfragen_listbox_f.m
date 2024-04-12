function  [okay,selection,s_prot,s_remote] = o_abfragen_listbox_f(s_frage,s_prot,s_remote)
%
% [okay,selection,s_prot,s_remote] = o_abfragen_listbox_f(s_frage,s_prot,s_remote);
%
% Abfrage auf ein Verzeichnis mit gui
%
% s_frage.c_liste{i}        enthält text für die Auswahlliste
% s_frage.c_name{i}         enthält die Namen für das Protokoll, Wenn nicht
%                           vorhanden, dann die selktierten Indices
% s_frage.frage             Frage
% s_frage.prot              (default:1)Flag ob protokolliert wird
% s_frage.prot_name         (default:0) Flag ob die Namen aus c_name
%                           gespeichert werden sollen (c_name muss vorhanden
%                           sein)
% s_frage.command           Command für Protokoll
% s_frage.single            Nur eine Auswahl zulässig
%                           auch ins Protokoll (wenn alle gewählt, dann wird <all> protokolliert )
% s_frage.fixedfont         0: matlabfont verwenden (default)
%                           1: Courier New verwenden
% s_frage.sort_list         0: Namen nicht sortieren (default)
%                           1: NAmen sortieren
%
% s_prot        Enthält Struktur für Protokollausgabe
%
% s_remote      Struktur mit den remote eingaben, wenn nicht vorhanden oder
%               keine Struktur dann ignorieren
%
%
okay = 1;
c_liste = {};
c_name  = {};
frage     = '';
prot_flag = 1;
prot_name = 0;
remote_flag = 1;
debug_fid = 0;
single = 0;
sort_list = 0;
fixedfont = 0;
selection = [];
if( strcmp(class(s_frage),'struct') )
    if( ~isfield(s_frage,'command') )
        prot_flag = 0;
        remote_flag = 0;
    else
        command = s_frage.command;
    end
    if( ~isfield(s_frage,'c_liste') )
        c_liste = {};
        okay = 0;
    else
        c_liste = s_frage.c_liste;
    end
    if( ~isfield(s_frage,'frage') )
        frage = 'Wert eingeben';
    else
        frage = s_frage.frage;
    end
    if( isfield(s_frage,'prot') )
        prot_flag = s_frage.prot;
    end
    if( isfield(s_frage,'prot_name') )
        prot_name = s_frage.prot_name;
    end
    if( isfield(s_frage,'c_name') )
        prot_name = 1;
        if( length(s_frage.c_name) < length(s_frage.c_liste) )
            prot_name = 0;        
        else
            c_name = s_frage.c_name;
        end
    else
        prot_name = 0;
    end
    if( ~isfield(s_frage,'single') )
        single = 0;
    else
        single = s_frage.single;
    end
    if( ~isfield(s_frage,'fixedfont') )
        fixedfont = 0;
    else
        fixedfont = s_frage.fixedfont;
    end
    if( ~isfield(s_frage,'sort_list') )
        sort_list = 0;
    else
        sort_list = s_frage.sort_list;
    end
    
else
     prot_flag = 0;
     remote_flag = 0;
     c_liste = {'keinen Wert vorgegeben'};
     frage = 'Wert eingeben';
     okay = 0;
end
    
if( length(c_liste) == 0 )
    printf('Es wurde keine Liste übergeben !!!!!!');
    okay = 0;
    return
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
    
    icount   = 0;
    command_found = 0;
    selection = [];
    [ok_flag,s_remote,line,remote_command,c_value,c_type] = o_remote_f(s_remote);
    if( ok_flag == 0 | ok_flag == 2  )
        remote_flag = 0;
    else
        if( strcmp(remote_command,command)  )
            command_found = 1;
            if( strcmp(c_type{1},'char') & strcmp(c_value{1},'all') )
                for i=1:length(c_liste)
                    icount = icount + 1;
                    selection(icount) = i;
                end
            else
                for i=1:length(c_value)
                    if( strcmp(c_type{i},'double') )
                        icount = icount+1;
                        selection(icount) = c_value{i};
                    elseif( prot_name & strcmp(c_type{i},'char') )
                        for j=1:length(c_liste)
                            if( strcmp(c_name{j},c_value{i}) )
                                icount = icount+1;
                                selection(icount) = j;
                            end
                        end
                    end
                end
            end
        end
    end
    
    if( icount == 0 )
        remote_flag = 0;
        okay        = 1;
        if( ~command_found )
            a=sprintf('\no_listbox_abfragen_f:Der remote_command <%s> aus Zeile %i in Datei <%s> \n',remote_command,line,s_remote.file);
            o_ausgabe_f(a,debug_fid);
            a=sprintf('entspricht nicht dem gesuchten command <%s>:\n',command);
            o_ausgabe_f(a,debug_fid);
        else
            for i=1:length(c_value)
                a=sprintf('\no_listbox_abfragen_f:Der value <%s> aus Zeile %i in Datei <%s> \n', ...
                          c_value{i},line,s_remote.file);
                o_ausgabe_f(a,debug_fid);
            end
            for j=1:length(c_name)
                a=sprintf('entspricht nicht den gesuchten values <%s>:\n',c_name{j});
                o_ausgabe_f(a,debug_fid);
            end
        end
    elseif( single & (icount > 0) )
        remote_flag = 1;
        okay        = 1;
        selection = selection(1);
    end

end

if( ~remote_flag )
    
    if( single )
        mode = 'single';
    else
        mode = 'multiple';
    end
    
    % Sortieren der Liste
    if( sort_list )
        c_liste_0 = c_liste;
        [c_liste,sort_index_list]=sort(c_liste_0);
    end
    for i=1:length(c_liste)
        c_liste{i} = sprintf('%3i.| %s',i,c_liste{i});
    end
    
    if(fixedfont)
        [selection,okay] = slistdlg('PromptString',frage...
                                   ,'ListString',c_liste ...
                                   ,'SelectionMode',mode...
                                   ,'ListSize',[500 400] ...
                                   );
    else
        [selection,okay] = listdlg('PromptString',frage...
                                  ,'ListString',c_liste ...
                                  ,'SelectionMode',mode...
                                  ,'ListSize',[500 400] ...
                                  );
    end        
    if( isempty(selection) )
        okay = 0;
        return
    else
        okay = 1;
    end
    % Zurücksortieren der Auswahl
    if( okay && sort_list )
        
        for ise=1:length(selection)
            
            selection(ise) = sort_index_list(selection(ise));
        end
    end    
end

if( prot_flag )
    if( ~okay )
        s_prot.command = 'end';
        s_prot = o_protokoll_f(2,s_prot);
    elseif( length(selection) == length(c_liste) & length(c_liste) > 2 )
        s_prot.command = command;
        s_prot.val = 'all';
        s_prot = o_protokoll_f(3,s_prot);
    elseif( prot_name )
        s_prot.command = command;
        s_prot.val = {};
        for i=1:length(selection)
            s_prot.val{i} = c_name{selection(i)};
        end
        s_prot = o_protokoll_f(3,s_prot);
    else
        
        s_prot.command = command;
        s_prot.val = {};
        for i=1:length(selection)
            s_prot.val{i} = selection(i);
        end
       s_prot = o_protokoll_f(3,s_prot);
   end
end


    