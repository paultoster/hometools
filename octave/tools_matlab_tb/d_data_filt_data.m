function [okay,d1,u1] = d_data_filt_data(c_name_list,d,u)
%
% [okay,d,u] = d_data_filt_data(c_name_list,d,u)
%
% c_name_list Liste mit Namen, die erhalten bleiben sollen
%             {'time','F'}
%
% d           Data-struktur mit äquidistanten Vektoren und erster Vektor ist Zeit
%             d.time
%             d.F
%             ...
% u           Unit-Struktur mit gleichen Namen, wie in d
%             u.time = 's'; 

% 
  okay = 1;
  d1 = struct;
  u1 = struct;
  if( exist('u','var') )
    use_u_flag = 1;
  else
    use_u_flag = 0;
  end
  
  for i=1:length(c_name_list)
    
    name = c_name_list{i};
    
    if( struct_find_f(d,name) )
      
      d1.(name) = d.(name);
      if( use_u_flag )
        if( isfield(u,'name') )
          u1.(name) = u.(name);
        else
          u1.(name) = '';
        end
      end
    end
  end
end