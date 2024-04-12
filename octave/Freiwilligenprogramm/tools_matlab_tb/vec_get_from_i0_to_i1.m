function vecout = vec_get_from_i0_to_i1(vec,i0,i1)
%
% vecout = vec_get_from_i0_to_i1(vec,i0,i1)
%
% vecout = vec_get_from_i0_to_i1(vec,i0,i1)
% vec = [1;2;2;3;4;5];  
% i0  = 2;
% i1  = 4;
%
% => vecout = [2;3;4];
%
  if( ~isnumeric(vec) )
      error('Parameter vec is kein Double')
  end

  n = length(vec);

  if( i0 < 1 ) 
    i0 = 1;
  elseif( i0 > n )
    i0 = n;
  else
    i0 = round(i0);
  end
  
  if( i1 < i0 )
    i1 = i0;
  elseif( i1 > n )
    i1 = n;
  else
    i1 = round(i1);
  end

  vecout = vec(i0:i1);
end
