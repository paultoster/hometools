function f_x = pt1_filter(t,x,t_const)
%
% f_x = pt1_filter(t,x,t_const)
%
if( nargin == 0 )
    fprintf('\nfunction f_x = pt1_filter(t,x,t_const)');
    fprintf('\n\nPT1-Filter');
    f_x = [];
    return
end

delta_t = t(2)-t(1);
n       = length(t);
f_x = t*0;

lam = exp(-delta_t/t_const);
elam = 1.-lam;

f_x(1) = x(1);

for i=2:n
    
    f_x(i) = x(i)*elam+f_x(i-1)*lam;
end