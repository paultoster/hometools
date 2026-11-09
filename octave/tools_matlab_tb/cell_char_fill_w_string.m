function c = cell_char_fill_w_string(c,n,str)
%
% c = cell_char_fill_w_string(c,n,str)
%
% fill each c{i} with str to get length(c{i}) == n
%
%
  
  for i=1:length(c)
    if( ischar(c{i}) )
      
      while( length(c{i}) < n )
        c{i} = [c{i},str];
      end
      if( c{i} > n )
        c{i} = c{i}(1:n);
      end
    end
  end
end
