function S = butter2_filter_online_ini(T,dt,nloop)
%
% s = butter2_filter_online_ini(T,dt,nloop)
%
% Butterworth second order filters online init
%

  MAT_COS_PI4 = cos(pi/4);
  S.n     = nloop;           % Calculate every n loop */
  S.i     = 0;               % initiate loop calc */
  S.reset = 1;               % set automatically reset */
  S.dt    = dt;
  S.dtn   = S.dt * nloop; % Calculation LoopTime */;
  
  % check weight value */
  if( S.dtn < 0.000001 )
  
    S.dtn = 0.000001; 
  end
  if( T < S.dtn )
  
    T = S.dtn;
  end

  % Omegac */
  om = tan(pi/(T/S.dtn));

  % c = 1 + 2*cos(pi/4)*om + om^2 */

  c = MAT_COS_PI4 * 2. + om;
  c = c*om+1.;

  S.a0 = om*om/c;
  S.a1 = 2. * S.a0;
  S.a2 = S.a0;
  S.b1 = 2. *(om*om-1.)/c;
  S.b2 = (1. +(-2. * MAT_COS_PI4+om)*om)/c;

  S.fm1val = 0.;
  S.fm2val = 0.;
  S.fval   = 0.;
  S.xm1val = 0.;
  S.xm2val = 0.;
  S.fvalp  = 0.;
end