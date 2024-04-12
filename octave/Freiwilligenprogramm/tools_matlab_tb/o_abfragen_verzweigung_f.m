function  [end_flag,option,s_prot,s_remote] = o_abfragen_verzweigung_f(s_liste,s_prot,s_remote);
%
% [end_flag,option,s_prot,s_remote] = o_abfragen_verzweigung_f(s_liste,s_prot,s_remote);
%
% Abfrage einer Liste auf Matlabebene
%
% s_liste         enthält in einem struktur-array den optionswert,den
%                 command und die Beschreibung
% s_liste(i).val           wert für den jeweiligen command
% s_liste{i}.prot          soll protokolliert werden 1/0
% s_liste(i).command       Kommando für dsa Protokoll
% s_liste(i).description   Beschreibung
%
% s_remote      Struktur mit den remote eingaben, wenn nicht vorhanden oder
%               keine Struktur dann ignorieren
%
% Beispiel:
%
% s_verzweig = o_abfragen_verzweigung_liste_erstellen_f ...
%                  (0,'image'         ,'jpg-Image mit Höhenlinien einladen' ...
%                  ,0,'hscan'         ,'Höhenlinien aus Image scannen' ...
%                  );
%              
% while( ~end_flag )    
%     
%     [end_flag,option] = o_abfragen_verzweigung_f(s_verzweig);
% 
%     if( ~end_flag )
%         switch option
%             case 1
%                 s_cont = conth_load_image(s_cont);
%             case 2
%                 s_cont = conth_scan_hoehenlinie(s_cont);
%         end
%     end
% end

end_flag = 0;
prot_flag = 1;
remote_flag = 1;
debug_fid = 0;
if( nargin == 1 )
    
    prot_flag = 0;
    remote_flag = 0;
    
    
elseif( nargin == 2 )

    if( ~strcmp(class(s_prot),'struct') )
        prot_flag = 0;
    else
        debug_fid = s_prot.debug_fid;
    end
    rmote_flag = 0;
elseif( nargin == 3 )
    
    if( ~strcmp(class(s_prot),'struct') )
        prot_flag = 0;
    else
        debug_fid = s_prot.debug_fid;
    end
    if( ~strcmp(class(s_remote),'struct') )
        remote_flag = 0;
    elseif( ~s_remote.run_flag )
        remote_flag = 0;
    end
end

n = length(s_liste);
if( remote_flag )
    
    [okay_flag,s_remote,line,remote_command] = o_remote_f(s_remote);
    if( okay_flag == 0 | okay_flag == 2 )
        remote_flag = 0;
    elseif( strcmp(remote_command,'end') )
        
        option     = 0;
        end_flag   = 1;
        found_flag = 1;
    else
            
        found_flag = 0;
        for i=1:n
            if( strcmp(remote_command,s_liste(i).command) )
                option = s_liste(i).val;
                found_flag = 1;
                i_option = i;
                break;
            end
        end
        if( ~found_flag )
            a=sprintf('\no_liste_abfragen:Der remote_command <%s> aus Zeile %i in Datei <%s> \n',remote_command,line,s_remote.file);
            o_ausgabe_f(a,debug_fid);
            a=sprintf('ist in der Liste nicht enthalten:\n');
            o_ausgabe_f(a,debug_fid);
            for i=1:n
                a=sprintf(' %s\n',s_liste(i).command);
                o_ausgabe_f(a,debug_fid);                
            end
            remote_flag = 0;
        end
    end
end

if( ~remote_flag )
    while( 1 )
    
        o_ausgabe_f('\n--------------------------------------------------------\n',debug_fid);
        a = sprintf('%3s %s\n','e','Ende/Abbruch/Zurück');
        o_ausgabe_f(a,debug_fid);
        for i=1:n
            a = sprintf('%3i %s\n',s_liste(i).val,char(s_liste(i).description));
            o_ausgabe_f(a,debug_fid);
        end
        a = sprintf('\n--------------------------------------------------------\n\n');
        o_ausgabe_f(a,debug_fid);
    
        option = input('Auswahl ? : ','s');
        a = sprintf('Auswahl ? : %s',option);
        o_ausgabe_f(a,debug_fid,0);
        
        if( length(option) > 0 )
            if( option(1) == 'e' | option(1) == 'E' )
                end_flag = 1;
                break;
            else
                option = fix(str2num(option));
                found_flag = 0;
                for i=1:n
                    if( s_liste(i).val == option )
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
                    break;
                end
            end
        end
    end
end

if( prot_flag )
    if( end_flag )
        s_prot.command = 'end';
        s_prot = o_protokoll_f(2,s_prot);
    elseif( s_liste(i_option).prot )
        s_prot.command = s_liste(i_option).command;
        s_prot = o_protokoll_f(2,s_prot);
    end
end


    