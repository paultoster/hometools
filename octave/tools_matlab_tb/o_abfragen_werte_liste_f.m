function  [end_flag,option_flag,option,s_liste,s_prot,s_remote] = o_abfragen_werte_liste_f(s_liste,s_prot,s_remote)
%
% [end_flag,option_flag,option,s_liste,s_prot,s_remote] = o_abfragen_werte_liste_f(s_liste,s_prot,s_remote)
%
% Abfrage einer werteListe auf Matlabebene
%
% s_liste         enthält in einem struktur-array den optionswert,den
%                 command und die Beschreibung
% s_liste(i).option        wert für den jeweiligen option
% s_liste{i}.tbd           Muß ausgewählt werden
% s_liste(i).command       Kommando
% s_liste(i).c_value       Werte in cell-array
% s_liste(i).description   Beschreibung
%
% s_remote      Struktur mit den remote eingaben, wenn nicht vorhanden oder
%               keine Struktur dann ignorieren
% Ausgabe
% option        gewählte option
% option_flag   wird 1 gesetzt, wenn eine option gewählt wurde
%               wird 0 gesetzt, wenn fertig
% end_flag      Abbruch oder Ende, wenn end_flag gesetzt
%
%
end_flag    = 0;
option_flag = 0;
option      = 0;
prot_flag = 1;
remote_flag = 1;
debug_fid = 0;
if( nargin == 1 )
    
    prot_flag = 0;
    remote_flag = 0;
    
    
end
if( nargin >= 2 )

    if( ~strcmp(class(s_prot),'struct') )
        prot_flag = 0;
    else
        debug_fid = s_prot.debug_fid;
    end
end
if( nargin >= 3 )
    
    if( ~strcmp(class(s_remote),'struct') )
        remote_flag = 0;
    elseif( ~s_remote.run_flag )
        remote_flag = 0;
    end
end

if( remote_flag )
    s_liste_old = s_liste;
    
    run_remote = 1;
    for i=1:length(s_liste)
        s_liste(i).c_value = {};
    end
    found_flag = zeros(length(s_liste),1);
    while(run_remote)
        [okay_flag,s_remote,line,remote_command,c_value,c_type] = o_remote_f(s_remote);
        if( (okay_flag == 0 | okay_flag == 2) & (max(found_flag) == 0) ) 
            remote_flag = 0;
            s_liste = s_liste_old;
        elseif( (okay_flag == 0) & (max(found_flag) ~= 0) )
        
            option     = 0;
            end_flag   = 1;
            run_remote = 0;
        else                    
            ff = 0;
            for i=1:length(s_liste)
                if( strcmp(remote_command,s_liste(i).command) )
                        
                    found_flag(i) = 1;
                    ff = 1;
                    len_list = length(s_liste(i).c_value); 
                    len_val  = length(c_value);
                    for j=len_list+1:len_list+len_val
                        s_liste(i).c_value{j} = c_value{j-len_list};
                    end
                    break;
                end
            end
            if( ~ff )
                [ok_flag,s_remote] = o_remote_f(s_remote,2);
                run_remote = 0;
            end
        end
    end
    for i=1:length(s_liste)
        if( found_flag(i) )
            s_liste(i).tbd = 0;
        else
            % default prüfen
            if( ~s_liste(i).tbd )
                s_liste(i).c_value = s_liste_old(i).c_value;
            else
                a=sprintf('\no_liste_abfragen:Der command <%s> kann in Datei <%s> nicht gefunden werden\n',s_liste(i).command,s_remote.file);
                o_ausgabe_f(a,debug_fid);
                remote_flag = 0;
            end
        end
    end
end

if( ~remote_flag )
    % Prüfen der Liste, ob Werte definiert werden müssen
    n = length(s_liste);
    for i=1:n
        if( s_liste(i).tbd )
            option_flag     = 1;
            option          = s_liste(i).option;
            return
        end
    end
    
    while( 1 )
    
        o_ausgabe_f('\n--------------------------------------------------------\n',debug_fid);
        a = sprintf('%3s %s\n','e','Ende/Abbruch/Zurück');
        o_ausgabe_f(a,debug_fid);
        a = sprintf('%3s %s\n','f','Fertig/Weitermachen');
        o_ausgabe_f(a,debug_fid);
        for i=1:n
            a = sprintf('%3i %s\n',s_liste(i).option,char(s_liste(i).description));
            o_ausgabe_f(a,debug_fid);
            if( length(s_liste(i).c_value) == 0 )
                a =sprintf('     %s = %s\n',s_liste(i).command,'{}');
                o_ausgabe_f(a,debug_fid);
            else
                for j=1:length(s_liste(i).c_value)
                    if( strcmp(class(s_liste(i).c_value{j}),'char') | strcmp(class(s_liste(i).c_value{j}),'cell') )
                        a =sprintf('     %s = %s\n',s_liste(i).command,char(s_liste(i).c_value{j}));
                    elseif( strcmp(class(s_liste(i).c_value{j}),'double') )
                        
                        if( length(s_liste(i).c_value{j}) > 1 )
                            a =sprintf('     %s = %s\n',s_liste(i).command,vec_get_str(s_liste(i).c_value{j}));
                        else
                            a =sprintf('     %s = %g\n',s_liste(i).command,s_liste(i).c_value{j});
                        end
                    end
                    o_ausgabe_f(a,debug_fid);
                end
            end
        end
        a = sprintf('\n--------------------------------------------------------\n\n');
        o_ausgabe_f(a,debug_fid);
    
        option = input('Auswahl ? : ','s');
        a = sprintf('Auswahl ? : %s',option);
        o_ausgabe_f(a,debug_fid,0);
        
        if( length(option) > 0 )

            if( option(1) == 'e' | option(1) == 'E' )
                end_flag    = 1;
                option_flag = 0;
                break;
            elseif( option(1) == 'f' | option(1) == 'F' )
                end_flag    = 0;
                option_flag = 0;
                break;
            else
                option = fix(str2num(option));
                found_flag = 0;
                for i=1:n
                    if( s_liste(i).option == option )
                        found_flag = 1;
                        i_option = i;
                        break;
                    end
                end
                if( ~found_flag )

                    a=sprintf('\no_liste_abfragen:Die option %s ist nicht in der Liste enthalten. \n',num2str(option));
                    o_ausgabe_f(a,debug_fid);
                    a=sprintf('Nochmal\n');
                    o_ausgabe_f(a,debug_fid);
                else
                    end_flag    = 0;
                    option_flag = 1;
                    break;
                end
            end
        end
    end
end

if( prot_flag & (end_flag | ~option_flag) )
    if( end_flag )
        s_prot.command = 'end';
        s_prot = o_protokoll_f(5,s_prot);
        s_prot = o_protokoll_f(2,s_prot);

    else
        for i=1:length(s_liste)
            s_prot.command = s_liste(i).command;
            s_prot.val = {};
            for j=1:length(s_liste(i).c_value)        
                s_prot.val{j} = s_liste(i).c_value{j};
            end
            s_prot = o_protokoll_f(3,s_prot);
        end
    end
end


    