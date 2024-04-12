function [d,u,h] = import_excel_by_name(filename,sheet_num_name,c_name,unit_to_read)
%
% [d,u,h] = import_excel_by_name(filename,sheet_num_name,c_name,unit_to_read)
%
% Sucht durch Namen angegebene Spalten und liest Tabelle ein:
%
% filename          'char'          Name der Datei
% sheet_num_name    'char'          Sheetname
%                   'double'        Nummer der des Sheets beginnen mit 1
% c_name            'cell'          Liste von Namen die gelesen werden sollen
%                                   in beliebiger  Zeile und Spalte. Nach
%                                   finden des Namens wird 
% unit_to_read      'double'        = 0 kein Einheit vorhanden
%                                   = 1 Eiheit einzeile unetr dem Namen
%
% d                 'struct'        Struktur mit n-Spaltenvektoren mit den ausgelesenen Daten
% u                 'struct'        Struktur mit n-Variablen mit den Einheiten
% h                 'cell'          Header
%==========================================================================

if( nargout == 0 )
    error('Mindestens eine Variable zur Ausgabe bereitstellen')
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

if( ~exist('unit_to_read','var') )
    
    unit_to_read = 0;  % keine Units angeben
end

%==========================================================

if( ~exist(filename,'file') )
    
    text = sprintf('File: %s existiert nicht ',filename);
    error(text)
end

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

[num,text,raw] = xlsread(filename,sheet);

[n,m] = size(raw);

for ic = 1:length(c_name)
    found_flag = 0;
    for j=1:m
        for i=1:n
        
            if( ischar(raw{i,j}) && strcmp(raw{i,j},c_name{ic}) )
                
                found_flag = 1;
                break;
            end
        end
        if( found_flag )
            break;
        end
    end
    
    if( ~found_flag )
        
        warning('Die Variable %s konnte in <%s> nicht gefunden werden',c_name{ic},filename)
    else
        c_name{ic} = str_cut_f(c_name{ic},' ');
        c_name{ic} = str_cut_f(c_name{ic},')');
        c_name{ic} = str_cut_f(c_name{ic},'(');
        if( unit_to_read && nargout >= 1 && i+1 <= n && ischar(raw{i+1,j}) )
            
            u.(c_name{ic}) = raw{i+1,j};
            i = i+1;
        else
            u.(c_name{ic}) = '';
        end
        vec = [];
        for k=i+1:n
            if( isnumeric(raw{k,j}) )
                vec = [vec;raw{k,j}];
            end
        end
        
        iend = length(vec);
        for( ivec = 1:iend )
            
            if( isnan(vec(ivec)) )
                iend = ivec-1;
                break;
            end
        end
        if( iend > 1 )
            d.(c_name{ic}) = vec(1:iend);
        else
            warning('Die Variable %s in <%s> konnte nicht glesen werden (NaN)',c_name{ic},filename)
        end
            
        
        
        
    end
end
if( nargout >= 3 )
    h{1}=[datestr(now),' read-xls-data(import_excel_by_name)'];
end
if( nargout >= 2 && ~exist('u','var') )
    u = 0;
end
if( nargout >= 1 && ~exist('d','var') )
    d = 0;
end

