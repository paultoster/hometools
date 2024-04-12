function inp = ds_set_inp_single(inp,val,vname,unit,comment)
%
% Setzt für  die Inputstruktur ds eine Single-Wert
% im Gegensatz zur Parameterstruktur gibt es keine Untergruppen
%  
% inp = ds_set_inp_single(inp,val,vname,unit,comment)
%
% inp           inputstruktur
% val           numericscher Einzelwert
% name          Name der Variablen
% unit          Einheit (default: '')
% comment       Kommentar (default: '')


%Übergabeparameter überprüfen
%============================

if( ~isstruct(inp) )    
    error('%s: 1. Parameter muß eine Strukctur sein (z.B. inp=struct([]))',mfilename)
end
if( ischar(val) )
    v = str2num(val);
    if( isempty(v) )
        error('%s: 2. Parameter ist ein char: <%s> und kann nicht numerisch gewandelt werden',mfilename,val)
    else
        val = v;
    end
end
if( ~isnumeric(val) )
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


%Parameterstruktur erstellen:
%============================

inp = ds_set_inp(inp,'name',vname,'val',val(1),'unit',unit,'com',comment);



    