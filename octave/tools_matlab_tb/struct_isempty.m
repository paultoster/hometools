function flag = struct_isempty(d)
% Aufruf: flag = struct_isempty(d)
%        z.B. struct_find_f(d,''Vref'')
%        flag = 1, wenn leer
%        flag = 0, wenn nicht leer 
%
% notempty  falg = 1 wenn gefunden und nicht leer (defauklt = 0)
% 
  flag = 0;
  if( isempty(d) )
    flag = 1;
  else
    try
      c_names = fieldnames(d);
      if( length(c_names) == 0 )
        flag = 1;
      end
    catch
      flag = 1;
    end
  end
end    
