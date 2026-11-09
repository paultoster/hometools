function par = ds_set_par_string(par,str,vname,group,comment)
%
% Setzt für  die Paarmeterstruktur ds eine String-Parameter
%  
% par = ds_set_par_string(par,str,vname,group,comment)
%
% par           Parameterstruktur ( Es kann struct([] verwendet werden ) )
% str           String-Wert
% name          Name der Variablen
% group         Gruppennamen (wenn weitere Hierachien dann im string mi '.'
%               trennen (default: '')
% comment           Kommentar (default: '')


%Übergabeparameter überprüfen
%============================

if( ~isstruct(par) )    
    error('%s: 1. Parameter muß eine Strukctur sein (z.B. p=struct([]))',mfilename)
end
if( ~ischar(str) )
        error('%s: 2. Parameter (String-Wert) ist kein char: <%s> ',mfilename,val)
end
if( ~ischar(vname) )
        error('%s: 3. Parameter ist Varuiablenname, muß char sein',mfilename)
end

if( ~exist('group','var') || ~ischar(group) )
    group = '';
end
if( ~exist('comment','var') || ~ischar(comment) )
    comment = '';
end


%Parameterstruktur erstellen:
%============================

par = ds_set_par(par,'group',group,'name',vname,'val',str,'com',comment);



    