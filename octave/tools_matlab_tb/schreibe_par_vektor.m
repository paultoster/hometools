function ierr=schreibe_par_vektor(fid,vektor,vektorname,vektoreinheit)
%
% TBert/TZS/3052/9.10.00
% Schreibt den Vektor im avs-Parameterformat in ein file
%
% fid             handle von fig=fopen(file)
% vektor				gewünschte Vektor aus der workspace
% vektorname		gewünschter NAme
% vektoreinheit	dargestellte Einheit

ierr = 0;

if fid <= 2
   error('Keine Datei geoeffnet')
   ierr = 1;
end

fprintf(fid,'\n');
fprintf(fid,'%s [%s] = \n',vektorname,vektoreinheit);
fprintf(fid,'%c\n','[');

m =length(vektor);
for i=1:m
   fprintf(fid,'%25.17e',vektor(i));
   if i == m
      fprintf(fid,'\n]');
   else
      fprintf(fid,',\n');
   end
end

fprintf(fid,'\n');