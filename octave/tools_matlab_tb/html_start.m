function okay = html_func(func,fid,p1,p2,p3,p4,p5)
%
% fid  = html_func('open',FileName);        Öffnen der Datei FielName
% okay = html_func('close',fid);            Schliesen der Datei 
% okay = html_func('start',fid,Title);      Beginn der html-Ausgabe
% okay = html_func('end',fid);              Beendet der html-Ausgabe
% okay = html_func('start_tab',fid,Title);  Beginn der Tabellenausgabe
% okay = html_func('end_tab',fid);          Beendet der Tabellenausgabe
% okay = html_func('start_colgroup',fid);   Beginn der Spaltengruppeformatierung
% okay = html_func('end_colgroup',fid);     Beendetder Spaltengruppeformatierung
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
        otherwise
            d=sprintf('\nhtml_func.m error: func = %s not kown',func);
            error(d)
    end
    
   def end_tab(f):




