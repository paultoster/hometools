function par = ds_set_par_1dtable(par,name,group,comment ...
                                 ,xname,xvec,xunit,xcom ...
                                 ,yname,yvec,yunit,ycom)
%
% Setzt f�r  die Paarmeterstruktur ds eine 1d-Tabelle-Parameter
%  
% par = ds_set_par_1dtable(par,name,group,comment ...
%                             ,xname,xvec,xunit,xcom ...
%                             ,yname,yvec,yunit,ycom)
%
% par           struct Parameterstruktur (par = struct([]) m�glich)
% name          char   Name der Variablen
% group         char   Gruppennamen (wenn weitere Hierachien dann im string mi '.'
% comment       char   Kommentar
% xname         char   Name des x-Vektors
% xvec          double x-Vektor (mu� monotonsteigend sein)
% xunit         char   Einheit x-Vektor 
% xcom          char   Kommentar
% yname         char   Name des y-Vektors
% yvec          double y-Vektor (mu� gleichlag xvec sein)
% yunit         char   Einheit y-Vektor 
% ycom          char   Kommentar


%�bergabeparameter �berpr�fen
%============================

if( ~exist('ycom','var') || ~ischar(ycom) )
    ycom = '';
end

if( ~isstruct(par) )    
    error('%s: 1. Parameter mu� eine Strukctur sein (z.B. p=struct([]))',mfilename)
end

if( ~exist('name','var') || ~ischar(name) )
    
    error('2. Parameter Name der Variable mu� char sein !!!');
end
if( ~exist('group','var') || ~ischar(group) )
    
    error('3. Parameter group mu� char z.B. ''tmc.channel1'' sein !!!');
end
if( ~exist('comment','var') || ~ischar(comment) )
    
    error('4. Parameter comment mu� char sein !!!');
end

if( ~exist('xname','var') || ~ischar(xname) )
    
    error('5. Parameter xname mu� char sein !!!');
end
if( ~exist('xvec','var') || ~isnumeric(xvec) )
    
    error('6. Parameter xvec mu� numerisch sein !!!');
end
if( ~is_monoton_steigend(xvec) )
    
    error('6. Parameter xvec mu� monoton steigend sein')
end
if( ~exist('xunit','var') || ~ischar(xunit) )
    
    error('7. Parameter xunit mu� char sein !!!');
end
if( ~exist('xcom','var') || ~ischar(xcom) )
    
    error('8. Parameter xcom mu� char sein !!!');
end
if( ~exist('yname','var') || ~ischar(yname) )
    
    error('9. Parameter yname mu� char sein !!!');
end
if( ~exist('yvec','var') || ~isnumeric(yvec) )
    
    error('10. Parameter yvec mu� numerisch sein !!!');
end
if( length(xvec) ~= length(yvec) )
    
    error('10. Parameter yvec(%i) mu� glech lange xvec(%i) sein',length(yvec),length(xvec))
end
if( ~exist('yunit','var') || ~ischar(yunit) )
    
    error('11. Parameter yunit mu� char sein !!!');
end
if( ~exist('ycom','var') || ~ischar(ycom) )
    
    error('12. Parameter ycom mu� char sein !!!');
end


%Parameterstruktur erstellen:
%============================

par = ds_set_par(par,'group',group,'name',name,'com',comment ...
                ,'xname',xname,'xval',xvec,'xunit',xunit,'xcom',xcom ...
                ,'yname',yname,'yval',yvec,'yunit',yunit,'ycom',ycom);



    