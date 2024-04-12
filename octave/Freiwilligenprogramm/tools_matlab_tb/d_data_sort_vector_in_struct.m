function d = d_data_sort_vector_in_struct(d,fieldname,steigend)
%
% d = d_data_sort_vector_in_struct(d,fieldname,steigend)
%
% Sortiert die Vektoren in d nach der d.fieldname
%             
% d           Data-struktur mit äquidistanten Vektoren und erster Vektor ist Zeit
%             d.time
%             d.F
%             ...
% fieldname   der zu sortierende Vektor d.(fieldname) 
% steigend    = 1 aufsteigend (default)
%             = 0 abfallend

% 
  if( ~exist('steigend','var') )
    steigend = 1;
  end
  
  if( ~isfield(d,fieldname) )
    error('der fieldname:<%s> ist in Datenstruktur nicht vorhanden',fieldname)
  end
  
  if( steigend )
    [a,ivec] = sort(d.(fieldname));
  else
    [a,ivec] = sort(d.(fieldname), 'descend');
  end
  nvec = length(ivec);
  
  fn = fieldnames(d);
  n  = length(fn);
  for i=1:n
    if( length(d.(fn{i})) == nvec )
      if( iscell(d.(fn{i})) )
        cvec = cell(nvec,1);
        for j=1:nvec
          cvec{j} = d.(fn{i}){ivec(j)};
        end
        d.(fn{i}) = vec;
      else
        vec = zeros(nvec,1);
        for j=1:nvec
          vec(j) = d.(fn{i})(ivec(j));
        end
        d.(fn{i}) = vec;
      end
    end
  end
end