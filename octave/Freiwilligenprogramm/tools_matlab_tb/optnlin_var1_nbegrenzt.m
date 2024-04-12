function [okay,res] = optnlin_var1_nbegrenzt(opt)
%
% Lösen von Minimusfunktionen mit
%        - Methode des steilsten Abstiegs
%        - BFGS-Verfahren (Newton-ähnlich
%        - Trust-Region-Verfahren
%
% opt = optnlin_var1_nbegrenzt (opt)
%
% Parametervariation über Vorgabe
% opt.P        Parameterbeschreibung, Anzahl der Parameter m = length(opt.P)
%              opt.P(i).name   = 'Parametername';
%              opt.P(i).xmin   = Minimalwert zu suchen
%              opt.P(i).xmax   = Maximalwert zu suchen
%              opt.P(i).n      = Anzahl der Stützstellen für Anfangswert x0
%              opt.P(i).dxP    = Penality Abstand
%
% Daraus wird der Beste Wert genommen und als Startwert für die Optimierung
% verwendet
%
% Werte speichern:
% opt.BestListFile    = 'dateiname.mat';   Dateiname, wenn vorhanden, dann
%                                          benutzen
% opt.useBestListFile = 1/0;               Soll, wenn vorhanden, benutzt
%                                          werden
% opt.nsortBestList                        Wieviele besten Werte aus
%                                          Bestenliste soll für Optimierung 
%                                          verwendet werden (default nmax)
% opt.fmaxBestList                         Bis zu welchem Maximalwert für f
%                                          soll Optimum in Bestenliste
%                                          als Startwert gesucht werden
%
%==========================================================================
  okay = 1;
  res  = [];
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
  if( ~isfield(opt.P,'dxP') )
    for i=1:length(opt.P) 
      opt.P(i).dxP = abs(opt.P(i).xmax-opt.P(i).xmin)*0.1;
    end
  end
  for i=1:length(opt.P)
    if( isempty(opt.P(i).xmin) )
      error('opt.P(%i).xmin ist leer',i);
    end
    if( isempty(opt.P(i).xmax) )
      error('opt.P(%i).xmax ist leer',i);
    end
    if( isempty(opt.P(i).n) )
      error('opt.P(%i).n ist leer',i);
    end
    if( isempty(opt.P(i).dxP) )
      error('opt.P(%i).dxP ist leer',i);
    end
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
  
  % BestListe speichern
  %====================
  if( ~isfield(opt,'BestListFile') )
    opt.useBestListFile = 0;
  end
  if( opt.useBestListFile )
    if( isempty(opt.BestListFile) )
      opt.useBestListFile = 0;
    elseif( ~exist(opt.BestListFile,'file') )
      opt.useBestListFile = 0;
    end
  end
  if( ~isfield(opt,'nsortBestList') )
    opt.nsortBestList = nend;
  end
  if( ~isfield(opt,'fmaxBestList') )
    opt.fmaxBestList = [];
  end

  if( ~isfield(opt,'func') )
    error('Functioncall opt.func  (f=funx(x)) not defined in option-structure');
  end
    
  % Bestenliste erstellen
  %======================
  if( opt.useBestListFile ) % einlesen
    load(opt.BestListFile);
  else
    % alle Parameterpunkte als Startwert durchrechnen
    %================================================
    d   = [];
    d.f = ones(nend,1)*1e39;
    for i=1:m
      d.(opt.P(i).name) = zeros(nend,1);
      d.(['i_',opt.P(i).name]) = zeros(nend,1);
    end
    opt.P(1).nact     = opt.P(1).nact - 1;
    opt.x0 = zeros(m,1);
    for i = 1:nend

      ffprintf(opt.fid,'====== %i/%i =====================\n',i,nend);
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
        d.(opt.P(j).name)(i)        = opt.x0(j);
        d.(['i_',opt.P(j).name])(i) = opt.P(j).nact;
      end

      % Berechnung der Funktion mit dem Anfangswert
      try
          for j=1:m
            ffprintf(opt.fid,'x%i = %f\n',j,opt.x0(j));
          end
         d.f(i)  = opt.func(opt.x0);
         ffprintf(opt.fid,'f = %f\n',d.f(i));
      catch ME
        error(getReport(ME));
        opt.okay = 0;
        opt.errtext = sprintf('Die Funktion opt.func(opt.x0) kann nicht ausgeführt werden');
        ffprintf(opt.fid,'%s\n\n',opt.errtext);
        for j=1:m
          ffprintf(opt.fid,'Startwert %14s = %f\n',opt.P(j).name,opt.x0(j));
        end
        return;
      end
    end
    save(opt.BestListFile,'d');
  end 
  
  % Sortieren nach f
  d = d_data_sort_vector_in_struct(d,'f',1);
  % Bestenliste n-Werte darstellen
  optnlin_var1_nbegrenzt_bestenliste_tabelle(opt.P,d,m,nend,nend);
  % aus Bestenliste Minimum und Zwischenminumums sammeln
  dd = optnlin_var1_nbegrenzt_bestenliste_dursuchen(opt.P,d,m,nend,opt.fmaxBestList);

  res.df_norm      = [];
  res.f            = [];
  res.k            = [];
  res.errtext_cell = {};
  res.inform       = [];
  res.calc_time    = [];
  kgesamt          = 0;

  % Optimierung mit den besten Startwerten:
  ndd = length(dd.f);
  ndd = min(ndd,opt.nsortBestList);
  for j=1:m
    res.(opt.P(j).name) = zeros(ndd,1);
    res.(['x0_',opt.P(j).name]) = zeros(ndd,1);
  end
  res.df_norm      = zeros(ndd,1);
  res.f            = zeros(ndd,1);
  res.k            = zeros(ndd,1);
  res.errtext_cell = cell(ndd,1);
  res.calc_time    = zeros(ndd,1);
  res.inform       = zeros(ndd,1);
  for i = 1:ndd
    for j=1:m
      opt.x0(j) = dd.(opt.P(j).name)(i);
      if( opt.x0(j) > opt.P(j).xmax*0.95 )
        opt.x0(j) = opt.P(j).xmax*0.95;
      elseif( opt.x0(j) < opt.P(j).xmin*1.05 )
        opt.x0(j) = opt.P(j).xmin*1.05;
      end
    end
    [xs,opt] = optnlin_nbegrenzt(opt);
%     xs = opt.x0;
%     opt.df_norm = 0;
%     opt.f = 0.;
%     opt.k  = 0;
%     opt.inform = 0;
%     opt.calc_time = 0;
%     opt.okay = 1;
    if( ~opt.okay )
      ffprintf(opt.fid,opt.errtext);
    end
    % Ergebnis speichern
    kgesamt  = kgesamt + opt.k;
    for j=1:m
      res.(opt.P(j).name)(i) = xs(j);
      res.(['x0_',opt.P(j).name])(i) = opt.x0(j);
    end
    res.df_norm(i) = opt.df_norm;
    res.f(i)       = opt.f;
    res.k(i)       = opt.k;
    res.errtext_cell{i} = opt.errtext;
    res.calc_time(i)    = opt.calc_time;
    res.inform(i)       = opt.inform;
  end
  % Sortieren nach f
  res = d_data_sort_vector_in_struct(res,'f',ndd);
  % Ausgabe
  optnlin_var1_nbegrenzt_optimiert_tabelle(opt.P,res,m,ndd);

end
function  optnlin_var1_nbegrenzt_bestenliste_tabelle(P,d,m,nend,nbest)

  % Ergebnis anzeigen
  vec_liste  = cell(2+2*m);
  name_liste = cell(2+2*m);
  n          = min(nbest,nend);
  vec_liste{1} = [1:1:n]';
  name_liste{1} = 'Nr'; 
  vec_liste{2} = d.f(1:n);
  name_liste{2} = 'f';
  tt = '(';
  for i=1:m
    vec_liste{2+(2*i-1)}  = d.(['i_',P(i).name])(1:n);
    name_liste{2+(2*i-1)} = ['i_',P(i).name];
    vec_liste{2+2*i}      = d.(P(i).name)(1:n);
    name_liste{2+2*i}     = P(i).name;
    if( i == 1 )
      tt = [tt,'(',num2str(P(i).n)];
    else
      tt = [tt,'/',num2str(P(i).n)];
    end
  end
  tt = [tt,')'];
  okay = o_ausgabe_tabelle_f('vec_list',vec_liste ...
                            ,'name_list',name_liste ...
                            ,'title',['Die ',num2str(nbest),' besten Parameter ',tt] ...
                            ,'debug_fid',0 ...
                            ,'screen_flag',1 ...
                            ,'excel_file','');
  
end
function dd = optnlin_var1_nbegrenzt_bestenliste_dursuchen(P,d,m,nend,fmax)

  % erstes gefundenes Minimum in dd und f0, p0 bilden
  % Dieser Wert wird auf jedenfall verwendet auch wenn > fmax
  idd  = 1;
  dd.f(idd) = d.f(1);
  f0        = d.f(1);

  p0 = zeros(m,1);
  for j = 1:m
    dd.(['i_',P(j).name])(idd) = d.(['i_',P(j).name])(1);
    dd.(P(j).name)(idd)        = d.(P(j).name)(1);

    p0(j) = d.(['i_',P(j).name])(1);
  end
  
  % weitere relevante 
  for i = 2:nend
    
    f1 = d.f(i);
    p1 = zeros(m,1);
    for j = 1:m
      p1(j) = d.(['i_',P(j).name])(i);
    end
    
    % Bilde Abstand r = p0p1
    r = 0.0;
    for j = 1:m, r = r + (p1(j)-p0(j))^2; end
    r = sqrt(r);
    
    % Suche Stützstellen entlang r
    drvec = [];
    for j = 1:m
      dpj10 = p1(j)-p0(j);
      if(  dpj10 < -0.5 ) % negativ
        for k = -1:-1:dpj10
          dr = r/dpj10*k;
          drvec = [drvec;dr];
        end
      elseif( dpj10 > 0.5 ) % positiv
        for k = 1:1:dpj10
          dr = r/dpj10*k;
          drvec = [drvec;dr];
        end
      end
    end
    drvec = sortiere_aufsteigend_f(drvec);
    % drvec = elim_vec_zunahe_elemente_f(drvec,0.0001);
    flag  = 0;
    for k = 1:length(drvec)
      pj = zeros(m,1);
      for l = 1:m
        pj(l) = p0(l)+(p1(l)-p0(l))/r*drvec(k);
      end
      [okay,f,ii] = optnlin_var1_nbegrenzt_suche_in_bestenliste(d,P,pj,m,nend);
      if( okay && (f > f1) ) % d.h das zwischen f0 und f1 (f1 > f0, da sortiert) ist
                             % f größer, und damit könnte ein weiteres Minimum
                             % vorhanden sein
        flag = 1;
        break;
      end
    end
    if( flag ) % Noch einen weiteren Wert speichern
      if( isempty(fmax) || (d.f(ii) < fmax) )
        idd  = idd+1;
        dd.f(idd) = d.f(ii);
        for j = 1:m
          dd.(['i_',P(j).name])(idd) = d.(['i_',P(j).name])(ii);
          dd.(P(j).name)(idd)        = d.(P(j).name)(ii);
        end
      end
    end
  end
end
function [okay,f,ii] = optnlin_var1_nbegrenzt_suche_in_bestenliste(d,P,pj,m,nend)
% Die indizes pj werden in d gesucht
%
  okay = 1;
  f    = 1.0e39;
  ii   = 0;
  for j = 1:m
    if( pj(j) < 1 )
      pj(j) = 1;
    elseif( pj(j) > P(j).n )
      pj(j) = P(j).n;
    else
      pj(j) = round(pj(j));
    end
  end
  for i=1:nend
    g = 0;
    for j=1:m
      if( abs(d.(['i_',P(j).name])(i)-pj(j)) < 0.5 )
        g = g +1;
      end
    end
    if( g == m )
      f  = d.f(i);
      ii = i;
      break;
    end
  end
  if( g < m )
    okay = 0;
  end
end
function optnlin_var1_nbegrenzt_optimiert_tabelle(P,res,m,nend)

  % Ergebnis anzeigen
  vec_liste  = cell(5+2*m);
  name_liste = cell(5+2*m);
  vec_liste{1} = [1:1:nend]';
  name_liste{1} = 'Nr'; 
  vec_liste{2} = res.f(1:nend);
  name_liste{2} = 'f';
  vec_liste{3} = res.k(1:nend);
  name_liste{3} = 'k';
  vec_liste{4} = res.df_norm(1:nend);
  name_liste{4} = 'df_norm';
  vec_liste{5} = res.calc_time(1:nend);
  name_liste{5} = 'calc_time';
  
  tt = '(';
  for i=1:m
    vec_liste{5+(2*i-1)}  = res.(['x0_',P(i).name])(1:nend);
    name_liste{5+(2*i-1)} = ['x0_',P(i).name];
    vec_liste{5+2*i}      = res.(P(i).name)(1:nend);
    name_liste{5+2*i}     = P(i).name;
    if( i == 1 )
      tt = [tt,'(',num2str(P(i).n)];
    else
      tt = [tt,'/',num2str(P(i).n)];
    end
  end
  tt = [tt,')'];
  
  okay = o_ausgabe_tabelle_f('vec_list',vec_liste ...
                            ,'name_list',name_liste ...
                            ,'title',['Optimierter Parameter ',tt] ...
                            ,'debug_fid',0 ...
                            ,'screen_flag',1 ...
                            ,'excel_file','');
  
  
end