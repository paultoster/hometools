function  [okay,s_data,n_data] = duh_mat_daten_einlesen_f(filename)

  okay = 1;

  [okay,c_d,c_u,c_h,n_data] = d_cell_data_read_mat(filename);
  
  s_file = str_get_pfe_f(filename);
  
  s_data(1,max(1,n_data)) = struct( 'file', [], 'name', [], 'c_prc_files',[], 'd',[], 'u',[], 'h',[]);

  for id = 1:n_data
    s_data(id).file      = filename;
    if( n_data > 1 )
      s_data(id).name    = [s_file.name,'_',num2str(id)];
    else
      s_data(id).name    = s_file.name;
    end
    s_data(id).d         = c_d{id};
    s_data(id).u         = c_u{id};
    s_data(id).h         = c_h{id};
    
  end

end
