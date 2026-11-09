function  cell_array = cell_reduce_double_elements(cell_array)
%
% cell_array = cell_reduce_double_elements(cell_array)
% 
% reduziert doppelt
%
  i = 1;
  while( i <= length(cell_array))
  
    if( ischar(cell_array{i}) )
      ifound  = cell_find_f(cell_array,cell_array{i},'f');
      if( ~isempty(ifound) )
        for j=1:length(ifound)
          if( ifound(j) ~= i )
            cell_array = cell_delete(cell_array,ifound(j));
          end
        end
      end
    elseif( isnumeric(cell_array{i}) )
      j = 1;
      while( j <= length(cell_array) )
        if( (i ~= j) && isnumeric(cell_array{j}) )
          
          if( vec_compare(cell_array{i},cell_array{j}) )
            cell_array = cell_delete(cell_array,j);
          end
        end
        j = j+1;
      end
    else
      error('Error_%s: type of cellarray{%i} is not numeric or char',mfilename,i);
    end
    
    i = i+1;
    
  end
          
end