function dstr = datum_add_to_str(d1,d2)
%
% dstr = datum_add_sto_str(dstr,dstr)
% dstr = datum_add_sto_str(dstr,dint)
% dstr = datum_add_sto_str(dint,dstr)
% dstr = datum_add_sto_str(dint,dint)
%
dint = datum_add_to_int(d1,d2);
dstr = datum_int_to_str(dint);
