function tabooSurfaceValue = taboo(s,Bs,b)
%
% taboo(s,Bs,b) returns the value of the
% quadratic that defines the taboo surface
% at s. That is, the value
%
% b*'s + 0.5*s'*B*s
%
% NB: It does NOT compute the absolute value.
%
tabooSurfaceValue = b'*s + 0.5*s'*Bs;

