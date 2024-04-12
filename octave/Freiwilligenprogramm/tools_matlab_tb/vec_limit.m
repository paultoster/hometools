function    [vec] = vec_limit(vec,lim_min,lim_max)
%
% [vec] = vec_limit(vec,lim_min,lim_max)
% Limitiert auf min und max

  if( nargin < 3 )
      error('Zuwenige Parameter: 1. Parameter Vector, 2. Parameter lim_min, 3. Parameter lim_max')
  end

  if( ~isnumeric(vec) )
    error('Falscher Typ: erster Parameter muss ein vekotor sein')
  end
  
  if( lim_max < lim_min ) 
    a = lim_max;
    lim_max = lim_min;
    lim_min = a;
  end

  [n,m] =size(vec);
  if( m > n )
    vec = vec';
    [n,m] =size(vec);
    trans_flag = 1;
  else
    trans_flag = 0;
  end


  for j = 1:m
    for i = 1:n

      if(     vec(i,j)>lim_max ), vec(i,j) = lim_max;
      elseif( vec(i,j)<lim_min ), vec(i,j) = lim_min;
      end
    end
  end
  
  if( trans_flag )
    vec = vec';
  end
end