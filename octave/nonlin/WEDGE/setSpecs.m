%
% Specs for Wedge
%
inSatOptn = 'Splx'; % Initial satellites, 'Rand' or 'Debg' or 'Splx'
CuteProb = 0;       % Cute problem (1) or user defined problem (0);
                    % set this variable also in driver.m
AlgOptn = 'Quadra'; % 'Linear' or 'Quadra'  

% Stop if any of the following stopping tests is satisfied.
DeltaTol = 10*eps;  % Stopping test 1: Stop if Delta < DeltaTol
fminimum = -inf;    % Stopping test 2: Stop if f <= fminimum
tol_fmin = 0;       % Stopping test 3: Stop if 
                    % (f - fminimum)/(f0 - fminimum) <= tol_fmin

ITERMAX = 100000;   % Stop if # of iter >= ITERMAX
FEVALMAX = 8000;    % Stop if # of function evaluation >= FEVALMAX

gammaValues = 0.4;  % Initial gamma (if AlgOptn = 'Quadra'), or
                    % constant value of gamma (if AlgOptn = 'Linear'). 
iPrint = 1;         % 0. no detailed output
                    % 1. detailed output only to file .out
                    % 2. detailed output to screen and to files .out 
dTheta = pi/600;    % increment angle in rotation
subpTechnique = 'RTTN'; 
rtol = eps;         % gqtpar() arguments 
atol = eps;
maxit = 1000;
par = 0; 

fracOptRed = 0.5;   % Factor in equation (4.13) in paper.

nRunsOptn = 'Var';  % Number of runs, 'One' or 'Var'

% TR parameters.
optnRad = 'DECR';   % TR radius update
Delta  = 1;         % Initial TR radius.
alpha1 = 0.25;      % alpha1 < alpha2 < 1      
alpha2 = 0.75;
gamma1 = 0.5;       %  gamma1 < 1 < gamma2
gamma2 = 2;

