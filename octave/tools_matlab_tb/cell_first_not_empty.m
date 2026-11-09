function [nrow,ncol] = cell_first_not_empty(c)
%
% [nrow,ncol] = cell_first_not_empty(c)
%
% [nrow,ncol] für erste nicht leere cell,, ansonsten [nrow,ncol] = [0, 0]
%
% c     cellarray    mit Vektoren gefüllt, z.B. trajectory, aber erst zu
%                    einem bestimmten zeitpubkt
  if( ~iscell(c) )
      error('cell_first_not_empty: erster Parameter c ist kein cell-array')
  end

  nrow = 0;
  ncol = 0;
  [nrows,ncols] = size(c);
  for j=1:ncols  
    for i=1:nrows
      if( ~isempty(c{i,j}) )
        nrow = i;
        ncol = j;
        return
      end
    end
  end
end