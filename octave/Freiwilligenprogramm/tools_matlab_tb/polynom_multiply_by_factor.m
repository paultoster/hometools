function s = polynom_multiply_by_factor(s,factor)
%
% s = polynom_multiply_by_factor(s,factor)
%
% multiply by factor
%
% F = factor * (x - roots(1)) * (x - roots(2) * ... * (x-roots(n)
%
% s.root_factor = s.root_factor * factor
% s.roots       = no change
% s.polynom     = s.polynom * factor  % [a(m),a(m-1), ..., a(1)]  
%                                     % y = a(m)*x^(m-1) + ... + a(1) * x^0
%
  s.root_factor = s.root_factor * factor;
  s.polynom     = s.polynom * factor;
  