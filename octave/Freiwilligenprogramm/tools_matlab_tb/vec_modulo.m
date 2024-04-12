function vecout = vec_modulo(type,vec,modmin,modmax)
%
% vecout = vec_modulo(type,vec,modmin,modmax)
% 
% Rechnet in den Vektor einen Modulowert rein oder raus
%
% type  = 1:     Bilde Vektor mit Modulo-Rechnung
%       = 2:     Rechne Modulo aus dem Vektor raus
% vec            Eingangsvektor
% modmin         min-Wert des Modulos (bei reinem Modulo ist modmin = 0.0; könnte aber auch -pi sein)
% modmax         max-Wert des Modulos
%
% output vecout

  n      = length(vec);
  d      = modmax - modmin;
  
  vecout = vec*0.0;

  if( type < 1.5 ) % bilde Vektor mit modulo

    vec    = vec - modmin;
    vecout = mod(vec,d);
    vecout = vecout + modmin;

  else % rechne Modulo raus

    d2     = d/2;
    if( vec(1) > d2 ) 
      nmod = -1;
    else
      nmod = 0;
    end

    vecout(1) = vec(1) + nmod * d;

    for i=2:n
      delta = vec(i) - vec(i-1);
      if( delta > d2 )
        nmod = nmod - 1;
      elseif( delta < -d2 )
        nmod = nmod + 1;
      end
      vecout(i) = vec(i) + nmod * d;
    end

  end

end
  
  
