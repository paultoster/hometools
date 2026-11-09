function okay = html_func(func,fid,p1,p2,p3,p4,p5)
%
% fid  = html_func('open',FileName);            Öffnen der Datei FielName
% okay = html_func('close',fid);                                        Schliesen der Datei 
% okay = html_func('start',fid,Title);                                  Beginn der html-Ausgabe
% okay = html_func('end',fid);                                          Beendet der html-Ausgabe
% okay = html_func('start_tab',fid,Title);                              Beginn der Tabellenausgabe
% okay = html_func('end_tab',fid);                                      Beendet der Tabellenausgabe
% okay = html_func('start_colgroup',fid);                               Beginn der Spaltengruppeformatierung
% okay = html_func('end_colgroup',fid);                                 Beendetder Spaltengruppeformatierung
% okay = html_func('set_col_align',fid,Align);                          Ausrichtung der Spalte Align='right','center' oder 'left'
% okay = html_func('start_tabrow',fid);                                 Beginn der Beschreibung einer Zeile
% okay = html_func('end_tabrow',fid);                                   Beendet die Beschreibung einer Zeile
% okay = html_func('tab_row',fid,inhalt,header_flag,bold_flag,farbe);   Beschreibung einer Zelle
%                                                                       head_flag = 1/0     Soll Header sein
%                                                                       bold_flag = 1/0     Soll Fett sein
%                                                                       farbe = 'black','red','blue','green','yellow', ...


%
%
    okay = 1;
    switch( lower(func) )
        case 'open'
            okay = fopen(fid,'w');
            if( okay == -1 )
                d=sprintf('\nhtml_func.m error: File = %s could not be openend',fid);
                error(d)
            end
        case 'close'
            fclose(fid)
        case 'start'
            title = p1;
            fprintf(fid,'\n<html>\n<head>\n<title>');
            fprintf(fid,'%s',title);
            fprintf(fid,'</title>\n</head>');
        case 'end'
            fprintf(fid,'\n</html>\n');
        case 'start_tab'
            title = p1;
            fprintf(fid,'\n\n<body>')
            if( length(title) > 0 )
                fprintf(fid,'\n<h1><font size=\"3\">%s</font></h1>',title);
                fprintf(fid,'\n\n<table border=0 cellspacing=0 cellpadding=0 style=''border-collapse:collapse;border:none;''>');
            end
        case 'end_tab'
            fprintf(fid,'\n\n</table>\n</body>');            
        case 'start_colgroup'
            fprintf(fid,'\n<colgroup>');            
        case 'end_colgroup'
            fprintf(fid,'\n</colgroup>');            
        case 'set_col_align'
            ausr = p1;
            if( ausr(1) == 'c' | ausr(1) == 'C' )
                name = 'center';
            elseif( ausr(1) == 'r' | ausr(1) == 'R' )
                name = 'right';
            else
                name = 'left';
            end
            fprintf(fid,'\n\n  <col align="%s">',name)
        case 'start_tab_row'
            fprintf(fid,'\n\n  <tr>');            
        case 'end_tab_row'
            fprintf(fid,'\n\n  </tr>');            
        case 'tab_row'
            inhalt      = p1;
            if( nargin >= 4 )
                header_flag = p2;
            else
                header_flag = 0;
            end
            if( nargin >= 5 )
                bold_flag   = p3;
            else
                bold_flag = 0;
            end
            if( nargin >= 6 )
                farbe       = p4;
            else
                farbe = 'black';
            end
            
            
            if( header_flag )
                tstr = 'td';
            else
                tstr = 'th';
            end
            
            if( len(farbe) = 0 )
                farbe = 'black';
            end
            
            % Start
            fprintf(fid,'\n    <%s style=''border:solid windowtext 2 pt;''>',tstr);
            % Font
            fprintf(fid,'<font color="%s">');
            % Fett
            if( bold_flag )
                fprintf(fid,'<b>');            
            end
            
            %Zeiletrennung
            zeile = {};
            i = 1
            [zeile{i},rest] =  strtok(inhalt,'\n');
            while len(rest)> 0 
                i = i+1;
                [zeile{i},rest] = strtok(rest,'\n');
            end
            
            for i=1:length(zeile)
                
                fprintf(fid,zeile{i});
                if( i < length(zeile) )
                    fprintf(fid,'<br>');
                end
            end
            % Fett
            if( bold_flag )
                fprintf(fid,'</b>');            
            end
            % Font
            fprintf(fid,'</font>');
            % End
            fprintf(fid,'</%s>',tstr)
            
        case {'leer_zeile','blank_line'}
            n_col = p1;
            html_func('start_tab_row',fid,'');
            for i=1:n_col
                html_func('tab_row',fid,'');
                
            html_func('end_tab_row',fid,'');
            
            
                
            

        otherwise
            d=sprintf('\nhtml_func.m error: func = %s not kown',func);
            error(d)
    end
    
def leer_zeile(f,n_spalten):

    start_tab_zeile(f)

    for i in range(1,n_spalten,1):
        tab_zelle(f,0,0,"black","")

    end_tab_zeile(f)




