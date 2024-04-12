function [d,u,h] = import_excel_by_range(filename,sheet_num_name,c_name,c_range,c_unit)
%
% [d,u,h] =
% import_excel_by_range(filename,sheet_num_name,c_name,c_range,c_unit)
%
% Liest durch angegebenen Range Vektoren aus einer Tabelle aus excel aus:
%
% filename          'char'          Name der Datei
% sheet_num_name    'char'          Sheetname
%                   'double'        Nummer der des Sheets beginnen mit 1
% c_name            'cell'          Liste von Namen die gelesen werden sollen
%                                   z.B. {'ndreh','pme','mp'}
% c_range           'cell'          Liste mit den Bereichen
%                                   z.B. {'F5:F392','G5:G392','H5:H392'}
% c_unit            'cell'          Liste mit EInheiten, wenn nicht vorhanden , dann leer
%                                   z.B {'U/min','bar','kg/h'}
% d                 'struct'        Struktur mit n-Spaltenvektoren mit den ausgelesenen Daten
% u                 'struct'        Struktur mit n-Variablen mit den Einheiten
% h                 'cell'          Header
%==========================================================================

if( nargout == 0 )
    error('Mindestens eine Variable zur Ausgabe bereitstellen')
end

if( ~exist(filename,'file') )
    
    text = sprintf('File: %s existiert nicht ',filename);
    error(text)
end

if( ~exist('sheet_num_name','var') )
    
    sheet_num_name = 1;  % 
end

if( ~exist('c_name','var') )
    
    error('kein Name ist angegeben')
else
    if( ischar(c_name) )
        c_name = {c_name};
    end
    if( ~iscell(c_name) )
        error('c_name muss ein cell-array mit char sein')
    end
end

if( ~exist('c_range','var') )
    
    error('kein Range ist angegeben')
else
    if( ischar(c_range) )
        c_range = {c_range};
    end
    if( ~iscell(c_range) )
        error('c_range muss ein cell-array mit char sein')
    end
end

nvek = min(length(c_name),length(c_range));
if( ~exist('c_unit','var') )
    
    for i=1:nvek
        c_unit{i} = '';
    end
        
else
    if( ischar(c_unit) )
        c_unit = {c_unit};
    end
    if( ~iscell(c_unit) )
        error('c_range muss ein cell-array mit char sein')
    end
    if( length(c_unit) < nvek )

        for i=length(c_unit)+1:nvek
            c_unit{i} = '';
        end
    end
        
end


%==========================================================


if( isnumeric(sheet_num_name) )
    
    sheet_num_name = round(sheet_num_name);
    
   [type, sheets]=xlsfinfo(filename) ;
   
   if( sheet_num_name > length(sheets) )
        text = sprintf('Das %i. sheet existiert in File: % nicht ',sheet_num_name,filename);
        error(text)
   else
       sheet = sheets{sheet_num_name};
   end
else
   
   [type, sheets]=xlsfinfo(filename) ;
   sheet = '';
    for i=1:length(sheets)
        
        if( strcmp(sheets{i},sheet_num_name) )            
            sheet = sheet_num_name;
        end
    end
    
    if( length(sheet) == 0 )
        text = sprintf('Der sheet_name %s existiert in File: % nicht ',sheet_num_name,filename);
        error(text)
    end
end

%
% Daten einlesen
%

for ivek = 1:nvek
    
    [num,text,raw] = xlsread(filename,sheet,c_range{ivek});
    
    % Suche nach einer Angabe von cellarray
    i0 = str_find_f(c_name{ivek},'{','vs');
    
    % wenn nicht gefunden normal einlesen
    if( i0 == 0 )
        d.(c_name{ivek}) = num;
        u.(c_name{ivek}) = c_unit{ivek}; 
        
    else
        
        if( i0 == 1 )
            warning('import_excel_by_range: Name: <%s> bzw. <%s> konnte als cellaray nicht richtig verarbeitet werden',c_name{ivek},c_name{ivek}(1:i0-1));
        end
        % Wenn gefunden cellarray suchen
        if( ivek > 1 && struct_find_f(d,c_name{ivek}(1:i0-1)) ) % d schon vorhanden und structelement vorhanden
            try
                eval([c_name{ivek}(1:i0-1),'=d.',c_name{ivek}(1:i0-1),';']);
                eval(['i1=iscell(',c_name{ivek}(1:i0-1),');']);
                if( i1 == 0 )
                    eval([c_name{ivek}(1:i0-1),'={',c_name{ivek}(1:i0-1),'};']);
                end
                    
            catch
                warning('import_excel_by_range: Name: <%s> bzw. <%s> konnte als cellaray nicht richtig verarbeitet werden',c_name{ivek},c_name{ivek}(1:i0-1));
            end
        end
        
        % Wert cellarray zuordnen
        try
            eval([c_name{ivek},'=num;']);
        catch
            warning('import_excel_by_range: Name: <%s> bzw. <%s> konnte als cellaray nicht richtig verarbeitet werden',c_name{ivek},c_name{ivek}(1:i0-1));
        end
        
        % Zurückschreiben
        try
            eval(['d.',c_name{ivek}(1:i0-1),'=',c_name{ivek}(1:i0-1),';'])
        catch
            warning('import_excel_by_range: Name: <%s> bzw. <%s> konnte als cellaray nicht richtig verarbeitet werden',c_name{ivek},c_name{ivek}(1:i0-1));
        end

        u.(c_name{ivek}(1:i0-1)) = c_unit{ivek};
        
    end
        
        
end
if( nargout >= 3 )
    h{1}=[datestr(now),' read-xls-data(import_excel_by_range)'];
end
if( nargout >= 2 && ~exist('u','var') )
    u = 0;
end
if( nargout >= 1 && ~exist('d','var') )
    d = 0;
end

