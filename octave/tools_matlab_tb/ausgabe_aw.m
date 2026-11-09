function [okay,s_a] = ausgabe_aw(type,varargin)
%
% Formatierte Ausgabe in Ascii und/oder Wordfile 
% Wordfile Kann auch diegramme aufnehmen
%
% Aufrufe mit default-Angabe:
% 
% [okay,s_a] =
% ausgabe_aw('init',['name','ausgabe'],['path',pwd],['ascii',1],['word',0],['ascii_ext','txt'],
%                                ['ncol1',50],['ncol2',10],['ncol3',10],['visible',0],
%                                ['font_name','Courier New'],['font_size',10])
% [okay,s_a] = ausgabe_aw('head',s_a,'text','Das soll der Text sein',
%                                    ['newpage',0],['newline',0],['ncols',70],['char','='])
% [okay,s_a] = ausgabe_aw('title',s_a,'text','Das soll der Text sein',
%                                    ['newpage',0],['newline',0],['ncols',70],['pos','left'],['uline',''])
% [okay,s_a] = ausgabe_aw('line',s_a,['char','-'],['ncols',70],['pos','left'],['newpage',0],['newline',0])
% [okay,s_a] = ausgabe_aw('res',s_a,'com','Kommentar','unit','Einheit','val',Wert,['pos_val','right']
%                                    ['newpage',0],['newline',0],['ncol1',50],['ncol2',10],['ncol3',10])
% [okay,s_a] = ausgabe_aw('string',s_a,'com','Kommentar','text','tval',Textwert,['pos_tval','right']
%                                    ['newpage',0],['newline',0],['ncol1',50],['ncol2',10],['ncol3',10])
% [okay,s_a] = ausgabe_aw('vector',s_a,'val',vec,['nvalline',10],
%                                    ['newpage',0],['newline',0])
% [okay,s_a] = ausgabe_aw('figure',s_a,'handle',id,
%                                    ['newpage',0],['newline',0])
% [okay,s_a] = ausgabe_aw('newline',s_a)
% [okay,s_a] = ausgabe_aw('newpage',s_a)
% [okay,s_a] = ausgabe_aw('save',s_a)
% [okay,s_a] = ausgabe_aw('close',s_a)
% [okay,s_a] = ausgabe_aw('table',s_a,'tablearray',cellarray{n,m});
okay = 1;
switch lower(type)
%=============================
% Init
%=============================
    case 'init'
    
    
    % Parameter abfragen
    %===================
    
    s_a.name      = 'ausgabe';      % Name
    s_a.ascii_ext = 'txt';
    s_a.path      = pwd;            % Pfad
    path_active_set = 0;
    s_a.ascii     = 0;              % ascii-Abspeichern
    s_a.word      = 0;              % Word abspeichern
    s_a.ncol1     = 50;             % Breite Spalte 1
    s_a.ncol2     = 10;             % Breite Spalte 2
    s_a.ncol3     = 10;             % Breite Spalte 3
    s_a.visible   = 0;
    s_a.font_name = 'Courier New';
    s_a.font_size = 10;
    
    i = 1;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'name'
                s_a.name = varargin{i+1};
            case 'ascii_ext'
                s_a.ascii_ext = varargin{i+1};
            case 'path'
                s_a.path = varargin{i+1};
                path_active_set = 1;
            case 'ascii'
                s_a.ascii = varargin{i+1};
            case {'word','doc'}
                s_a.word   = varargin{i+1};
            case 'ncol1'
                s_a.ncol1   = varargin{i+1};
            case 'ncol2'
                s_a.ncol2   = varargin{i+1};
            case 'ncol3'
                s_a.ncol3   = varargin{i+1};
            case 'visible'
                s_a.visible   = varargin{i+1};
            case 'font_name'
                s_a.font_name   = varargin{i+1};
            case 'font_size'
                s_a.font_size   = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    s_a.ncols = s_a.ncol1+s_a.ncol2+s_a.ncol3;          % Breite Gesamt
    
% %   [fpath,fname,fext] = fileparts(filename);
% %   if isempty(fpath); fpath = pwd; end
% %   if isempty(fext); fext = '.doc'; end
% %   filespec = fullfile(fpath,[fname,fext]);

    s = str_get_pfe_f(s_a.name);
    
    s_a.name = s.name;
    if( ~isempty(s.dir) && ~path_active_set )
      s_a.path = s.dir;
    end
    
    % Ascii file öffnen
    %-----------------
    if( s_a.ascii )
        s_file = str_get_pfe_f(s_a.name);
        s_a.ascii_file = fullfile(s_a.path,[s_file.name,'.',s_a.ascii_ext]);
        s_a.ascii_fid  = fopen(s_a.ascii_file,'w');
        if( s_a.ascii_fid < 0 )
                tdum = sprintf('%s: Datei <%s> konnte nicht geöffnet werden',mfilename,s_a.ascii_file)
                error(tdum)
        end
    else
        s_a.ascci_file = 0;
        s_a.ascii_fid  = 0;
    end
    
    % Word file öffnen
    %-----------------
    if( s_a.word )
        s_a.word_file = fullfile(s_a.path,[s_a.name,'.doc']);
        [okay,s_a.word_fid]  = word_com_f('open', ...
                                          'visible',s_a.visible, ...
                                          'font_name',s_a.font_name, ...
                                          'font_size',s_a.font_size);
        if( ~okay )
            return
        end
    else
        s_a.word_file = 0;
        s_a.word_fid  = 0;
    end
    
    
    s_a.init_done = 1;
    
    
%=============================
% Head/Überschrift
%=============================
    case 'head'
    
    
    % Parameter abfragen
    %===================

    s_a = varargin{1};              % Struktur
    
    text         = '';              % Text
    newpage      = 0;               % Neue Seite
    newline      = 0;               % Neue Zeile
    ncols        = s_a.ncols;       % Spaltenbreiet
    fchar        = '=';             % Zeichen für Umrahmung
    
    
    i = 2;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'text'
                text = varargin{i+1};
            case 'newpage'
                newpage = varargin{i+1};
            case 'newline'
                newline = varargin{i+1};
            case 'ncols'
                ncols = varargin{i+1};
            case {'char','fchar'}
                fchar   = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    
    if( s_a.word )
        % Neue Seite einfügen
        if( newpage ) 
            [okay] = word_com_f('newpage',s_a.word_fid);
        end
        % Neue Seite einfügen
        if( newline ) 
            [okay] = word_com_f('newline',s_a.word_fid);
        end
    end
    if( s_a.ascii )
        % Neue Seite einfügen
        if( newpage ) 
            fprintf(s_a.ascii_fid,'\n');
        end
        % Neue Zeile einfügen
        if( newline ) 
            fprintf(s_a.ascii_fid,'\n');
        end
    end
    
    % Überschrift erstellen
    ctext = ausgabe_aw_make_head(text,ncols,fchar);
    
    for i=1:length(ctext)
        
        if( s_a.word )
            % Text einfügen
            [okay] = word_com_f('line',s_a.word_fid,ctext{i});
        end
        if( s_a.ascii )
            % text einfügen
            fprintf(s_a.ascii_fid,'%s\n',ctext{i});
        end
    end
% [okay,s_a] = ausgabe_aw('title',s_a,'text','Das soll der Text sein',['newpage',0],['ncols',70],['pos','left'])
%=============================
% Title/einache Überschrift
%=============================
    case 'title'
    
    
    % Parameter abfragen
    %===================
    
    s_a = varargin{1};              % Struktur

    text         = '';              % Text
    newpage      = 0;               % Neue Seite
    newline      = 0;               % Neue Zeile
    ncols        = s_a.ncols;       % Spaltenbreiet
    pos          = 'left';          % Positionierung
    uline        = '';              % Unterlinienzeichen
    
    
    i = 2;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'text'
                text = varargin{i+1};
            case 'newpage'
                newpage = varargin{i+1};
            case 'newline'
                newline = varargin{i+1};
            case 'ncols'
                ncols = varargin{i+1};
            case 'pos'
                pos= varargin{i+1};
            case 'uline'
                uline= varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    
    if( s_a.word )
        % Neue Seite einfügen
        if( newpage ) 
            [okay] = word_com_f('newpage',s_a.word_fid);
        end
        % Neue Zeile einfügen
        if( newline ) 
            [okay] = word_com_f('newline',s_a.word_fid);
        end
    end
    if( s_a.ascii )
        % Neue Seite einfügen
        if( newpage ) 
            fprintf(s_a.ascii_fid,'\n');
        end
        % Neue Zeile einfügen
        if( newline ) 
            fprintf(s_a.ascii_fid,'\n');
        end
    end
    
    % Tile erstellen
    [ctext,tline] = ausgabe_aw_make_title(text,ncols,pos,uline);                    
    
    for i=1:length(ctext)
        
        if( s_a.word )
            % Text einfügen
            [okay] = word_com_f('line',s_a.word_fid,ctext{i});
        end
        if( s_a.ascii )
            % text einfügen
            fprintf(s_a.ascii_fid,'%s\n',ctext{i});
        end
    end
    if( length(uline) > 0 )
        if( s_a.word )
            % Linie einfügen
            [okay] = word_com_f('line',s_a.word_fid,tline);
        end
        if( s_a.ascii )
            % Linie einfügen
            fprintf(s_a.ascii_fid,'%s\n',tline);
        end
    end
% [okay,s_a] = ausgabe_aw('line',s_a,['char','-'],['pos','left'],['ncols',70],['newpage',0],['newline',0])
%=============================
% Linie ziehen
%=============================
    case 'line'
    
    
    % Parameter abfragen
    %===================
    
    s_a = varargin{1};              % Struktur

    char         = '-';              % Text
    newpage      = 0;               % Neue Seite
    newline      = 0;               % Neue Zeile
    ncols        = s_a.ncols;       % Spaltenbreiet
    pos          = 'left';          % Positionierung
    
    
    i = 2;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'char'
                char = varargin{i+1};
            case 'newpage'
                newpage = varargin{i+1};
            case 'newline'
                newline = varargin{i+1};
            case 'ncols'
                ncols = varargin{i+1};
            case 'pos'
                pos= varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    
    if( s_a.word )
        % Neue Seite einfügen
        if( newpage ) 
            [okay] = word_com_f('newpage',s_a.word_fid);
        end
        % Neue Zeile einfügen
        if( newline ) 
            [okay] = word_com_f('newline',s_a.word_fid);
        end
    end
    if( s_a.ascii )
        % Neue Seite einfügen
        if( newpage ) 
            fprintf(s_a.ascii_fid,'\n');
        end
        % Neue Zeile einfügen
        if( newline ) 
            fprintf(s_a.ascii_fid,'\n');
        end
    end
    
    % Tile erstellen
    text = '';
    for i=1:ncols
        text = [text,'k'];
    end
    [ctext,tline] = ausgabe_aw_make_title(text,ncols,pos,char);                    
    
    if( length(char) > 0 )
        if( s_a.word )
            % Linie einfügen
            [okay] = word_com_f('line',s_a.word_fid,tline);
        end
        if( s_a.ascii )
            % Linie einfügen
            fprintf(s_a.ascii_fid,'%s\n',tline);
        end
    end

%=============================
% Ausgabe von Werten
%=============================
    case 'res'
    
    
    % Parameter abfragen
    %===================
    
    s_a = varargin{1};      % Struktur

    com         = '';             % Kommentar
    unit        = '';             % EInheit
    val         = 0;              % Wert
    newpage     = 0;              % Neue Seite
    newline      = 0;               % Neue Zeile
    ncol1       = s_a.ncol1;      % Spaltenbreit1 Kommentar
    ncol2       = s_a.ncol2;      % Spaltenbreit1 Einheit
    ncol3       = s_a.ncol3;      % Spaltenbreit1 Wert
    pos_val     = 'right';         % Position String 'left','right','middle'
    
    
    i = 2;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'com'
                com = varargin{i+1};
            case 'unit'
                unit = varargin{i+1};
            case 'val'
                val = varargin{i+1};
            case 'pos_val'
                pos_val = varargin{i+1};
            case 'newpage'
                newpage = varargin{i+1};
            case 'newline'
                newline = varargin{i+1};
            case 'ncol1'
                ncol1 = varargin{i+1};
            case 'ncol2'
                ncol2 = varargin{i+1};
            case 'ncol3'
                ncol3 = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    if( strcmp(class(val),'struct') )
       tdum = sprintf('%s: val mit com <%s> mit unit <%s> ist kein double sondern struct',mfilename,com,unit)
       error(tdum)
    end        
    if( strcmp(class(val),'cell') & length(val) > 1 )
        val = val{1};
    end
    if( strcmp(class(val),'char') )
        val = num2str(val);
    end
    if( strcmp(class(val),'double') & length(val) > 1 )
        val = val(1);
    end
    
    
    if( s_a.word )
        % Neue Seite einfügen
        if( newpage ) 
            [okay] = word_com_f('newpage',s_a.word_fid);
        end
        % Neue Seite einfügen
        if( newline ) 
            [okay] = word_com_f('newline',s_a.word_fid);
        end
    end
    if( s_a.ascii )
        % Neue Seite einfügen
        if( newpage ) 
            fprintf(s_a.ascii_fid,'\n');
        end
        % Neue Zeile einfügen
        if( newline ) 
            fprintf(s_a.ascii_fid,'\n');
        end
    end
    
    % Ergebnisse erstellen
    ctext = ausgabe_aw_make_res(com,unit,val,ncol1,ncol2,ncol3,pos_val);
    
    for i=1:length(ctext)
        
        if( s_a.word )
            % Text einfügen
            [okay] = word_com_f('line',s_a.word_fid,ctext{i});
        end
        if( s_a.ascii )
            % text einfügen
            fprintf(s_a.ascii_fid,'%s\n',ctext{i});
        end
    end
%=============================
% Ausgabe von Text-Werten
%=============================
    case 'string'
    
    
    % Parameter abfragen
    %===================
    
    s_a = varargin{1};      % Struktur

    com         = '';             % Kommentar
    tval        = '';              % Wert
    newpage     = 0;              % Neue Seite
    newline      = 0;               % Neue Zeile
    ncol1       = s_a.ncol1;      % Spaltenbreit1 Kommentar
    ncol2       = s_a.ncol2;      % Spaltenbreit1 Einheit
    ncol3       = s_a.ncol3;      % Spaltenbreit1 Wert
    pos_tval    = 'right';         % Position String 'left','right','middle'
    
    
    i = 2;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'com'
                com = varargin{i+1};
            case 'tval'
                tval = varargin{i+1};
            case 'pos_tval'
                pos_tval = varargin{i+1};
            case 'newpage'
                newpage = varargin{i+1};
            case 'newline'
                newline = varargin{i+1};
            case 'ncol1'
                ncol1 = varargin{i+1};
            case 'ncol2'
                ncol2 = varargin{i+1};
            case 'ncol3'
                ncol3 = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    
    if( s_a.word )
        % Neue Seite einfügen
        if( newpage ) 
            [okay] = word_com_f('newpage',s_a.word_fid);
        end
        % Neue Seite einfügen
        if( newline ) 
            [okay] = word_com_f('newline',s_a.word_fid);
        end
    end
    if( s_a.ascii )
        % Neue Seite einfügen
        if( newpage ) 
            fprintf(s_a.ascii_fid,'\n');
        end
        % Neue Zeile einfügen
        if( newline ) 
            fprintf(s_a.ascii_fid,'\n');
        end
    end
    
    % Ergebnisse erstellen
    ctext = ausgabe_aw_make_res(com,'',tval,ncol1,ncol2,ncol3,pos_tval);
    
    for i=1:length(ctext)
        
        if( s_a.word )
            % Text einfügen
            [okay] = word_com_f('line',s_a.word_fid,ctext{i});
        end
        if( s_a.ascii )
            % text einfügen
            fprintf(s_a.ascii_fid,'%s\n',ctext{i});
        end
    end
%=============================
% Ausgabe von einem vektor
%=============================
    case 'vector'
    
    
    % Parameter abfragen
    %===================
    
    s_a = varargin{1};      % Struktur

    val         = [];              % Wert
    newpage     = 0;              % Neue Seite
    newline      = 0;               % Neue Zeile
    nvalline    = 10;             % Anzahl Werte pro Zeile
    
    i = 2;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'val'
                val = varargin{i+1};
            case 'newpage'
                newpage = varargin{i+1};
            case 'newline'
                newline = varargin{i+1};
            case 'nvalline'
                nvalline = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    nvalline = max(1,nvalline);
    
    if( isempty(val) )
       tdum = sprintf('%s: val mit com <%s> mit unit <%s> enthält keinen Wert ',mfilename,com,unit)
       error(tdum)
    end        
    if( ~isnumeric(val) )
       tdum = sprintf('%s: val mit com <%s> mit unit <%s> ist kein double ',mfilename,com,unit)
       error(tdum)
    end        
    
    if( s_a.word )
        % Neue Seite einfügen
        if( newpage ) 
            [okay] = word_com_f('newpage',s_a.word_fid);
        end
        % Neue Seite einfügen
        if( newline ) 
            [okay] = word_com_f('newline',s_a.word_fid);
        end
    end
    if( s_a.ascii )
        % Neue Seite einfügen
        if( newpage ) 
            fprintf(s_a.ascii_fid,'\n');
        end
        % Neue Zeile einfügen
        if( newline ) 
            fprintf(s_a.ascii_fid,'\n');
        end
    end
    
    [n,m] = size(val);
    if( n >= m )
        val = val(1:n,1);
    else
        val = val(1,1:m)';
        n = m;
    end
    
    ctext = {};
    ict = 0;
    ival = nvalline;
    for i=1:n
        
        if( ival >= nvalline )
            ival = 1;
            ict  = ict + 1;
            ctext{ict} = '';
        else
            ival = ival + 1;
        end
            
        if( i == 1 )
            
            ctext{ict} = ['[ ',num2str(val(i))];
            
        else
            ctext{ict} = [ctext{ict},' , ',num2str(val(i))];
        end            
        if( i == n )
            
            ctext{ict} = [ctext{ict},' ]'];
        end
    end
    
    for i=1:length(ctext)
        
        if( s_a.word )
            % Text einfügen
            [okay] = word_com_f('line',s_a.word_fid,ctext{i});
        end
        if( s_a.ascii )
            % text einfügen
            fprintf(s_a.ascii_fid,'%s\n',ctext{i});
        end
    end
%=============================
% Ausgabe einer Figur/Graf
%=============================
    case 'figure'
    
    
    % Parameter abfragen
    %===================
    
    s_a = varargin{1};      % Struktur

    handle      = 0;             % Handle
    newpage     = 0;              % Neue Seite
    newline      = 0;               % Neue Zeile
    
    
    i = 2;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'handle'
                handle = varargin{i+1};
            case 'newpage'
                newpage = varargin{i+1};
            case 'newline'
                newline = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    
    if( s_a.word )
        % Neue Seite einfügen
        if( newpage ) 
            [okay] = word_com_f('newpage',s_a.word_fid);
        end
        % Neue Seite einfügen
        if( newline ) 
            [okay] = word_com_f('newline',s_a.word_fid);
        end
        % Plot einfügen
       [okay] = word_com_f('figure',s_a.word_fid,handle);
    end
        
%=============================
% Newline
%=============================
    case 'newline'
    
    s_a = varargin{1};
    
    % Wordfile  neue Zeile
    if( s_a.word )
        [okay,s_a.word_fid] = word_com_f('newline',s_a.word_fid);
    end
    % Asciifile  neue Zeile
    if( s_a.ascii )
        fprintf(s_a.ascii_fid,'\n');
    end
%=============================
% Newpage
%=============================
    case 'newpage'
    
    s_a = varargin{1};
    
    % Wordfile neue Seite
    if( s_a.word )
        [okay,s_a.word_fid] = word_com_f('newpage',s_a.word_fid);
    end
    % Asciifile neue Zeile
    if( s_a.ascii )
        fprintf(s_a.ascii_fid,'\n');
    end
%=============================
% Save
%=============================
    case 'save'
    
    s_a = varargin{1};
    
    % Wordfile speichern
    if( s_a.word )
        [okay,s_a.word_fid] = word_com_f('save',s_a.word_fid,'name',s_a.word_file);
    end
    % Asciifile schliessen
%     if( s_a.ascii )
%         fclose(s_a.ascii_fid)
%     end
%=============================
% Close
%=============================
    case 'close'
    
    s_a = varargin{1};
    
    % Wordfile schliessen
    if( s_a.word )
        [okay,s_a.word_fid] = word_com_f('close',s_a.word_fid,'name',s_a.word_file);
    end
    % Asciifile schliessen
    if( s_a.ascii )
        fclose(s_a.ascii_fid);
    end
 % [okay,s_a] = ausgabe_aw('table',s_a,'tablearray',cellarray{n,m});
%=============================
% Table (nur Word)
%=============================
    case 'table'
    
    s_a = varargin{1};
    tablearray  = {};              % Wert
    
    i = 2;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'tablearray'
                tablearray = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)
        end
        i = i+2;
    end
   
    if( ~isempty(tablearray) )
      [n,m] = size(tablearray);
      for i=1:n
        for j=1:m
          if( ~ischar(tablearray{i,j}) )     
            tablearray{i,j} = '';
          end
        end
      end
      
      % Wordfile Tabelle
      if( s_a.word )
          [okay,s_a.word_fid] = word_com_f('table',s_a.word_fid,'tablearray',tablearray);
      end
    end
%=============================
% Fehler
%=============================
    otherwise

    s_a = varargin{1};
    tdum = sprintf('%s: type <%s> nicht gültig',mfilename,s_a.ascii_file)    
    error(tdum)
    
end
                
%=======================================================
%=======================================================
function     ctext = ausgabe_aw_make_head(text,ncols,fchar)

ctext = {};
t = [];
for i=1:ncols        
    t = [t,fchar];
end
n        = 1;
ctext{n} = t;
cctext = ausgabe_aw_make_text_split(text,ncols);
for i=1:length(cctext)
    n = n+1;
    ctext{n} = cctext{i};
end
n        = n+1;
ctext{n} = t;

%=======================================================
%=======================================================
function     [ctext,tline] = ausgabe_aw_make_title(text,ncols,pos,uline)

if( nargin < 4 )
    uline = '';
end

if( length(text) < ncols )
    ctext{1} = text;
else
    n = 0;
    while length(text) > 0
        if( length(text) > ncols )
            
            n        = n+1;
            ctext{n} = text(1:ncols);
            text     = text(ncols+1:length(text));
        else
            n        = n+1;
            ctext{n} = text;
            text     = '';
        end
    end
end
nl = 0;
nr = 0;
for i=1:length(ctext)
    lc = length(ctext{i});
    if( lc < ncols )
        
        if( pos(1) == 'l' ) % left postioning
            nl = length( ctext{i} );
            t = ctext{i};
            while length(t) < ncols
                t = [t,' '];
            end
        else
            nr = length(ctext{i});
            t = '';
            while length(t) < ncols-lc
                t = [t,' '];
            end
            t = [t,ctext{i}];
        end
        ctext{i} = t;
    end
end

tline = '';
if( length(uline) > 0 )
    
    if( length(ctext) > 1 ) % Unterlinie über die ganze Breite
        for i=1:floor(ncols/length(uline))
            tline = [tline,uline];
        end
    else
        if( nl > 0 )
            for i=1:floor(nl/length(uline))
                tline = [tline,uline];
            end 
        elseif( nr > 0 )
            for i=1:ncols-nr
                tline = [tline,' '];
            end
            for i=1:floor(nr/length(uline))
                tline = [tline,uline];
            end
        else
            for i=1:length(ctext{1})
                tline = [tline,uline];
            end 
            
        end
    end
end        

%=======================================================
%=======================================================
function    ctext = ausgabe_aw_make_res(com,unit,val,ncol1,ncol2,ncol3,pos);

if( nargin < 7 )
    pos = 'right';
end

c1text = ausgabe_aw_make_text_split(com,ncol1);
c2text = ausgabe_aw_make_text_split(unit,ncol2);

if( strcmp(class(val),'double') )
    c3text = ausgabe_aw_make_val_split(val,ncol3,'r',pos);
else
    c3text = ausgabe_aw_make_text_split(val,ncol3,'r',pos);
end
l1 = length(c1text);
l2 = length(c2text);
l3 = length(c3text);

ll = max(l1,max(l2,l3));

for i=1:ll
    if( i <= l1 )
        t1 = c1text{i};
    else
        t1 = '';
    end
    lt1 = length(t1);
    if( lt1 < ncol1 )
        for j=1:ncol1-lt1
            t1 = [t1,' '];
        end
    end
    
    if( i <= l2 )
        t2 = c2text{i};
    else
        t2 = '';
    end
    lt2 = length(t2);
    if( lt2 < ncol2 )
        for j=1:ncol2-lt2
            t2 = [t2,' '];
        end
    end
    
    if( i <= l3 )
        t3 = c3text{i};
    else
        t3 = '';
    end
    lt3 = length(t3);
    if( lt3 < ncol3 )
        for j=1:ncol3-lt3
            t3 = [t3,' '];
        end
    end
    ctext{i} = [t1,t2,t3];
end
%=======================================================
%=======================================================
function ctext = ausgabe_aw_make_val_split(val,ncols,regel,pos)

if( nargin < 4 )
    pos = 'right';
end
if( nargin < 3 )
    regel = 'v';
end

text = num2str(val);

if( strcmp(regel,'r') )
    if( length(text) < ncols )
        t = '';
        for i=1:ncols-length(text)
            t = [t,' '];
        end
        text = [t,text];
    end
end

if( length(text) <= ncols )
    ctext{1} = text;
else
    icount = 0;
    while length(text) > 0
        if( length(text) > ncols )
            icount = icount + 1;
            ctext{icount} = text(1:ncols);
            text = text(ncols+1:length(text));
        else
            icount = icount + 1;
            ctext{icount} = text;
            text = '';
        end
    end
end
ctext = ausgabe_aw_make_text_pos(ctext,pos);
            
%=======================================================
%=======================================================
function ctext = ausgabe_aw_make_text_split(text,ncols,regel,pos)

if( nargin < 4 )
    pos   = 'right';
end
if( nargin < 3 )
    regel = 'v';

end
    
ctext{1} = '';
ntext = 1;
[c_names,n] = ausgabe_aw_str_split(text,' ');
for i=1:n
    text = c_names{i};
    while( length(text) > 0 )
        lc = length(ctext{ntext});
        lt = length(text);
        if( lc == 0 & lt <= ncols )
            ctext{ntext} = text;
            text = '';
        elseif( lc == 0 & lt > ncols )
            ctext{ntext} = text(1:ncols);
            text = text(ncols+1:lt);
            
            ntext = ntext + 1;
            ctext{ntext} = '';
        elseif( lc+1+lt < ncols )
            ctext{ntext} = [ctext{ntext},' ',text];
            text = '';
        else
            ntext = ntext + 1;
            ctext{ntext} = '';
        end
    end
end
if( strcmp(regel,'r') )
    for i=1:length(ctext)
        dtum = str_cut_e_f(ctext{i},' ');
        n   = length(ctext{i})-length(dtum);
        text = '';
        for j=1:n
            text = [text,' '];
        end
        dtum = [text;dtum];
        text = '';
        for j= 1:ncols-length(dtum)
            text = [text,' '];
        end
        ctext{i} = [text,dtum];
    end
end
ctext = ausgabe_aw_make_text_pos(ctext,pos);
%=======================================================
%=======================================================
function [c_names,icount] = ausgabe_aw_str_split(text,delim)

c_names = {};
icount = 0;
go_on  = 1;

while( go_on )

    a = findstr(text,delim);
 
    if( length(a) == 0 )
        
         icount = icount + 1;
         c_names{icount} = text;
         go_on = 0;
    else
        i0 = a(1)-1;
        i1 = a(1)+length(delim);
        if( i0 < 1 )
            icount = icount + 1;
            c_names{icount} = '';
        else
            icount = icount + 1;
            c_names{icount} = text(1:i0);
        end
        if( i1 > length(text) )
            text = '';
        else
            text = text(i1:length(text));
        end
    end            
            
end
function ctext = ausgabe_aw_make_text_pos(ctext,pos)

for ictext=1:length(ctext)
    
    n0 = length(ctext{ictext});
    
    text = str_cut_ae_f(ctext{ictext},' ');
    
    n1   = length(text);
    deln = n0 - n1;
    deln2 = floor(deln/2);
    
    if( deln > 0 )
        
        if( strcmp(lower(pos(1)),'l') )
            
            for i=1:deln
                text = [text,' '];
            end
        elseif( strcmp(lower(pos(1)),'l') )
            
            for i=1:deln
                text = [text,' '];
            end
        else

            for i=1:deln2
                text = [' ',text];
            end
            while( length(text) < n0 )
                
                text = [text,' '];
            end
        end
        
        ctext{ictext} = text;
    end            
end      
        