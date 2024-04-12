function [cyvec,u] = cell_vec_convert_unit(cyvec,unit_in,unit_out)
%
% [cyvec,u] = cell_vec_convert_unit(cyinvec,unit_in,unit_out)
%
% Konvertiert cell array mit Vektor yin mit unit_in in y mit unit_out
%
  [n,m] = size(cyvec);
    
  u = unit_out;
  
  for i= 1:n
    for j=1:m      
      if( ~isempty(cyvec{i,j}) )     
        [cyvec{i,j},u] = vec_convert_unit(cyvec{i,j},unit_in,unit_out);
      end
    end
  end
end