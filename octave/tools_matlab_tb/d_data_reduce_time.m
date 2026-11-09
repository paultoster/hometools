function d = d_data_reduce_time(d,tstart,tend,zero_flag)
%
% d = d_data_reduce_time(d,tstart,tend,zero_flag)
%
% d           Data-struktur mit äquidistanten Vektoren und erster Vektor ist Zeit
%             d.time
%             d.F
%             ...
% tstart      Startzeit für Eingrenzung, wenn nicht benutzt, dann tstart = -1
% tend        Endzeit für Eingrenzung, wenn nicht benutzt, dann tend = -1
% zero_flag   flag Zeitvektor geht aus null raus
% 
  
  c_names = fieldnames(d);
  nd      = length(d);
  for id=1:nd
    nt      = length(d(id).(c_names{1}));

    if( tstart > 0. )
      i0 = suche_index(d(id).(c_names{1}),tstart);
      if( i0 < 1 )
        i0 = 1;
      end
    else
      i0 = 1;
    end
    if( (tend > 0.) && (tend > tstart) )
      i1 = suche_index(d(id).(c_names{1}),tend,'====');
      if( i1 > nt )
        i1 = nt;
      end
    else
      i1 = nt;
    end
    d(id) = d_data_reduce_by_index(d(id),i0,i1,zero_flag);
  end
end