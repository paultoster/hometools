function s = but2_filt_online_param(T,dt,nloop,prolong)
  
  s = [];
  % Parameter Calc
  s.n     = nloop;           % Calculate every n loop
  s.i     = 0;               % initiate loop calc
  s.reset = 1;               % set automatically reset
  s.dt    = dt;
  s.dtn   = s.dt * nloop;    % Calculation LoopTime
  s.prol  = prolong;
  
  % check weight value %
  if( s.dtn < 0.000001 )
    s.dtn = 0.000001; 
  end
  if( T < s.dtn )
    T = s.dtn;
  end

  % Omegac %
  om = tan(pi/(T/s.dtn));

  % c = 1 + 2*cos(pi/4)*om + om^2 %
  c = cos(pi/4.);
  c = c * 2. + om;
  c = c*om+1.;

  s.a0 = om*om/c;
  s.a1 = 2. * s.a0;
  s.a2 = s.a0;
  s.b1 = 2. * (om*om-1)/c;
  s.b2 = (1.+(-2.*cos(pi/4)+om)*om)/c;

  s.fm1val = 0.;
  s.fm2val = 0.;
  s.fval   = 0.;
  s.xm1val = 0.;
  s.xm2val = 0.;
  s.fvalp  = 0.;
    
end
