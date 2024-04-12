function polynom = polynom_coeff_multiply_polynoms(p1,p2)
%
% polynom = polynom_coeff_multiply_polynoms(p1,p2)
%
% multply two polynom
% p1 = [an,an-1, ... ,a1,a0]     an*x^(n-1)+an-1*x^(n-2) ... + a1*x + a0
% p2 = [bm,bm-1, ... ,b1,b0]     bm*x^(m-1)+bm-1*x^(m-2) ... + b1*x + b0
% =>
% polynom = [cl,cl-1, ... ,c1,c0]     cl*x^(l-1)+cl-1*x^(l-2) ... + c1*x + c0
%
% l = (n-1) + (m-1) + 1
%

  n = length(p1);
  m = length(p2);
  l = (n-1) + (m-1) + 1;
  
  polynom = zeros(1,l);
  
  for i=1:n
    for j=1:m
      k = (i-1) + (j-1) + 1;
      polynom(k) = polynom(k) + p1(i) * p2(j);
    end
  end
end