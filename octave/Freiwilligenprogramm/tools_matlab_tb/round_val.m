function xout = round_val(xin,stellen)
%
% xout = round_val(xin,stellen)
%
% Auf/Abrunden auf die angegebene Stelle
% z.B. stelle = 0.01 oder 10.0 oder 1 (entspr round())
% stelle ~= 0
stellen = abs(stellen);
if( stellen < eps )
  error('round_val: stellen == 0, darf nicht sein')
end

a = log10(stellen);

if( a < 0.0 ), a = floor(a);
else           a = ceil(a);
end

d = 10^a;

xout = round(xin/d)*d;


