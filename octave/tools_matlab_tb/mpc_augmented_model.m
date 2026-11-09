function [A, B,C] = mpc_augmented_model(Am,Bm,Cm)
%
% [A, B,C] = mpc_augmented_model(Am,Bm,Cm)
%
% xm(k+1) = Am * xm(k) + Bm * u(k)
% ym(k)   = Cm * xm(k)
%
% u(k):  m x 1
% xm(k): n x 1
% ym(k): q x 1
%
% Cm:  q x n
% Bm:  n x m
% Am:  n x n
%
% augmented model:
%
% x(k+1) = A * x(k) + B * del_u(k)
% y(k+1) = C * x(k)
%
% del_u(k)  = u(k) - u(k-1):      m x 1
%                                 N = n+q
% x(k)      = [del_xm(k),ym(k)]': N x 1
% del_xm(k) = xm(k)-xm(k-1):      n x 1
% y(k)      = ym(k)               q x 1
%
% B         = [Bm,Cm*Bm]':        N x m
% A         = [Am   ,0nxq
%              Cm*Am,Iqxq]:       N x N
% C         = [0qxn,Iqxq]:        q x N
%
  [q,n] = size(Cm);
  [n,m] = size(Bm);
  N     = n+q;
  
  A=eye(N,N);
  A(1:n,1:n)=Am;
  dd = Cm*Am;
  A(n+1:n+q,1:n)=Cm*Am;
  B=zeros(N,m);
  B(1:n,:)=Bm;
  B(n+1:N,:)=Cm*Bm;
  C=zeros(q,N);
  C(:,n+1:N)=eye(q,q);

end