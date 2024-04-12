function [d,u,h] = import_excel(filename,sheet_num_name,name_flag,unit_flag)
%
% Liest eine gesamte Tabelle aus excel aus (erste Zeile Name, zweite Zeile Unit):
%
% filename          'char'          Name der Datei
% sheet_num_name    'char'          Sheetname
%                   'double'        Nummer der des Sheets beginnen mit 1
% name_flag         'double'        Name soll ausgelesen werden und in d-Struktur als VArname verwenden
%                                   (erste Zeile)
% unit_flag         'double'        Unit auslesen und in u-Struktur reinschreiben
%
% d                 'struct'        Struktur mit n-Spaltenvektoren mit den ausgelesenen Daten
% u                 'struct'        Struktur mit n-Variablen mit den Einheiten
% h                 'cell'          Header
%==========================================================================
if( ~exist('sheet_num_name','var') )
    
    sheet_num_name = 1;  % 
end
if( ~exist('name_flag','var') )
    
    name_flag = 0;  % kein Name angeben
end

if( ~exist('unit_flag','var') )
    
    unit_flag = 0;  % keine Units angeben
end

if( ~name_flag )
    unit_flag = 0;
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

[num,text] = xlsread(filename,sheet);

[n_num,m_num] = size(num);
[n_text,m_text] = size(text);

m_end = min(m_num,m_text);

% Erste Zeile mit Namen suchen
i_name = 1e10;
for j=1:m_text

    for i=1:n_text
        
        if( length(text{i,j}) > 0 )
            
            i_name = min(i,i_name);
            break
        end
    end
end

% Daten der Struktur zuordnen
if( name_flag & i_name < 1e10 )
    
    for j=1:m_end

        tt = change_varname(text{i_name,j});
        d.(tt) = num(:,j);
        
        if( unit_flag )            
            u.(tt) = text(i_name+1,j);
        end
    end
else
    for j=1:m_end
     
        name = ['sig',num2str(j)];
        d.(name) = num(:,j);

    end
end

h{1}=[datestr(now),' read-xls-data(import_excel)'];

if( ~exist('d','var') )
    d=0;
end
if( ~exist('u','var') )
    u=0;
end

