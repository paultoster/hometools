function ivec = strfind_outof_quot(tt,textsearch,quot0,quot1)
%
% ivec = strfind_outof_quot(tt,textsearch,quoat0,quot1)
%
% Sucht ausserhalb der quots nach textsearch
%

ifchar = 1;
fchar = char(ifchar);
ttdum = '';
for i=1:length(textsearch)
  ttdum = [ttdum,fchar];
end
while( strcmp(ttdum,textsearch) || strcmp(ttdum,quot0) ||  strcmp(ttdum,quot1) )
    ifchar = ifchar+1;
    fchar  = char(ifchar);
    for i=1:length(textsearch)
      ttdum = [ttdum,fchar];
    end
end
fchar = ttdum;

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
    
    ttt = str_change_f(tt(i0:i2),textsearch,fchar,'a');
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

ivec = strfind(tt,textsearch);