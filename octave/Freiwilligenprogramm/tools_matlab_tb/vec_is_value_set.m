function found = vec_is_value_set(vec,value,errval)
%
% found = vec_is_value_set(vec,value)
% found = vec_is_value_set(vec,value,errval)
%
% vec           num      Spaltenvektor
% value         num      Wert
% errval        num      error to accept found (default=1e-3)

  if( ~exist('errval','var') )
    errval = 1.e-3;
  end
  
  errval = abs(errval);
  
  if( min(abs(vec - value)) < errval )
    found = 1;
  else
    found = 0;
  end
  
end  
