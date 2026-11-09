function vec = vector_set_fix_length(vec,nvec,val0)
%
% vec = vector_set_fix_length(vec,n,val0)
% 
% truncate or prolong with val0 to length of n
%
%
  if( ~exist('val0','var') )
    val0 = 0.0;
  end
  
  [n,m] = size(vec);
  if( m > n )
    flag = 1;
    vec = vec';
    nn  = n;
    n   = m;
    m   = nn;
  else
    flag = 0;
  end
  
  if( n < nvec )
    vec2 = ones(nvec-n,m)*val0;
    vec  = [vec;vec2];
  end
  vec = vec(1:nvec,1);
  
  if( flag )
    vec = vec';
  end
  
end