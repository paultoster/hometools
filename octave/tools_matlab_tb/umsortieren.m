function vek_out=umsortieren(vek_in)
%
% vek_out=umsortieren(vek_in)
%
% Sortiert Vektor rückwerts

[m,n]=size(vek_in);

for i=1:m
   for j=1:n
      vek_out(i,j)=vek_in(m-i+1,n-j+1);
   end
end
