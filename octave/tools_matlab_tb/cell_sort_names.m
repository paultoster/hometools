function cout = cell_sort_names(cnames,typ)
%
% cnames = cell_sort_names(cnames,typ)
%
% z.B.
% sortiert nach Kriterien typ
% typ   = 'n','numeric'       sortiert nach der ersten Zahl in text von
% cnames{i}
% cin = { 'abs2' ,  'abc1' }
% cout = { 'abs1'  , 'abs2' }
  cout = {};
  if( typ(1) == 'n' )
    typ_flag = 1;
  else
    error('typ ist nicht bekannt')
  end
  
  n = length(cnames);
  
  if( typ_flag == 1 )
    i = 1;
    while( i<=n )
      if( ~ischar(cnames{i}) )
        cnames = cell_delete(cnames,i);
        n = n-1;
      else
        i = i+1;
      end
      
    end
    intvec = zeros(n,1);
    for i=1:n

      c = find_integer_in_string(cnames{i});
      if( isempty(c) )
        intvec(i) = 0;
      else
        intvec(i) = c{1};
      end
    end
    [~,sortvec] = sort(intvec);
    for i=1:n
      cout = cell_add(cout,cnames{sortvec(i)});
    end
  end
end
    