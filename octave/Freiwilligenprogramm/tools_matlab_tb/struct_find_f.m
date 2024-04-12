function flag = struct_find_f(d,suchtext,notempty)
% Aufruf: flag = struct_find_f(d_struct,such_text[,notempty])
%        z.B. struct_find_f(d,''Vref'')
%        flag = 1, wenn gefunden
%        flag = 0, wenn nicht gefunden 
%
% notempty  falg = 1 wenn gefunden und nicht leer (defauklt = 0)
%   
if( ~exist('notempty','var') )
  notempty = 0;
end
flag = 0;
if( isstruct(d) )
    c_names = fieldnames(d);
    for i=1:length(c_names)

        if( strcmp(c_names{i},suchtext) )
          if( notempty )
            if( ~isempty(d.(c_names{i})) )
              flag = 1;
            end
          else
            flag = 1;
          end
          return
        end
    end
end
    
