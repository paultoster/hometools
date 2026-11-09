function [PHI, F] = mpc_predicted_horizon_model(A,B,C,Nc,Np)
%
% [PHI, F] = mpc_predicted_horizon_model(A,B,C,Nc,Np)
%
% Y = F * x(ki) + PHI * DEL_U
%
% DEL_U = [del_u(ki)',del_u(ki+1)', ... , del_u(ki+Nc-1)']':     (Nc*m) x 1
% Y     = [y(ki+1|ki)',y(ki+2|ki)', ... , y(ki+Np|ki)]':         (Np*q) x 1
% F:                                                             (Np*q) x N
% PHI:                                                           (Np*q) x (Nc*m)
%
% Input:
% A: NxN, B: Nxm, C: qxN
% x(ki+1)= A*x(ki)+B*del_u(ki)
% y(ki)  = C*x(ki)
%
  [N,m] = size(B);
  [q,~] = size(C);
  error(abcdchk(A,B,C));
  i0 = 1;
  i1 = q;
  h(i0:i1,:)=C;
  F(i0:i1,:)=C*A;
  for kk=2:Np
    ii0 = (kk-1)*q+1;
    ii1 = kk*q;
    h(ii0:ii1,:) = h(i0:i1,:)*A;
    F(ii0:ii1,:) = F(i0:i1,:)*A;
    i0 = ii0;
    i1 = ii1;
  end
  v        = h*B;
  PHI      = zeros(Np*q,Nc*m); %declare the dimension of Phi
  i0 = 1;
  i1 = q;
  PHI(:,i0:i1) = v; % first column of Phi
  for i=2:Nc
    ii0 = (i-1)*m+1;
    ii1 = i*m;
    PHI(:,ii0:ii1) = [zeros((i-1)*q,m);v(1:(Np-i+1)*q,1:m)]; %Toeplitz matrix
    i0 = ii0;
    i1 = ii1;
  end
end