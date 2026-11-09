function val = vec_calc_value_from_index(rcalc,vec)
%
% val = vec_calc_value_from_index(rcalc,vec)
%
% rcalc        num       linear interolierten Index mit Anteil
%                        z.B. rcalc = 10.5 ist vec(10)+(vec(11)-vec(10))*0.5
%                        rcalc     = suche_index(time_vec,time0,'===','v')
% vec          num       Vektor
%
  n = length(vec);
  if( rcalc < 0.0 )
    error('%s: rcalc = %f darf nicht kleiner null sein !',mfilename,rcalc);
  elseif( rcalc < 1.0 )
    val = vec(1)+(vec(min(n,2))-vec(1))*(1.0-rcalc);
  elseif( rcalc > n )
    val = vec(n) + (vec(n)-vec(max(1,n-1)))*(rcalc-n);
  else
    i0     = floor(rcalc);
    i1     = ceil(rcalc);
    d      = rcalc - i0;
    val    = vec(max(1,i0)) + ( vec(min(n,i1))- vec(max(1,i0)) ) * d;
  end
end