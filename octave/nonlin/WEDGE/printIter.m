function printIter(iterNo,nf,f,Delta,iterType,gamma,theta,flagTR,...
              norm_g,infoWedge,fout,inform,iPrint,DeltaTol,ITERMAX,fminimum)
%
% Function that prints some iteration info.
% iPrint: 0  No output 
%         1  Only to file 
%         2  To file and screen 

if infoWedge == 1
   iWedge = 'Inac';
elseif infoWedge == 2
   iWedge = 'Act';
elseif infoWedge == 3
   iWedge = 'ActRed';
elseif infoWedge == -1
   iWedge = 'pred<=0';
else
   error('printIter: Unknown value of infoWedge.')
end

fid = fout; 	
for i=1:iPrint
   if mod(iterNo,20) == 0           % print headers every 20 iterations
      fprintf(fid,' iter  nf     f         Delta     type    wedge    gamma    theta     tr     ||g||\n');
      fprintf(fid,'-----------------------------------------------------------------------------------\n');
      if iterNo == 0                % partial output at very first iteration
         fprintf(fid,'%4i %4i %12.5e %9.2e           \n',...
         [iterNo, nf, f, Delta]);
      end
   else
      fprintf(fid,'%4i %4i %12.5e %9.2e %5s %8s %9.1e %9.1e %4s %10.2e\n',...
             [iterNo, nf, f, Delta], iterType, iWedge, gamma, theta, flagTR, norm_g);
   end

   fid = 1;  % Go back and print the same to the screen.
end

