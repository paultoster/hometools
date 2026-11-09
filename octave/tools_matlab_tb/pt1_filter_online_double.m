function f_x = pt1_filter_online_double(x_new,x_old,delta_t,t_const)
%
% f_x = pt1_filter_online_double(x_new,x_old,delta_t,t_const)
%
lam = exp(-delta_t/t_const);
elam = 1.-lam;
    
f_x = x_new*elam+x_old*lam;
   