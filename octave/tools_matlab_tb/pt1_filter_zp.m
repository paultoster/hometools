function f_x = pt1_filter_zp(t,x,t_const)
%
% f_x = pt1_filter_zp(t,x,t_const)
%
% PT1-Filter with Zero-Phase

  if( nargin == 0 )
      fprintf('\nfunction f_x = pt1_filter_zp(t,x,t_const)');
      fprintf('\n\nPT1-Filter with Zero-Phase');
      f_x = [];
      return
  end
  n       = length(t);
  f_x = t*0;
  delta_t = t(2)-t(1);

  % lam = -exp(-delta_t/t_const);
  % elam = 1.+lam;
  % 
  % f_x = filtfilt([elam,0],[1,lam],x);


  % Filter
  %=======
  lam = exp(-delta_t/t_const);
  elam = 1.-lam;

  f_x(1) = x(1);

  for i=2:n

      f_x(i) = x(i)*elam+f_x(i-1)*lam;
  end

  % Phasenverschiebung
  %===================
%   [R0, lags0]    = sxcorr(x);
%   [R, lags]      = sxcorr(x,f_x);
% 
%   [R0max,iR0max] = max(R0);
%   [Rmax,iRmax]   = max(R);
% 
%   di             = iR0max - iRmax;
% 
%   if( di > 0 )
% 
%     for i=1:n-di
%       f_x(i)  = f_x(i+di);
%     end
% 
%     for i=n-di+1:n
%       f_x(i) = x(n)*elam+f_x(i-1)*lam;
%     end
%   end
  
  maxshift = t_const/delta_t*2;
  di = phaseshift(x,f_x,'self',maxshift);
  f_x = shiftsignal(f_x,di);

end