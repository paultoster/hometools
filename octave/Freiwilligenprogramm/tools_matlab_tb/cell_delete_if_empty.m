function c = cell_delete_if_empty(c)
%
% c = cell_delete_if_empty(c);
%
% Löscht cell array  wenn leer 
%
  n = length(c);
  ii = [];
  for i=1:n
    if( isempty(c{i}) )
      ii = [ii;i];
    end
  end
  if( ~isempty(ii) )
    c = cell_delete(c,ii);
  end
end
