function s = polynom_build_with_roots(root_vector,factor)
%
% s = polynom_build_with_roots(roots,factor)
%
% Build roots/nullstellen of polynom in a structure
%
% F = factor * (x - roots(1)) * (x - roots(2)) * ... * (x-roots(n))
%
% s.root_factor = factor
% s.roots       = roots
% s.polynom     = [a(m),a(m-1), ..., a(1)]';  y = a(m)*x^(m-1) + ... + a(1) * x^0
%
  s.root_factor = factor;
  s.roots       = root_vector;
  s.polynom     = poly_from_roots(root_vector)*factor;
  