%
% Driver for wedge.m
% Set the variable CuteProb.
%
% Marcelo Marazzi, 1999.
%
format compact
CuteProb = 0;       % Cute problem (1) or user defined problem (0)

if CuteProb == 0
   x0 = user_usetup;
   n  = length(x0);
   pname = user_unames;
elseif CuteProb == 1
   x0 = usetup;
   pname = unames;
   n = length(x0);
else
   error('driver: Wrong value of CuteProb.');
end

setSpecs;

if nRunsOptn == 'Var'
   nRuns = 5;
elseif nRunsOptn == 'One'
   nRuns = 1;
end

for gamma = gammaValues
    f0 = fcn(x0,CuteProb);

    f_run = zeros(1,nRuns); niter_run = zeros(1,nRuns); nf_run = zeros(1,nRuns); 
    nAct_run = zeros(1,nRuns); nAct_run = zeros(1,nRuns); nActRed_run = zeros(1,nRuns);
    inform_run = zeros(1,nRuns);
    for i = 1:nRuns
        x = x0;
        f = f0;

        [x,f,inform,niter,nf,nAct,nActRed] = wedge(x,f,gamma,pname);
        f_run(i) = f;
        inform_run(i) = inform;
        niter_run(i) = niter;
        nf_run(i) = nf;
        nAct_run(i) = nAct;
        nActRed_run(i) = nActRed;
    end
    percentAct_run = round(100 * nAct_run ./ niter_run);
    percentActRed_run = round(100 * nActRed_run ./ niter_run);
%
%   Print summary of the nRuns to screen and to files .out and *.sum
%
    filename = [pname '.' 'out'];
    [fout,message] = fopen(filename,'a');
    if fout == -1 
        fprintf([filename,': ', message, '\n'])
    end
    filename = [pname '.' 'sum'];
    [fsum,message] = fopen(filename,'a');
    if fsum == -1 
        fprintf([filename,': ', message, '\n'])
    end
%
%   Print summary to screen, .out and .sum
%
    for fid = [1, fout, fsum]
        fprintf(fid,'\nProblem %8s  -  Summary (%3i run(s) ):\n',pname,nRuns);
        fprintf(fid,'------------------------------------------------------------------------------------------------------------\n');
        fprintf(fid,'    n     niter   nf         f                   gamma nActRed nAct   nActRed%% nAct%%  inform\n');
        fprintf(fid,' %4i\t%4i\t%4i\t%16.10e\t%6.g\t%4i\t%2i\t%4i\t%2i\t%2i\n',...
        [n*ones(1,nRuns);niter_run;nf_run;f_run;gamma*ones(1,nRuns);nActRed_run;nAct_run;...
                 percentActRed_run;percentAct_run;inform_run]);
    end
end
fclose(fout);
fclose(fsum);


