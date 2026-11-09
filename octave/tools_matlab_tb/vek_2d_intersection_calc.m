function value = vek_2d_intersection_calc(vec,iact,dPathAct)
%
% value = vek_2d_intersection_calc(vec,iact,dPathAct)
%
% calculation of linear point on vector
%

n = length(vec);

if( iact > n )
  value = 0.0;
else
  value = vec(iact) + (vec(iact+1)-vec(iact))*dPathAct;
end

