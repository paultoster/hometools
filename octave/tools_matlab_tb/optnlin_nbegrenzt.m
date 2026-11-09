function [xs,opt] = optnlin_nbegrenzt(opt)
%
% Minimumsaufgabe mit den Methoden:
%        - Methode des steilsten Abstiegs
%        - BFGS-Verfahren (Newton-ähnlich
%        - Trust-Region-Verfahren
%        - BFGS-Verfahren (Newton-ähnlich mit penality)
%
% [xs,opt] = optnlin_nbegrenzt (opt)
%
% opt.fid          handle für Ausgabe Datei und/oder Bildschirm 
%                  1:Bildschirm,i:i = fopen('name.dat','w') oder [1,i]
% opt.x0           Anfangwerte 
% opt.func         (muss) Funktionsaufruf f  = opt.func(x); (Funktionswert f skalar), muss definiert sein
% opt.dfunc        (kann) Funktionsaufruf df = opt.func(x); (Funktionsableitung Länge df entspricht x)
% opt.Hfunc        (kann) Funktionsaufruf H  = opt.Hfunc(x); (Hesse-Matrix Länge H entspricht length(x) x length(x) )
% opt.use_df_func  analytische Ableitfunktion verwenden
% opt.use_H_func   soll analytische Hessematrix funktion verwendet werden,
%                  Wenn null wird die zweite Ableitung der
%                  Hauptdiagonale für den Startwert (BFGS,Trust-Region)
%                  berechnet und verwendet H0 und B0= H0^-1 (es kann aber
%                  auch ein Startwert für die zweite Ableitung vorgegeben
%                  werden H0
% opt.H0           für BFGS- und RT-Verfahren wird symetrische positiv-definite Startmatrix
%                  vorgegeben, wenn nicht, dann wird H-Matrix gebildet oder analytisch berechnet
%                  gilt aber nur, wenn use_H_func = 0, bez. nicht gesetzt ist
% opt.kmax         Anzahl der maximalen Iterationen (def 100000)
% opt.err          Fehlerschranke (def 1e-6) zum Abbruch df = dfunc(x) norm(df) < err
% opt.type         Berechnungsart
%                  0: Methode Steilster Abstieg
%                  1: Quasi-Newton-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel
%                  2: Trust-Region-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren
%                  3: Trust-Region-Verfahren mit wedge
%                  4: Quasi-Newton-Verfahren mit penality, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren
%
%opt.type = 0   Methode Steilster Abstieg (Hfunc wird nicht benutzt)
%
% opt.stype      0: Schrittweiten Regelung für steilsetn Abstieg nach Armijo-Regel
%                1: Schrittweiten Regelung für steilsetn Abstieg nach Powell-Wolfe
% stype=0:     Armijo-Regel
%  opt.beta      Skalierungsfaktor für Schrittweiensteuerung 0 < beta < 1  (def 0.5)
%  opt.gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-2)
% stype=1:     Powell-Wolfe-Regel
%  opt.gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-4)
%  opt.eta       gamma < eta < 1 skaliert Gradienten gröber
%
%opt.type = 1   Quasi-Newton-Verfahren
% opt.stype      0: Schrittweiten Regelung für steilsetn Abstieg nach Armijo-Regel
%                1: Schrittweiten Regelung für steilsetn Abstieg nach Powell-Wolfe
% stype=0:     Armijo-Regel
%  opt.beta      Skalierungsfaktor für Schrittweiensteuerung 0 < beta < 1  (def 0.5)
%  opt.gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-2)
% stype=1:     Powell-Wolfe-Regel
%  opt.gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-4)
%  opt.eta       gamma < eta < 1 skaliert Gradienten gröber
%
%opt.type = 2   Trust-Region-Verfahren
%
% opt.delta0     Startwert für Trust-Region-Radius (def 1.0)
% opt.deltamin   minimal Trust-Region-Radius (def 10*eps)
% opt.rho1       Bestimmung des Radius deltak (def 0.25)
% opt.rho2       Bestimmung des Radius deltak 0 < rho1 < rho2 < 1 ((def 0.75)
% opt.sigma1     Bestimmung des Radius deltak (def 0.5)
% opt.sigma2     Bestimmung des Radius deltak 0 < sigma1 < 1 < sigma2 (def 2)
% opt.TP_itermax maximale Iterationsloop des Teilproblems (def 100)
% opt.TP_rtol    relative Toleranz Teilproblem (def eps)
% opt.TP_atol    absolute Toleranz Teilproblem (def eps)
% opt.TP_par     Unbekannt  zu TeilProblem (def 0)
%
%opt.type = 4    Quasi-Newton-Verfahren mit penality
%  opt.Penality  Strafhöhe bei dxP
%  opt.P(i).xmin minimaler Wert
%  opt.P(i).xmax max
%  opt.P(i).dxP  Straßabstand bis Penality erreicht

% opt.stype      0: Schrittweiten Regelung für steilsetn Abstieg nach Armijo-Regel
%                1: Schrittweiten Regelung für steilsetn Abstieg nach Powell-Wolfe
% stype=0:     Armijo-Regel
%  opt.beta      Skalierungsfaktor für Schrittweiensteuerung 0 < beta < 1  (def 0.5)
%  opt.gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-2)
% stype=1:     Powell-Wolfe-Regel
%  opt.gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-4)
%  opt.eta       gamma < eta < 1 skaliert Gradienten gröber
%
% Rückgabewerte:
% opt.okay      = 1 Erfolgreich
%                 0 Fehler
% opt.errtext   Ausgabe Text
% opt.inform    the algorithm stops if either of the following
%               - criterias reached                             (inform =  0)
%               - trust region radius < deltamin                (inform =  1)
%               - number of iterations >= kmax                  (inform =  2)
%               - relative stopping test 
%                 (f - fminimum)/(f0 - fminimum) <= tol_fmin           
%                 satisfied                                     (inform =  3)   
%               - maximal function call reached                 (inform =  4)
%               - crieria df_norm < err reached                 (inform =  5)
%               - Quasi-Newton Matrix Bk = inv(Hk) singular     (inform =  6)
%               - no further progress can be made               (inform = -1)
% opt.calc_time Berechnungszeit elapsed time
% opt.xs        letzter berechneter x-Vektor
% opt.f         Funktionswert in opt.xs
% opt.df        Ableitung in opt.xs
% opt.df_norm   Norm der Ableitung

  if( ~isfield(opt,'fid') )
    opt.fid = 1;
  end

  if( ~isfield(opt,'x0') )
    error('Startvalue opt.x0 not defined in option-structure');
  else
    [n,m] = size(opt.x0);
    if( m > n )
      opt.x0 = opt.x0';
      n = m;
    end
  end
  xs  = opt.x0*0.0;
  
  if( ~isfield(opt,'type') )
    fprintf('opt.type = 0: Methode Steilster Abstieg\n')
    fprintf('opt.type = 1: Quasi-Newton-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel\n')
    fprintf('opt.type = 2: Trust-Region-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren\n')
    fprintf('opt.type = 3: Trust-Region-Verfahren mit Wedge\n')
    fprintf('opt.type = 4: Quasi-Newton-Verfahren mit penality, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel\n')
    error('opt.type muss bestimmt werden');
  end
  opt.type = round(opt.type);
  if( opt.type < 0 || opt.type > 4 )
    fprintf('opt.type = 0: Methode Steilster Abstieg\n')
    fprintf('opt.type = 1: Quasi-Newton-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel\n')
    fprintf('opt.type = 2: Trust-Region-Verfahren, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren\n')
    fprintf('opt.type = 3: Trust-Region-Verfahren mit Wedge\n')
    fprintf('opt.type = 4: Quasi-Newton-Verfahren mit penality, wenn Hfunc nicht vorhanden, dann mit BFGS-Verfahren () mit Powell-Wolfe-Regel\n')
    error('opt.type=%i ist falsch ',opt.type);
  end

  if( ~isfield(opt,'kmax') )
    opt.kmax = 100000;
  end

  if( ~isfield(opt,'err') )
    opt.err = 1e-6;
  else
    opt.err = abs(opt.err);
  end
  
  % steilster Abstieg, BFGS, BFGS mit STrafe
  if( (opt.type == 0) || (opt.type == 1) || (opt.type == 4) )
    
    if( ~isfield(opt,'stype') )
      opt.stype = 0;
    else
      opt.stype = max(0,min(1,round(opt.stype)));
    end
  
    if( opt.stype == 0 ) % Armijo-Regel
      if( ~isfield(opt,'beta') )
        opt.beta = 0.5;
      else
      if( opt.beta >= 1.0 ),opt.beta = 0.999999999;
      elseif( opt.beta <=  0.0 ),opt.beta = 0.0000001;end
      end
      if( ~isfield(opt,'gamma') )
        opt.gamma = 1e-2;
      else
        if( opt.gamma >= 1.0 ),opt.gamma = 0.999999999;
        elseif( opt.gamma <=  0.0 ),opt.gamma = 0.0000001;end
      end
    else % Powell-Wolfe-Regel
      if( ~isfield(opt,'gamma') )
        opt.gamma = 1e-2;
      else
        if( opt.gamma >= 1.0 ),opt.gamma = 0.999999999;
        elseif( opt.gamma <=  0.0 ),opt.gamma = 0.0000001;end
      end

      if( ~isfield(opt,'eta') )
        opt.eta = 0.1;
      else
        if( opt.eta >= 1.0 ),opt.eta = 0.999999999;
        elseif( opt.eta <=  opt.gamma ),opt.eta=opt.gamma*1.1;end
      end
      if(    opt.eta >= 1.0 )        ,opt.eta = 0.999999999;
      elseif( opt.eta <=  opt.gamma ),opt.eta=opt.gamma*1.1;  
      end
    end
  end
  
  % BFGS mit Straffunktion  
  if( (opt.type == 4) ) 
    if( ~isfield(opt,'P') )
      error('opt.P fehlt sie Beschreibung')
    end
    if( ~isfield(opt,'Penality') )
      error('opt.Penality fehlt sie Beschreibung')
    end
  end
  
  % Trust-Region-Verfahren
  if( (opt.type == 2) || (opt.type == 3) )
    
    if( ~isfield(opt,'deltamin') )
      opt.deltamin = 10*eps;
    end
    opt.deltamin = abs(opt.deltamin);
    if( opt.deltamin == 0.0 )
      error('Trust-Region: deltamin muss im Bereich liegen (deltamin > 0.0)');     
    end
    
    if( ~isfield(opt,'delta0') )
      opt.delta0 = 1.0;
    end
    if( opt.delta0 <= opt.deltamin )
      error('Trust-Region: delta0(%f) muss im Bereich größer deltmin(%f) liegen (delta0 > deltamin)',opt.delta0,opt.deltamin);     
    end
    
    if( ~isfield(opt,'rho1') )
      opt.rho1 = 0.25;
    end
    if( ~isfield(opt,'rho2') )
      opt.rho2 = 0.75;
    end
    if( (opt.rho1 <= 0.0) || (opt.rho2 >= 1.0) || (opt.rho2 <= opt.rho1) )
      error('Trust-Region: rho1,rho2 muss im Bereich liegen (0 < rho1(%f) < rho2(%f) < 1)',opt.rho1,opt.rho2);     
    end
    
    if( ~isfield(opt,'sigma1') )
      opt.sigma1 = 0.5;
    end
    if( ~isfield(opt,'sigma2') )
      opt.sigma2 = 2.0;
    end
    if( (opt.sigma1 <= 0.0) || (opt.sigma1 >= 1.0)  )
      error('Trust-Region: sigma1 muss im Bereich liegen (0 < sigma1(%f) <  1)',opt.sigma1);     
    end
    if( (opt.sigma2 <= 1.0)  )
      error('Trust-Region: sigma2 muss im Bereich liegen (1 < sigma2(%f) )',opt.sigma2);
    end
    
    % opt.TP_itermax maximale Iterationsloop des Teilproblems (def 100)
    if( ~isfield(opt,'TP_itermax') )
      opt.TP_itermax = 1000;
    end
    opt.TP_itermax = round(opt.TP_itermax);

    % opt.TP_rtol    relative Toleranz Teilproblem (def eps)
    if( ~isfield(opt,'TP_rtol') )
      opt.TP_rtol = eps;
    end
    opt.TP_rtol = abs(opt.TP_rtol);
    
    % opt.TP_atol    absolute Toleranz Teilproblem (def eps)
    if( ~isfield(opt,'TP_atol') )
      opt.TP_atol = eps;
    end
    opt.TP_atol = abs(opt.TP_atol);
    
    % opt.TP_par     Unbekannt  zu TeilProblem (def 0)
    if( ~isfield(opt,'TP_par') )
      opt.TP_par = 0;
    end
    
  end  


  opt.okay    = 1;
  opt.errtext = '';

  % Anzahl der Variablen
  opt.n  = length(opt.x0);
  opt.xs = opt.x0;

  if( ~isfield(opt,'func') )
    error('Functioncall opt.func  (f=funx(x)) not defined in option-structure');
  end
  % Test für Berechnung der Funktion mit Anfangswert
  try
    opt.f  = opt.func(opt.xs);
  catch ME
    error(getReport(ME));
    opt.okay = 0;
    opt.errtext = sprintf('Die Funktion opt.func(opt.x0) kann nicht ausgeführt werden');
    return;
  end
  if( length(opt.f) ~= 1 )
    opt.okay    = 0;
    opt.errtext = sprintf('Ergbnis der Funktion opt.func ist nicht skalar');
    return;
  end
  
  % Festlegung, wie Ableitung berechnet wird
  % Berechnung Ableitung mit Anfangswert
  %-----------------------------------------
  if( isfield(opt,'use_df_func') )
    if( opt.use_df_func )
      if( ~isfield(opt,'dfunc') )
        error('differentiation of func opt.dfunc not defined in option-structure');
      end
    end
  else
    if( isfield(opt,'dfunc') )
      opt.use_df_func = 1;
    else
      opt.use_df_func = 0;
    end
  end

  if( opt.use_df_func ) % anayltisch
    if( ~isfield(opt,'dfunc') )
      error('differentiation of func opt.dfunc not defined in option-structure');
    end
    try
      opt.df = opt.dfunc(opt.xs);
    catch ME
      error(getReport(ME));
      opt.okay = 0;
      opt.errtext = sprintf('Die Ableitungsfunktion opt.dfunc(opt.x0) kann nicht ausgeführt werden');
      return;
    end
    if( length(opt.df) ~= opt.n )
      opt.okay    = 0;
      opt.errtext = sprintf('Länge Ergbnisvektor der Ableitungsfunktion opt.dfunc ist nicht gleich n=%i (aus opt.x0)',opt.n);
      return;
    end
    if( length(opt.df'*opt.xs) ~= 1 )
      opt.okay    = 0;
      opt.errtext = sprintf('Ergbnisvektor der Ableitungsfunktion opt.dfunc hat nicht gleiche Aurichtung wie opt.x0');
      return;
    end
  else % numerisch
    opt.df = optnlin_nbegrenzt_build_df(opt);
  end
  
  % B0/H0 BFGS-Verfahren und Trust-Region
  if( (opt.type == 1) || (opt.type == 2) || (opt.type == 4) )
    % Festlegung, wie Ableitung berechnet wird
    % Berechnung Ableitung mit Anfangswert
    %-----------------------------------------
    if( isfield(opt,'use_H_func') )
       if( opt.use_H_func )
        if( ~isfield(opt,'Hfunc') )
          error('analytical Hesse-Matrix calculation function opt.Hfunc not defined in option-structure');
        end
      end
    else
      if( isfield(opt,'Hfunc') )
        opt.use_H_func = 1;
      else
        opt.use_H_func = 0;
      end
    end

    if( opt.use_H_func == 1 ) % analytisch
      
        try
          opt.H0 = opt.Hfunc(opt.x0);
        catch ME
          error(getReport(ME));
          opt.okay = 0;
          opt.errtext = sprintf('Die Hessefunktion opt.Hfunc(opt.x0) kann nicht ausgeführt werden');
          return;
        end
        [n,m] = size(opt.H0);
        if( (n ~= opt.n) || (m ~= opt.n) )
          opt.okay    = 0;
          opt.errtext = sprintf('Länge Ergbnismatrix der Hessefunktion opt.Hfunc ist nicht gleich n=%i (%ix%i) (aus opt.x0)',opt.n,n,m);
          return;
        end
        opt.B0 = inv(opt.H0);
        
    else
        if( isfield(opt,'H0') )
          opt.B0 = inv(opt.H0);
        else
          [H0,B0] = optnlin_nbegrenzt_build_H0(opt);
          opt.H0 = H0;
          opt.B0 = B0;
        end
    end
    
    % B0 prüfen
    [R,p] = chol(opt.B0);
    if( p ~= 0 )
      opt.B0 = eye(opt.n);
%       opt.okay = 0;
%       opt.errtext = sprintf('Die Anfangsmatrix B0 für BFGS- u. Trust-Region-Verfahren ist nicht symetrisch positiv definit');
%       return;
    end
  end
  
  % Ausführen:
  t0 = clock;
  if( opt.type == 0 )
    opt = optnlin_nbegrenzt_steilsterAbstieg(opt);
  elseif( opt.type == 1 )
    opt.flag_penality = 0;
    opt = optnlin_nbegrenzt_BFGS(opt);
  elseif( opt.type == 2 )
    opt = optnlin_nbegrenzt_TrustRegion(opt);
  elseif( opt.type == 3 )
    opt = optnlin_nbegrenzt_TrustRegionWedge(opt);
  elseif( opt.type == 4 )
    opt.flag_penality = 1;
    opt = optnlin_nbegrenzt_BFGS(opt);
  end
  xs = opt.xs;
  opt.calc_time = etime(clock,t0);
  
end
function [opt] = optnlin_nbegrenzt_steilsterAbstieg(opt)
  ffprintf(opt.fid,'Methode steilsten Abstieg');
  if( opt.stype == 0 )
    ffprintf(opt.fid,' mit Armaijo-Regel (Schrittweitensteuerung)\n');
  else % Powell-Wolfe
    ffprintf(opt.fid,' mit Powell-Wolfe (Schrittweitensteuerung)\n');
  end

  % Zähler Iteration
  opt.k  = 0;
  opt.inform = 0;
  
  % Ausgabezähler
  kout = round(opt.kmax/100);
  if( kout == 0 ) 
    kout = 1;
  end
  
  % Betrag der Ableitung aus Startwert
  opt.df_norm = norm(opt.df); 
  if( opt.df_norm <= opt.err )
    findflag = 1;
  else
    findflag = 0;
  end
  
  sigmak = 0.0;
  while( (opt.k < opt.kmax) && ~findflag )
    
    % Anzeige
    if( (opt.k < 10) || (mod(opt.k,kout) == 0))
      ffprintf(opt.fid,'k = %i f = %20.5g err = %20.5g sigma = %20.5g\n',opt.k,opt.f, opt.df_norm, sigmak);
      for ii=1:opt.n
        ffprintf(opt.fid,'x%i = %g;',ii,opt.xs(ii))
      end
      ffprintf(opt.fid,'\n');
    end
        
    opt.k = opt.k + 1;
    sk = opt.df*(-1.);

    
    % Armaijo-Regel
    if( opt.stype == 0 )
      [opt, sigmak] = optnlin_nbegrenzt_Armijo(opt,sk);
    else % Powell-Wolfe
      [opt, sigmak] = optnlin_nbegrenzt_PowellWolfe(opt,sk);
    end
    if( ~opt.okay ),return;end

    opt.xs = opt.xs + sigmak*sk;
    opt.f  = opt.func(opt.xs);

    if( opt.use_df_func )
      opt.df = opt.dfunc(opt.xs);
    else
      opt.df = optnlin_nbegrenzt_build_df(opt);
    end
    opt.df_norm = norm(opt.df); 
    
    if( opt.df_norm <= opt.err )
      findflag = 1;
    end
  end
  ffprintf(opt.fid,'> k = %i f = %20.5g err = %20.5g sigma = %20.5g\n',opt.k,opt.f, opt.df_norm, sigmak);
  for i=1:opt.n
    ffprintf(opt.fid,'x%s = %f\n',num2str(i),opt.xs(i));
  end
  if( opt.k >= opt.kmax )
    opt.okay = 0;
    opt.inform = 2;
    opt.errtext = 'steilster Abstieg: maximale Anzahl der Interationen erreicht';
  end
end
function [opt] = optnlin_nbegrenzt_BFGS(opt)
  ffprintf(opt.fid,'\n\nMethode Quasi-Newton-Verfahren');
  if( opt.type == 4 )
    ffprintf(opt.fid,' mit Straffunktion');
  end
  if( opt.stype == 0 )
    ffprintf(opt.fid,' mit Armaijo-Regel (Schrittweitensteuerung)\n');
  else % Powell-Wolfe
    ffprintf(opt.fid,' mit Powell-Wolfe (Schrittweitensteuerung)\n');
  end

  % Zähler Iteration
  opt.k      = 0;
  opt.inform = 0;

  % Ausgabezähler
  kout = round(opt.kmax/100);
  if( kout == 0 ) 
    kout = 1;
  end
  
  % Betrag der Ableitung aus Startwert
  opt.df_norm = norm(opt.df); 
  if( opt.df_norm <= opt.err )
    findflag = 1;
  else
    findflag = 0;
  end
  
  sigmak = 0.0;
  opt.Bk = opt.B0;
  while( (opt.k < opt.kmax) && ~findflag )
    
    % Anzeige
    if( (opt.k < 10) || (mod(opt.k,kout) == 0))
      ffprintf(opt.fid,'k = %i f = %20.5g err = %20.5g sigma = %20.5g\n',opt.k,opt.f, opt.df_norm, sigmak);
      for ii=1:opt.n
        ffprintf(opt.fid,'x%i = %g;',ii,opt.xs(ii))
      end
      ffprintf(opt.fid,'\n');
    end
    
    
    opt.k = opt.k + 1;
    % Suchrichtung
    sk = -opt.Bk*opt.df;

    
    % Armaijo-Regel
    if( opt.stype == 0 )
      [opt, sigmak] = optnlin_nbegrenzt_Armijo_BFGS(opt,sk);
    else % Powell-Wolfe
      [opt, sigmak] = optnlin_nbegrenzt_PowellWolfe_BFGS(opt,sk);
    end
    if( ~opt.okay ),return;end

    % Differenzbildung alter Wert
    opt.xs_last     = opt.xs;
    opt.df_last     = opt.df;
    
    opt.xs = opt.xs + sigmak*sk;
    opt.f  = optnlin_nbegrenzt_BFGS_func(opt, opt.xs);
    if( opt.use_df_func ) 
      opt.df = opt.dfunc(opt.xs);
    else
      opt.df = optnlin_nbegrenzt_build_df(opt);
    end
    opt.df_norm = norm(opt.df); 
    
    if( opt.df_norm <= opt.err )
      findflag = 1;
    else
    
      if( opt.use_df_func )
        opt.Hk = opt.Hfunc(opt.xs);
        [R,p] = chol(opt.Hk);
        if( p ~= 0 )
          opt.ok     = 0;
          opt.inform = 6;
          return;
        else
          opt.Bk = inv(opt.Hk);
        end
      else
        % Differenzbildung mit neuem Wert
        dk     = opt.xs-opt.xs_last;
        yk     = opt.df-opt.df_last;

        % Berechnung Bk
        dBy = dk-opt.Bk*yk;
        dy  = dk'*yk;

        if( abs(dy) < eps )
          opt.ok     = 0;
          opt.inform = 6;
          return;
          % dy = eps * sign(dy); 
        end
        B1  = (dBy*dk'+dk*dBy')/dy;
        B2  = ((dBy'*yk/dy/dy)*dk)*dk';

        opt.Bk  = opt.Bk + B1 - B2;

      end
    end
  end
  ffprintf(opt.fid,'> k = %i f = %20.5g err = %20.5g sigma = %20.5g\n',opt.k,opt.f, opt.df_norm, sigmak);
  for i=1:opt.n
    ffprintf(opt.fid,'x%s = %f\n',num2str(i),opt.xs(i));
  end
  if( opt.k >= opt.kmax )
    opt.okay = 0;
    opt.inform = 2;
    opt.errtext = 'Quasi-Newton maximale Anzahl der Interationen erreicht';
  end
end
function f = optnlin_nbegrenzt_BFGS_func(opt,xs)

  f = opt.func(xs);
  if( opt.flag_penality )
    for i=1:opt.n
      if( xs(i) > opt.P(i).xmax )
        d = (xs(i) - opt.P(i).xmax)/opt.P(i).dxP;
        f = f * (opt.Penality*(d^6)+1.0);
      elseif(xs(i) < opt.P(i).xmin )
        d = (opt.P(i).xmin - xs(i))/opt.P(i).dxP;
        f = f * (opt.Penality*(d^6)+1.0);
      end
    end
  end
end
function opt = optnlin_nbegrenzt_TrustRegion(opt)

  % Zähler Iteration
  opt.k  = 0;
  opt.inform = 0;
  
  % Ausgabezähler
  kout = round(opt.kmax/100);
  if( kout == 0 ) 
    kout = 1;
  end
  
  % Betrag der Ableitung aus Startwert
  opt.df_norm = norm(opt.df); 
  if( opt.df_norm <= opt.err )
    findflag = 1;
  else
    findflag = 0;
  end
  
  %sigmak     = 0.0;
  opt.Bk     = opt.B0;
  opt.Hk     = opt.H0;
  opt.deltak = opt.delta0;
  while( (opt.k < opt.kmax) && ~findflag )
    
    % Anzeige
    if( (opt.k < 10) || (mod(opt.k,kout) == 0))
      ffprintf(opt.fid,'k = %i f = %20.5g err = %20.5g delta = %20.5g\n',opt.k,opt.f, opt.df_norm, opt.deltak);
      for ii=1:opt.n
        ffprintf(opt.fid,'x%i = %g;',ii,opt.xs(ii))
      end
      ffprintf(opt.fid,'\n');
    end
        
    opt.k = opt.k + 1;
    
    
%     % Suchrichtung
%     sk = -opt.Bk*opt.df;
%     % Cauchy-Absteigsbedingung
%     [opt, sigmak] = optnlin_nbegrenzt_CauchyAbstieg(opt,sk);
%     if( ~opt.okay ),return;end
    [dk,redQ_tr,par,iter,z,infoGqtpar] = ...
     mex_gqtpar(opt.Hk,opt.df,opt.deltak,opt.TP_rtol,opt.TP_atol,opt.TP_itermax,opt.TP_par);
    if infoGqtpar == 3
       ffprintf(opt.fid,'gqtpar: Rounding errors prevent further progress.\n');
    elseif infoGqtpar == 4
       ffprintf(opt.fid,'gqtpar: Number of iterations has reached maxit.\n');
    end

    % Differenzbildung alter Wert
    opt.xs_last     = opt.xs;
    opt.df_last     = opt.df;
    opt.f_last      = opt.f;
    
%    opt.xs = opt.xs + sigmak*sk;
    opt.xs = opt.xs + dk;
    opt.f  = opt.func(opt.xs);
    
    % Berechnung rho
    % [predsk,opt] = optnlin_nbegrenzt_TrustRegion_Predik(opt,sigmak*sk);
    [predsk,opt] = optnlin_nbegrenzt_TrustRegion_Predik(opt,dk);
    if( ~opt.okay ), return;end
    
    opt.rk  = (opt.f_last-opt.f)/not_zero(predsk);
    
    % neuer Schritt verwerfen wenn rho zu klein
    if( opt.rk < opt.rho1 )
      opt.xs = opt.xs_last;
      opt.f  = opt.f_last;
      new_x  = 0;
    else
      new_x  = 1;
    end
    
    %neuer Trust-Region-RAdius berechnen
    if( opt.rk < opt.rho1 )
      opt.deltak = max(opt.deltamin,opt.deltak*opt.sigma1);
    elseif( (opt.rk >= opt.rho1) && (opt.rk < opt.rho2) )
      opt.deltak = max(opt.deltamin,opt.deltak);
    else
      opt.deltak = min(max(opt.deltamin,opt.sigma2*opt.deltak),1.0e30);
    end
    
    % Norm,Bk,Hk berechnen
    if( new_x )
      if( opt.use_df_func ) 
        opt.df = opt.dfunc(opt.xs);
      else
        opt.df = optnlin_nbegrenzt_build_df(opt);
      end
      opt.df_norm = norm(opt.df); 

      if( opt.df_norm <= opt.err )
        findflag = 1;
      else
    
        if( opt.use_df_func )
          opt.Hk = opt.Hfunc(opt.xs);
          [R,p] = chol(opt.Hk);
          if( p ~= 0 )
            opt.ok     = 0;
            opt.inform = 6;
            return;
          else
            opt.Bk = inv(opt.Hk);
          end
        else
          % Differenzbildung mit neuem Wert
          dk     = opt.xs-opt.xs_last;
          yk     = opt.df-opt.df_last;

          % Berechnung Hk
          dHy = yk-opt.Hk*dk;
          dy  = yk'*dk;

          if( abs(dy) < eps )
            opt.ok     = 0;
            opt.inform = 6;
            return;
          end
          H1  = (dHy*yk'+yk*dHy')/dy;
          H2  = ((dHy'*dk/dy/dy)*yk)*yk';

          opt.Hk  = opt.Hk + H1 - H2;

          % Berechnung Bk
          dBy = dk-opt.Bk*yk;
          dy  = dk'*yk;

          if( abs(dy) < eps )
            opt.ok     = 0;
            opt.inform = 6;
            return;
          end
          B1  = (dBy*dk'+dk*dBy')/dy;
          B2  = ((dBy'*yk/dy/dy)*dk)*dk';

          opt.Bk  = opt.Bk + B1 - B2;
        end
      end
    end
  end
  ffprintf(opt.fid,'k = %i f = %20.5g err = %20.5g deltak = %20.5g\n',opt.k,opt.f, opt.df_norm, opt.deltak);
  for i=1:opt.n
    ffprintf(opt.fid,'x%s = %f\n',num2str(i),opt.xs(i));
  end
  if( opt.k >= opt.kmax )
    opt.okay = 0;
    opt.errtext = 'Trusted Reggion maximale Anzahl der Interationen erreicht';
    opt.inform  = 2;
  end
end
function opt = optnlin_nbegrenzt_TrustRegionWedge(opt)

  o.inSatOptn = 'Splx'; % Initial satellites, 'Rand' or 'Debg' or 'Splx'
  o.AlgOptn   = 'Quadra'; % 'Linear' or 'Quadra'  

  % Stop if any of the following stopping tests is satisfied.
  o.DeltaTol = 10*eps;  % Stopping test 1: Stop if Delta < DeltaTol
  o.fminimum = -inf;    % Stopping test 2: Stop if f <= fminimum
  o.err      = opt.err; % Stopping test 3: Stop if dfnorm < err 
  o.tol_fmin = opt.err; % Stopping test 3: Stop if 
                        % (f - fminimum)/(f0 - fminimum) <= tol_fmin

  o.ITERMAX = opt.kmax;   % Stop if # of iter >= ITERMAX
  o.FEVALMAX = opt.kmax*10;    % Stop if # of function evaluation >= FEVALMAX

  o.gamma  = 0.4;  % Initial gamma (if AlgOptn = 'Quadra'), or
                    % constant value of gamma (if AlgOptn = 'Linear'). 
  o.iPrint = 1;         % 0. no detailed output
                    % 1. detailed output only to file .out
                    % 2. detailed output to screen and to files .out 
  o.dTheta = pi/600;    % increment angle in rotation
  o.subpTechnique = 'RTTN'; 
  o.rtol = opt.TP_rtol;         % gqtpar() arguments 
  o.atol = opt.TP_atol;
  o.maxit = opt.TP_itermax;
  o.par = opt.TP_par; 

  o.fracOptRed = 0.5;   % Factor in equation (4.13) in paper.

  % TR parameters.
  o.optnRad = 'DECR';   % TR radius update
  o.Delta  = opt.delta0;         % Initial TR radius.
  o.alpha1 = opt.rho1;      % alpha1 < alpha2 < 1      
  o.alpha2 = opt.rho2;
  o.gamma1 = opt.sigma1;       %  gamma1 < 1 < gamma2
  o.gamma2 = opt.sigma2;
  
  o.func   = opt.func;
  o.fid    = opt.fid;

  % Ausgabezähler
  o.iterout = round(opt.kmax/100);
  if( o.iterout == 0 ) 
    o.iterout = 1;
  end


 [opt.xs,opt.f,inform,opt.k,opt.kf,nAct,nActRed,opt.df_norm] = optnlin_nbegrenzt_TRW(opt.x0,opt.f,o);
 
%   if( opt.use_df_func ) 
%     opt.df = opt.dfunc(opt.xs);
%   else
%     opt.df = optnlin_nbegrenzt_build_df(opt);
%   end
%   opt.df_norm = norm(opt.df); 
  opt.inform = inform;
  if( inform == 1 )
    opt.errtext = sprintf('trust region radius < DeltaTol=%g',o.DeltaTol);
    opt.okay    = 0;
  elseif( inform == 2 )
    opt.errtext = sprintf('number of iterations >= kmax=%i',opt.kmax);
    opt.okay    = 0;
  elseif( inform == 4 )
    opt.errtext = sprintf('numer of function evaluations >= FEVALMAX=%i',o.FEVALMAX);
    opt.okay    = 0;
  elseif( inform == 3 )
    opt.errtext = sprintf('relative stopping test (f - fminimum)/(f0 - fminimum) <= err=%g',o.tol_fmin);
    opt.okay    = 1;
  elseif( inform == 5 )
    opt.errtext = sprintf('relative stopping test dfnorm <= err=%g',o.err);
    opt.okay    = 1;
  elseif( inform == -1 )
    opt.errtext = sprintf('no further progress can be made');
    opt.okay    = 0;
  else
    opt.errtext = sprintf('inform=%i not known',inform);
    opt.okay    = 0;
  end 
end
function [opt, sigmak] = optnlin_nbegrenzt_Armijo(opt,sk)
  i = 0;
  fac = opt.gamma*(opt.df'*sk);
  sigmak = 1.0;
  delta  = (opt.func(opt.xs+sigmak*sk)-opt.f);
  val    = sigmak*opt.gamma*(opt.df'*sk);
  while( (delta > val) && i < 100 )
    i      = i+1;    
    sigmak = sigmak * opt.beta;
    delta  = (opt.func(opt.xs+sigmak*sk)-opt.f);
    val    = sigmak*fac;
  end
  if( i >= 100 )
    opt.okay    = 0;
    opt.errtext = 'Schrittweitensteuerung Armijo-Regel > 100 Iterationen';
  end
end
function [opt, sigmak] = optnlin_nbegrenzt_PowellWolfe(opt,sk)
  sw     = 1;
  while( sw < 6 )
    switch( sw )
      case 1
        sigmak = 1.0;
        delta  = (opt.func(opt.xs+sigmak*sk)-opt.f);
        val    = sigmak*opt.gamma*(opt.df'*sk);
        if( delta <= val )
          sw = 3;
        else
          sw = 2;
        end
      case 2
        i = 0;
        sigmam = 2^-(i+1);
        delta  = (opt.func(opt.xs+sigmam*sk)-opt.f);
        val    = sigmam*opt.gamma*(opt.df'*sk);
        while( delta > val && i < 100 ) % also nicht erfüllt
          i = i + 1;
          sigmam = 2^-(i+1);
          delta  = (opt.func(opt.xs+sigmam*sk)-opt.f);
          val    = sigmam*opt.gamma*(opt.df'*sk);
        end
        if( i >= 100 )
          opt.okay    = 0;
          opt.errtext = 'Schrittweitensteuerung(2) Powell-Wolfe-Regel > 100 Iterationen';
          return;
        end
        sigmap = 2.0*sigmam;
        sw = 5;
      case 3
        if( opt.use_df_func ) 
          val1 = opt.dfunc(opt.xs+sigmak*sk)'*sk;
        else
          val1 = optnlin_nbegrenzt_build_df(opt,opt.xs+sigmak*sk)'*sk;
        end

        val2   = opt.eta*(opt.df'*sk);
        if( val1 >= val2 )
          sw = 6; % Ende
        else
          sw = 4;
        end
      case 4
        i = 0;
        sigmap = 2^(i+1);
        delta  = (opt.func(opt.xs+sigmap*sk)-opt.f);
        val    = sigmap*opt.gamma*(opt.df'*sk);
        while( delta <= val && i < 100 ) % also nicht erfüllt
          i = i + 1;
          sigmap = 2^(i+1);
          delta  = (opt.func(opt.xs+sigmap*sk)-opt.f);
          val    = sigmap*opt.gamma*(opt.df'*sk);
        end
        if( i >= 100 )
          opt.okay    = 0;
          opt.errtext = 'Schrittweitensteuerung(4) Powell-Wolfe-Regel > 100 Iterationen';
          return;
        end
        sigmam = 0.5*sigmap;
        sw = 5;
      case 5
        i = 0;
        sigmak = sigmam;
        if( opt.use_df_func ) 
          v    = opt.dfunc(opt.xs+sigmak*sk);
          val1 = v'*sk;
        else
          v    = optnlin_nbegrenzt_build_df(opt,opt.xs+sigmak*sk);
          val1 = v'*sk;
        end
        val2   = opt.eta*(opt.df'*sk);
        while( val1 < val2 && i < 100 )
          i      = i+1;
          sigmak = (sigmam+sigmap)*0.5;

          delta  = (opt.func(opt.xs+sigmak*sk)-opt.f);
          val    = sigmak*opt.gamma*(opt.df'*sk);
          if( delta <= val )
            sigmam = sigmak;
          else
            sigmap = sigmak;
          end
          sigmak = sigmam;
          if( opt.use_df_func ) 
            v    = opt.dfunc(opt.xs+sigmak*sk);
            val1 = v'*sk;
          else
            v    = optnlin_nbegrenzt_build_df(opt,opt.xs+sigmak*sk);
            val1 = v'*sk;
          end
          val2   = opt.eta*(opt.df'*sk);
        end
        if( i >= 100 )
          opt.okay    = 0;
          opt.errtext = 'Schrittweitensteuerung(5) Powell-Wolfe-Regel > 100 Iterationen';
          return;
        end
        sigmak = sigmam;
        sw = 6; % Ende
    end
  end
end
function [opt, sigmak] = optnlin_nbegrenzt_Armijo_BFGS(opt,sk)
  i = 0;
  fac = opt.gamma*(opt.df'*sk);
  sigmak = 1.0;
  delta  = (optnlin_nbegrenzt_BFGS_func(opt,opt.xs+sigmak*sk)-opt.f);
  val    = sigmak*opt.gamma*(opt.df'*sk);
  while( (delta > val) && i < 100 )
    i      = i+1;    
    sigmak = sigmak * opt.beta;
    delta  = (optnlin_nbegrenzt_BFGS_func(opt,opt.xs+sigmak*sk)-opt.f);
    val    = sigmak*fac;
  end
  if( i >= 100 )
    opt.okay    = 0;
    opt.errtext = 'Schrittweitensteuerung Armijo-Regel > 100 Iterationen';
  end
end
function [opt, sigmak] = optnlin_nbegrenzt_PowellWolfe_BFGS(opt,sk)
  sw     = 1;
  while( sw < 6 )
    switch( sw )
      case 1
        sigmak = 1.0;
        delta  = (optnlin_nbegrenzt_BFGS_func(opt,opt.xs+sigmak*sk)-opt.f);
        val    = sigmak*opt.gamma*(opt.df'*sk);
        if( delta <= val )
          sw = 3;
        else
          sw = 2;
        end
      case 2
        i = 0;
        sigmam = 2^-(i+1);
        delta  = (optnlin_nbegrenzt_BFGS_func(opt,opt.xs+sigmam*sk)-opt.f);
        val    = sigmam*opt.gamma*(opt.df'*sk);
        while( delta > val && i < 100 ) % also nicht erfüllt
          i = i + 1;
          sigmam = 2^-(i+1);
          delta  = (optnlin_nbegrenzt_BFGS_func(opt,opt.xs+sigmam*sk)-opt.f);
          val    = sigmam*opt.gamma*(opt.df'*sk);
        end
        if( i >= 100 )
          opt.okay    = 0;
          opt.errtext = 'Schrittweitensteuerung(2) Powell-Wolfe-Regel > 100 Iterationen';
          return;
        end
        sigmap = 2.0*sigmam;
        sw = 5;
      case 3
        if( opt.use_df_func ) 
          val1 = opt.dfunc(opt.xs+sigmak*sk)'*sk;
        else
          val1 = optnlin_nbegrenzt_build_df(opt,opt.xs+sigmak*sk)'*sk;
        end

        val2   = opt.eta*(opt.df'*sk);
        if( val1 >= val2 )
          sw = 6; % Ende
        else
          sw = 4;
        end
      case 4
        i = 0;
        sigmap = 2^(i+1);
        delta  = (optnlin_nbegrenzt_BFGS_func(opt,opt.xs+sigmap*sk)-opt.f);
        val    = sigmap*opt.gamma*(opt.df'*sk);
        while( delta <= val && i < 100 ) % also nicht erfüllt
          i = i + 1;
          sigmap = 2^(i+1);
          delta  = (optnlin_nbegrenzt_BFGS_func(opt,opt.xs+sigmap*sk)-opt.f);
          val    = sigmap*opt.gamma*(opt.df'*sk);
        end
        if( i >= 100 )
          opt.okay    = 0;
          opt.errtext = 'Schrittweitensteuerung(4) Powell-Wolfe-Regel > 100 Iterationen';
          return;
        end
        sigmam = 0.5*sigmap;
        sw = 5;
      case 5
        i = 0;
        sigmak = sigmam;
        if( opt.use_df_func ) 
          v    = opt.dfunc(opt.xs+sigmak*sk);
          val1 = v'*sk;
        else
          v    = optnlin_nbegrenzt_build_df(opt,opt.xs+sigmak*sk);
          val1 = v'*sk;
        end
        val2   = opt.eta*(opt.df'*sk);
        while( val1 < val2 && i < 100 )
          i      = i+1;
          sigmak = (sigmam+sigmap)*0.5;

          delta  = (optnlin_nbegrenzt_BFGS_func(opt,opt.xs+sigmak*sk)-opt.f);
          val    = sigmak*opt.gamma*(opt.df'*sk);
          if( delta <= val )
            sigmam = sigmak;
          else
            sigmap = sigmak;
          end
          sigmak = sigmam;
          if( opt.use_df_func ) 
            v    = opt.dfunc(opt.xs+sigmak*sk);
            val1 = v'*sk;
          else
            v    = optnlin_nbegrenzt_build_df(opt,opt.xs+sigmak*sk);
            val1 = v'*sk;
          end
          val2   = opt.eta*(opt.df'*sk);
        end
        if( i >= 100 )
          opt.okay    = 0;
          opt.errtext = 'Schrittweitensteuerung(5) Powell-Wolfe-Regel > 100 Iterationen';
          return;
        end
        sigmak = sigmam;
        sw = 6; % Ende
    end
  end
end
function [opt, sigmak] = optnlin_nbegrenzt_CauchyAbstieg(opt,sk0)

  sigmak = 0.;
  
  % 1. Bedignung norm(sk) <= betaT * deltaT
  sigma1 = opt.betaT*opt.deltaT/norm(sk0);
  
  % 2. Bedignung
  % Cauchy-Schritt sck:
  
  % min qk(sck) = f - t * df'*df + 0.5 * t^2 df'*Hk'df
  % dqk/dt = 0 = -df'*df + t * df'*Hk'df
  A = opt.df'*opt.Hk*opt.df;
  B = opt.df'*opt.df;
  t = B/not_zero(A);
  
  sck = -t * opt.df;
  predsck = optnlin_nbegrenzt_TrustRegion_Predik(opt,sck);
  
  % -sigmak * df'* sk0 - 0.5 * sigmak^2 * sk0' * Hk * sk0 - alphaT * predsck >= 0
  A1 = sk0'*opt.Hk*sk0;
  B1 = opt.df' * sk0;
  C1 = opt.alphaT*predsck;
  D1 = B1*B1-2*A1*C1;
  flag = 0;
  if( norm(A1) <= eps )
    sigma2 = -C1/B1;
    sigma3 = sigma2;
  else
    if( D1 >= 0.0 )
      sigma2 = (-B1+sqrt(D1))/not_zero(A1);
      sigma3 = (-B1-sqrt(D1))/not_zero(A1);
    else
      flag = 1;
    end
  end
  if( flag ) % keine Lösung
    i = 0;
    while( (optnlin_nbegrenzt_TrustRegion_Predik(opt,sk0*sigma1) > C1) && i <= 100 )
      sigma1 = sigma1 * 0.5;
      i      = i+1;
    end
    if( i >= 100 )
      opt.errtext= sprintf('Iteration mit sigma1 geht nicht ');
      opt.okay   = 1;
      return
    end
    sigmak = sigma1;
  else
    if( (sigma2 <= sigma1) && (sigma3 <= sigma1) )
      sigmak = max(sigma2,sigma3);
    elseif( (sigma2 <= sigma1) )
      sigmak = sigma2;
    elseif( (sigma3 <= sigma1) )
      sigmak = sigma3;
    else
      i = 0;
      while( (optnlin_nbegrenzt_TrustRegion_Predik(opt,sk0*sigma1) > C1) && i <= 100 )
        sigma1 = sigma1 * 0.5;
        i      = i+1;
      end
      if( i >= 100 )
        err('Iteration mit sigma1 geht nicht ');
      end
      sigmak = sigma1;      
    end
  end
end
function [pred,opt] = optnlin_nbegrenzt_TrustRegion_Predik(opt,sktest)

   pred = -opt.df' * sktest - 0.5 * sktest' * opt.Hk * sktest;
  
end
function df = optnlin_nbegrenzt_build_df(opt,xs)

 
 df  = opt.xs * 0.0;
 if( nargin == 1 )
   f0 = opt.f;
   x0 = opt.xs;
 else
   f0 = opt.func(xs);
   x0 = xs;
 end
 for i=1:opt.n
   x     = x0;
   dx    = sqrt(eps*max(abs(x(i)),1.e-5));
   x(i)  = x(i)+dx;
   f     = opt.func(x);   
   df(i) = (f - f0)/dx;
 end
end
function [H0,B0] = optnlin_nbegrenzt_build_H0(opt)
  
 x0  = opt.x0;
 H0  = eye(opt.n);
 B0  = H0;
 
 if( opt.use_df_func )
  for i=1:opt.n
    x       = x0;
    dx      = sqrt(eps*max(abs(x(i)),1.e-5));
    df1     = opt.df(i);
    x(i)    = x(i) + dx;
    df      = opt.dfunc(x);
    df2     = df(i);
    H0(i,i) = (df2 - df1)/dx;
    B0(i,i) = 1/not_zero(H0(i,i));
  end
 else
  for i=1:opt.n
    x       = x0;
    f0      = opt.f;
    dx      = sqrt(eps*max(abs(x(i)),1.e-5));
    x(i)    = x(i)+dx;
    f1      = opt.func(x);   
    df1     = (f1 - f0)/dx;
    x(i)    = x(i) + dx;
    f2      = opt.func(x);   
    df2     = (f2 - f1)/dx;
    H0(i,i) = (df2 - df1)/dx;
    B0(i,i) = 1/not_zero(H0(i,i));
  end
 end
    
end
