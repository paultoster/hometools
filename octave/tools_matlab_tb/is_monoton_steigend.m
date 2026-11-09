function bool=is_monoton_steigend(x,n)
%
% bool=is_monoton_steigend(x);
% Prüft, ob monoton steigend
%
if( exist('n','var') )
  x = x(1:n);
end
dx=diff(x);
if any(dx<=0)
   bool = 0;
else
   bool = 1;
end
