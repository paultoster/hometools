function val = vec_get_get_value(vec,rindex)
%
% val = vec_get_get_value(vec,rindex)
%
% get value from vector with index with residuum
%
% vec          Vector
% rindex       index with residuum  (e.g. 1.23 or 10.45) (e.g suche_index())
%
% val          linear calculated


n = length(vec);
index = floor(rindex);
fac   = rindex-index;

if( index < n )
  val = vec(index) + (vec(index+1)-vec(index))*fac;
else
  error('%s: rindex=%f, index=%i > n=%i',mfilename,rindex,index,n)
end


end