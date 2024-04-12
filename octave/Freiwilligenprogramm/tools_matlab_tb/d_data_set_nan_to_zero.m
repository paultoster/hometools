function d =d_data_set_nan_to_zero(d)
%
% [d]=d_data_set_nan_to_zero(d)
% setzt alle NaN-werte zu null
%
  c_names = fieldnames(d);
  for i = 1:length(c_names)
    ll  = length(d.(c_names{i}));
    vec = isnan(d.(c_names{i}));
    if( max(vec) > 0 )
      if( sum(vec) == ll )
        warning('In Vektor <%s> sind alle items NaN\n',c_names{i})
      end
      for j = 1:ll
        if( isnan(d.(c_names{i})(j)) )
          d.(c_names{i})(j) = 0.;
        end
      end
    end
  end
end