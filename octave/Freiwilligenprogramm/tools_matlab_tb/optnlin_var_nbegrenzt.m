function opt = optnlin_var_nbegrenzt(opt)
%
% Lösen von Minimusfunktionen
%        - Methode des steilsten Abstiegs
%        - BFGS-Verfahren (Newton-ähnlich
%        - Trust-Region-Verfahren
%
% opt = optnlin_var_nbegrenzt (opt)
%
% [xs,opt] = optnonlin_unconstrained (opt)
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
%
%opt.type = 0   Methode Steilster Abstieg (Hfunc wird nicht benutzt)
%
% opt.stype      0: Schrittweiten Regelung für steilsetn Abstieg nach Armijo-Regel
%                1: Schrittweiten Regelung für steilsetn Abstieg nach Powell-Wolfe
% stype=0:     Armijo-Regel
%  opt.beta      Skalierungsfaktor für Schrittweiensteuerung 0 < beta < 1  (def 0.5)
%  opt.gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-4)
% stype=1:     Powell-Wolfe-Regel
%  opt.gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung 0 < gamma < 1 (def 1e-4)
%  opt.eta       gamma < eta < 1 skaliert Gradienten gröber
%
%opt.type = 1   Quasi-Newton-Verfahren
%  opt.gamma     Skalierungsfaktor Gradient für Schrittweiensteuerung (Powell-Wolfe-Regel)
%                0 < gamma < 1 (def 1e-4)
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
% opt.nshow    Wieviel beste Minimas anzeigen?(def 3)
% opt.P        Parameterbeschreibung, Anzahl der Parameter m = length(opt.P)
%              opt.P(i).name   = 'Parametername';
%              opt.P(i).xmin   = Minimalwert zu suchen
%              opt.P(i).xmax   = Maximalwert zu suchen
%              opt.P(i).n      = Anzahl der Stützstellen für Anfangswert x0
%              
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
%               - no further progress can be made               (inform = -1)
% opt.xs        letzter berechneter x-Vektor
% opt.f         Funktionswert in opt.xs
% opt.df        Ableitung in opt.xs
%
% opt.df_norm   Norm der Ableitung
% opt.xs_mat(:,nshow)      nshow besten berechneten x-Vektoren
% opt.f_vec(nshow)         nshow besten Funktionswerte in opt.xs
% opt.df_norm_vec(nshow)   nshow besten Fehlerwerte der Ableitung
% opt.k_vec(nshow)         Iteratiosschritte dazu

  if( ~isfield(opt,'fid') )
    opt.fid = 1;
  end
  if( ~isfield(opt,'nshow') )
    opt.nshow = 3;
  end
  if( ~isfield(opt,'use_in_range') )
    opt.use_in_range = 0;
  end
  

  % Parameterbeschreibung opt.P prüfen
  %===================================
  if( ~isfield(opt,'P') )
    error('Parameterbeschreibung opt.P nicht definiert in Struktur');
  end
  if( ~isstruct(opt.P) )
    error('Parameterbeschreibung opt.P ist keine Struktur');
  end
  if( ~isfield(opt.P,'xmin') )
    error('Parameterbeschreibung opt.P(i).xmin Minimum nicht vorhanden');
  end
  if( ~isfield(opt.P,'xmax') )
    error('Parameterbeschreibung opt.P(i).xmax Maximum nicht vorhanden');
  end
  if( ~isfield(opt.P,'n') )
    error('Parameterbeschreibung opt.P(i).n Anzahl Stützstellen für Anfangswert x0 nicht vorhanden');
  end
  
  % Vorbereiten
  %============
  m    = length(opt.P);
  nend = 1;
  for i=1:m
    if( opt.P(i).n < 0.99 )
      error('Anzahl Stützstellen opt.P(i).n > 0')
    end
    if( opt.P(i).n > 1 )
      opt.P(i).delta = (opt.P(i).xmax - opt.P(i).xmin)/(opt.P(i).n-1);
    else
      opt.P(i).delta = 0.0;
    end
    opt.P(i).nact = 1;
    nend          = nend * opt.P(i).n;
  end
    
  % alle Parameterpunkte als Startwert durchrechnen
  %================================================
  opt.x0 = zeros(m,1);
  opt.P(1).nact     = opt.P(1).nact - 1;
  opt.xs_mat        = [];
  opt.df_norm_vec   = [];
  opt.f_vec         = [];
  opt.k_vec         = [];
  opt.errtext_cell  = {};
  opt.inform_vec    = [];
  opt.calc_time_vec = [];
  kgesamt           = 0;
  tic
  for i = 1:nend
    
    ffprintf(opt.fid,'Index %i(%i) itype:%i \n#################################################\n',i,nend, opt.type)
    
    % Anfangswerte permutieren
    j = 1;
    opt.P(j).nact = opt.P(j).nact + 1;
    while( j < m )
     j = j+1;
     if( opt.P(j-1).nact > opt.P(j-1).n )
      opt.P(j-1).nact = 1;
      opt.P(j).nact   = opt.P(j).nact + 1;
     end
    end
      
    % Anfangswert bilden
    for j=1:m
      opt.x0(j) = opt.P(j).xmin + opt.P(j).delta * (opt.P(j).nact-1);
    end
    
    % Optimierung
    [xs,opt] = optnlin_nbegrenzt(opt);
    
    if( ~opt.okay )
      warning(opt.errtext);
    end
    
    kgesamt = kgesamt + opt.k;


    % Sortieren
    if(  (opt.use_in_range && optnlin_var_nbegrenzt_is_in_rage(xs,opt)) ...
      || ~opt.use_in_range ...
      )
        opt = optnlin_var_nbegrenzt_sort(xs,opt);
    end  
    % Ergebnis anzeigen
    ffprintf(opt.fid,'Eregebnis:\n');
    ffprintf(opt.fid,'-----------------------------------------------------------\n');
    ffprintf(opt.fid,'Eregebnis:\n');
    for j=1:m
      ffprintf(opt.fid,'Startwert %14s = %f\n',opt.P(j).name,opt.x0(j));
    end
    for j=1:m
      ffprintf(opt.fid,'Parameter %14s = %f\n',opt.P(j).name,opt.xs(j));
    end
    ffprintf(opt.fid,'Minimum                f = %f\n',opt.f);
    ffprintf(opt.fid,'FehlerAbleitung  df_norm = %f\n',opt.df_norm);
    ffprintf(opt.fid,'Iterationen            k = %i\n',opt.k);
    ffprintf(opt.fid,'inform            inform = %i\n',opt.inform);
    ffprintf(opt.fid,'errtext          errtext = %s\n',opt.errtext);
    ffprintf(opt.fid,'calc_time      calc_time = %f\n',opt.calc_time);
    ffprintf(opt.fid,'-----------------------------------------------------------\n');
  end
    
  % Ergebnisse anzeigen
  %====================
  ffprintf(opt.fid,'Eregebnis (%i besten Werte):\n',length(opt.f_vec));
  ffprintf(opt.fid,'===========================================================\n');
  toc
  ffprintf(opt.fid,'kgesamt: %i\n',kgesamt);
  ffprintf(opt.fid,'===========================================================\n');
  for i=1:length(opt.f_vec)
    for j=1:m
      ffprintf(opt.fid,'Startwert %14s = %f              (opt.x0_mat(%i,%i))\n',opt.P(j).name,opt.x0_mat(j,i),j,i);
    end
    for j=1:m
      ffprintf(opt.fid,'Parameter %14s = %f              (opt.xs_mat(%i,%i))\n',opt.P(j).name,opt.xs_mat(j,i),j,i);
    end
    ffprintf(opt.fid,'Minimum                f = %f              (opt.f_vec(%i))\n',opt.f_vec(i),i);
    ffprintf(opt.fid,'FehlerAbleitung  df_norm = %f              (opt.df_norm_vec(%i))\n',opt.df_norm_vec(i),i);
    ffprintf(opt.fid,'Iterationen            k = %i              (opt.k_vec(%i))\n',opt.k_vec(i),i);
    ffprintf(opt.fid,'inform            inform = %i              (opt.inform_vec(%i))\n',opt.inform_vec(i),i);
    ffprintf(opt.fid,'errtext          errtext = %s              (opt.errtext_cell(%i))\n',opt.errtext_cell{i},i);
    ffprintf(opt.fid,'calc_time      calc_time = %f              (opt.calc_time_vec(%i))\n',opt.calc_time_vec(i),i);
    ffprintf(opt.fid,'===========================================================\n');
  end
  
end

function opt = optnlin_var_nbegrenzt_sort(xs,opt)

  n = length(opt.f_vec);
  ff          = [opt.f_vec;opt.f];
  [fff,ifff]  = sort(ff);
  m           = min(opt.nshow,length(fff));
  xs_mat      = [];
  x0_mat      = [];
  df_norm_vec = [];
  k_vec       = [];
  errtext_cell  = {};
  inform_vec    = [];
  calc_time_vec = [];
  for i = 1:m
    ii = ifff(i);
    if( ii > n )
      xs_mat      = [xs_mat,xs];
      x0_mat      = [x0_mat,opt.x0];
      df_norm_vec = [df_norm_vec;opt.df_norm];
      k_vec       = [k_vec;opt.k];
      errtext_cell{length(errtext_cell)+1} = opt.errtext;
      inform_vec  = [inform_vec;opt.inform];
      calc_time_vec  = [calc_time_vec;opt.calc_time];
    else
      xs_mat      = [xs_mat,opt.xs_mat(:,ii)];
      x0_mat      = [x0_mat,opt.x0_mat(:,ii)];
      df_norm_vec = [df_norm_vec;opt.df_norm_vec(ii)];
      k_vec       = [k_vec;opt.k_vec(ii)];
      errtext_cell{length(errtext_cell)+1} = opt.errtext_cell{ii};
      inform_vec  = [inform_vec;opt.inform_vec(ii)];
      calc_time_vec = [calc_time_vec;opt.calc_time_vec(ii)];
    end      
  end
  
  opt.f_vec        = fff(1:m);
  opt.xs_mat       = xs_mat;
  opt.x0_mat       = x0_mat;
  opt.df_norm_vec  = df_norm_vec;
  opt.k_vec        = k_vec;
  opt.errtext_cell = errtext_cell;
  opt.inform_vec   = inform_vec;
  opt.calc_time_vec = calc_time_vec;

end
function okay = optnlin_var_nbegrenzt_is_in_rage(xs,opt)

  okay = 1;
  for i=1:opt.n
    if( (xs(i) < opt.P(i).xmin) || (xs(i) > opt.P(i).xmax) )
      okay = 0;
      return;
    end
  end
end