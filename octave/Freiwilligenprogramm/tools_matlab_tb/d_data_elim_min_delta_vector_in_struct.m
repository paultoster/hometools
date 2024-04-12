function d = d_data_elim_min_delta_vector_in_struct(d,fieldname,delta_min)
%
% d = d_data_elim_min_delta_vector_in_struct(d,fieldname,delta_min)
%
% Eleminiert Werte in gesamter struct, wenn d.('fieldname') Abstände hat, die kleiner delta_min
% sind 
%             
% d           Data-struktur mit äquidistanten Vektoren und erster Vektor ist Zeit
%             d.time
%             d.F
%             ...
% fieldname   der zu betrachtende Vektor d.(fieldname) mit zu geringen
%             Abständen
% delta_min   Abstand zwischen zwei Werten aus d.('fieldname')(default= eps)


% 
  if( ~exist('delta_min','var') )
    delta_min = eps;
  end
  
  if( ~isfield(d,fieldname) )
    error('der fieldname:<%s> ist in Datenstruktur nicht vorhanden',fieldname)
  end
  
  ndata = length(d.(fieldname));
  [vec,ivec] = elim_vec_zunahe_elemente_f(d.(fieldname),delta_min);
  d.(fieldname) = vec;
  nvec = length(ivec);
  
  fn = fieldnames(d);
  n  = length(fn);
  for i=1:n
    if( ~strcmp(fn{i},fieldname) && length(d.(fn{i})) == ndata )
      vec = zeros(ndata-nvec,1);
      kk  = 0;
      for j=1:ndata
        if( isempty(find_val_in_vec(ivec,j,0.1)) )
          kk = kk + 1;
          vec(kk) = d.(fn{i})(j);
        end
      end
      d.(fn{i}) = vec;
    end
  end
end