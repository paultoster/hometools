function ttt = str_insert_index(tt,i0,tinsert)
% ttt = str_insert_index(tt,i0,tinsert)
% Fügt hinter tt(i0) tinsert ein, also kann i0 = 0 sein
%
n  = length(tt);
i0 = min(i0,n);
if( i0 == 0 )
  ttt = [tinsert,tt];
else
  ttt = [tt(1:i0),tinsert];
  if( i0 < n )
    ttt = [ttt,tt(i0+1:n)];
  end
end
