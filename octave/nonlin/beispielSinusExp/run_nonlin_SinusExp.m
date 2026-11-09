try
  clear opt P
  fid     = fopen('run_nonlin_SinusExp.txt','w');
  if( fid > 0 )
    opt.fid = [1,fid];
  else
    opt.fid = 1;
  end

  for itype = 1:1
       
    opt.type  = itype;         % 0: Methode des steilsten Abstiegs
                               % 1: Quasi-Newton-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel
                               % 2: Trust-Region-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren
                               % 3: Trust-Region-Verfahren mit wedge

    if( opt.type == 0 ) %Methode des steilsten Abstiegs
                               % Methode des steilsten Abstiegs:
      opt.stype = 0;             % 0: Schrittweiten Regelung nach Armijo-Regel
                               % 1: Schrittweiten Regelung nach Powell-Wolfe
      opt.beta  = 0.5;           % Armijo-Regel 0 < beta < 1  skaliert Schrittweite
      opt.gamma = 1e-4;          % Armijo-Regel,Powell-Wolfe-Regel 0 < gamma < 1 skaliert Gradienten
      opt.eta   = 0.9;           % Powell-Wolfe-Regel gamma < eta < 1 skaliert Gradienten gröber

      opt.use_df_func = 0;          % Soll Ableitung aus der Funktion berechnet werden

    elseif( opt.type == 1 ) % Quasi-Newton-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel
      
      opt.stype = 0;             % 0: Schrittweiten Regelung nach Armijo-Regel
                               % 1: Schrittweiten Regelung nach Powell-Wolfe
      opt.gamma = 1e-4;          % Armijo-Regel,Powell-Wolfe-Regel 0 < gamma < 1 skaliert Gradienten
      opt.eta   = 0.9;           % Powell-Wolfe-Regel gamma < eta < 1 skaliert Gradienten gröber
      opt.use_df_func = 0;          % Soll Ableitung mit dem Funktionsaufruf berechnet werden
      opt.use_H_func  = 0;          % Soll zweite Ableitung mit dem Funktonsaufruf gebildet werden

    elseif( (opt.type == 2) || (opt.type == 3) ) % Trust-Region-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren

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
    
    opt.func  = @funcSinusExpBilder; % Funktion mit   f = func(xs)  Skalar
    opt.kmax  = 10;
    opt.err   = 1e-3;

    opt.nshow = 5;             % Wieviel beste Minimas anzeigen?
    opt.use_in_range = 0;      % Es sollen nur Werte die im Min-Max-Bereich liegen verwendet werden

    P(1).name   = 'a';         % Name i-ten Parameter
    P(1).xmin   = 1.5;         % minimaler Wert Startwert
    P(1).xmax   = 3.5;         % maximaler Wert Startwert
    P(1).n      = 3;           % Anzahl der unterteile delta = (max-min)/(n-1)
    P(2).name   = 'b';         % Name i-ten Parameter
    P(2).xmin   = 0.0;         % minimaler Wert Startwert
    P(2).xmax   = 1.0;         % maximaler Wert Startwert
    P(2).n      = 3;           % Anzahl der unterteile delta = (max-min)/(n-1)
    P(3).name   = 'c';         % Name i-ten Parameter
    P(3).xmin   = 0.0;         % minimaler Wert Startwert
    P(3).xmax   = 0.4;         % maximaler Wert Startwert
    P(3).n      = 3;           % Anzahl der unterteile delta = (max-min)/(n-1)
    opt.P       = P;

    opt = optnlin_var_nbegrenzt(opt);
  end
  fclose(fid);
catch ME
  if(fid),fclose(fid),end
  error(getReport(ME));
end