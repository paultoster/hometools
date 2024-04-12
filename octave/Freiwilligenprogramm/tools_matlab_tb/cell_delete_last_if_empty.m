function c = cell_delete_last_if_empty(c,all_flag)
%
% c = cell_delete_last_if_empty(c,all_flag);
%
% Löscht in cell array am Ende wenn leer 
% all_flag = 1    alle vom Ende her
%          = 0    nur das letzte
%
  if( ~exist('all_flag','var') )
    all_flag = 0;
  end
    
  flag = 1;
  while( flag )
    n = length(c);
    if( isempty(c{n}) )
      c = cell_delete(c,n);
      if( ~all_flag )
        flag = 0;
      end
    else
      flag = 0;
    end
  end
end
