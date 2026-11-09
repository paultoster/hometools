function [found,pf] = find_item_in_struct(p,item,deep)
%
% [okay,pf] = find_struct_with_item(p,item,[deep=0]);
%
% Suche in der Struktur nach dem vorgegebenen item
% p     struct      Die zu durchsuchende Struktur
% item  char        Den zu sucheneden Name
% deep  double      0= nur in der ersten Ebene suchen
%                   1= alle Ebenen suchen bis erste auftritt
%
% found double      1: ist gefunden
%                   0: ist nicht gefunden
% pf                gefundene übergeordnete Struktur#
found = 0;

if( ~exist('deep','var') )
    
    deep = 0;
end

liste = fieldnames(p);

for i=1:length(liste)
    
    if( strcmp(liste{i},item) )
        found = 1;
        pf = p;
        return;
    end
end
if( deep )
    for i=1:length(liste)
    
        p1 = p.(liste{i});
        if( isstruct(p1) )
            [found,pf] = find_struct_with_item(p1,item,deep);
            if( found )
                return;
            end
        end
    end
end



