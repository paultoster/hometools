function c2 = cell_insert(c,index,c1)
%
% c = cell_insert(c,index,item)
% c = cell_insert(c,index,c1)
%
% Einfügen eines items (string,num,etc ) oder cellarray c1 an der stelle
% index von c (wenn length(c) < index, dann wird index angepasst)
% 


  if( ~iscell(c1) )
      c1 = {c1};
  end
  nc1 = length(c1);

  nc = length(c);

  if( index > nc ) 
    for i=1:nc1
      c{nc+i} = c1{i};
    end
    c2 = c;
    return
  elseif( index < 1 )
    index = 1;
  end

  c2 = {};
  n  = 0;
  for i=1:index-1
    n = n+1;
    c2{n} = c{i};
  end
  for i=1:nc1
    n = n+1;
    c2{n} = c1{i};
  end
  for i=index:nc
    n = n+1;
    c2{n} = c{i};
  end
end