function printX1(fout,f,fYmin,pname)
% printX1(fout,f,fYmin,pname) prints information at the 
% begining of the run.

fid = 1;        % Print to screen
for i=1:2
    fprintf(fid,'Problem: %8s\n\n', pname);
    fprintf(fid,'Initial function value f = %9.2e\n',f);
    if fYmin < f
       fprintf(fid,'------- Switched x1 \n');
    end
    fprintf(fid,'\n');
    fid = fout; % Go back and print the same to file.
end
