function printVersion(fout,version)
% printVersion(fout,version) prints the version 
% to the screen and to the output file.

fid = 1; 	% Print to screen
for i=1:2
    fprintf(fid,['Method: Wedge ' version '\n\n']);
    fid = fout;  % Go back and print the same to file.
end
