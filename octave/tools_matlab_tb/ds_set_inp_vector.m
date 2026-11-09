function inp = ds_set_inp_vector(inp,vec,vname,unit,comment)
%
% Setzt für  die Inputstruktur ds eine Vektor-Wert
% im Gegensatz zur Parameterstruktur gibt es keine Untergruppen
%  
% inp = ds_set_inp_vector(inp,vec,vname,group,unit,comment)
%
% inp           Parameterstruktur (inp = struct([]) möglich)
% vec           numericscher Vektor
% name          Name der Variablen
% unit          Einheit (default: '')
% comment       Kommentar (default: '')


%Übergabeparameter überprüfen
%============================

if( ~isstruct(inp) )    
    error('%s: 1. Parameter muß eine Strukctur sein (z.B. p=struct([]))',mfilename)
end
if( ischar(vec) )
    v = str2num(vec);
    if( isempty(v) )
        error('%s: 2. Parameter ist ein char: <%s> und kann nicht numerisch gewandelt werden',mfilename,vec)
    else
        vec = v;
    end
end
if( ~isnumeric(vec) )
        error('%s: 2. Parameter ist Wert, muß ein numerischer Wert sein',mfilename)
end
if( ~ischar(vname) )
        error('%s: 3. Parameter ist Varuiablenname, muß char sein',mfilename)
end

if( ~exist('unit','var') || ~ischar(unit) )
    unit = '';
end
if( ~exist('comment','var') || ~ischar(comment) )
    comment = '';
end


%Inputstruktur erstellen:
%============================

inp = ds_set_inp(inp,'name',vname,'vec',vec,'unit',unit,'com',comment);



    