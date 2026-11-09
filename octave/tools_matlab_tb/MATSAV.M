function i = matsav(fid,xname,xout,ihead)
%
% function i = matsav(fid,xname,xout)
%
% Speichert im Matrixx ASCII-Format
% unter unit fid wird der Vektor xout
% mit dem Namen xname gespeichert
%
format = '(1P2E25.17)';

if fid <= 2
   disp('Keine Datei geoeffnet')
   i = -1;
elseif ihead == 1
   fprintf(fid,'MATSAVE');
   fprintf(fid,'\r\n');
else

   [m n]=size(xname);
   for i=1:n,
     fprintf(fid,'%c',xname(i));
   end
   
   for i=n+1:10,
     fprintf(fid,'%c',' ');
   end

   [m n] =size(xout);
   fprintf(fid,'%5.0f%5.0f%5.0f',[m n 0]);
   fprintf(fid,'%11s\r\n',format);

   i = 1;
   while i <= m
     fprintf(fid,'%25.17e',xout(i));
     i = i + 1;
     if i <= m
        fprintf(fid,'%25.17e\r\n',xout(i));
     else
        fprintf(fid,'\r\n');
     end
     i = i +1;
   end     
   i = 1;
end

