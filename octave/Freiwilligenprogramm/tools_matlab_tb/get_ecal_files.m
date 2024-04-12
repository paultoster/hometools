function  [ecaldirs]    = get_ecal_files(read_meas_path)
      
  c_all_dir_list = get_sub_dirs(read_meas_path);
  s_files        = suche_files_ext(c_all_dir_list,'hdf5');
  
  ecaldirs = {};

  for i=1:length(s_files)
    
    % Proof if parant-dir of sfile has a doc folder 
    % if then this is the measurement folder
    hdfpath = s_files(i).dir;
    messpath = get_parent_path(hdfpath);
    subpaths = get_sub_dirs(messpath);
    ifound   = cell_find_f(subpaths,fullfile(messpath,'doc'),'fl');
    
    % if dir 'doc' is found, messpath is parant path
    if( ~isempty(ifound) )
      if( isempty(cell_find_f(ecaldirs,messpath,'fl')) )
        ecaldirs = cell_add(ecaldirs,messpath);
      end
    % if dir 'doc' is not found, hdfpath is parant path
    else
      if( isempty(cell_find_f(ecaldirs,hdfpath,'fl')) )
        ecaldirs = cell_add(ecaldirs,hdfpath);
      end
    end
  end
    
end
