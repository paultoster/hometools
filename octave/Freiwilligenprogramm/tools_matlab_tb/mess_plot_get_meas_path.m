function meas_dir = mess_plot_get_meas_path(q)
%
%  meas_dir = mess_plot_get_meas_path(q)
%
% Search for one ecal-messdir with hdf5 data
%
% q.use_start_dir            0/1     Start-Dir soll benutzt werden
%                            2       benutze q.start_dir = qlast_get(1);
%                                    und     qlast_set(1,measdir);
% q.start_dir                string  Start-Dir zum suchen
%
%  meas_dir                          is notempty if set
%
  meas_dir         = '';
  
  if( ~isfield(q,'use_start_dir') )
    q.use_start_dir = 0;
  end
  if( ~isfield(q,'start_dir') )
    q.start_dir = '';
  end
  if( q.use_start_dir == 2 )
    if( ~isempty(qlast_get(1)) )
      q.start_dir = qlast_get(1);
    end
  end
  

  s_frage             = [];
  s_frage.comment     = 'Verzeichnis mit Ecal-Messdateien auswählen';
    
  if( q.use_start_dir && exist(q.start_dir,'file'))
      s_frage.start_dir = q.start_dir;
  else
      s_frage.start_dir = 'd:\';
  end
  [okay,c_dirname] = o_abfragen_dir_f(s_frage);


  if( okay )
    meas_dir = c_dirname{1};
  end

end
