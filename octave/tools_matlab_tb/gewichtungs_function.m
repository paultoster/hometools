function y = gewichtungs_function(x,xm,xfac)

% y = gewichtungs_function(x,xfac)
%
% Gewichtsfunktion für x = 0 ... 1 =>  y = 0 ... 1
% 0 < xm < 1.0  Verschiebung Übergang xm = 0.5 Mitte
% mit xfac   >> 1 macht Übergang schmäller

  xm = max(min(xm,0.95),0.05);
  a = (2.*xm(1)-1.)/xm(1)/(1-xm(1));
  b = 2.-a;
  c = -1;
  xx = a*x.*x+b*x+c;

  %y = tanh(xx*xfac(1));
  y = step_function(xx*xfac(1),-1,1,0.0,1.0);
  
  figure
  plot(x,y)
  grid on
end
% function y = tanh_func(x,n)
%   y1 = exp_func(x,n);
%   y2 = exp_func(x*(-1.),n);
%   y  = (y1-y2)./(y1+y2);
% end
% function y = exp_func(x,n)
%   y = x*0.0+1;
%   for i=n:-1:1
%     y = ((y .* x)/i)+1;
%   end
% end