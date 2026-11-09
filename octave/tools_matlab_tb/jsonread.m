function [out,okay] = jsonread(file_name)
%
% [out,okay] = jsonread(file_name)
%
  
  if( ~exist(file_name,'file') )
    error('Filename: <%s> does not exist',file_name)
  end
  
  if( get_verion_number > 9.05 )
    [ okay,c,~ ] = read_ascii_file(file_name);
    t = cell_str_build_text(c);
    out = jsondecode(t);
  else
    okay = 1;
    out = 0;
    
    json.startup;
    j = json.read(file_name);    
    out = cell_matrix_to_nested(j)';
  end
end
