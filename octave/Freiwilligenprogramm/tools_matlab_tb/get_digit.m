function dig = get_digit(val,decimal)
%
% dig = get_digit(val,decimal)
%
% get the enum of the value 
% decimal =-3,-2,-1,0,1,2,3,4 wich decimal position 1: Einer, 
%                                                   2:hundert, 
%                                                   3:thousand
%                                                   0: 0.x
%                                                  -1: 0.0x
%
v = floor(abs(val)/10^(decimal-1));
vv = floor(v/10)*10;

dig = v-vv;