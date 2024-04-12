function can_mess_doc_ausgabe(pbot,ctl)
% Ausgabe in xls
% pbot              struct   ausgewertete und gefilterte Messung
% pbot(i).name
%        .comment
%        .ident
%        .identhex
%        .sender
%        .time              double vector mit Zeit
%        .sig(j).name
%               .comment    char            Kommentar
%               .einheit
%               .nr
%               .mtyp       char    '
%               ':normale,'Z':Zaehler,'Mi':Multiplexsignal mit Zaehlernummer
%               .startbit
%               .bitlength
%               .empfang    cell
%               .vec        double   Signal
%               .s_val(i)         struct  Stuktur mit Wert und Bezeichnung
%              
%                s_val(k).val    double  Wert
%                        .comment  char   Bezeichnung
%
%
%


ncol1  = 14;
ncol2  = 1;
ncol3  = 77;
font_size = 8;

if( ~isfield(ctl.doc,'plot_ndiff') )
    ctl.doc.plot_ndiff = 5;
end

if( isfield(ctl.doc,'plot_marker') & ctl.doc.plot_marker  == 1 )
    
    marker_type = 'o';
else
    marker_type = 'none';
end


% Zaehler über alle Signale
nsig_glob = 0;

% Datei öffnen
%=============
[okay,s_a] = ausgabe_aw('init', ...
                        'name',ctl.doc_file{1}, ...
                        'ascii_ext','dat', ...
                        'ascii',0, ...
                        'word',1, ...
                        'ncol1',ncol1, ...
                        'ncol2',ncol2, ... 
                        'ncol3',ncol3, ...
                        'font_name','Courier New', ...
                        'font_size',8, ...
                        'visible',1);
if( ~okay )
    error('Worddatei konnte nicht egöffnet werden ')
end

% Überschrift
%============
com = sprintf('Auswertung Messung %s',ctl.mess_file{1});
[okay,s_a] = ausgabe_aw('head',s_a,'text',com);
[okay,s_a] = ausgabe_aw('newline',s_a);


for ipbot=1:length(pbot)
    
    % einzelne Botschat
    %=================
    b = pbot(ipbot);

    % Linie(=)
    %========
    [okay,s_a] = ausgabe_aw('line',s_a,'char','=');

    % Name
    %=====
    com = sprintf('Botschaft : %s',b.name);
    [okay,s_a] = ausgabe_aw('head',s_a,'text',com);
    % [okay,s_a] = ausgabe_aw('newline',s_a);
    
    % Identifier
    %===========
    [okay,s_a] = ausgabe_aw('string',s_a,'com','Identhex','tval',b.identhex,'pos_tval','left');
    [okay,s_a] = ausgabe_aw('string',s_a,'com','Ident','tval',num2str(b.ident),'pos_tval','left');

    % Kommentar
    %==========
    [okay,s_a] = ausgabe_aw('string',s_a,'com','Kommentar','tval',b.comment,'pos_tval','left');

    % Sender
    %=======
    [okay,s_a] = ausgabe_aw('string',s_a,'com','Sender','tval',b.sender,'pos_tval','left');
    % [okay,s_a] = ausgabe_aw('newline',s_a);
    
    % Wiederholrate
    %=============
    dt = mean(diff(b.time));
    com = sprintf('%g ms',dt*1000.0);
    [okay,s_a] = ausgabe_aw('string',s_a,'com','Wiederholrate','tval',com,'pos_tval','left');

    % Sendestart
    %=============
    com = sprintf('%g s',b.time(1));
    [okay,s_a] = ausgabe_aw('string',s_a,'com','Sendestart','tval',com,'pos_tval','left');
    
    % Sendeende
    %=============
    com = sprintf('%g s',b.time(length(b.time)));
    [okay,s_a] = ausgabe_aw('string',s_a,'com','Sendeende','tval',com,'pos_tval','left');

    for isig=1:length(b.sig)
    
        % Signal
        %=======
        s = b.sig(isig);
        
        % Linie
        %======
        [okay,s_a] = ausgabe_aw('line',s_a,'char','-');
        
        % Name
        %=====
        nsig_glob = nsig_glob + 1;
        com = sprintf('%s. (%s.)Signal : %s',num2str(nsig_glob),num2str(s.nr),s.name);
        [okay,s_a] = ausgabe_aw('head',s_a,'text',com,'char','-');
        
        % Kommentar
        %==========
        [okay,s_a] = ausgabe_aw('string',s_a,'com','Erklärung','tval',s.comment,'pos_tval','left');
        
        % Startbit
        %=========
        [okay,s_a] = ausgabe_aw('string',s_a,'com','Startbit','tval',num2str(s.startbit),'pos_tval','left');
        
        % Bitlength
        %==========
        [okay,s_a] = ausgabe_aw('string',s_a,'com','Bitlength','tval',num2str(s.bitlength),'pos_tval','left');

        % Multiplex
        %==========
        if( s.mtyp(1) == 'M' )
            type = sprintf('Mulitplexsignal Zaehler:%s',s.mtyp(min(2,length(s.mtyp)):length(s.mtyp)));
        elseif( s.mtyp(1) == 'Z' )
            type = 'Zaehlersignal Mulitplex';
        else
            type = 'normales Signal';
        end
        [okay,s_a] = ausgabe_aw('string',s_a,'com','Type','tval',type,'pos_tval','left');
        
        % Einheit
        %========
        if( length(s.einheit) > 0 )
            [okay,s_a] = ausgabe_aw('string',s_a,'com','Einheit','tval',s.einheit,'pos_tval','left');
        end
        
        % FAktor
        %=======
        if( s.faktor ~= 1.0 )
            [okay,s_a] = ausgabe_aw('string',s_a,'com','Faktor','tval',num2str(s.faktor),'pos_tval','left');
        end
        
        % Offset
        %=======
        if( s.offset ~= 0.0 )
            [okay,s_a] = ausgabe_aw('string',s_a,'com','Offset','tval',num2str(s.offset),'pos_tval','left');
        end
        
        % Empfaänger
        %===========
        if( length(s.empfang) > 0 )
            com = '';
            for i=1:length(s.empfang)
                if( i < length(s.empfang) )
                    com = [com,s.empfang{i},', '];
                else
                    com = [com,s.empfang{i}];
                end
            end
            [okay,s_a] = ausgabe_aw('string',s_a,'com','Empfänger','tval',com,'pos_tval','left');
        end
        
        % Wertezuweisung
        %===============
        if( length(s.s_val) > 0 )
            for i=1:length(s.s_val)
                com = sprintf('%10.2f : %s',s.s_val(i).val,s.s_val(i).comment);
                [okay,s_a] = ausgabe_aw('string',s_a,'com','Textwert','tval',com,'pos_tval','left');
            end
        end
        
        
        % Signal auswertung
        %==================
        [okay,s_a] = ausgabe_aw('newline',s_a);
        
        if( nsig_glob == 465 )
            t=1;
        end
        % 1. Checksumme erkennen  am Namen
        %---------------------------------
        if( ~isempty(strfind(lower(s.name),'checksum')) )
            
            [okay,s_a] = ausgabe_aw('string',s_a,'com','Signal','tval','Ckecksumm','newline',1,'pos_tval','left');

        % 2. Zaehlerwert
        %---------------
        elseif( s.mtyp == 'Z' )
            
            [okay,s_a] = ausgabe_aw('string',s_a,'com','Signal','tval','Zählerwert','newline',1,'pos_tval','left');

            valmin = min(s.vec);
            [okay,s_a] = ausgabe_aw('res',s_a,'com','min','unit','','val',valmin,'pos_val','left');
            valmax = max(s.vec);
            [okay,s_a] = ausgabe_aw('res',s_a,'com','max','unit','','val',valmax,'pos_val','left');
            
        else
            [s_w,okay] = can_mess_doc_ausgabe_zaehle_wechsel(b.time,s.vec,max(10,ctl.doc.plot_ndiff));
            
            % 3. n-verschiedene Werte
            %-------------------------
            if( length(s_w) <= max(1,ctl.doc.plot_ndiff) & okay )
                
                if( length(s_w) == 1 ) % Konstantwert
                    
                    [okay,s_a] = ausgabe_aw('string',s_a,'com','Konstantwert','tval',num2str(s_w(1).val),'pos_tval','left');
                    
                else % n-Werte
                    
                    for is_w = 1:length(s_w)
                        
                        com = sprintf('%i. Wert',is_w);
                        cval = sprintf('%15.5f s : %s [%s]',s_w(is_w).time,num2str(s_w(is_w).val),s.einheit);
                        [okay,s_a] = ausgabe_aw('string',s_a,'com',com,'tval',cval,'pos_tval','left');
                    end
                end
            % 4. 
            %--------------
            else

                if( okay )
                     for is_w = 1:length(s_w)
                        
                        com = sprintf('%i. Wert',is_w);
                        cval = sprintf('%15.5f s : %s [%s]',s_w(is_w).time,num2str(s_w(is_w).val),s.einheit);
                        [okay,s_a] = ausgabe_aw('string',s_a,'com',com,'tval',cval,'pos_tval','left');
                     end
                else
                    valmin = min(s.vec);
                    [okay,s_a] = ausgabe_aw('res',s_a,'com','min','unit','','val',valmin,'pos_val','left');
                    valmax = max(s.vec);
                    [okay,s_a] = ausgabe_aw('res',s_a,'com','max','unit','','val',valmax,'pos_val','left');
                    valmean = mean(s.vec);
                    [okay,s_a] = ausgabe_aw('res',s_a,'com','mean','unit','','val',valmean,'pos_val','left');
                end
                
                pid = p_figure(0,2,'');
                
                plot(b.time,s.vec,'LineWidth',3,'Color','k','Marker',marker_type)
                grid
                ylabel([str_change_f(s.name,'_',' ','a'),' [',str_change_f(s.einheit,'_',' ','a'),']'])
                
                %if( okay ) % Plotfenster größer aufspannen
                    
                    
                
                [okay,s_a] = ausgabe_aw('figure',s_a,'handle',pid);
                
                close(pid);
            end
        end
    end
        
end
        
        
% File sichern und schliessen
 [okay,s_a] = ausgabe_aw('save',s_a);
% [okay,s_a] = ausgabe_aw('close',s_a)


function [s_w,okay] = can_mess_doc_ausgabe_zaehle_wechsel(time,vec,nmax)

    okay = 1;
    is = 1;
    s_w(is).time = time(1);
    s_w(is).val  = vec(1);
    
    for i=1:length(vec)
        
        if( abs(vec(i)-s_w(is).val) > 1e-8 )
            
            is = is+1;
            if( is > nmax )
                okay = 0;
                return
            end
            s_w(is).time = time(i);
            s_w(is).val  = vec(i);
        end
    end