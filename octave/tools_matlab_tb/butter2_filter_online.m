function S = butter2_filter_online(S,xraw,external_reset)
%
  % loop counter
  S.i = S.i + 1;

  % Reset */
  if( external_reset )
  
    S.reset = 1;
  end
  if( S.reset )
  
    S.fm1val = xraw;
    S.fm2val = xraw;
    S.fval   = xraw;
    S.xm1val = xraw;
    S.xm2val = xraw;
    S.fvalp  = 0.;
    S.reset  = 0;
    S.i      = S.n;
  end


  % Estimate Points inbetween */
  if( S.i < S.n )
  
    S.fval = S.fval + S.fvalp * S.dt * S.i;
  
  % Calculate Filter */
  else
  
    S.i = 0;

    S.fval   =  S.a0 * (xraw);
    S.fval   = S.fval + S.a1 * S.xm1val;
    S.fval   = S.fval + S.a2 * S.xm2val;
    S.fval   = S.fval - S.b1 * S.fm1val;
    S.fval   = S.fval - S.b2 * S.fm2val;

    % S.fvalp  = (S.fval-S.fm1val)/S.dtn; */
    S.fvalp  = (S.fval-S.fm2val)/S.dtn/2.;


    % Umspeichern */
    S.fm2val =  S.fm1val;
    S.fm1val =  S.fval;

    S.xm2val = S.xm1val;
    S.xm1val = xraw;

  end
end