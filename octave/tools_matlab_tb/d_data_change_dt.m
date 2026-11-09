function [okay,d] = d_data_change_dt(d,dt)
%
% [okay,d] = d_data_change_dt(d,dt)
%
% d           Data-struktur mit äquidistanten Vektoren und erster Vektor ist Zeit
%             d.time
%             d.F
%             ...
% dt          loop time
% 
  okay = 1;
  if( dt < 1e-6 )
    okay = 0;
  else
    n = length(d);
    for id=1:n

      c_names = fieldnames(d(id));

      time = d(id).(c_names{1});
      [nn,mm] =size(time);

      t0 = time(1);
      t1 = time(length(time));

      if( nn > 1 && nn > mm )
        time_new = [t0:dt:t1]';
      else
        time_new = [t0:dt:t1];
      end        

      for j = 2:length(c_names)

          d(id).(c_names{j}) = interp1(time,d(id).(c_names{j}),time_new,'linear','extrap');
      end
      d(id).(c_names{1}) = time_new;
    end
  end
end