function flag_true = vec_compare(vec0,vec1,toleranz)
%
% flag_true = vec_compare(vec0,vec1)
% flag_true = vec_compare(vec0,vec1,toleranz)
%
% compare two vector (matrix) with toleranz
%
% vec0     first vector
% vec1     second vector
% toleranz (default: eps)
% 
% flag_true = 1:   stimmt überein
% flag_true = 0:   stimmt nicht überein (Länge oder Werte mit toleranz)

  flag_true = 0;
  
  if( ~exist('toleranz','var') )
    toleranz = eps;
  end
  
  toleranz = abs(toleranz);
  
  [n0,m0] = size(vec0);
  [n1,m1] = size(vec1);
  
  if( (n0 == m1) && (n1 == m1) )
    vec1 = vec1';
    [n1,m1] = size(vec1);
  end
  
  if( (n0 ~= n1) || (m0 ~= m1) )
    return;
  else
    for i=1:n0
      for j=1:m0
        if( abs(vec0(i,j)-vec1(i,j)) > toleranz )
          return;
        end
      end
    end
  end
  flag_true = 1;
  

end

