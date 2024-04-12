function par = ds_set_par_single(par,val,vname,group,unit,comment)
%
% Setzt für  die Paarmeterstruktur ds eine Single-Parameter
%  
% par = ds_set_par_single(par,val,vname,group,unit,comment)
%
% par           Parameterstruktur (par = struct([]) möglich)
% val           numericscher Einzelwert
% name          Name der Variablen
% group         Gruppennamen (wenn weitere Hierachien dann im string mi '.'
%               trennen (default: '')
% unit          Einheit (default: '')
% comment           Kommentar (default: '')


%Übergabeparameter überprüfen
%============================

if( ~isstruct(par) )    
    error('%s: 1. Parameter muß eine Strukctur sein (z.B. p=struct([]))',mfilename)
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

if( ~exist('group','var') || ~ischar(group) )
    group = '';
end
if( ~exist('unit','var') || ~ischar(unit) )
    unit = '';
end
if( ~exist('comment','var') || ~ischar(comment) )
    comment = '';
end


%Parameterstruktur erstellen:
%============================

par = ds_set_par(par,'group',group,'name',vname,'val',val(1),'unit',unit,'com',comment);



    