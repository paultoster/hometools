function c = cell_shift(c,ishift)
%
% c = cell_shift(c,ishift)
%
% verschiebt Inhalt um ishift = 1,2,3,... index nach vorne (vergrößern)
% verschiebt Inhalt um ishift = -1,-2,-3,... index nach hinten (verkleinern)
% 

  if( ~iscell(c) )
      error('cell_shift: c ist kein cell-array')
  end
  if( ~exist('ishift','var') )
      error('cell_shift: i ist nicht vorhanden')
  end
  n = length(c);
  ishift = round(ishift);
  if( ishift > 0 )
    for i=n:-1:1
      c{i+ishift} = c{i};
    end
  elseif(ishift < 0 )
    ishift = -ishift;
    if( ishift > n )
      c = {};
    else
      c1 = cell(1,n-ishift);
      for i=1:n-ishift;
        c1{i} = c{i+ishift};
      end
      c = c1;
    end
  end
end