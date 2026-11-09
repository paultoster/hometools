function par = ds_set_par_vector(par,vec,vname,group,unit,comment)
%
% Setzt für  die Paarmeterstruktur ds eine Vektor-Parameter
%  
% par = ds_set_par_vector(par,vec,vname,group,unit,comment)
%
% par           Parameterstruktur (par = struct([]) möglich)
% vec           numericscher Vektor
% name          Name der Variablen
% group         Gruppennamen (wenn weitere Hierachien dann im string mi '.'
%               trennen (default: '')
% unit          Einheit (default: '')
% comment       Kommentar (default: '')


%Übergabeparameter überprüfen
%============================

if( ~isstruct(par) )    
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

par = ds_set_par(par,'group',group,'name',vname,'vec',vec,'unit',unit,'com',comment);



    