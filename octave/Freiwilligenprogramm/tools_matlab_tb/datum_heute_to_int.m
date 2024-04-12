function dint = datum_heute_to_int
%
% dint = datum_heute_to_int
%
% wandelt aktuelles Datum in int-Datum um
% dint   jjjjmmtt  z.B 20090531 => 31.5.2009
 v=datevec(now);
 dint = v(1)*10000+v(2)*100+v(3);
end