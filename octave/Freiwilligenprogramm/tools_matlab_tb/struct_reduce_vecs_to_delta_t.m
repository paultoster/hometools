function d = struct_reduce_vecs_to_delta_t(d,delta_t0,delta_t1,time_name,zero_time_flag)
%
% d = struct_reduce_vecs_to_delta_t(d,delta_t0,delta_t1,[time_name='time'],[zero_time_flag=1])
%
% delta_t0   zum Beginn abschneiden, wenn delta_t0 >= 0.0
% delta_t1   am Ende abschneiden, wenn delta_t1 >= 0.0

  if( ~exist('time_name','var') )
      time_name = 'time';
  end
  if( ~exist('zero_time_flag','var') )
      zero_time_flag = 1;
  end

  if( delta_t0 < 0.0 )
    delta_t0 = 0.0;
  end
  if( delta_t1 < 0.0 )
    delta_t1 = 0.0;
  end
  c_names = fieldnames(d);

  ifound = cell_find_f(c_names,time_name,'f');

  if( ~isempty(ifound) )

    if( delta_t0 > eps )
      for i=1:length(d)

        tmin = min(d(i).(time_name));

        n = length(d(i).(time_name));
        i0 = suche_index(d(i).(time_name),tmin+delta_t0,'==');

        if( i0 < 1 ), i0=1;end
        if( i0 > n ), i0=n;end

        for j=1:length(c_names)

          if( isnumeric(d(i).(c_names{j})) && (length(d(i).(c_names{j}))==n) )
            d(i).(c_names{j}) = d(i).(c_names{j})(i0:n);
          elseif( iscell(d(i).(c_names{j})) && (length(d(i).(c_names{j}))==n) )
            if( i0 > 1 )
              d(i).(c_names{j}) = cell_delete(d(i).(c_names{j}),1,i0-1);
            end
          end
        end
      end
    end
    if( delta_t1 > eps )
     for i=1:length(d)

       tmax = max(d(i).(time_name));

       n = length(d(i).(time_name));
       i1 = suche_index(d(i).(time_name),tmax-delta_t1,'==');

       if( i1 < 1 ), i1=1;end
       if( i1 > n ), i1=n;end

       for j=1:length(c_names)

          if( isnumeric(d(i).(c_names{j})) && (length(d(i).(c_names{j}))==n) )

            d(i).(c_names{j}) = d(i).(c_names{j})(1:i1);
          elseif( iscell(d(i).(c_names{j})) && (length(d(i).(c_names{j}))==n) )
            if( i1 < n )
              d(i).(c_names{j}) = cell_delete(d(i).(c_names{j}),i1+1,n);
            end
          end
      end
    end
    if( zero_time_flag )
        d(i).(time_name) = d(i).(time_name) - d(i).(time_name)(1);
    end

  end
end