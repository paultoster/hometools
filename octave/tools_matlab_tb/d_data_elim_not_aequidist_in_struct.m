function d = d_data_elim_not_aequidist_in_struct(d,fieldname,jitter_factor)
%
% d = d_data_elim_not_aequidist_in_struct(d,fieldname,jitter_factor)
%
% Eleminiert Werte in der gesamten Struct wenn d.(fieldname)(i+1)-d.(fieldname)(i)
% nicht aequidistant (gleicher Abstand) sind
%
% Die obere Schranke für aequidistant wird aus
% mean(diff(d.(fieldname))*(1.0+jitter_factor) gebildet
%
% Die untere Schranke für aequidistant wird aus
% mean(diff(d.(fieldname))*(1.0-jitter_factor) gebildet
%             
% d             Data-struktur mit äquidistanten Vektoren und erster Vektor ist Zeit
%               d.time
%               d.F
%               ...
% fieldname     der zu betrachtende Vektor d.(fieldname) 
% jitter_factor Wert für zulässigen jitter siehe oben (default eps) 
% 
  if( ~exist('jitter_factor','var') )
    jitter_factor = eps;
  end
  if( jitter_factor < 0. )
    jitter_factor = jitter_factor * (-1.0);
  end
  
  if( ~isfield(d,fieldname) )
    error('der fieldname:<%s> ist in Datenstruktur nicht vorhanden',fieldname)
  end
  
  ndata = length(d.(fieldname));
  dvec  = diff(d.(fieldname));
%
% Schranken
%
  limo = mean(dvec);
  limu = limo * (1.0-jitter_factor);
  limo = limo * (1.0+jitter_factor);
  
  index_liste = 1;
  for i=1:ndata-1
    if( (dvec(i) <= limo) && (dvec(i) >= limu) )
      index_liste = [index_liste;i+1];
    end
  end
  nindex_liste = length(index_liste);
  
  fn = fieldnames(d);
  n  = length(fn);
  for i=1:n
    if( length(d.(fn{i})) == ndata )
      vec = zeros(nindex_liste,1);
      for j=1:nindex_liste
        vec(j) = d.(fn{i})(index_liste(j));
      end
      d.(fn{i}) = vec;
    end
  end
end