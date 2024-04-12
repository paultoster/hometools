function ttt = str_cut_index(tt,i0,ll)
% tt = str_cut_index(tt,i0,ll)
% Schneidet aus tt von i0 der Länge ll den Text aus
%
n  = length(tt);
i0 = min(i0,n+1);
if( i0 > 1 )
  ttt = tt(1:i0-1);
else
  ttt = '';
end
i1 = i0+ll;
if( i1 <= n )
  ttt = [ttt,tt(i1:n)];
end
