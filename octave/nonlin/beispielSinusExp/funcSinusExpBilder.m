function ee = funcSinusExpBilder (x)
    
  a = x(1);
  b = x(2);
  c = x(3);
    
  liste  = {'SinusExpBilder_01.mat','SinusExpBilder_02.mat'};
  nliste = length(liste);
    
  ee  = 0.0;
  ne  = 0;
  for iliste = 1:nliste
    % Messwerte
    [xmess,ymess] = funcSinusExpBilderReadData(liste{iliste});
    nmess = length(xmess);
    if( nmess > 0 )
      % Approximerte Funktion mit xmess
      y = sin(a*xmess+b)+exp(c*xmess);
      % Fehler dieser Messreihe
      dy = ymess-y;
      e  = sqrt((dy'*dy)/nmess/nmess);
      % Fehler gesamt
      q  = ne/nmess;
      ee = (ee*q+e)/(q+1);
      ne = ne + nmess;
    end
  end
    
end
function [x,y] = funcSinusExpBilderReadData(mat_datei)

  [okay,d] = d_data_read_mat(mat_datei);
  if( okay )
    x = d.x;
    y = d.y;
  else
    error('Datei <%s> konnte nicht eingelesen werden',mat_datei);
  end

end
