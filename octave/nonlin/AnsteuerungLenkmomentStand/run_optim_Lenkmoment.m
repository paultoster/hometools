clear opt P erg d 
fid     = fopen('run_optim_Lenkmoment.txt','w');
if( fid > 0 )
  opt.fid = [1,fid];
else
  opt.fid = 1;
end

% Parameter, die nicht variiert werden für die Funktion 
global p d
p.delta_t     = 0.001;
p.delta_t_out = 0.01;
p.plot_flag   = 0;
close all


% zu variierende Parameter anlegen
JzSteer = 1;
C0      = 0.1;
D0      = 0.1;
T0      = 0.5;
Sigma   = 4;

% Messdaten zur Simulation
% p.messfile_liste  = {'MomentenSinus2Nm2sStand_1.mat' ...
%                     ,'MomentenSinus25Nm1sStand_1.mat' ...
%                     ,'MomentenSinus25Nm2sStand_1.mat' ...
%                     ,'MomentenSinus3Nm2sStand_1.mat' ...
%                     ,'MomentenSinus4Nm2sStand_11.mat' ...
%                     ,'MomentenSinus45Nm2sStand_1.mat' ...
%                     ,'MomentenSinus5Nm1sStand_1.mat' ...
%                     ,'MomentenSinus5Nm2sStand_1.mat' ...
%                     };
p.messfile_liste  = {'MomentenSinus2Nm25sStand_1.mat' ...
                    ,'MomentenSinus2Nm50sStand_1.mat' ...
                    ,'MomentenSinus3Nm25sStand_1.mat' ...
                    ,'MomentenSinus45Nm25sStand_1.mat' ...
                    ,'MomentenSinus4Nm25sStand_1.mat' ...
                    ,'MomentenSinus4Nm50sStand_1.mat' ...
                    ,'MomentenSinus5Nm25sStand_1.mat' ...
                    };
p.nmessfile_liste = length(p.messfile_liste);
% Gewichtung dazu
p.gewichtung = ones(p.nmessfile_liste,1);

% Optimierungsverfahren:
%=======================
opt.type  = 1;             % 0: Methode des steilsten Abstiegs
                           % 1: Quasi-Newton-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel
                           % 2: Trust-Region-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren
                           % 3: Trust-Region-Verfahren mit wedge

if( opt.type == 0 ) %Methode des steilsten Abstiegs
  opt.method = 'steilster Abstieg';
                           % Methode des steilsten Abstiegs:
  opt.stype = 0;             % 0: Schrittweiten Regelung nach Armijo-Regel
                           % 1: Schrittweiten Regelung nach Powell-Wolfe
  opt.beta  = 0.5;           % Armijo-Regel 0 < beta < 1  skaliert Schrittweite
  opt.gamma = 1e-4;          % Armijo-Regel,Powell-Wolfe-Regel 0 < gamma < 1 skaliert Gradienten
  opt.eta   = 0.9;           % Powell-Wolfe-Regel gamma < eta < 1 skaliert Gradienten gröber

  opt.use_df_func = 0;          % Soll Ableitung aus der Funktion berechnet werden

elseif( opt.type == 1 ) % Quasi-Newton-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel
  opt.method = 'Quasi-Newton-Verfahren';

  opt.stype = 0;             % 0: Schrittweiten Regelung nach Armijo-Regel
                           % 1: Schrittweiten Regelung nach Powell-Wolfe
  opt.gamma = 1e-4;          % Armijo-Regel,Powell-Wolfe-Regel 0 < gamma < 1 skaliert Gradienten
  opt.eta   = 0.9;           % Powell-Wolfe-Regel gamma < eta < 1 skaliert Gradienten gröber
  opt.use_df_func = 0;          % Soll Ableitung mit dem Funktionsaufruf berechnet werden
  opt.use_H_func  = 0;          % Soll zweite Ableitung mit dem Funktonsaufruf gebildet werden

elseif( (opt.type == 2) || (opt.type == 3) ) % Trust-Region-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren

  opt.method = 'Trust-Region-Verfahren';
  if( opt.type == 3 ),opt.method = [opt.method,' mit wedge'];end

  opt.use_df_func = 0;          % Soll Ableitung mit dem Funktionsaufruf berechnet werden
  opt.use_H_func  = 0;          % Soll zweite Ableitung mit dem Funktonsaufruf gebildet werden

  opt.alphaT = 0.5;            % opt.alphaT   Trust-Region 0 < alphaT <= 1.0
  opt.betaT = 1.2;            % opt.betaT    Trust-Region betaT >= 1
  opt.etaT1  = 0.2;            % opt.eta T1     Trust-Region zur Bestimmung des Radius deltak
  opt.etaT2  = 0.5;            % opt.etaT2     Trust-Region 0 < etaT1 < etaT2 < 1
  opt.gammaT0 = 0.3;           % opt.gammaT0   Trust-Region zur Bestimmung des Radius deltak
  opt.gammaT1 = 0.6;           % opt.gammaT1   Trust-Region 0 < gammaT0 < gammaT1 < 1
  opt.gammaT2 = 1.3;           % opt.gammaT2   Trust-Region gammaT2 > 1
  opt.deltaT0 = 0.2;           % opt.deltaT0   Trust-Region Startwert für Trust-Region-Radius
  opt.deltaTmin = 1e-3;        % opt.deltaTmin Trust-Region minimal Trust-Region-Radius
end

% Funktionsaufruf
%================
opt.func  = @funcLenkmoment; % Funktion mit   f = func(xs)  Skalar
opt.kmax  = 100;
opt.err   = 1e-6;

% Parameterraum festlegen
%========================
% JzSteer = 1;
% C0      = 0.1;
% D0      = 0.1;
% T0      = 0.5;
% Sigma   = 4;

P(1).name   = 'JzSteer';       % Name i-ten Parameter
P(1).xmin   = 0.01;         % minimaler Wert Startwert
P(1).xmax   = 10.;         % maximaler Wert Startwert
P(1).n      = 4;           % Anzahl der unterteile delta = (max-min)/(n-1)
P(2).name   = 'C0';         % Name i-ten Parameter
P(2).xmin   = 0.01;         % minimaler Wert Startwert
P(2).xmax   = 10.;         % maximaler Wert Startwert
P(2).n      = 4;           % Anzahl der unterteile delta = (max-min)/(n-1)
P(3).name   = 'D0';         % Name i-ten Parameter
P(3).xmin   = 0.01;         % minimaler Wert Startwert
P(3).xmax   = 10;         % maximaler Wert Startwert
P(3).n      = 4;           % Anzahl der unterteile delta = (max-min)/(n-1)
P(4).name   = 'T0';         % Name i-ten Parameter
P(4).xmin   = 0.01;         % minimaler Wert Startwert
P(4).xmax   = 10;         % maximaler Wert Startwert
P(4).n      = 4;           % Anzahl der unterteile delta = (max-min)/(n-1)
P(5).name   = 'Sigma';         % Name i-ten Parameter
P(5).xmin   = 0.01;         % minimaler Wert Startwert
P(5).xmax   = 20;         % maximaler Wert Startwert
P(5).n      = 4;           % Anzahl der unterteile delta = (max-min)/(n-1)
opt.P       = P;

% Bestenliste speichern, bzw gespeicherte benutzen
%=================================================
opt.BestListFile    = 'best_list.mat';
opt.useBestListFile = 1;

try
  tstart = tic;
  [okay,res] = optnlin_var1_nbegrenzt(opt);
  telapsed = toc(tstart);
  fprintf('Time Total: %f s\n',telapsed)        
catch
  fclose('all');
  % getReport(ME)
  okay = 0;
end

if( okay )
  save('res_struct.mat','res')
end
fclose('all');
