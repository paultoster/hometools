function val = vek_2d_get_val_at_index_dPath(vec,index,dPath)
%
% val = vek_2d_get_val_at_index_dPath(vec,index,dPath)
%
% get value at index plus portion of vec(inedx+1)-vec(index) ;

  n = length(vec);
  if( index >= n ) 
    error('index (%i) >= n (%i)',index,n);
  end
  if( index < 0 ) 
    error('index (%i) < 0',index);
  end
  val = vec(index) + (vec(index+1)-vec(index))*dPath;
end