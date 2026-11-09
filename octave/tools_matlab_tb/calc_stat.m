function s = calc_stat(vec)
%
% s = calc_stat(vec)
%
% Statistik von einem Vektor
%
% s.min      Minimum
% s.imin     index Minumum
% s.max      Maximum
% s.imax     index Maximum
% s.mean     Mittelwert
% s.absmean  Mittelwert aus Absolutwerte
% s.std      Standardabweichung
% s.absstd   Standardabweichung aus Absolutwerte

  [n,m] = size(vec);
  
  if( m > n ) 
    vec = vec';
    mm  = m;
    m   = n;
    n   = mm;
  end
  
  s.min     = zeros(m,1);
  s.max     = zeros(m,1);
  s.imin     = zeros(m,1);
  s.imax     = zeros(m,1);
  s.mean    = zeros(m,1);
  s.absmean = zeros(m,1);
  s.std     = zeros(m,1);
  s.absstd  = zeros(m,1);
  
  for i=1:m
    
    [s.min(i),s.imin(i)] = min(vec(:,i));
    [s.max(i),s.imax(i)] = max(vec(:,i));
    s.mean(i)            = mean(vec(:,i));
    s.absmean(i)         = mean(abs(vec(:,i)));
    s.std(i)             = std(vec(:,i));
    s.absstd(i)          = std(abs(vec(:,i)));
  end
  
end