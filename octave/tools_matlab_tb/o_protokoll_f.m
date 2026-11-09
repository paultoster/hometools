function s_prot = o_protokoll_f(option,s_prot)
%
% Protokollieren der Kommandos in der ablaufsteuerung
%
% option        0       Datei öfnnen
%              -1       Datei öffnen und anhängen
%               1       Datei schliessen
%               2       Listen-Kommando command speichern (s_prot.command wird mit einem Punkt
%                       in die gleiche Zeile gespeichert (Verzweigung))
%               3       Variablen-Kommando command speichern (Es wird
%                       s_prot.command mit einem Wertzuordnung s_prot.val
%                       gespeichert, mit Zeilenvorschub oder mit einer
%                       Liste von Wertzuordnungen, dabei ist s_prot.val ein
%                       array (cell oder double))
%               4       Zeilenvorschub mit Kommentar speichern
%               5       Zeilenvorschub speichern

if( option == -1 ) % bestehende Datei einlesen und speichern
    file = s_prot;
    clear s_prot
    if( nargin >= 2 & strcmp(class(file),'char') & exist(file,'file') ) 
        s_prot.file = file;
        s_prot.fid = fopen(s_prot.file,'r');
	
        text = fscanf(s_prot.fid,'%c');
	
        izeile = 0;
        tline = {};
        while 1
            izeile = izeile + 1;
            [tline{izeile},text] = strtok(text,char(10));
            if( length(text) == 0 )
                if( length(tline{izeile}) == 0 )
                    izeile = izeile - 1;
                end
                break
            end
        end
        if( izeile > 0 )
            tline{izeile} = str_cut_ae_f(tline{izeile},' ');
            if( strcmp(tline{izeile}(1:4),'.end') )
                izeile = izeile - 1;
            end
        end
        fclose(s_prot.fid);
	
        s_prot.fid = fopen(s_prot.file,'w');
        for i=1:izeile
            fprintf(s_prot.fid,'%s\n',tline{i});
        end
        clear tline
	
        s_prot.command    = '';
        s_prot.val        = 0;
        s_prot.debug_fid  = 0;
        
	else
        option = 0;
	end
end
    
    
    
if(  option == 0 ) % Datei öfnnen        
    file = s_prot;
    clear s_prot
    if( nargin >= 2 & strcmp(class(file),'char') )        
        s_prot.file = file;
        s_prot.fid  = 0;
    else
        if( s_prot.fid > 0 )
            fclose(s_prot.fid);
        end
        s_prot.fid = 0;
    end
    s_prot.command    = '';
    s_prot.val        = 0;
    s_prot.debug_fid  = 0;
        
elseif( option == 1 ) % Datei schliessen
    
    if( s_prot.fid > 0 )
        fclose(s_prot.fid);
    end
    s_prot.fid        = 0;
    s_prot.file       = '';
    s_prot.command    = '';
    s_prot.val        = 0;
    s_prot.debug_fid  = 0;
    return
end

% Erst mal Datei überprüfen
if( s_prot.fid == 0 )
    
    if( isfield(s_prot,'file') && isempty(s_prot.file) )
            s_prot.file = 'protokoll.dat';
    end
    s_prot.fid = fopen(s_prot.file,'w');
    
    if( s_prot.fid < 0 )
            dum = sprintf('Datei <%s> konnte nicht geöffnet werden',s_prot.file);
            error('o_protokoll:open file',dum);
    end
end

if( option == 2 ) % Listen-Kommando command speichern
    
    if( ~isfield(s_prot,'command' ) )
        error('o_protokoll:no_command','Feld <command> in s_prot nicht enthalten')
    end
    fprintf(s_prot.fid,'.%s',s_prot.command);
    s_prot.command = '';
elseif( option == 3 ) % Variablen-Kommando command speichern

    if( ~isfield(s_prot,'command' ) )
        error('o_protokoll:no_command','Feld <command> in s_prot nicht enthalten')
    end
    if( ~isfield(s_prot,'val' ) )
        error('o_protokoll:no_value','Feld <vav> in s_prot nicht enthalten')
    end

    
    if( strcmp(class(s_prot.val),'char') )
        fprintf(s_prot.fid,'\n%s = %s',s_prot.command,s_prot.val);
    elseif( strcmp(class(s_prot.val),'double') )
        fprintf(s_prot.fid,'\n%s = ',s_prot.command);
        
        [n,m] = size(s_prot.val);
        slen = 0;
        ncount = 0;
        for i=1:n
            for j=1:m
                ncount = ncount + 1;
                if(  slen > 80 )
                    fprintf(s_prot.fid,'... \n');
                    slen = 0;
                end

                if( n*m > 1 && ncount == 1 )
                    fprintf(s_prot.fid,'[');
                    slen = slen+1;
                end
                
                a=sprintf('%g',s_prot.val(i,j));
                slen = slen+length(a);
                fprintf(s_prot.fid,'%s',a);
                
                if( n*m > 1 && j < m )
                    fprintf(s_prot.fid,',');
                    slen = slen+1;
                end
            end
            if( n*m > 1 && i < n )
                fprintf(s_prot.fid,';');
                slen = slen+1;
            end
            if( n*m > 1 && i == n )
                fprintf(s_prot.fid,']');
                slen = slen+1;
            end

        end
        
%         len = length(s_prot.val);
%         slen = 0;
%         for i=1:len
%             if(  slen > 80 )
%                 fprintf(s_prot.fid,'... \n');
%                 slen = 0;
%             end
%             if( len > 1 & i == 1 )
%                 fprintf(s_prot.fid,'[');
%                 slen = slen+1;
%             end
%             a=sprintf('%g',s_prot.val(i));
%             slen = slen+length(a);
%             fprintf(s_prot.fid,'%s',a);
%             if( len > 1 & i < len )
%                 fprintf(s_prot.fid,',');
%                 slen = slen+1;
%             end
%             if( len > 1 & i == len )
%                 fprintf(s_prot.fid,']');
%                 slen = slen+1;
%             end
% 
%         end
    elseif( strcmp(class(s_prot.val),'cell') )
        fprintf(s_prot.fid,'\n%s = ',s_prot.command);
        len = length(s_prot.val);
        slen = 0;
        for i=1:len
            if(  slen > 80 )
                fprintf(s_prot.fid,' ...\n');
                slen = 0;
            end
            if( len > 1 & i == 1 )
                fprintf(s_prot.fid,'[');
                slen = slen+1;
            end
            if( strcmp(class(s_prot.val{i}),'double') && length(s_prot.val{i}) > 0 )
                a=sprintf('%g',s_prot.val{i}(1));
                slen = slen+length(a);
                fprintf(s_prot.fid,'%s',a);
            elseif( strcmp(class(s_prot.val{i}),'char') )
                fprintf(s_prot.fid,'%s',s_prot.val{i});
                slen = slen+length(s_prot.val{i});
            end
            if( len > 1 & i < len )
                fprintf(s_prot.fid,',');
                slen = slen+1;
            end
            if( len > 1 & i == len )
                fprintf(s_prot.fid,']');
                slen = slen+1;
            end
        end
        
    end
    s_prot.command = '';
    s_prot.val     = 0;
elseif( option == 4 ) % Zeilenvorschub am Ende einer Sequenz
    fprintf(s_prot.fid,'\n%%--------------------------------\n');
elseif( option == 5 ) % Zeilenvorschub
    fprintf(s_prot.fid,'\n');
end
    
    
    
