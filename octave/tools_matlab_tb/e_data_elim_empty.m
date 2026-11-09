function [ee]=e_data_elim_empty(e)
%
% [ee]=e_data_elim_empty(e)
% Eleminiert leere Struktur-Elemente (leere Vektoren)
%
  if( length(e) > 1 )
    error('Struktur e soll kein array sein, sonst nicht gut zu bereinigen')
  end
  c_names = fieldnames(e);
  ee = [];
  for i = 1:length(c_names) 
    if( e_data_is_timevec(e,c_names{i}) )
      if( ~isempty(e.(c_names{i}).time) && ~isempty(e.(c_names{i}).vec) )
        ee.(c_names{i}) = e.(c_names{i});
      end
    elseif( e_data_is_param(e,c_names{i}) )
      if( check_val_in_struct(e.(c_names{i}),'param','num',1) )
        ee.(c_names{i}) = e.(c_names{i});
      end
    end
  end
end