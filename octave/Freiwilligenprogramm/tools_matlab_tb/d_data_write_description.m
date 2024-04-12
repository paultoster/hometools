function okay = d_data_write_description(excel_falg,duh_mat_file_name)
%
%  okay = d_data_write_description(excel_falg)
%  okay = d_data_write_description(excel_falg,duh_mat_file_name)
%  
%  excel_falg       1:         excelDatei

  if( ~exist('excel_falg','var') )
    excel_falg = 0;
  end
  if( ~exist('duh_mat_file_name','var') )
    [okay,d,u,h,f] = d_data_read_mat;
  else
    [okay,d,u,h,f] = d_data_read_mat(duh_mat_file_name);
  end
  if( ~okay )
    return;
  end
  
  if( length(h) >= 1 )
    descr = h{1};
  else
    descr = '';
  end  
  if( length(h) >= 2 )
    c = h{2};
  else
    c = [];
  end
  
  d_names = fieldnames(d);
  n       = length(d_names);
  u_names = cell(1,n);
  c_names = cell(1,n);
  
  for i=1:n
    
    if( struct_find_f(u,d_names{i},1) )
      u_names{i} = u.(d_names{i});
    else
      u_names{i} = '';
    end  
    if( struct_find_f(c,d_names{i},1) )
      c_names{i} = c.(d_names{i});
    else
      c_names{i} = '';
    end  
  end
  
  tt = sprintf('Datei: %s\n%s',f,descr);
  
  if( excel_falg )
    excel_file = str_filename_change_ext(f,'xls');
  else
    excel_file = '';
  end
  okay = o_ausgabe_tabelle_f('vec_list',{d_names,u_names,c_names} ...
                             ,'name_list',{'Signalname','Einheit','Kommentar'} ...
                             ,'title',tt ...
                             ,'debug_fid',0 ...
                             ,'screen_flag',1 ...
                             ,'excel_file',excel_file);
end
  