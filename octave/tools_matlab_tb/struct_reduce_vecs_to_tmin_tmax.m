function d = struct_reduce_vecs_to_tmin_tmax(d,tmin,tmax,time_name,zero_time_flag)
%
% d = struct_reduce_vecs_to_tmin_tmax(d,tmin,tmax,[time_name='time'],[zero_time_flag=1])
%
  if( ~exist('time_name','var') )
      time_name = 'time';
  end
  if( ~exist('zero_time_flag','var') )
      zero_time_flag = 1;
  end

  c_names = fieldnames(d);

  ifound = cell_find_f(c_names,time_name,'f');

  if( ~isempty(ifound) )

    for i=1:length(d)

      if( tmin < 0 ),tmin = min(d(i).(time_name));end
      if( tmax < 0 ),tmax = max(d(i).(time_name));end

      n = length(d(i).(time_name));
      i0 = suche_index(d(i).(time_name),tmin,'==');
      i1 = suche_index(d(i).(time_name),tmax,'==');

      if( i0 < 1 ), i0=1;end
      if( i1 > n ), i1=n;end

      for j=1:length(c_names)

          if( isnumeric(d(i).(c_names{j})) && (length(d(i).(c_names{j}))==n) )

              d(i).(c_names{j}) = d(i).(c_names{j})(i0:i1);
          end
      end
      if( zero_time_flag )
          d(i).(time_name) = d(i).(time_name) - d(i).(time_name)(1);
      end
    end

  end
end