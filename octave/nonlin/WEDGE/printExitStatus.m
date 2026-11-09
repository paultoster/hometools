function printExitStatus(inform,DeltaTol,ITERMAX,fminimum,iPrint,fout)
%
% At the end of the run, print exit status
%
fid = fout; 
for i=1:iPrint
   if inform == 1 
      fprintf(fid,'\nSTOP: Trust region radius < DeltaTol = %9.2e\n\n', DeltaTol);
   elseif inform == 2
      fprintf(fid,'\nSTOP: Number of iterations  >= ITERMAX = %4i\n\n', ITERMAX);
   elseif inform == 3
      fprintf(fid,'\nSTOP: Objective value satisfies relative stopping test  w.r.t. f* = %9.2e\n\n', fminimum);
   elseif inform == -1
      fprintf(fid,'\nSTOP: No further progress can be made.\n\n');
   end
   fid = 1;  % Go back and print the same to the screen.
end

