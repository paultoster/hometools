global fcounter dfcounter

clear opt
opt.type  = 0;             % 0: Methode des steilsten Abstiegs
                           % 1: BFGS-Verfahren (Quasi-Newton-Verfahren) mit
                           %    Powell-Wolfe-Regel
                           % 2: Trust-Region
                           % 3: Trust-Region-Wedge
                           % Methode des steilsten Abstiegs:
opt.stype = 1;             % 0: Schrittweiten Regelung nach Armijo-Regel
                           % 1: Schrittweiten Regelung nach Powell-Wolfe
opt.use_df_func = 1;          % Soll Ableitung aus der Funktion berechnet werden
opt.use_H_func  = 1;
opt.x0    = [-1.2;1.0];    % Anfangswert vektor nx1
%opt.x0    = [0.0;0.0];    % Anfangswert vektor nx1


opt.beta  = 0.5;           % Armijo-Regel 0 < beta < 1  skaliert Schrittweite
opt.gamma = 1e-4;          % Armijo-Regel,Powell-Wolfe-Regel 0 < gamma < 1 skaliert Gradienten
opt.eta   = 0.9;           % Powell-Wolfe-Regel gamma < eta < 1 skaliert Gradienten gröber
%opt.B0    = [0.2,0;0,0.2]; % BFGS-Verfahren symetrische positiv-definite Startmatrix

opt.func  = @funcRosenbrock; % Funktion mit   f = func(xs)  Skalar
opt.dfunc = @diffRosenbrock; % Ableitung mit df = dfunc(xs) Vektor nx1
opt.Hfunc = @HRosenbrock;    % Hessematrix mit H = Hfunc(xs) Vektor nx1

opt.delta0   = 1.;           % opt.deltaT0   Trust-Region Startwert für Trust-Region-Radius
opt.deltamin = 1e-3;        % opt.deltaTmin Trust-Region minimal Trust-Region-Radius

opt.kmax  = 100000;
opt.err   = 1e-10;

fcounter  = 0;
dfcounter = 0;

fid     = fopen('run_nonlin_Rosenbrock.txt','w');
if( fid > 0 )
  opt.fid = [1,fid];
else
  opt.fid = 1;
end


tic
[xs,opt] = optnlin_nbegrenzt(opt);
toc

if( ~opt.okay )
  fprintf(opt.fid,'%s\n',opt.errtext);
  for i= 1:opt.n
    fprintf(opt.fid,'x%s = %f\n',num2str(i),opt.xs(i));
  end
end

fprintf(opt.fid,'number of calls fcounter = %i\n',fcounter);

fclose(fid);
