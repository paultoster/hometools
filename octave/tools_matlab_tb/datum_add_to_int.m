function dint = datum_add_to_int(d1,d2)
%
% dint = datum_add_sto_int(dstr,dstr)
% dint = datum_add_sto_int(dstr,dint)
% dint = datum_add_sto_int(dint,dstr)
% dint = datum_add_sto_int(dint,dint)
%
if( ischar(d1) )
    
    d1int = datum_str_to_int(d1);
else
    d1int = floor(d1);
end

if( ischar(d2) )
    
    d2int = datum_str_to_int(d2);
else
    d2int = floor(d2);
end

dint = d1int+d2int;

jj = floor(dint/10000);
mm = floor((dint - jj*10000)/100);
tt = floor((dint - jj*10000 - mm*100));

if( mm == 1 || mm == 3 || mm == 5 || mm == 7 || mm == 8 || mm == 10 || mm == 12 )
    
    t1 = 31;
    
elseif( mm == 2 )

    t1 = 28;
else
    t1 = 30;
end

while(tt > t1)
    mm = mm+1;
    tt = tt-t1;
end

while( mm > 12 )
    jj = jj+1;
    mm = mm-12;
end

dint = jj*10000+mm*100+tt;
