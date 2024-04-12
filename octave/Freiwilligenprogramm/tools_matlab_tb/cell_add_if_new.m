function c1 = cell_add_if_new(c1,c2,type)
%
% c1 = cell_add_if_new(c1,c2) oder
% c1 = cell_add_if_new(c1,'text') oder
% c1 = cell_add_if_new(c1,[1,2,3,4])
% c1 = cell_add_if_new(c1,c2,type)
%
% Fügt an c1 Inhalt von c2 wenn nicht schon vorhanden. Text und Num ist
% eine neue Zelle
% type = 0 (default) wird vollständig verglichen
% type = 1           wird groß/klein unabhängig veglichen
%
  if( ~exist('type','var') )
    type = 0;
  end
  if( ~iscell(c1) )
      error('cell_add: erster Parameter c1 ist kein cell-array')
  end
  if( ischar(c2) )
    c2 = {c2};
  elseif( isnumeric(c2) )
    c2 = {c2};
  elseif( ~iscell(c2) )
      error('cell_add: zweiter Parameter c2 ist kein cell-array,char oder numeric')
  end

  [nrows1,ncols1] = size(c1);
  [nrows2,ncols2] = size(c2);
  
  if( nrows1 == 0 && ncols1 == 0 )
    
    c1 = c2;
  else

    if( nrows1 <= nrows2 )
      jj = 0;
      for j=1:ncols2  
        for i=1:nrows2
          if( type )
            ifound  = cell_find_f(c1,c2{i,j},'fl');
          else
            ifound  = cell_find_f(c1,c2{i,j},'f');
          end
          if( isempty(ifound) )
            jj = jj + 1;
            if( nrows1 >= ncols1 )
              c1{nrows1+jj,j} = c2{i,j};
            else
              c1{i,ncols1+jj} = c2{i,j};
            end
          end
        end
      end
    elseif( ncols1 <= ncols2 )
      ii = 0;
      for i=1:nrows2
        for j=1:ncols2
          if( type )
            ifound  = cell_find_f(c1,c2{i,j},'fl');
          else
            ifound  = cell_find_f(c1,c2{i,j},'f');
          end
          if( isempty(ifound) )
            ii = ii + 1;
            if( nrows1 >= ncols1 )
              c1{nrows1+ii,j} = c2{i,j};
            else
              c1{i,ncols1+ii} = c2{i,j};
            end
          end
        end
      end  
    else

      error('call_add: muß noch festgelegt werden wie addieren');
    end
  end
end