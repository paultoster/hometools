function [okay,Excel]=excel_com_f(type,varargin)
%
% Kommunikation zu Excel
%
% [okay,Excel] = excel_com_f('open','name',filename,['visible',0]);
%                                       Öffnen der Datei und eine Seite anlegen
% [okay,Excel] = excel_com_f('close',Excel,'name',filename);
%                                       Speichert und schließt Datei
% [okay,Excel] = excel_com_f('save',Excel,'name',filename);
%                                       Speichert Datei und läßt Datei offen
% [okay,Excel] = excel_com_f('val',Excel,'col',vcol,'row',vrow,'val',value)
% Schreibt Werte in die Zelle:
% icol          double          Spalte kann Vektor mit n-Spalten sein
% vrow          double          Zeile kann Vektor mit n-Zeilen sein
% value         double,char     Wert, der eingeschrieben wird als string oder
%                               double-Wert
% font_name     char            Fontname
% font_size     double          Fontgröße
% 
% [okay,Excel] = excel_com_f('vec',Excel,'icol',icol,'irow',irow,'vec',vec)
% Schreibt Vector in die Zelle:
% icol          double          Start-Spalte
% irow          double          Star-Zeile
% vec           double,cell     Vector
% font_name     char            Fontname
% font_size     double          Fontgröße
% 
% [okay,Excel] = excel_com_f('cat',Excel,'col',vcol,'row',row,'val',value)
% Zellen verbinden und Wert schreiben
% vcol          double array    Spaltenbeginn und Ende der Zellen, die
%                               zusammengeführt werden [1,10]
% vrow          double array    Zeilenbeginn und Ende der Zellen, die
%                               zusammengeführt werden [3,3]
% value         double,char     Wert, der eingeschrieben wird als string oder
%                               double-Wert
% [okay,Excel] = excel_com_f('format',Excel,'col',vcol,'row',vrow,['color','orange'],
%                          ['col_width',10],['font_name','Courier New'],['font_size',10])
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
%               char            'auto'  automatisch
% border        char            'all'
% font_name     char            Fontname
% font_size     double          Fontgröße
% font_form     char            'bold'
% orientation   double          Schriftausrichtung in grad
% number_format char            '0.00' Zwei tellen hinter dem Komma
% number_format char            '#.##0,00' Zwei Stellen hinter dem Komma und Punkt bei tausend
%
% [okay,Excel] = excel_com_f('sheet',Excel,['sheet_nr',nr],['sheet_name',name])
% Tabelle aussuchen
%
% sheet_nr      double          Auswahl der Tabelle
% sheet_name    char            Wenn sheet_nr nicht vorhanden, dann Auswahl über Name
%
% 
punctuation_excel = ',';

char_new_line = char(13);
char_new_page = char(12);

okay = 1;
%=============
% Datei öffnen
%=============
type = lower(type);
if( strcmp(type,'open') )
    
    filename  = '';
    visible   = 0;
    i = 1;
    while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'name'
                filename = varargin{i+1};
            case 'visible'
                visible = varargin{i+1};
            otherwise
                error('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
                
        end
        i = i+2;
        
        
        
        
    end
    
    % Exceldatei öffnen
    Excel = actxserver('Excel.Application'); 

    if( visible )
        Excel.Visible = 1; 
    end
    Excel.Workbooks.Add();
    

%    Excel.ActiveDocument.Content.Font.Name = font_name;
%    Excel.ActiveDocument.Content.Font.Size = font_size;
    if( ~isempty(filename) )
        Excel.ActiveWorkbook.SaveAs(filename);
    end
%=================
% Datei speichern
%=================
elseif( strcmp(type,'save')  )
    
    Excel = varargin{1};

    filename  = ''; %fullfile(pwd,'erg.doc');
    i = 2;
    while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'name'
                filename = varargin{i+1};
            otherwise
                error('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type)
                
        end
        i = i+2;
    end
    if( strcmpi(class(Excel),'com.excel_application') )
        if( ~isempty(filename) )
            Excel.ActiveWorkbook.SaveAs(filename);
        end
        
    else
        error('%s: type = <%s>, Excel ist kein Klasse com.excel_application, sondern <%s>!!!',mfilename,type,class(Excel));
    end

elseif( strcmp(type,'close') )
    
    Excel = varargin{1};

    filename  = ''; %fullfile(pwd,'erg.doc');
    i = 2;
    while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'name'
                filename = varargin{i+1};
            otherwise
                error('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type)
                
        end
        i = i+2;
    end
    if( strcmpi(class(Excel),'com.excel_application') )
        if( strcmp(type,'close') )
            Excel.ActiveWorkbook.Close;
            Excel.Quit;
            delete(Excel);
            Excel = 0;
        end
        
    else
        error('%s: type = <%s>, Excel ist kein Klasse com.excel_application, sondern <%s>!!!',mfilename,type,class(Excel));
    end
%==================
% Wert einschreiben
%==================
elseif( strcmp(type,'val') )
    
    Excel = varargin{1};
    text = varargin{2};
    if( ~ischar(text) )
        error('%s: type = <%s>, Text ist keine string, sondern Klasse <%s>!!!',mfilename,type,class(text));
    end

    vcol = [1,1];
    vrow = [1,1];
    val  = 0;
    val_set = 0;
    font_name = '';
    font_size = -1;
    
    sheet_nr   = 0;
    sheet_name = '';
    
    i = 2;
    while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'col'
                vcol = varargin{i+1};
            case 'row'
                vrow = varargin{i+1};
            case 'val'
                val = varargin{i+1};
                val_set = 1;
            case 'font_name'
                font_name = varargin{i+1};
            case 'font_size'
                font_size = varargin{i+1};
            case 'sheet_nr'
                sheet_nr = varargin{i+1};
            case 'sheet_name'
                sheet_name = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
                error(tdum)
                
        end
        i = i+2;
        
    end

    if( strcmpi(class(Excel),'com.excel_application') )
                
        % Zeilen und Reihen auswerten
        if( isempty(vcol) )
            error('%s: type = <%s>, vcol hat die Länge 0 !!!',mfilename,type);
        end
        if( isempty(vrow) )
            error('%s: type = <%s>, vrow hat die Länge 0 !!!',mfilename,type);
        end
    
        if( val_set )
            ival = 0;
            for icol=1:length(vcol)
        
                ic = vcol(icol);
        
                for irow=1:length(vrow)
            
                    ir = vrow(irow);
            
                    % Range von A1-Zn festlegen char('@'+1) => 'A', char('@'+26) =>
                    % 'Z'
                    range = [char('@'+min(26,round(ic))) ...
                            ,num2str(round(ir)) ...
                            ,':' ...
                            ,char('@'+min(26,round(ic))) ...
                            ,num2str(round(ir)) ...
                            ];
                        
                    % fontname
                    if( ~isempty(font_name) )
                        Excel.Range(range).Font.Name = font_name;
                    end
                    % fontsize
                    if( font_size > -1 )
                        Excel.Range(range).Font.Size = font_size;
                    end

                    if( ischar(val) )

                        Excel.Range(range).Value = val;
                    elseif( isnumeric(val) )

                        if( length(val) > 1 )
                            ival  = ival+1;
                            Excel.Range(range).Value = str_change_f(num2str( val(min(ival,length(val))) ),'.',punctuation_excel);
                        else
                            Excel.Range(range).Value = str_change_f(num2str( val ),'.',punctuation_excel);
                        end
                        
                    elseif( iscell(val) )
                        
                        ival  = ival + 1;
                        value = val{ival};
                    
                        if( ischar(value) )

                            Excel.Range(range).Value = value;
                        elseif( isnumeric(value) )

                            Excel.Range(range).Value = str_change_f(num2str( value ),'.',punctuation_excel);
                        end
                    end
                end
            end
        end
                        
    else
        error('%s: type = <%s>, Excel ist kein Klasse com.excel_application, sondern <%s>!!!',mfilename,type,class(Excel));
    end
%==================
% Vector einschreiben
%==================
elseif( strcmp(type,'vec') )
    
    Excel = varargin{1};
    text = varargin{2};
    if( ~ischar(text) )
        tdum = sprintf('%s: type = <%s>, Text ist keine string, sondern Klasse <%s>!!!',mfilename,type,class(text))
        error(tdum)
    end

    icol = 1;
    irow = 1;
    vec  = 0;
    val_set = 0;
    font_name = '';
    font_size = -1;
    
    i = 2;
    while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'icol'
                icol = varargin{i+1};
            case 'irow'
                irow = varargin{i+1};
            case 'vec'
                vec = varargin{i+1};
                val_set = 1;
            case 'font_name'
                font_name = varargin{i+1};
            case 'font_size'
                font_size = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
                error(tdum)
                
        end
        i = i+2;
        
    end

    if( strcmpi(class(Excel),'com.excel_application') )
                
        % Zeilen und Reihen auswerten
        if( icol <= 0 )
            tdum = sprintf('%s: type = <%s>, icol muß groeßer null sein !!!',mfilename,type);
            error(tdum)
        end
        if( irow == 0 )
            tdum = sprintf('%s: type = <%s>, irow muß groeßer null sein !!!',mfilename,type);
            error(tdum)
        end
    
        if( val_set )
            [nrow,ncol] = size(vec);
            
            % Range von A1-Zn festlegen char('@'+1) => 'A', char('@'+26) =>
            % 'Z'
            range = [char('@'+min(26,round(icol))) ...
                    ,num2str(round(irow)) ...
                    ,':' ...
                    ,char('@'+min(26,round(icol+ncol-1))) ...
                    ,num2str(round(irow+nrow-1)) ...
                    ];
            % convert input to cell array of data.
            if iscell(vec)
                A=vec;
            else
                A=num2cell(vec);
            end
            
            % Select range in worksheet.
            Select(Range(Excel,sprintf('%s',range)));
    
            set(Excel.selection,'Value',A);
            
            % fontname
            if( length(font_name) > 0 )
                Excel.Range(range).Font.Name = font_name;
            end
            % fontsize
            if( font_size > -1 )
                Excel.Range(range).Font.Size = font_size;
            end
        end
                        
    else
        tdum = sprintf('%s: type = <%s>, Excel ist kein Klasse com.excel_application, sondern <%s>!!!',mfilename,type,class(Excel))
        error(tdum)
    end
%=================
% Zellen verbinden
%=================
elseif( strcmp(type,'cat') )
    
    Excel = varargin{1};
    text = varargin{2};
    if( ~strcmp(class(text),'char') )
        tdum = sprintf('%s: type = <%s>, Text ist keine string, sondern Klasse <%s>!!!',mfilename,type,class(text))
        error(tdum)
    end

    vcol = [1,1];
    vrow = [1,1];
    i = 2;
    while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'col'
                vcol = varargin{i+1};
            case 'row'
                vrow = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type)
                error(tdum)
                
        end
        i = i+2;
        
    end

    % Zeilen und Reihen auswerten
    if( length(vcol) == 0 )
        tdum = sprintf('%s: type = <%s>, vcol hat die Länge 0 !!!',mfilename,type)
        error(tdum)
    elseif( length(vcol) == 1 )
        vcol = [vcol,vcol];
    end
    if( length(vrow) == 0 )
        tdum = sprintf('%s: type = <%s>, vrow hat die Länge 0 !!!',mfilename,type)
        error(tdum)
    elseif( length(vrow) == 1 )
        vrow = [vrow,vrow];
    end
    
    col_start = char('@'+vcol(1));
    col_end   = char('@'+vcol(2));
    
    % Range von A1-Zn festlegen char('@'+1) => 'A', char('@'+26) => 'Z'
    
    range = [char('@'+min(26,round(vcol(1)))) ...
            ,num2str(round(vrow(1))) ...
            ,':' ...
            ,char('@'+min(26,round(vcol(2)))) ...
            ,num2str(round(vrow(2))) ...
            ];
    
    if( strcmp(lower(class(Excel)),'com.excel_application') )
        
        Excel.Range(range).MergeCells = 1;
    else
        tdum = sprintf('%s: type = <%s>, Excel ist kein Klasse com.excel_application, sondern <%s>!!!',mfilename,type,class(Excel))
        error(tdum)
    end
%===================
% Zellen formatieren
%===================
elseif( strcmp(type,'format') )
    
    Excel = varargin{1};
    text = varargin{2};
    if( ~strcmp(class(text),'char') )
        tdum = sprintf('%s: type = <%s>, Text ist keine string, sondern Klasse <%s>!!!',mfilename,type,class(text))
        error(tdum)
    end

    vcol = [];
    vrow = [];
    color = '';
    col_width = -1;
    row_height = -1;
    border = '';
    font_name = '';
    font_size = -1;
    font_form = '';
    orientation = [];
    number_format = '';
    
    i = 2;
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
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type)
                error(tdum)
                
        end
        i = i+2;
        
    end

    if( ~strcmp(lower(class(Excel)),'com.excel_application') )
        tdum = sprintf('%s: type = <%s>, Excel ist kein Klasse com.excel_application, sondern <%s> (vielleicht nicht geöffnet)!!!',mfilename,type,class(Excel))
        error(tdum)
    end
    % Zeilen und Reihen auswerten
    if( length(vcol) == 0 )
        tdum = sprintf('%s: type = <%s>, vcol hat die Länge 0 !!!',mfilename,type)
        error(tdum)
    end
    if( length(vrow) == 0 )
        tdum = sprintf('%s: type = <%s>, vrow hat die Länge 0 !!!',mfilename,type)
        error(tdum)
    end
        
    % Farbe
    %======
    color_index = 0;
    if( length(color) > 0 )
        if( strcmp(lower(color),'orange') | (length(color) == 1 &  lower(color(1)) == 'o') )
            color_index = 46;
        elseif( strcmp(lower(color),'rot') | strcmp(lower(color),'red') | (length(color) == 1 &  lower(color(1)) == 'r') )
            color_index = 3;
        elseif( strcmp(lower(color),'grau') | strcmp(lower(color),'gray') | strcmp(lower(color),'grey') | (length(color) == 1 &  lower(color(1)) == 'g') )
            color_index = 15;
        elseif( strcmp(lower(color),'gelb') | strcmp(lower(color),'yellow')  | (length(color) == 1 &  lower(color(1)) == 'y') )
            color_index = 6;
        end
    end
    
    
    % Range von A1-Zn festlegen char('@'+1) => 'A', char('@'+26) => 'Z'
    for icol = 1:length(vcol)
        ic = vcol(icol);
        for irow = 1:length(vrow)
            ir = vrow(irow);
            
            range = [char('@'+min(26,round(ic))) ...
                    ,num2str(round(ir)) ...
                    ,':' ...
                    ,char('@'+min(26,round(ic))) ...
                    ,num2str(round(ir)) ...
                    ];
               
            % Farbe
            if( color_index > 0 )
                Excel.Range(range).Interior.ColorIndex = color_index;
            end
            % Spaltenbreite
            if( strcmp(class(col_width),'double') & col_width > -1 )
                Excel.Range(range).ColumnWidth = col_width;              
            end
            % Zeilenhöhe
            if( strcmp(class(row_height),'double') & row_height > -1 )
                Excel.Range(range).RowHeight = row_height;
            
            end
            
            % fontname
            if( length(font_name) > 0 )
                Excel.Range(range).Font.Name = font_name;
            end
            % fontsize
            if( font_size > -1 )
                Excel.Range(range).Font.Size = font_size;
            end
            
            if( strcmp(lower(font_form),'bold') )
                Excel.Range(range).Font.Bold = 1;
            end 

            % fontsize
            if( length(orientation) > 0 )
                Excel.Range(range).Orientation = orientation(1);
            end
            
            % Numberformat
            if( length(number_format) > 0 )
                Excel.Range(range).NumberFormat = number_format;
            end

        end
        
        
        range = [char('@'+min(26,round(vcol(1)))) ...
                ,num2str(round(vrow(1))) ...
                ,':' ...
                ,char('@'+min(26,round(vcol(length(vcol))))) ...
                ,num2str(round(vrow(length(vrow)))) ...
               ];
        % Automatische Anpassung Spalten
        if(strcmp(class(col_width),'char') & length(col_width) > 0 & lower(col_width(1)) == 'a' )
                Excel.Range(range).Columns.AutoFit;
        end
        % Automatische Anpassung Zeilen
        if(strcmp(class(row_height),'char') & length(row_height) > 0 & lower(row_height(1)) == 'a' )
                Excel.Range(range).Rows.AutoFit;
        end
        % Einfacher Rahmen
        if( length(border) > 0 & lower(border(1)) == 'a' )
                Excel.Range(range).Borders(1).LineStyle = 1;
        end
        
    end

%===================
% Tabelle auswählen
%===================
elseif( strcmp(type,'sheet') )
    
    Excel = varargin{1};
    text = varargin{2};
    if( ~strcmp(class(text),'char') )
        tdum = sprintf('%s: type = <%s>, Text ist keine string, sondern Klasse <%s>!!!',mfilename,type,class(text))
        error(tdum)
    end

    sheet_nr   = 0;
    sheet_name = '';
    autofit    = 0;
    
    i = 2;
    while( i+1 <= length(varargin) )
    
        switch lower(varargin{i})
            case 'sheet_nr'
                sheet_nr = varargin{i+1};
                if( ~isnumeric(sheet_nr) )
                   tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht char',mfilename,varargin{i},type);
                   error(tdum)
                end 
            case 'sheet_name'
                sheet_name = varargin{i+1};
                if( ~ischar(sheet_name) )
                   tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht char',mfilename,varargin{i},type);
                   error(tdum)
                end 
            case 'autofit'
                autofit = varargin{i+1};
            otherwise
                tdum = sprintf('%s: Attribut <%s> für type = ''%s'' nicht okay',mfilename,varargin{i},type);
                error(tdum);
                
        end
        i = i+2;
        
    end
    
    
    % Tabelle auswählen
    if( sheet_nr > 0  && isempty(sheet_name) ) % auswählen über Nummer

        % Get name of specified worksheet from workbook
        try
            TargetSheet = get(Excel.sheets,'item',sheet_nr);
        catch

            while( Excel.sheets.Count < sheet_nr)

                % find last sheet in worksheet collection
                lastsheet   = Excel.sheets.Item(Excel.sheets.Count);
                TargetSheet = Excel.sheets.Add([],lastsheet);
            end
        end

        % activate worksheet
        Activate(TargetSheet);
    elseif( sheet_nr == 0  && ~isempty(sheet_name) ) % auswählen über Name
        
        % Get name of specified worksheet from workbook
        try
            TargetSheet = get(Excel.sheets,'item',sheet_name);
        catch

            % find last sheet in worksheet collection
            lastsheet   = Excel.sheets.Item(Excel.sheets.Count);
            TargetSheet = Excel.sheets.Add([],lastsheet);
            set(TargetSheet,'Name',sheet_name);
        end

        % activate worksheet
        Activate(TargetSheet);
        
    elseif( sheet_nr > 0  && ~isempty(sheet_name) ) % auswählen über Nummer und umbenennen
        
        % Get name of specified worksheet from workbook
        try
            TargetSheet = get(Excel.sheets,'item',sheet_nr);
        catch

            while( Excel.sheets.Count < sheet_nr)

                % find last sheet in worksheet collection
                lastsheet   = Excel.sheets.Item(Excel.sheets.Count);
                TargetSheet = Excel.sheets.Add([],lastsheet);
            end
        end

        % umbenennen
        set(TargetSheet,'Name',sheet_name);
        % activate worksheet
        Activate(TargetSheet);
        
    end
    
    if( autofit )
        
        Excel.Cells.Select;
        Excel.Selection.Columns.AutoFit;
    end
end    
