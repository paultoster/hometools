function [index,dPath] = vek_2d_get_index_dPath_at_val(vec,val)
%
% [index,dPath] = vek_2d_get_index_dPath_at_val(vec,val)
%
% get index plus portion at value vec must be increasing ;

  n = length(vec);
  if( n == 1 )
    error('vec has only 1 point');
  end
  if( ~is_monoton_steigend(vec) )    
    error('vec is not monoton increasing');
  end
  index = n-1;
  for i=2:n 
    if( val <= vec(i) )
      index = i-1;
      break;
    end
  end
  
  dPath = (val-vec(index))/not_zero(vec(index+1)-vec(index));
  
end