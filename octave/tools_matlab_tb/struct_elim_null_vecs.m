function [d,u] = struct_elim_null_vecs(d,u)
%
% d     = struct_elim_null_vecs(d);
% [d,u] = struct_elim_null_vecs(d,u);
%
if( ~exist('u','var') )
    u = struct([]);
    u_flag = 0;
else
    u_flag = 1;
end   

if(  ~isempty(d) )

  c_names = fieldnames(d);
  if( u_flag )
      c_names_u =  fieldnames(d);
      u0 = struct([]);
  end

  startflag = 1;
  d0 = struct([]);
  for i=1:length(c_names)

      if( isnumeric(d.(c_names{i})) )

          if( length(d.(c_names{i})) > 0 )

              if( u_flag && struct_find_f(u,c_names{i}) )
                  if( isempty(u0) )
                      u0 = struct(c_names{i},u.(c_names{i}));
                  else
                      u0.(c_names{i}) =u.(c_names{i});
                  end
              end
              if( isempty(d0) )
                  d0 = struct(c_names{i},d.(c_names{i}));
              else
                  d0.(c_names{i}) =d.(c_names{i});
              end
          end
      else
              if( isempty(d0) )
                  d0 = struct(c_names{i},d.(c_names{i}));
              else
                  d0.(c_names{i}) =d.(c_names{i});
              end
          if( u_flag && struct_find_f(u,c_names{i}) )
              if( isempty(u0) )
                  u0 = struct(c_names{i},u.(c_names{i}));
              else
                  u0.(c_names{i}) =u.(c_names{i});
              end
          end
      end
  end
  d = d0;
  if( u_flag )
      u = u0;
  end
end
            