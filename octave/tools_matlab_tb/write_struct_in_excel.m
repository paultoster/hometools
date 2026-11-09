function [okay,s_e] = write_struct_in_excel(varargin)
%
% [okay,s_e] = write_struct_in_excel('struct',S,['name','test'])
%
% Ausgabe Struktur, bisher nur char und single-Werte
%
S        = [];
filename = 'excel_out';

i = 1;
while( i+1 <= length(varargin) )

    c = lower(varargin{i});
    switch c
        case 'struct'
            S = varargin{i+1};
        case {'name','filename'}
            filename = varargin{i+1};
        otherwise

            error('%s: Attribut <%s> nicht okay',mfilename,varargin{i})

    end
    i = i+2;
end

if( isempty(S) )
    fprintf('Struktur ist leer, nichts zu schreiben')
    return
end
if( ~isstruct(S) )
    error('Vorgegebenener Parameter S ist keine Struktur')
end

% Datei öffnen
%=============
[okay,s_e] = ausgabe_excel('init','name',filename,'visible',1);
if( ~okay )
    
    error('Datei <%s> konnte nicht erstellt werden',filename)
end

% Erste Ebene ausgeben
%=====================
sheetnr = 1;
sheetname = 'main';
okay = write_struct_in_excel_next(s_e,S,sheetnr,sheetname);
if( okay )
    % Datei speichern
    [okay,s_e] = ausgabe_excel('save',s_e,'name',filename);
end

function okay = write_struct_in_excel_next(s_e,S,sheetnr,sheetname)


% Typen prüfen
% nur char und single Werte bisher ausgeben
%==========================================
cfields = fieldnames(S);
sfields = [];
ss      = [];
for i=1:length(cfields)

    n = length(sfields);
    if( ischar(S(1,1).(cfields{i})) )
        sfields(n+1).name = cfields{i};
        sfields(n+1).type = 'char';
    elseif( isnumeric(S(1,1).(cfields{i})) && length(S(1,1).(cfields{i})) == 1 )
        sfields(n+1).name = cfields{i};
        sfields(n+1).type = 'single';
    elseif( isstruct(S(1,1).(cfields{i})) )
        n = length(ss);
        ss(n+1).name = cfields{i};
        ss(n+1).type = 'struct';        
    end
end

% Sheet
%======
[okay,s_e] = ausgabe_excel('sheet',s_e,'sheet_nr',sheetnr,'sheet_name',sheetname);
if( ~okay )
    return
end

% Title
%======
irow = 1; 
[okay,s_e] = ausgabe_excel('val',s_e,'col',1,'row',irow,'val','n');
if( ~okay )
    return
end
[okay,s_e] = ausgabe_excel('val',s_e,'col',2,'row',irow,'val','m');
if( ~okay )
    return
end
for i=1:length(sfields)
    
	[okay,s_e] = ausgabe_excel('val',s_e,'col',i+2,'row',1,'val',sfields(i).name);
    if( ~okay )
        return
    end
end

[n,m]   = size(S);
for i=1:n
    for j=1:m

        % Werte
        %======
        irow = irow + 1;
        [okay,s_e] = ausgabe_excel('val',s_e,'col',1,'row',irow,'val',i);
        if( ~okay )
            return
        end
        [okay,s_e] = ausgabe_excel('val',s_e,'col',2,'row',irow,'val',j);
        if( ~okay )
            return
        end
        for k=1:length(sfields)

            [okay,s_e] = ausgabe_excel('val',s_e,'col',k+2,'row',irow,'val',S(i,j).(sfields(k).name));
            if( ~okay )
                return
            end
        end
    end
end

[okay,s_e] = ausgabe_excel('format',s_e,'col_width','auto','row_height','auto');

if( ~isempty(ss) )
    for i=1:n
        for j=1:m
            % Strukturen
            %===========
            for k=1:length(ss)

                sheetnr = sheetnr+1;
                okay = write_struct_in_excel_next(s_e,S(i,j).(ss(k).name),sheetnr,ss(k).name);
                if( ~okay )
                    return
                end
            end
        end
    end
end
