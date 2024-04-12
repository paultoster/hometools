function tt = str_replace_by_index(tt,i_liste,ll,treplace)
%
%  ttt = str_replace_by_index(tt,i_liste,ll,treplace)
%  Ersetzt in tt an der Stelle i_liste(i) mit Länge ll bzw. ll(i) mit
%  treplace
  ishift = 0;
  n = length(i_liste);
  while( length(ll) < n )
    ll(length(ll)+1) = ll(length(ll));
  end
  for i=1:length(i_liste)
    tt = str_cut_index(tt,i_liste(i)+ishift,ll(i));
    tt = str_insert_index(tt,i_liste(i)+ishift-1,treplace);
    ishift = ishift + length(treplace)-ll(i);
  end
end
