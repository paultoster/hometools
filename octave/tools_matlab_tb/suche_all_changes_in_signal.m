function cindextuple = suche_all_changes_in_signal(signal,value,type)
%
% cindextuple = suche_all_changes_in_signal(signal,value,type)
%
% signal              Vektor mit Signal mit length(signal)>1
% value               Wert 
% type                '>>' muss erst größer werden als Wert und dann kleiner
%                     '<<' muss erst kleiner werden als Wert und dann größer
%
% cindextuple         {{found_type,i0,i1},...}
%
%                     Möglichkeiten:
%                     [0,0,0]    keine gefunden
%                     [1,i0,0]    nur einen ertsen Wechsel gefunden
%                     [2,0,i1]    nur einen zweiten Wechsel gefunden
%                     [3,i0,i1]    Ein Wechsel hin und zurück gefunden
%
%
  cindextuple = {};
  n = length(signal);
  
  
  if( type(1) == '>' ) % aufsteigend
    itype = 1;
  else
    itype = 0;
  end
  
  if( itype ) % Aufsteigend
  
    if( signal(1) >= value ) % ist schon oberhalb
      zustand = 1;
    else
      zustand = 0; % ist unterhalb
    end
    
  else % absteigend
    
    if( signal(1) < value ) % ist schon unterhalb
      zustand = 1;
    else
      zustand = 0;   % ist oberhalb
    end
  end   
  
  if( itype ) % Aufsteigend
    
    status = 0;
    
    for i=2:n
      if( zustand ) % ist oberhalb
        if( signal(i) < value )
          zustand = 0;
          if( status == 0 )
            status = 2;
            tuple = [2,0,i];
          elseif( status == 1 )
            status = 3;
            tuple(1) = 3;
            tuple(3) = i;
          end
        end
      else % ist unterhalb
        if( signal(i) >= value )
          zustand = 1;
          if( status == 0 )
            status = 1;
            tuple = [1,i,0];
          elseif( status == 2 )
            status = 3;
            tuple(1) = 3;
            tuple(2) = i;
          end
        end
      end            
      if( status == 3 )
        cindextuple = cell_add(cindextuple,tuple);
        status = 0;
      end
    end
    
  else % Absteigend
    
      for i=2:n
        if( zustand ) % ist unterhalb
          if( signal(i) >= value )
            zustand = 0;
            if( status == 0 )
              status = 2;
              tuple = [2,0,i];
            elseif( status == 1 )
              status = 3;
              tuple(1) = 3;
              tuple(3) = i;
            end
          end
        else % ist oberhalb
          if( signal(i) < value )
            zustand = 1;
            if( status == 0 )
              status = 1;
              tuple = [1,i,0];
            elseif( status == 2 )
              status = 3;
              tuple(1) = 3;
              tuple(2) = i;
            end
          end
        end            
        if( status == 3 )
          cindextuple = cell_add(cindextuple,tuple);
          status = 0;
        end
      end
  end
  
  if( status == 0 )
    if( isempty(cindextuple) )
      cindextuple = {{0,[],[]}};
    end
  elseif( (status == 1) || (status == 2) )
    cindextuple = cell_add(cindextuple,tuple);
  end
    
end
