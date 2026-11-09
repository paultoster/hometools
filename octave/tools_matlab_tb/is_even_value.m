function liste = is_even_value(val,tol)
%
% liste = is_odd_value(val,tol)
%
% val  single,vector, matrix wird geprüft ob ungerade
% tol                        Toleranz (default tol=eps)

if( ~exist('tol','var') )
    tol=eps;
end

[n,m] = size(val);

liste = val*0;

for i=1:n
  for j=1:m

    a = val(i,j)/2.0;

    if(  abs(fix(a)-a) <= tol )
      liste(i,j) = 1;
    end
  end
end
            