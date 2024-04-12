function [flag,iliste,jliste] = suche_wert_in_vek(vek,wert,tol)
%
% [flag,iliste,jliste] = suche_wert_in_vek(vek,wert,tol)
%
% Sucht Wert im Vektor mit der angegebenen Toleranz (default 1e-6)
%
% vek       num   Vektor vek(i)
% wert      num   gesuchter Wert
% tol       num   Toleranz
%
% flag            0/1 gefunden/nicht gefunden
% iliste
% jliste          Liste mit vek(iliste(i),jliste(i)) i=1:length(iliste) 

  iliste = [];
  jliste = [];
  flag = 0;
  
  if( ~exist('tol','var') )
    tol = 1e-6;
  else
    tol = abs(tol);
  end
  [n,m] = size(vek);
  for i=1:n
    for j=1:m
      if( abs(vek(i,j)-wert) < tol )
        iliste = [iliste,i];
        jliste = [jliste,j];
        flag   = 1;
      end
    end
  end 
end