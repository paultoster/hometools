function dstr = datum_int_to_str(dint)
%
% dstr = datum_int_to_str(dint)
%
% wandelt int-Datum in string-Datum um
% dint   jjjjmmtt  z.B 2009 => 20090000
%                      dez  => 1200
%                      1.   => 1
% dstr   'tt.mm.jjjj'

jj = floor(dint/10000);
mm = floor((dint - jj*10000)/100);
tt = floor((dint - jj*10000 - mm*100));

dstr = [num2str(tt,'%2.2i'),'.',num2str(mm,'%2.2i'),'.',num2str(jj,'%4.4i')];