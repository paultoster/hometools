function [okay,errtext] = make_plot_traj_for_t0(t0,path)
%
% [okay,errtext] = make_plot_traj_for_t0(t0,path)
%
%  make o plot of trajectory at time t0 
%  find description file trajectory_description.m on path
%  
% 
  fprintf('start make_plot_traj_for_t0\n');
  okay    = 1;
  errtext = '';
  
  % get e-struct from base
  %-----------------------
  try
    e = evalin('base', 'e');
    clear e
  catch
    errtext = sprintf('make_plot_traj_for_t0:e-structure could not be found in base workspace');
    okay = 0;
    return
  end
  
  % proof trajectory description file
  %----------------------------------
  filename = fullfile(path,'trajectory_description.m');
  if( ~exist(filename,'file') )
    errtext = sprintf('make_plot_traj_for_t0:description file not found <%s>',filename);
    okay = 0;
    return
  end
  
  
  
  
  % decide to build seg (segmentation of trajectorries)
  %----------------------------------------------------
  make_seg = 0;
  try   
    e_traj   = evalin('base', 'e_traj');
    e_data_read_time   = evalin('base', 'e_data_read_time');
    e_traj_read_time = evalin('base', 'e_traj_read_time');    
    
    if( datenum(e_traj_read_time) < datenum(e_data_read_time) )
      make_seg = 1;
    end
    
    listing = dir(filename);
    if( datenum(e_traj.q.datetime) < listing.datenum )
      make_seg = 1;
    end
      
  catch
    make_seg = 1;
  end
  make_seg = 1;
  % make segmentation
  if( make_seg )
    filename = fullfile(path,'trajectory_description.m');
    if( ~exist(filename,'file') )
      errtext = sprintf('make_plot_traj_for_t0:description file not found <%s>',filename);
      okay = 0;
      return
    else
      try
        addpath(get_path_from_fullfilename(filename));
        eval(get_file_name(filename,1));
        fprintf('run %s\n',filename);
      catch exception
        print_exception_to_screen(exception)
      end
    end
  end
  
  e_traj   = evalin('base', 'e_traj');
  
  make_plot_traj_seg_plot(e_traj.q,e_traj.seg,e_traj.nseg,t0);
  fprintf('end   make_plot_traj_for_t0\n');
end