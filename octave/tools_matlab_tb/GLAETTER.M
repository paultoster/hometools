function y=glaetter(x,n,g)
% glaetter.m  UN 3.7.96 
%
% y=glaetter(x,n,g)
% nichtkausal(zero phase), lokale Parabelapproximation
%
% Vektor x (eindimensional) wird geglättet
% 2 n+1 Punkte werden exponentiell gewichtet für die Parabelapproximation 
% herangezogen
% 0<g<1 Gedächtnis: g=0 keine Erinnerung (nur aktueller Eingang)
%                   g=1 alles gleich gewichtet    

  x=x(:);                               % Spalte erzwingen


  % Hilfsgrößen:
  index=(-n:n)';                                
  s0=sum(g.^abs(index));
  s2=sum((index.^2).*g.^abs(index));
  s4=sum((index.^4).*g.^abs(index));

  % Filterkoeffizienten:
  b=(s4-index.^2*s2)/(s0*s4-s2^2).*g.^abs(index);
  y=filter(b,1,x);

  % Ergebnis
  y=flipud(filter(b,1,flipud(y)));

return

