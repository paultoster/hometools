function [c_names,icount] = str_split_quot(tt,delim,quot0,quot1,elim)
%
% [c_names,icount] = str_split_quot(tt,delim,quot0,quot1)
% [c_names,icount] = str_split_quot(tt,delim,quot0,quot1,elim)
%
% elim ~= 0     bereinigt Leerzellen (default: 0)
%
% Text wird nach delim gesplittet aber die quots werden beachtet, d.h.
% nicht gesplittet.
% Ausgabe cellarray mit den Textteilen

if( ~exist('elim','var') )
    elim = 0;
end
ifchar = 1;
fchar = char(ifchar);
while( strcmp(fchar,delim) | strcmp(fchar,quot0) |  strcmp(fchar,quot1) )
    ifchar = ifchar+1;
    fchar  = char(ifchar);
end

if( strcmp(delim,'\t') )
  delim  = sprintf(delim);
end

ldelim = length(delim);
ilist = strfind(tt,quot0);
i = 1;
while i <= length(ilist)
    ltt  = length(tt);
  
    i0 = min(ilist(i)+1,ltt);
    i1 = strfind(tt(i0:ltt),quot1);
    
    if( isempty(i1) )
        break
    else
        i1 = i1(1);
    end
    
    i2 = i0+i1-1;
    
    ttt = str_change_f(tt(i0:i2),delim,fchar,'a');
    if( i0 > 1 )
      ttt = [tt(1:i0-1),ttt];
    end
    if( i2 < length(tt) )
      ttt = [ttt,tt(i2+1:length(tt))];
    end
    tt = ttt;
    if( strcmp(quot0,quot1) )
        i = i+2;
    else
        i = i+1;
    end
end

c_names = {};
icount = 0;
go_on  = 1;
 
while( go_on )

    a = findstr(tt,delim);
 
    if( isempty(a) )
        
         icount = icount + 1;
         c_names{icount} = tt;
         go_on = 0;
    else
        i0 = a(1)-1;
        i1 = a(1)+length(delim);
        if( i0 < 1 )
            icount = icount + 1;
            c_names{icount} = '';
        else
            icount = icount + 1;
            c_names{icount} = tt(1:i0);
        end
        if( i1 > length(tt) )
            tt = '';
        else
            tt = tt(i1:length(tt));
        end
    end            
            
end

for i=1:length(c_names)
    
    c_names{i} = str_change_f(c_names{i},fchar,delim,'a');
end

if( elim )
    i1 = 0;
    for i=1:length(c_names)
        if( length(c_names{i}) > 0 )
            i1           = i1+1;
            c_names1{i1} = c_names{i};
        end
    end
    c_names = c_names1;
end
            
            