function polynom = polynom_coeff_shift_in_x(polynom,dx)

  n = length(polynom);
  pcell = cell(1,n);
  % multiply a(1)*(x+dx)^(n-1),a(2)*(x+dx)^(n-2), ... , a(n-1)*(x+dx), a(n)
  % pcell{1} = a(1)*(x+dx)^(n-1)
  % pcell{2} = a(2)*(x+dx)^(n-2)
  % ...
  % pcell{n-1} = a(n-1)*(x+dx)
  % pcell{n}   = a(n)
  for i=1:n-1
    p        = [1.,dx];   % x +dx
    pcell{i} = [1.,dx];   % x +dx
    for j=i:n-2
      pcell{i} = polynom_coeff_multiply_polynoms(pcell{i},p); 
    end
    pcell{i} = pcell{i} * polynom(i);
    
  end
  pcell{n} = polynom(n);

  % add all polynoms
  for i=1:n
    exponent = n-i;
    polynom(i) = 0.0;
    for j=1:length(pcell)
      jj = length(pcell{j})-exponent;
      if( jj > 0.5 )
        polynom(i) = polynom(i) + pcell{j}(jj);
      end
    end
  end
end