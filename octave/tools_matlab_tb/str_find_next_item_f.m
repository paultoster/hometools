function  [word,index] = str_find_next_item_f(text_string,index0,regel)
%
%  [word,index] = str_find_next_item_f(text_string,index0,regel)
%
% text_string               text zum durchsuchen
% index0                    Startpunkt i0 = max(1,min(inedx0,length(text_string)))
%
% 'v' vorwärts suchen von i0 nach word
% 'r' rückwärts suchen von i0 nach word
%
% Gibt das nächste Item aus, was nicht White Space (' ',\t,\n) und bis zum
% nächsten whitespace oder ende 
% index = 0 bedeutet nichts gefunden
%
%  t = 'abc =10; ijk';
%  [w,i] = str_find_next_item_f(t,4,'v')      => w = '=10;' i = 5
%  [w,i] = str_find_next_item_f(t,4,'r')      => w = 'abc;' i = 1

  if( ~ischar(text_string) )
    error('1. Parameter kein string');
  end
  if( ~exist('index0','var') )
    error('2. Parameter index0 fehlt')
  end
  if( ~exist('regel','var' ) )
      error('3. Parameter regel fehlt')
  elseif( isempty(regel) || ~ischar(regel) )
      error('3. Parameter regel ist leer oder kein string')
  end

  i0 = max(1,min(index0,length(text_string)));

  index = 0;
  word  = '';

  n = length(text_string);
  
  ivec = isstrprop(text_string,'wspace');
  
  if( regel(1) == 'v' )

    % go forward until not whitespace
    
    i    = i0;
    while(ivec(i) ~= 0)
      i = i + 1;
      if( i > n )
    %     index = 0;
        return;
      end
    end
    istart = i;
    if( i == n )
      iend = i;
    else
      i    = i + 1;
      while(ivec(i) == 0)
        if( i >= n )
           i = n+1;
           break;
        end
        i = i + 1;      
      end
      iend = i-1;
    end    
    word  = text_string(istart:iend);
    index = istart;
  elseif( regel(1) == 'r' )
    
    i    = i0;
    while(ivec(i) ~= 0)
      i = i - 1;
      if( i < 1 )
    %     index = 0;
        return;
      end
    end
    
    iend = i;
    if( i == 1 )
      istart = 1;
    else
      i    = i - 1;
      while(ivec(i) == 0)
        if( i <= 1 )
           i = 0;
           break;
        end
        i = i - 1;      
      end
      istart = i+1;
    end    
    word  = text_string(istart:iend);
    index = istart;
  end
  
end        
    
    
    