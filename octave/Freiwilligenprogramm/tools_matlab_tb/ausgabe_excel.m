function [okay,s_e] = ausgabe_excel(type,varargin)
%
% Formatierte Ausgabe in Excel-File 
%
% Aufrufe mit default-Angabe:
% 
% [okay,s_e] =
% ausgabe_excel('init',['name','ausgabe'],
%                      ['path',pwd],
%                      ['visible',0],
%                      ['font_name','Courier New'],
%                      ['font_size',10],
%                      ['color','no')
%
% [okay,s_e] = ausgabe_excel('save',s_e,['name','ausgabe'],['path',pwd])
% [okay,s_e] = ausgabe_excel('close',s_e)
%
% [okay,s_e] = ausgabe_excel('val',s_e,'col',vcol,'row',vrow,'val',value ...
%                                     ,['sheet_nr',nr],['sheet_name',name])
% Schreibt Werte in die Zelle, wenn kein Font angegeben wird default (init)
% genommen, wenn gesetzt:
% vcol          double          Spalte kann Vektor mit n-Spalten sein
% vrow          double          Zeile kann Vektor mit n-Zeilen sein
% value         double,char     Wert, der eingeschrieben wird als string oder
%                               double-Wert
% font_name     char            Fontname
% font_size     double          Fontgröße
% sheet_nr      double          Auswahl der Tabelle
% sheet_name    char            Wenn sheet_nr nicht vorhanden, dann Auswahl über Name
%                               Wenn sheet_nr > 0, dann Auswahl über Nummer und umbenennen
%
% [okay,s_e] = ausgabe_excel('vec',s_e,'icol',icol,'irow',irow,'vec',vec ...
%                                     ,['sheet_nr',nr],['sheet_name',name])
% Schreibt vector in die Zellen, wenn kein Font angegeben wird default (init)
% genommen, wenn gesetzt:
% icol          double          Start-Spalte
% irow          double          Star-Zeile
% vec           double,cell     Vector
% sheet_nr      double          Auswahl der Tabelle
% sheet_name    char            Wenn sheet_nr nicht vorhanden, dann Auswahl über Name
%                               Wenn sheet_nr > 0, dann Auswahl über Nummer und umbenennen
%
% [okay,s_e] = ausgabe_excel('cat',s_e,'col',icol,'row',irow,'val',value)
% Zellen verbinden und Wert schreiben
% icol          double array    Spaltenbeginn und Ende der Zellen, die
%                               zusammengeführt werden [1,10]
% irow          double array    Zeilenbeginn und Ende der Zellen, die
%                               zusammengeführt werden [3,3]
% val          double,char     Wert, der eingeschrieben wird als string oder
%                               double-Wert
%
% [okay,s_e] = ausgabe_excel('format',s_e,'col',icol,'row',irow,['color','orange']
%                           ,['col_width',10],['row_height',10],['font_name','Courier New'],['font_size',10]
%                           ,['sheet_nr',nr],['sheet_name',name])
% Zellen verbinden und Wert schreiben
% icol          double array    Vektor mit den Spalten, die formatiert
%                               werden sollen
% irow          double array    Vektor mit den Zeilen, die formatiert
%                               werden sollen
% color         char            Farbe: 'o' oder 'orange'
%                                      'r' oder 'red' oder 'rot'
%                                      'g' oder 'grey','gray' oder 'grau'
%                                      'y' oder 'yellow' oder 'gelb'
% col_width     double          Breite der Spalte
%               char            'auto'  automatisch
% row_height    double          Höhe der Zeile
%                               'auto' automatisch
% border        char            'all'
% font_name     char            Fontname
% font_size     double          Fontgröße
% font_form     char            'bold'
% orientation   double          Schriftausrichtung in grad
% number_format char            '#.##0,00' Zwei Stellen hinter dem Komma und Punkt bei tausend
% sheet_nr      double          Auswahl der Tabelle
% sheet_name    char            Wenn sheet_nr nicht vorhanden, dann Auswahl über Name
%                               Wenn sheet_nr > 0, dann Auswahl über Nummer und umbenennen
%
% [okay,s_e] = ausgabe_excel('sheet',s_e,['sheet_nr',nr],['sheet_name',name])
% Tabelle aussuchen
%
% sheet_nr      double          Auswahl der Tabelle
% sheet_name    char            Wenn sheet_nr nicht vorhanden, dann Auswahl über Name
%

okay = 1;
switch lower(type)
%=============================
% Init
%=============================
    case 'init'
    
    
    % Parameter abfragen
    %===================
    
    s_e.name      = 'liste';      % Name
    s_e.path      = pwd;          % Pfad
    s_e.visible   = 0;
    s_e.font_name = '';
    s_e.font_size = 10;
    s_e.color     = '';
    s_e.file_open = 0;
    s_e.col_width = {};
    
    i = 1;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'name'
                s_e.name = varargin{i+1};
            case 'path'
                s_e.path = varargin{i+1};
            case 'visible'
                s_e.visible   = varargin{i+1};
            case 'font_name'
                s_e.font_name   = varargin{i+1};
            case 'font_size'
                s_e.font_size   = varargin{i+1};
            case 'color'
                s_e.color   = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    % Dateiname
    s_e.excel_file = fullfile(s_e.path,[s_e.name]);
    
    % Excel file öffnen
    %-----------------
    [okay,s_e.excel_fid]  = excel_com_f('open' ...
                                       ,'visible',s_e.visible ...
                                       );
    if( ~okay )
        return
    end
    
    
    s_e.file_open = 1;
    
    
%=============================
% Save
%=============================
    case 'save'
    
    s_e = varargin{1};
    i = 2;
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'name'
                s_e.name = varargin{i+1};
            case 'path'
                s_e.path = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    % Dateiname
    s = str_get_pfe_f(s_e.name);
    s_e.excel_file = fullfile(s_e.path,[s.name]);
    %s_e.excel_file = s_e.name;
    %s = str_get_pfe_f(s_e.excel_file);
    %s_e.excel_file = [s.dir,s.name];
    
    % Excelfile speichern
    if( s_e.file_open == 1 )
        [okay,s_e.excel_fid] = excel_com_f('save',s_e.excel_fid,'name',s_e.excel_file);
        s_e.file_open = 2;
    end
%=============================
% Close
%=============================
    case 'close'
    
    s_e = varargin{1};
    
    % Excelfile speichern
    if( s_e.file_open == 1 )
        
        s = str_get_pfe_f(s_e.excel_file);
        s_e.excel_file = [s.dir,s.name];
        [okay,s_e.excel_fid] = excel_com_f('save',s_e.excel_fid,'name',s_e.excel_file);
        if( okay )
            s_e.file_open = 2;
        end
    end

    % Excelfile schliessen
    if( s_e.file_open == 2 )
        [okay,s_e.excel_fid] = excel_com_f('close',s_e.excel_fid,'name',s_e.excel_file);
        if( okay )
            s_e.file_open = 0;
        end
    end

%=============================
% Wert
%=============================
    case 'val'
    
    s_e = varargin{1};
    i = 2;
    val   = [];
    vcol  = [];
    vrow  = [];
    color = '';
    font_name = '';
    font_size = -1;
    
    sheet_nr   = 0;
    sheet_name = '';
        
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'col'
                vcol = varargin{i+1};
            case 'row'
                vrow = varargin{i+1};
            case 'color'
                color = varargin{i+1};
            case 'font_name'
                font_name = varargin{i+1};
            case 'font_size'
                font_size = varargin{i+1};
            case 'val'
                val = varargin{i+1};
            case 'sheet_nr'
                sheet_nr = varargin{i+1};
            case 'sheet_name'
                sheet_name = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    
    
    if( length(vcol) > 0 & length(vrow) > 0 & length(val) > 0)
        
        % Tabelle auswählen
        if( sheet_nr > 0 || ~isempty(sheet_name) )
            
            [okay,s_e.excel_fid] = excel_com_f('sheet',s_e.excel_fid ...
                                              ,'sheet_nr',sheet_nr ...
                                              ,'sheet_name',sheet_name);
        end        
        
        % Formatierung
        %=============
        if( length(font_name) == 0 & length(s_e.font_name) > 0 )
            font_name = s_e.font_name;
        end
        if( font_size == -1 & s_e.font_size > -1 )
            font_size = s_e.font_size;
        end
        if( length(color) == 0 & length(color) > 0 )
            color = s_e.color;
        end
            
        [okay,s_e.excel_fid] = excel_com_f('format',s_e.excel_fid,'col',vcol,'row',vrow ...
                                      ,'color',color ...
                                      ,'font_name',font_name ...
                                      ,'font_size',font_size ...                                  
                                      );
        
        % Wert
        %=====
        [okay,s_e.excel_fid] = excel_com_f('val',s_e.excel_fid,'col',vcol,'row',vrow,'val',val);

    end
        
        
%=============================
% Vektor
%=============================
    case 'vec'
    
    s_e = varargin{1};
    i = 2;
    vec   = [];
    icol  = [];
    irow  = [];
    
    sheet_nr   = 0;
    sheet_name = '';
        
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'icol'
                icol = varargin{i+1};
            case 'irow'
                irow = varargin{i+1};
            case 'vec'
                vec = varargin{i+1};
            case 'sheet_nr'
                sheet_nr = varargin{i+1};
            case 'sheet_name'
                sheet_name = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    
    
    if( icol > 0 && irow > 0 && ~isempty(vec))
        
        % Tabelle auswählen
        if( sheet_nr > 0 || ~isempty(sheet_name) )
            
            [okay,s_e.excel_fid] = excel_com_f('sheet',s_e.excel_fid ...
                                              ,'sheet_nr',sheet_nr ...
                                              ,'sheet_name',sheet_name);
        end        
        
        
        % Wert
        %=====
        [okay,s_e.excel_fid] = excel_com_f('vec',s_e.excel_fid,'icol',icol,'irow',irow,'vec',vec);

    end
        
        
        
%=============================
% Format
%=============================
    case 'format'
    
    s_e = varargin{1};
    i = 2;
    vcol  = 0;
    vrow  = 0;
    color = '';
    col_width = -1;
    row_height = -1;
    font_name = '';
    font_size = -1;
    orientation = [];
    font_form   = '';
    border      = '';
    number_format = '';
    
    sheet_nr   = 0;
    sheet_name = '';
    
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'col'
                vcol = varargin{i+1};
            case 'row'
                vrow = varargin{i+1};
            case 'color'
                color = varargin{i+1};
            case 'col_width'
                col_width = varargin{i+1};
            case 'row_height'
                row_height = varargin{i+1};
            case 'border'
                border = varargin{i+1};
            case 'font_name'
                font_name = varargin{i+1};
            case 'font_size'
                font_size = varargin{i+1};
            case 'font_form'
                font_form = varargin{i+1};
            case 'orientation'
                orientation = varargin{i+1};
            case 'number_format'
                number_format = varargin{i+1};
            case 'sheet_nr'
                sheet_nr = varargin{i+1};
            case 'sheet_name'
                sheet_name = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    
    
    if( vcol(1) ~= 0 & vrow(1) ~= 0 )
        
        % Tabelle auswählen
        if( sheet_nr > 0 || ~isempty(sheet_name) )
            
            [okay,s_e.excel_fid] = excel_com_f('sheet',s_e.excel_fid ...
                                              ,'sheet_nr',sheet_nr ...
                                              ,'sheet_name',sheet_name);
        end

        % colwidth sich merken
        if( strcmp(class(col_width),'double') & col_width > -1 )
            
            for icol= 1:length(vcol)
                
                ic = vcol(icol);
                if( length(s_e.col_width) < ic )
                    
                    for i=length(s_e.col_width)+1:ic
                        s_e.col_width{i} = -1;
                    end
                end
                s_e.col_width{ic} = col_width;
            end
        end
                
            
                
        [okay,s_e.excel_fid] = excel_com_f('format',s_e.excel_fid,'col',vcol,'row',vrow ...
                                          ,'color',color ...
                                          ,'col_width',col_width ...
                                          ,'row_height',row_height ...
                                          ,'border',border ...
                                          ,'font_name',font_name  ...
                                          ,'font_size',font_size  ...
                                          ,'font_form',font_form  ...
                                          ,'orientation',orientation  ...
                                          ,'number_format',number_format ...
                                          );
    end
        
        
        
%=============================
% Verbinden
%=============================
    case 'cat'
    
    s_e = varargin{1};
    i = 2;
    icol = [1,1];
    irow = [1,1];
    val  = 0;
    val_set = 0;
    
    sheet_nr   = 0;
    sheet_name = '';
    
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'col'
                icol = varargin{i+1};
            case 'row'
                irow = varargin{i+1};
            case 'val'
                val = varargin{i+1};
                val_set = 1;
            case 'sheet_nr'
                sheet_nr = varargin{i+1};
            case 'sheet_name'
                sheet_name = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    % Tabelle auswählen
    if( sheet_nr > 0 || ~isempty(sheet_name) )

        [okay,s_e.excel_fid] = excel_com_f('sheet',s_e.excel_fid ...
                                          ,'sheet_nr',sheet_nr ...
                                          ,'sheet_name',sheet_name);
    end
    if( length(icol) > 1 || length(irow) > 1 )       %#ok<OR2>
        [okay,s_e.excel_fid] = excel_com_f('cat',s_e.excel_fid,'col',icol,'row',irow);
    end
    if( val_set )
        [okay,s_e.excel_fid] = excel_com_f('val',s_e.excel_fid,'col',icol(1),'row',irow(1),'val',val);
    end
        
        
        
%=============================
% Init
%=============================
    case 'sheet'

    i = 2;
    s_e = varargin{1};
    sheet_nr   = 0;
    sheet_name = '';
    autofit    = 0;
    
    while( i+1 <= length(varargin) )
        
        switch lower(varargin{i})
            case 'sheet_nr'
                sheet_nr = varargin{i+1};
            case 'sheet_name'
                sheet_name = varargin{i+1};
            case 'autofit'
                autofit = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,type,varargin{i})
                error(tdum)

        end
        i = i+2;
    end
    
    % Tabelle auswählen
    if( sheet_nr > 0 || ~isempty(sheet_name) )

        [okay,s_e.excel_fid] = excel_com_f('sheet',s_e.excel_fid ...
                                          ,'sheet_nr',sheet_nr ...
                                          ,'sheet_name',sheet_name ...
                                          ,'autofit',autofit);
    end
        
%=============================
% Fehler
%=============================
    otherwise

    s_e = varargin{1};
    tdum = sprintf('%s: type <%s> nicht gültig',mfilename,s_e.ascii_file)    
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
            text     = text(ncols+1:length(ncols));
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
        