function s = un_filt_online_param(g,dt,nloop)
%
%  s = un_filt_online_param(g,dt,nloop)
%
%  g     gewichtungsfaktor 0 ... 1
%  dt    Zeitschritt
%  nloop Filterung jede n-te Loop, ansonsten interpolieren
%        ( Aufruf s = un_filt_online(s,xin,external_reset) aber jede Loop )

  s = [];
  % check weight value
  if( g > 0.999 )
    g = 0.999;
  elseif( g < 0.001 )
  
    g = 0.001;
  end
  
  % check dt 
  if( dt < 0.001 )
    s.dt = 0.001;
  else
    s.dt = dt;
  end
  s.dtn = s.dt * nloop;% Calculation LoopTime */;

  % Parameter Calc */
  s.n     = nloop;          % Calculate every n loop */
  s.i     = 0;              % initiate loop calc */
  s.reset = 1;              % set automatically reset */

  s.a11   = g*g;
  s.a12   = s.a11*s.dtn;
  s.a21   = g-1.;
  s.a21   = s.a21 * (s.a21*(-1.));
  s.a21   = s.a21 / s.dtn;
  s.a22   = g*(g-2.)*(-1.);
  s.c1    = (g-1.)*(g+1.)*(-1.);
  s.c2    = (g-1.)*(g-1.);
  s.c2    = s.c2 / s.dtn;

  s.fval   = 0.;
  s.fvalp  = 0.;
  s.xf     = 0.;
  s.xs     = 0.;
  s.xp     = 0.;
end
