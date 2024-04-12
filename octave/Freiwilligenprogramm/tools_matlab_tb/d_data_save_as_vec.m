function d_data_save_as_vec(d,filename)
%
% d_data_save_as_vec(d,filename)
%
  % Namen der d-Struktur
  c_name = fieldnames(d);
  n      = length(c_name);
  
  tt = 'save(filename';
  for i=1:n
    command = [c_name{i},' = d.',c_name{i},';'];
    eval(command);
    
    if( i ~= n )
      tt = [tt,', ''',c_name{i},''''];
    else
      tt = [tt,', ''',c_name{i},''');'];
    end
  end
  
  eval(tt);
end
