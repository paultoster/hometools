function str = str_cut_ae_f(str,del_str)
%
% function str = str_cut_ae_f(str,del_str)
%
% Schneide del_str aus str am Anfang und am Ende aus
%
% z.B.  txt = str_cut_ae_f('|abc|','|')
% => txt = 'abc'
%
% um carrige return zu entfernen del_str=char(10) verwenden

str = str_cut_a_f(str,del_str);
str = str_cut_e_f(str,del_str);
