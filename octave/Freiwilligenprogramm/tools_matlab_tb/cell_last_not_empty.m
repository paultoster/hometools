function [nrow,ncol] = cell_last_not_empty(c)
%
% [nrow,ncol] = cell_last_not_empty(c)
%
% [nrow,ncol] für letzte nicht leeren cell,, ansonsten [nrow,ncol] = [0, 0]
%
% c     cellarray    mit Vektoren gefüllt, z.B. trajectory, aber erst zu
%                    einem bestimmten zeitpubkt
  if( ~iscell(c) )
      error('cell_last_not_empty: erster Parameter c ist kein cell-array')
  end

  nrow = 0;
  ncol = 0;
  [nrows,ncols] = size(c);
  for j=ncols:-1:1  
    for i=nrows:-1:1
      if( ~isempty(c{i,j}) )
        nrow = i;
        ncol = j;
        return
      end
    end
  end
end