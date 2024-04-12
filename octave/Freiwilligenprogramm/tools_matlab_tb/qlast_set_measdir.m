function okay = qlast_set_measdir( measdir )
%
%   okay = qlast_set_measdir( measdir )
%   okay = qlast_set_measdir( )
%
%  set directory in to qlast_set(1,measdir)
%  use measdir = qlast_get(1) to get last stored
%  
  okay = 1;
  if( ~exist('measdir','var') )
    s_frage.comment   = 'Pfad mit den Messungen auswählen';
    s_frage.start_dir = qlast_get(1);
    [path_okay,c_dirname] = o_abfragen_dir_f(s_frage);
    if( path_okay )
      measdir = c_dirname{1};
    else
      okay = 0;
    end
  end
  
  if( okay )
    
    qlast_set(1,measdir);
    
  end

end

