function [Phi, Gamma] = state_space_contious_to_discret(a, b, t)
%
% [Phi, Gamma] = ContiousToDiscret(a, b, t)
%
% Conversion of state space models
% from continuous to discrete time.
% [Phi, Gamma] = C2D(A,B,T)
% converts the continuous-time system:
% .
% x = Ax + Bu
%
% to the discrete-time state-space system:
%
% x[n+1] = Phi * x[n] + Gamma * u[n]
%
% assuming a zero-order hold on the inputs
% and sample time T.

  error(nargchk(3,3,nargin));
  error(state_space_abcdchk(a,b));

  [m,n] = size(a);
  [m,nb] = size(b);
  s = self_expm([[a b]*t; zeros(nb,n+nb)]);
  Phi = s(1:n,1:n);
  Gamma = s(1:n,n+1:n+nb);
end 

function e = self_expm(a)
% Matrix exponential via Taylor series.
% Scale A by power of 2 so that its norm is < 1/2 .

  s = round(log(norm(a,1))/log(2)+1.5);
  if s < 0,
    s = 0;
  end
  a = a/2^s;

  % Taylor series for exp(A)
  [m,n] = size(a);
  k = 1;
  e = 0*a;
  f = eye(m,n);
  while norm(e+f-e,1) > 0,
    e = e + f;
    f = a*f/k;
    k = k+1;
  end

  % Undo scaling by repeated squaring
  for k = 1:s,
    e = e*e;
  end
end