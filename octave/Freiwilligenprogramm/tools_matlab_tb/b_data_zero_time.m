function b = b_data_zero_time(b)
%
% b = b_data_zero_time(b)
%
% nullt die Zeit
% 

  if( b.time(1) > eps )
    delta_t = b.time(1);
    for i = 1:length(b.time)
      b.time(i) = b.time(i) - delta_t;
    end
  end
end