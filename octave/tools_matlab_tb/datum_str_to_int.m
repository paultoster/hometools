function dint = datum_str_to_int(dstr)
%
% dint = datum_str_to_int(dstr)
%
% wandelt string-Datum in int-Datum um
% dstr   'tt.mm.jjjj'
% dint   jjjjmmtt  z.B 2009 => 20090000
%                      dez  => 1200
%                      1.   => 1
[c_names,icount] = str_split(dstr,'.');

if( icount == 1 )
    dint = str2num(c_names{1});
elseif( icount == 2 )

    dint = str2num(c_names{2})*100+str2num(c_names{1});
    
else
    jj = str2num(c_names{3});
    if( jj < 100 )
        jj = 2000+jj;
    end
    dint = jj*10000+str2num(c_names{2})*100+str2num(c_names{1});
end    