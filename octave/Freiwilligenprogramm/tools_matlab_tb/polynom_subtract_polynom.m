function s = polynom_subtract_polynom(s1,s2)
%
% s = polynom_subtract_polynom(s1,s2)
%
% subtract s1 polynom - s2 polynom
%
% y = root_factor * (x - roots(1)) * (x - roots(2) * ... * (x-roots(n))
% y = a(m)*x^(m-1) + ... + a(1) * x^0
% s.polynom = [a(m),a(m-1), ..., a(1)]  
%
% new calclated:
% s.root_factor 
% s.roots       
% s.polynom       
%                                            
%
  n1 = length(s1.polynom);
  n2 = length(s2.polynom);
  dn = n1 - n2;
  if( dn == 0 )
    polynom = s1.polynom - s2.polynom;
  elseif( dn > 0 )
    polynom = s1.polynom;
    for i=dn+1:n1
      polynom(i) = polynom(i) - s2.polynom(i-dn);
    end
  else
    polynom = s2.polynom;
    for i=-dn+1:n2
      polynom(i) = polynom(i) - s1.polynom(i+dn);
    end
  end
  
  s = polynom_build_with_polynom(polynom);
      
end