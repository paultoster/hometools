function f_x = butter2_filter(t,x,t_const,zero_phase)
%
% f_x = butter2_filter(t,x,t_const[,zero_phase])
%
% Butterworth second order filters x = f(t)
% zero_phase = 1 makes a zerophaseshift
%
  if( nargin == 0 )
      fprintf('\nf_x = butter2_filter(t,x,t_const[,zero_phase])');
      fprintf('\n\Butterworth-Filter 2nd order with Zero-Phase');
      f_x = [];
      return
  end
  
  if( ~exist('zero_phase','var') )
    zero_phase = 0;
  end
  
  n       = min(length(t),length(x));
  f_x     = t*0;
  delta_t = mean(diff(t));
  fs      = 1./not_zero(delta_t);
  fc      = 1./not_zero(t_const);
  fr      = fs/fc;

  
  omegac  = tan(pi/fr);
  c       = not_zero(1+(2*cos(pi/4)+omegac)*omegac);
  
  a0 = omegac*omegac/c;
  a1 = 2*a0;
  a2 = a0;
  b1 = 2*(omegac*omegac-1)/c;
  b2 = (1+(-2*cos(pi/4)+omegac)*omegac)/c;

  % PT1-Filter für ersten Wert
  %===========================
  lam = exp(-delta_t/t_const);
  elam = 1.-lam;

  f_x(1) = x(1);
  f_x(2) = x(2)*elam+f_x(1)*lam;

  for i=3:n

      f_x(i) = a0*x(i)+a1*x(i-1)+a2*x(i-2)-b1*f_x(i-1)-b2*f_x(i-2);
  end

  
  % Phasenverschiebung
  %===================
  if( zero_phase )
    maxshift = t_const/delta_t*2;
    di = phaseshift(x,f_x,'self',maxshift);
    f_x = shiftsignal(f_x,di);

%     [R0, lags0]    = sxcorr(x);
%     [R, lags]      = sxcorr(x,f_x);
% 
%     [R0max,iR0max] = max(R0);
%     [Rmax,iRmax]   = max(R);
% 
%     di             = iR0max - iRmax;
% 
%     if( di > 0 )
% 
%       for i=1:n-di
%         f_x(i)  = f_x(i+di);
%       end
% 
%       for i=n-di+1:n
%         % f_x(i) = x(n)*elam+f_x(i-1)*lam;
%         f_x(i) = a0*x(n)+a1*x(n-1)+a2*x(n-2)-b1*f_x(i-1)-b2*f_x(i-2);
%       end
%     end
  end
end