function c2 = cell_delete(c1,ivec,i1)
%
% c2 = cell_delete(c1,i)
% c2 = cell_delete(c1,ivec)
% c2 = cell_delete(c1,i0,i1)
%
% Löscht aus cell-array das Element i oder ivec oder von i0 bis i1 als vector von indices
% 
  c2 = {};

  if( ~iscell(c1) )
      error('cell_delete: c1 ist kein cell-array')
  end
  if( ~exist('ivec','var') )
      error('cell_cut: ivec ist nicht vorhanden')
  end
  if( exist('i1','var') )
      flag = 1;
      i0   = ivec(1);
      if( i1 < i0 )
        %error('i1 > i0, sollte umgekehrt sein');
        c2 = c1;
        return
      end
  else
    flag = 0;
  end

  n = length(c1);
  if( flag )
    i0 = min(n,i0);
    i1 = min(n,i1);
    i = 1;
    while( i < i0 )
      c2{i} = c1{i};
      i     = i+1;
    end
    i = i1+1;
    while( i <= n )
      c2{length(c2)+1} = c1{i};
      i = i + 1;
    end
  else      
    for i=1:n
      if( isempty(find_val_in_vec(ivec,i)) )
        c2{length(c2)+1} = c1{i};
      end
    end
  end
end