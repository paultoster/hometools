function [jj,mm,tt] = datum_to_3int(d)
%
%[jj,mm,tt] = datum_to_3int(d)
%
if( ischar(d) )
    
    dint = datum_str_to_int(d);
else
    dint = floor(d);
end
jj = floor(dint/10000);
mm = floor((dint - jj*10000)/100);
tt = floor((dint - jj*10000 - mm*100));
