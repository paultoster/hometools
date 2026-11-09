function value = e_data_get_value_at_time_only(e,signame,t0)
%
% [value,index] = e_data_get_value_at_time(e,signame,t0)
%
% 
  value = [];
  index = 0;
  if( ~isfield(e,signame) )
    error('e.(%s) is not existend',signame);
  end
  if( e_data_is_timevec(e,signame) )
      
      index = suche_index(e.(signame).time,t0,'====');
      if( iscell(e.(signame).vec) )
        value = e.(signame).vec{index};
      else
        value = e.(signame).vec(index);
      end
  end

end