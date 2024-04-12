function vec = vec_elim_nan(vec,substitute)
%
% vec = vec_elim_nan(vec);
% vec = vec_elim_nan(vec,substitute);
%
% substitute values in vektor with 'NaN' to 0 (default) or substitute
%
%
  if( ~exist('substitute','var') )
    substitute = 0.;
  end
  ll  = length(vec);
  ivec = isnan(vec);
  if( max(ivec) > 0 )
    if( sum(ivec) == ll )
      warning('In Vektor sind alle items NaN\n')
    end
    vec(ivec) = substitute;
  end
end
