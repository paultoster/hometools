function inp = ds_set_inp_1dtable(inp,name,comment ...
                                 ,xname,xvec,xunit,xcom ...
                                 ,yname,yvec,yunit,ycom)
%
% Setzt f¸r  die Inputstruktur ds eine 1d-Tabelle-Wert
% im Gegensatz zur Parameterstruktur gibt es keine Untergruppen
%  
% inp = ds_set_inp_1dtable(inp,name,group,comment ...
%                             ,xname,xvec,xunit,xcom ...
%                             ,yname,yvec,yunit,ycom)
%
% inp           struct Parameterstruktur (inp = struct([]) mˆglich)
% name          char   Name der Variablen
% comment       char   Kommentar
% xname         char   Name des x-Vektors
% xvec          double x-Vektor (muﬂ monotonsteigend sein)
% xunit         char   Einheit x-Vektor 
% xcom          char   Kommentar
% yname         char   Name des y-Vektors
% yvec          double y-Vektor (muﬂ gleichlag xvec sein)
% yunit         char   Einheit y-Vektor 
% ycom          char   Kommentar


%‹bergabeparameter ¸berpr¸fen
%============================

if( ~exist('ycom','var') || ~ischar(ycom) )
    ycom = '';
end

if( ~isstruct(inp) )    
    error('%s: 1. Parameter muﬂ eine Strukctur sein (z.B. p=struct([]))',mfilename)
end

if( ~exist('name','var') || ~ischar(name) )
    
    error('2. Parameter Name der Variable muﬂ char sein !!!');
end
if( ~exist('comment','var') || ~ischar(comment) )
    
    error('4. Parameter comment muﬂ char sein !!!');
end

if( ~exist('xname','var') || ~ischar(xname) )
    
    error('5. Parameter xname muﬂ char sein !!!');
end
if( ~exist('xvec','var') || ~isnumeric(xvec) )
    
    error('6. Parameter xvec muﬂ numerisch sein !!!');
end
if( ~is_monoton_steigend(xvec) )
    
    error('6. Parameter xvec muﬂ monoton steigend sein')
end
if( ~exist('xunit','var') || ~ischar(xunit) )
    
    error('7. Parameter xunit muﬂ char sein !!!');
end
if( ~exist('xcom','var') || ~ischar(xcom) )
    
    error('8. Parameter xcom muﬂ char sein !!!');
end
if( ~exist('yname','var') || ~ischar(yname) )
    
    error('9. Parameter yname muﬂ char sein !!!');
end
if( ~exist('yvec','var') || ~isnumeric(yvec) )
    
    error('10. Parameter yvec muﬂ numerisch sein !!!');
end
if( length(xvec) ~= length(yvec) )
    
    error('10. Parameter yvec(%i) muﬂ glech lange xvec(%i) sein',length(yvec),length(xvec))
end
if( ~exist('yunit','var') || ~ischar(yunit) )
    
    error('11. Parameter yunit muﬂ char sein !!!');
end
if( ~exist('ycom','var') || ~ischar(ycom) )
    
    error('12. Parameter ycom muﬂ char sein !!!');
end


%Parameterstruktur erstellen:
%============================

inp = ds_set_inp(inp,'name',name,'com',comment ...
                ,'xname',xname,'xval',xvec,'xunit',xunit,'xcom',xcom ...
                ,'yname',yname,'yval',yvec,'yunit',yunit,'ycom',ycom);



    