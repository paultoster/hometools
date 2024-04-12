function [okay,e] = e_data_check(e)
%
%  [okay,e] = e_data_check(e);
%
% Check and Modifies structur if e.name.time and e.name.vec or e.name.param exist
% 
%
  okay = 0;
  if( isstruct(e) )
    cnames = fieldnames(e);
    n      = length(cnames);
    vokay  = zeros(n,1);
    for i=1:n
      name   = cnames{i};
      if( isstruct(e.(name)) )
        % Zeitvektor mit numerischen Vektor
        if(  check_val_in_struct(e.(name),'time','num',1) ...
          && check_val_in_struct(e.(name),'vec','num',1) ...
          )
          if( ~check_val_in_struct(e.(name),'comment','char',1) )
            e.(name).comment = '';
          end
          if( ~check_val_in_struct(e.(name),'unit','char',1) )
            e.(name).unit = '';
          end
          if( ~check_val_in_struct(e.(name),'lin','num',1) )
            e.(name).lin = 0;
          end
          vokay(i) = 1;
        % Zeitcellarray mit numerischen Vektoren
        elseif(  check_val_in_struct(e.(name),'time','num',1) ...
          && check_val_in_struct(e.(name),'vec','cell',1) ...
          )
          for j=1:length(e.(name).vec)
            if( ~isempty(e.(name).vec{j}) && isnumeric(e.(name).vec{j}) )
              vokay(i) = 1;
              break;
            end
          end
          if( ~check_val_in_struct(e.(name),'comment','char',1) )
            e.(name).comment = '';
          end
          if( ~check_val_in_struct(e.(name),'unit','char',1) )
            e.(name).unit = '';
          end
          if( ~check_val_in_struct(e.(name),'lin','num',1) )
            e.(name).lin = 0;
          end
          
        elseif( check_val_in_struct(e.(name),'param','num',1) )
          if( ~check_val_in_struct(e.(name),'comment','char',1) )
            e.(name).comment = '';
          end
          if( ~check_val_in_struct(e.(name),'unit','char',1) )
            e.(name).unit = '';
          end
          vokay(i) = 1;
        end

      end
    end
    if( sum(vokay) == n )
        okay = 1;
    else
      e1 = [];
      for i = 1:n
        if( vokay(i) == 1 )
          e1.(cnames{i}) = e.(cnames{i});
        end
      end
      okay = 0;
      e = e1;
    end

  else
    e = [];
  end
    
end
