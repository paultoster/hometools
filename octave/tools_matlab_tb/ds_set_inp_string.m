function inp = ds_set_inp_string(inp,str,vname,comment)
%
% Setzt für  die Inputstruktur ds eine String-Wert
% im Gegensatz zur Parameterstruktur gibt es keine Untergruppen
%  
% inp = ds_set_inp_single(inp,str,vname,group,unit,comment)
%
% inp           Parameterstruktur ( Es kann struct([] verwendet werden ) )
% str           String-Wert
% name          Name der Variablen
% comment           Kommentar (default: '')


%Übergabeinpameter überprüfen
%============================

if( ~isstruct(inp) )    
    error('%s: 1. Parameter muß eine Strukctur sein (z.B. p=struct([]))',mfilename)
end
if( ~ischar(str) )
        error('%s: 2. Parameter (String-Wert) ist kein char: <%s> ',mfilename,val)
end
if( ~ischar(vname) )
        error('%s: 3. Parameter ist Varuiablenname, muß char sein',mfilename)
end

if( ~exist('comment','var') || ~ischar(comment) )
    comment = '';
end


%Parameterstruktur erstellen:
%============================

inp = ds_set_inp(inp,'name',vname,'val',str,'com',comment);



    