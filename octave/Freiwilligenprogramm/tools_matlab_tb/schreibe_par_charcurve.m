function ierr=schreibe_par_charcurve(fid,charcurve_name,linear_flag, ...
   vek1_name,vek1_einheit,vek1,vek2_name,vek2_einheit,vek2)
%
% TBert/TZS/3052/9.10.00
% Schreibt den Vektor im avs-Parameterformat in ein file
%
% fid             handle von fig=fopen(file)
% charcurve_name  Name des Blocks
% liear_flag      = 1 linear
% vek1_name			gewünschter NAme x
% vek1_einheit		dargestellte Einheit x
% vek1				gewünschte Vektor aus der workspace x
% vek2_name			gewünschter NAme y
% vek2_einheit		dargestellte Einheit y
% vek2				gewünschte Vektor aus der workspace y

ierr = 0;

if fid <= 2
   error('Keine Datei geoeffnet')
   ierr = 1;
end
fprintf(fid,'>>>bgn>>>  characteristic_curve: %s\n\n',charcurve_name);
if( linear_flag > 0.5 )
	fprintf(fid,'interpolation = linear\n');
else
	fprintf(fid,'interpolation = kubic\n');
end

fprintf(fid,'\n');
fprintf(fid,'%s [%s] = \n',vek1_name,vek1_einheit);
fprintf(fid,'%c\n','[');

m =length(vek1);
if( m ~= length(vek2) )
   error('vek1 und vek2 sind nicht identisch lang')
end

for i=1:m
   fprintf(fid,'%25.17e',vek1(i));
   if i == m
      fprintf(fid,'\n]\n');
   else
      fprintf(fid,',\n');
   end
end

fprintf(fid,'\n');
fprintf(fid,'%s [%s] = \n',vek2_name,vek2_einheit);
fprintf(fid,'%c\n','[');

m =length(vek2);
for i=1:m
   fprintf(fid,'%25.17e',vek2(i));
   if i == m
      fprintf(fid,'\n]\n');
   else
      fprintf(fid,',\n');
   end
end

fprintf(fid,'\n');

fprintf(fid,'<<<end<<<  characteristic_curve: %s\n',charcurve_name);
