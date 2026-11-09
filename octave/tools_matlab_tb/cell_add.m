function c1 = cell_add(c1,c2,add_cell_in_cell)
%
% c1 = cell_add(c1,c2) oder
% c1 = cell_add(c1,'text') oder
% c1 = cell_add(c1,[1,2,3,4])
% oder
% 
%
% to add cell in cell c1{i}{j}
%
% c1 = cell_add(c1,c2,1)
% Fügt an c1 Inhalt von c2
%
  if( ~exist('add_cell_in_cell','var') )
    add_cell_in_cell= 0;
  end
  if( ~iscell(c1) )
      error('cell_add: erster Parameter c1 ist kein cell-array')
  end
  if( ischar(c2) )
    c2 = {c2};
    add_cell_in_cell = 0;
  elseif( isnumeric(c2) )
    c2 = {c2};
    add_cell_in_cell = 0;
  elseif( ~iscell(c2) )
    c1{length(c1)+1} = c2;
    return
    % error('cell_add: zweiter Parameter c2 ist kein cell-array,char oder numeric')
  end

  [nrows1,ncols1] = size(c1);
  [nrows2,ncols2] = size(c2);
  
  if( add_cell_in_cell )
    
    if( (nrows1 == 0) || (ncols1 == 0) )

      c1{1,1} = c2;
    else

      if( nrows1 == 1 )

        c1{nrows1,ncols1+1} = c2;
      else
        c1{nrows1+1,ncols1} = c2;
      end
    end
    
  else
  
    if( (nrows1 == 0) || (ncols1 == 0) )

      c1 = c2;
    else

      if( nrows1 <= ncols1 )

        for j=1:ncols2  
          for i=1:nrows2
            c1{i,ncols1+j} = c2{i,j};
          end
        end
      else
        for i=1:nrows2
          for j=1:ncols2
            c1{nrows1+i,j} = c2{i,j};
          end
        end  
      end
    end
  end
end