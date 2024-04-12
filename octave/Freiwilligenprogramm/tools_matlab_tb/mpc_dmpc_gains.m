function [Ky, Kmpc] = mpc_dmpc_gains(PHI,F,Nc,m,rW)
%
% [Ky, Kmpc] = mpc_dmpc_gains(PHI,F,R,Nc,m)
% [Ky]       = mpc_dmpc_gains(PHI,F,R,Nc,m)
%
% Output:
%          1      2   ...    Nc
% Ky   = [Imxm, 0mxm, ... , 0mxm] * (PHI' * PHI + R)^-1 * PHI'
% Kmpc = Ky * F
%
% for u(ki) = Ky * Rs - Kmp * del x(ki)
%     u(ki) = Ky * (Rs - F * del x(ki)
%
% R    = rW*I(Nc*m)x(Nc*m)
% 
% Imxm  Diagonal one matrix
% 0mxm  zero matrix
%
% Input
% PHI   (Np*q) x (Nc*m)   Y = F * x(ki) + PHI * DEL_U
% F     (Np*q) x N
% Nc    control horizon
% m     number of inputs
% rW    skalar gain for R = rW*I(Nc*m)x(Nc*m) (unit diagonal matrix dim:Nc*mxNc*m)  
%
%

  Ncm = Nc * m;
  [nPHI,mPHI] = size(PHI);
  if( mPHI ~= Ncm )
    error('Nc(%i)*m(%i) does not fit with PHI',Nc,m);
  end
  
  R = rW*eye(Ncm);
    
  M = PHI'*PHI + R;
  if( rank(M) < Ncm )
    error('%s: rank(PHI''*PHI + R) < Nc*m, keine Inverse möglich',mfilename);
  end
  Ky  = M\(PHI'); 
  
  Ky   = Ky(1:m,1:Ncm);
  
  if( nargout > 1 )
   [nF,~] = size(F);
    if( nF ~= nPHI )
      error('PHI does not fit with F');
    end
    Kmpc = Ky * F;
  end
end