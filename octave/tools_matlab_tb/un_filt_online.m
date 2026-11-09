function s = un_filt_online(s,xin,external_reset)
%
% s = un_filt_online(s,xin,external_reset)
% s              Struktur mit s = un_filt_online_param(g,dt,nloop) bilden
% xin            neuer Wert 
% external_reset reset durchführen
%
% output:
% s.fval       Filterwert
% s.fvalp      zeitl. Ableitung
%

 % loop counter */
  s.i = s.i + 1;

 % Reset */
  if( external_reset )  
    s.reset = 1;
  end
  if( s.reset )
    s.xf = xin;
    s.xs = (1.-s.a11-s.c1) * (xin) /  s.a12;
    s.xp = 0.;
    s.reset  = 0;
    s.i      = s.n;
  end


  % Estimate Points inbetween */
  if( s.i < s.n )
    s.fval = s.xf + s.fvalp * s.dt * s.i;
  
  % Calculate Filter */
  else
  
    s.i = 0;

   % filt neuer Wert */
    xf = s.a11 * s.xf + s.a12 * s.xs + s.c1 * (xin);
    xs = s.a21 * s.xf + s.a22 * s.xs + s.c2 * (xin);

    dx      = xf - s.xf;
    s.xf  = xf;
    s.xs  = xs;

    s.fval = xf;
    
   % fvalp berechnen 2. Ordnung */

    s.fvalp = s.xp;
    s.xp     = dx/s.dtn;      % neuer Wert Speichern */ 
    s.fvalp  = s.fvalp+s.xp;
    s.fvalp  = s.fvalp*0.5;
  end
end
