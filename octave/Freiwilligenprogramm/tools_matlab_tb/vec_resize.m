function vec = vec_resize(vec,nresize)
%
% vec = vec_resize(vec,nresize)
%
% resize to n as C++ std::vector
%
% flag_true = 1:   okay
% flag_true = 0:   nokay

  flag_true = 1;
  
  [n,m] = size(vec);
  if( n > m )
    trans = 0;
  else
    trans = 1;
    i = n;
    n = m;
    m = i;
    vec = vec';
  end
  
  if( n >= nresize )
    vec = vec(1:nresize);
  else
    vec1 = zeros(nresize-n,1);
    vec = [vec;vec1];  
  end
  
  if( trans )
    vec = vec';
  end
end
