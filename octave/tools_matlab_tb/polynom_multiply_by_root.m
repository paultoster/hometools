function s = polynom_multiply_by_root(s,root_value)
%
% s = polynom_multiply_by_factor(s,root_value)
%
% multiply by factor
%
% F = factor * (x - roots(1)) * (x - roots(2) * ... * (x-roots(n))
%
% s.root_factor = no change
% s.roots       = [s.roots,root_value]
% s.polynom     = poly(roots) * root_factor  % [a(m),a(m-1), ..., a(1)]  
%                                            % y = a(m)*x^(m-1) + ... + a(1) * x^0
%
  if( (length(s.polynom) > 1) || (abs(s.polynom(1)) > eps) )
    [n,m]         = size(s.roots);
    if(n > m )
      s.roots = s.roots';
    end
    s.roots       = [s.roots, root_value];
    s.polynom     = poly_from_roots(s.roots) * s.root_factor;
  end
end