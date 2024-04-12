function [e,q] = get_e_data(q)
%
  
  if( ~isfield(q,'read_from_disc') )
    q.read_from_disc = 0;
  end
  if( qlast_exist(2) && ~q.read_from_disc)
    q.file_list      = qlast_get(2);
    q.load_file_list = 1; 
  else
    q.load_file_list = 0;
    q.use_start_dir  = 1;
    if( qlast_exist(1) )
      q.start_dir = qlast_get(1);
    else
      q.start_dir = 'D:\';
    end
    q.load_one_file = 1;
  end
  
  [e,q,measdir] = mess_plot_read_e_data(q);
  qlast_set(1,measdir);
end