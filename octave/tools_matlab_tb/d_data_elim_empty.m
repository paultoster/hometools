function [dd,uu]=d_data_elim_empty(d,u)
%
% [dd,uu]=d_data_elim_empty(d,u)
% Eleminiert leere Struktur-Elemente (leere Vektoren)
%
  if( length(d) > 1 )
    error('Struktur d soll kein array sein, sonst nicht gut zu bereinigen')
  end
  c_names = fieldnames(d);
  dd = [];
  uu = [];
  for i = 1:length(c_names) 
    if( ~isempty(d.(c_names{i})) )
      dd.(c_names{i}) = d.(c_names{i});
      if( isfield(u,c_names{i}) )
        uu.(c_names{i}) = u.(c_names{i});
      else
        uu.(c_names{i}) = '';
      end
    end
  end
end